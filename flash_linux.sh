#!/bin/bash

avrdude -v  -c usbasp -p m8 -U flash:w:"Exe/nixie.hex":a -q
