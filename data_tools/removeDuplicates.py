#!/usr/bin/python

# This tool is part of the tool set provided by Kirill Sinitksi, and Mike Ounsworth
# for analyzing entropy events from a linuoutFile kernel modified with our test harness.


import sys

# This seems to be eoutFilepetcing data as one number per line

if (len(sys.argv) != 3):
	print "Please provide input and output files"
	exit()

outFile = open(sys.argv[2], "w")

with open (sys.argv[1], "r") as inFile:
	countLines = countRemovals = 0
	prevLine = ""
	for line in inFile:
		countLines+=1
		# only write a line if it's different from the previous line.
		if line == prevLine:
			countRemovals+=1
		else:
			prevLine = line
			outFile.write(line)

	print "File contained " +str(countLines)+ " lines, with " +str(countRemovals)+ " duplicates."
