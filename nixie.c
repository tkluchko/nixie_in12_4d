#asm
.equ __w1_port=0x15
.equ __w1_bit=3
#endasm
#include <1wire.h>
#include "ds18b20.h"


#include <mega8.h>
#include <delay.h>
#include "ds3231_twi.c"


//didits pins 
#define DIGIT_1  1
#define DIGIT_2  2
#define DIGIT_3  4
#define DIGIT_4  8

#define PIN_A  1
#define PIN_B  4
#define PIN_C  8
#define PIN_D  2

#define ZERO 0
#define HALF 5

#define PIN_DP PORTB.4

#define PIN_DEBUG PORTB.5

#define MODE_SHOW_MAIN_INFO 0
#define MODE_SET_TIME_HOUR 1
#define MODE_SET_TIME_MINUTE 2
#define MODE_SET_TIME_SECONDS 3
#define MODE_SET_DISPLAY_MAIN_INFO_TIME 4
#define MODE_SET_DISPLAY_SENSORS_TIME 5

#define MODE_SHOW_SECONDS 40
#define MODE_SHOW_TEMPERATURE 50


#define BTN1 PINC.0
#define BTN2 PINC.1

#define CHECK_BTN_COUNT 3

#define PORT_ANODE PORTD
#define PORT_CATODE PORTB


#define BLANK_DIGIT 10

#define MAX_DS18b20 4

ds18b20_temperature_data_struct temperature;
unsigned char ds18b20_devices;
unsigned char rom_code[MAX_DS18b20][9];

static flash unsigned char digit[] = {
	0,
	PIN_A,
	PIN_B,
	PIN_B + PIN_A, 
	PIN_C,
	PIN_C + PIN_A,
	PIN_C + PIN_B,
	PIN_C + PIN_B + PIN_A,
	PIN_D,
	PIN_D + PIN_A
};

static flash unsigned char commonPins[] = {
	DIGIT_1,
	DIGIT_2,
	DIGIT_3,
	DIGIT_4
};


unsigned char ANODE_MASK = 0b11111111 ^ (DIGIT_1 + DIGIT_2 + DIGIT_3 + DIGIT_4);
unsigned char CATODE_MASK = 0b11111111 ^ (PIN_A + PIN_B + PIN_C + PIN_D);

unsigned char digit_out[4], cur_dig = 0;
unsigned char displayCounter = 0;
unsigned char displayDigit = 0;

unsigned char seconds;
unsigned char minutes;
unsigned char hours;
unsigned char day;
unsigned char date;
unsigned char month;
unsigned char year;

unsigned char btn1Counter = 0;
unsigned char btn2Counter = 0;


unsigned char mode;
unsigned char prevLastDigit;
unsigned char lastDigit;
bit show_point;
bit lastDigitChanged;

unsigned char displayMainInfoTime = 30;
unsigned char displaySensorInfoTime = 5;
unsigned char modeCounter = 0;

unsigned char modeTmpCounter = 0;

bit manualSet = 0;

void doBtn1Action(void) {
	mode = mode < 6 ? (mode + 1) : 0;
}

void doBtn2Action(void) {
	switch (mode) {
		case MODE_SHOW_MAIN_INFO:
			mode = MODE_SHOW_TEMPERATURE;
			manualSet = 1;
			break;
		case MODE_SET_TIME_HOUR:
			hours = hours < 23 ? (hours + 1) : 0;
			rtc_set_time(seconds, minutes, hours, day, date, month, year);
			break;
		case MODE_SET_TIME_MINUTE:
			minutes = minutes < 59 ? (minutes + 1) : 0;
			rtc_set_time(seconds, minutes, hours, day, date, month, year);
			break;
		case MODE_SET_TIME_SECONDS:
			seconds = 0;
			rtc_set_time(seconds, minutes, hours, day, date, month, year);
			break;
		case MODE_SET_DISPLAY_MAIN_INFO_TIME:
			displayMainInfoTime = displayMainInfoTime < 60 ? (displayMainInfoTime + 5) : 0;
			break;
		case MODE_SET_DISPLAY_SENSORS_TIME:
			displaySensorInfoTime = displaySensorInfoTime < 60 ? (displaySensorInfoTime + 5) : 0;
			break;
		case MODE_SHOW_TEMPERATURE:
			manualSet = 0;
			mode = MODE_SHOW_SECONDS;
			break;
		case MODE_SHOW_SECONDS:
			mode = MODE_SHOW_MAIN_INFO;
			break;
	}
}


