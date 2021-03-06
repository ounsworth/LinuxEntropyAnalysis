#!/bin/bash

# This tool is part of the tool set provided by Kirill Sinitksi, and Mike Ounsworth
# for analyzing entropy events from a linux kernel modified with our test harness.

# This script takes in a raw datafile of kernel entropy events (it must already be
# filtered to only contain entries generated by our test harness). This script
# will extract only the jiffies values and write them to a file one value per line.

if [[ $1 == "" && $2 == ""  ]]
	then
	echo "Please provide input and output files"
	exit
fi

cat $1 | sed 's/^.*cycles: \([0-9]*\) -.*$/\1/;tx;d;:x' > $2
echo "" >> $2  # in POSIX, text files must end in a newline
