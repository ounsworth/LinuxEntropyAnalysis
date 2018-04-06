#!/usr/bin/python

# This tool is part of the tool set provided by Kirill Sinitksi and Mike Ounsworth
# for analyzing entropy events from a linux kernel modified with our test harness.


import sys

# This seems to be expetcing data as one number per line

if (len(sys.argv) != 4):
	print "Please provide output bit width, an input file and an output file."
	print "Usage: convertToBinary.py <bitwidth> inFile outFile"
	exit()

outputBitWidth = int(sys.argv[1])
if outputBitWidth != 6 and outputBitWidth != 8 and outputBitWidth != 16 and outputBitWidth != 24 and outputBitWidth != 32:
	print "Output bit width needs to be either 6, 8, 16, 24 or 32."
	exit()

if outputBitWidth == 6:
	print "Truncating values to " +str(6)+ "bits and outputting them in " +str(8)+ " bit symbols."
else:
	print "Truncating values to " +str(outputBitWidth)+ " bits and outputting them in " +str(outputBitWidth)+ " bit symbols."

outFile = open(sys.argv[3], "wb")

def splitNumber (num):
	lst = []
	if outputBitWidth == 6:
		lst.append(num & 0x3F)
	else:
		bits = outputBitWidth
		while bits > 0:
			lst.append(num & 0xFF)  # truncation to 8 bits
			num >>= 8; bits -= 8
	return lst[::-1]

with open (sys.argv[2], "r") as infile:
	for line in infile:
		try:
			ent_val = int(line)
		#if ent_val >= 2<<(outputBitWidth - 1) :
			#print "Val larger than "+str(outputBitWidth)+" bits, ignoring: " + str(ent_val)
			#continue
		except ValueError:
			continue
		outFile.write(bytearray(splitNumber(ent_val)))