void switchMode(void) {

	if(mode == MODE_SHOW_MAIN_INFO) {
		if(modeCounter < displayMainInfoTime) {
			modeCounter++;
		} else if(displaySensorInfoTime > 0){
			modeCounter = 0;
			mode = MODE_SHOW_TEMPERATURE;
		}
	}
	if(!manualSet && mode == MODE_SHOW_TEMPERATURE) {
		if(modeCounter < displaySensorInfoTime) {
			modeCounter++;
		} else if(displayMainInfoTime > 0){
			modeCounter = 0;
			mode = MODE_SHOW_MAIN_INFO;
		}
	}

}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
	if(modeTmpCounter % 20 == 0) {
		switchMode();
	}

	if(!BTN1) {
		btn1Counter++;
		if(btn1Counter == CHECK_BTN_COUNT) {
			doBtn1Action();
			btn1Counter = 0;
		}
	} else {
		btn1Counter = 0;
	}

	if(!BTN2) {
		btn2Counter++;
		if(btn2Counter == CHECK_BTN_COUNT) {
			doBtn2Action();
			btn2Counter = 0;
		}
	} else {
		btn2Counter = 0;
	}
	PIN_DEBUG = ~PIN_DEBUG;
	modeTmpCounter = modeTmpCounter == 255 ? 0 : modeTmpCounter + 1;
	TCNT1=0; //обнуляем таймер
}



void showInfo() {

	if (displayCounter == 0) {
		unsigned char anodeVar = PORT_ANODE & ANODE_MASK;
		unsigned char catodeVar = PORT_CATODE & CATODE_MASK;

		PORT_CATODE &= CATODE_MASK;
		PORT_ANODE &= ANODE_MASK;

		displayDigit = digit_out[cur_dig];
		if (displayDigit < 10) {
			catodeVar |= digit[displayDigit];
			anodeVar |= commonPins[cur_dig];
			PORT_CATODE = catodeVar;
			PORT_ANODE = anodeVar;
		}
		//delay_ms(100);

		if (cur_dig == 2 && (mode == MODE_SHOW_MAIN_INFO || mode == MODE_SHOW_TEMPERATURE)) {
			PIN_DP = show_point;
		} else {
			PIN_DP = 0;
		}

		cur_dig++;
		if (cur_dig > 3) {
			cur_dig = 0;
		}
	}
}


// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void) {
	showInfo();
}

unsigned char nextDigit(unsigned char digit) {
	return (digit + 1) % 10;
}

void view_term(void) {
	unsigned char decades;
	decades = temperature.temperatureIntValue / 10;
	digit_out[0] = decades > 0 ? decades : BLANK_DIGIT;
	digit_out[1] = temperature.temperatureIntValue % 10;
	digit_out[2] = temperature.halfDegree ? HALF : ZERO;
	digit_out[3] = BLANK_DIGIT;
	show_point = 1;
}

void displayMainInfo() {
    unsigned char j = 0; 
	if(lastDigitChanged) {
		for(j = 0; j < 10; j++) {
			digit_out[0] = nextDigit(digit_out[0]);
			digit_out[1] = nextDigit(digit_out[1]);
			digit_out[2] = nextDigit(digit_out[2]);
			digit_out[3] = nextDigit(digit_out[3]);
			delay_ms(300);
		}
		lastDigitChanged = 0;
	} else {
		digit_out[0] = hours / 10;
		digit_out[1] = hours % 10;
		digit_out[2] = minutes / 10;
		lastDigit = minutes % 10;

		lastDigitChanged = prevLastDigit != lastDigit;
		prevLastDigit = lastDigit;
		digit_out[3] = lastDigit;
	}
}

void displayInfo(void) {
	switch (mode) {
	case MODE_SHOW_MAIN_INFO:
		displayMainInfo();
		break;
	case MODE_SET_TIME_HOUR:
		digit_out[0] = 8;
		digit_out[1] = 1;
		digit_out[2] = hours / 10;
		digit_out[3] = hours % 10;
		break;
	case MODE_SET_TIME_MINUTE:
		digit_out[0] = 8;
		digit_out[1] = 2;
		digit_out[2] = minutes / 10;
		digit_out[3] = minutes % 10;
		break;
	case MODE_SET_TIME_SECONDS:
		digit_out[0] = 8;
		digit_out[1] = 3;
		digit_out[2] = seconds / 10;
		digit_out[3] = seconds % 10;
		break;
	case MODE_SET_DISPLAY_MAIN_INFO_TIME:
		digit_out[0] = 8;
		digit_out[1] = 4;
		digit_out[2] = displayMainInfoTime / 10;
		digit_out[3] = displayMainInfoTime % 10;
	case MODE_SET_DISPLAY_SENSORS_TIME:
		digit_out[0] = 8;
		digit_out[1] = 5;
		digit_out[2] = displaySensorInfoTime / 10;
		digit_out[3] = displaySensorInfoTime % 10;
		break;
	case MODE_SHOW_SECONDS:
		digit_out[0] = BLANK_DIGIT;
		digit_out[1] = BLANK_DIGIT;
		digit_out[2] = seconds / 10;
		digit_out[3] = seconds % 10;
		break;

	case MODE_SHOW_TEMPERATURE:
		view_term();
		break;
	}
}

void main(void)
{
// Declare your local variables here
	unsigned char i = 0;
    int tmp_counter;

	PORTB = 0xFF;
	DDRB = 0xFF;

	PORTC = 0x07;
	DDRC = 0xF8;

	PORTD = 0xFF;;
	DDRD = 0xFF;


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
	TCCR0 = 0x00;
	TCNT0 = 0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x01;
OCR1AL=0x86;
OCR1BH=0x00;
OCR1BL=0x00;



// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 62,500 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR = 0x00;
TCCR2 = 0x05;
TCNT2 = 0x00;
OCR2 = 0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
//TIMSK = 0x44;
TIMSK = 0x50;



// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;


// TWI initialization
// TWI disabled
TWBR = 0x0C;
TWAR = 0xD0;
TWCR = 0x44;

w1_init();
ds18b20_devices = w1_search(0xf0, rom_code);

// Global enable interrupts
#asm("sei")


digit_out[0] = 1;
digit_out[1] = 2;
digit_out[2] = 2;
digit_out[3] = 3;


digit_out[0] = ds18b20_devices;
digit_out[1] = BLANK_DIGIT;
digit_out[2] = ds18b20_devices;
digit_out[3] = BLANK_DIGIT;

//skip first values
if (ds18b20_devices >= 0) {
	for (i = 0; i < ds18b20_devices; i++) {
		ds18b20_temperature(&rom_code[i][0]);
	}
}


ds3231_init();
rtc_get_time(&seconds, &minutes, &hours, &day, &date, &month, &year);

	tmp_counter = 0;
	while (1) {
		rtc_get_time(&seconds, &minutes, &hours, &day, &date, &month, &year);
		tmp_counter++;
		if (tmp_counter % 5 == 0) {
			show_point = ~show_point;
		}
		

		displayInfo();
		



		if (tmp_counter == 150) {
			if (ds18b20_devices > 0) {
				temperature = ds18b20_temperature_struct(&rom_code[0][0]);
			}
			tmp_counter = 0;
		}
		delay_ms(100);

	}

}

