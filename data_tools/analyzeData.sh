#!/bin/bash

# Note, when I used this, I added the dirs `Sinitksi-data-tools` and NIST's `python90b-r3` to my path. If you want this to work otherwise, you'll need to modify it.

# You also need to add "#!/usr/bin/python" to the start of the referenced NIST python tools - currently only noniid_main.py (or else it tries to run them as bash scripts).

if [ "$#" -ne 1 ]
then
    echo "Usage: analyzeData.sh <kernel log file>"
    exit 1
fi

echo; echo "analyzing" $1 "for" $(basename `pwd`)


echo; echo "Experiment start time:"
head -n 2 $1

echo; echo "Experiment end time:"
tail -n 1 $1

echo; echo "Num Reboots: $(grep -i reboot $1 | wc -l)"

echo; echo "extractJiffies.sh $1 jiffies.data"
extractJiffies.sh $1 jiffies.data
echo; echo "extractCPUCycles.sh $1 cycles.data"
extractCPUCycles.sh $1 cycles.data

removeDuplicates.py jiffies.data jiffies_nodupes.data
removeDuplicates.py cycles.data cycles_nodupes.data


# Truncate the data values, and convert to binary format

## jiffies
echo; echo "convertToBinary.py 6 jiffies.data jiffies_6bit.bin"
convertToBinary.py 6 jiffies.data jiffies_6bit.bin
echo; echo "convertToBinary.py 8 jiffies.data jiffies_8bit.bin"
convertToBinary.py 8 jiffies.data jiffies_8bit.bin

## jiffies no duplicates
echo; echo "convertToBinary.py 6 jiffies_nodupes.data jiffies_nodupes_6bit.bin"
convertToBinary.py 6 jiffies_nodupes.data jiffies_nodupes_6bit.bin
echo; echo "convertToBinary.py 8 jiffies_nodupes.data jiffies_nodupes_8bit.bin"
convertToBinary.py 8 jiffies_nodupes.data jiffies_nodupes_8bit.bin


## cycles
echo; echo "convertToBinary.py 6 cycles.data cycles_6bit.bin"
convertToBinary.py 6 cycles.data cycles_6bit.bin
echo; echo "convertToBinary.py 8 cycles.data cycles_8bit.bin"
convertToBinary.py 8 cycles.data cycles_8bit.bin

## cycles no duplicates
echo; echo "convertToBinary.py 8 cycles_nodupes.data cycles_nodupes_8bit.bin"
convertToBinary.py 8 cycles_nodupes.data cycles_nodupes_8bit.bin
echo; echo "convertToBinary.py 6 cycles_nodupes.data cycles_nodupes_6bit.bin"
convertToBinary.py 6 cycles_nodupes.data cycles_nodupes_6bit.bin


# Perform NIST min_entropy statistical tests

## We nede to tell the tool that it's 8-bit symbols because our convertToBinary only seems to be able to output in byte blocks
echo; echo "===" $(basename `pwd`)" jiffies_6bit ============================================================================"
echo; echo "noniid_main.py jiffies_6bit.bin 8 | tee jiffies_6bit_results.txt"
noniid_main.py jiffies_6bit.bin 8 | tee jiffies_results_6bit.txt

echo; echo "===" $(basename `pwd`)" jiffies_8bit ============================================================================"
echo; echo "noniid_main.py jiffies_8bit.bin 8 | tee jiffies_8bit_results.txt"
noniid_main.py jiffies_8bit.bin 8 | tee jiffies_results_8bit.txt

## We nede to tell the tool that it's 8-bit symbols because our convertToBinary only seems to be able to output in byte blocks
echo; echo "===" $(basename `pwd`)" jiffies_nodupes_6bit ============================================================================"
echo; echo "python noniid_main.py jiffies_nodupes_6bit.bin 8 | tee jiffies_nodupes_6bit_results.txt"
noniid_main.py jiffies_nodupes_6bit.bin 8 | tee jiffies_nodupes_6bit_results.txt

echo; echo "===" $(basename `pwd`)" jiffies_nodupes_8bit ============================================================================"
echo; echo "python noniid_main.py jiffies_nodupes_8bit.bin 8 | tee jiffies_nodupes_8bit_results.txt"
noniid_main.py jiffies_nodupes_8bit.bin 8 | tee jiffies_nodupes_8bit_results.txt


## We nede to tell the tool that it's 8-bit symbols because our convertToBinary only seems to be able to output in byte blocks
echo; echo "===" $(basename `pwd`)" cycles_6bit ============================================================================"
echo; echo "python noniid_main.py cycles_6bit.bin 8 | tee cycles_6bit_results.txt"
noniid_main.py cycles_6bit.bin 8 | tee cycles_6bit_results.txt

echo; echo "===" $(basename `pwd`)" cycles_8bit ============================================================================"
echo; echo "python noniid_main.py cycles_8bit.bin 8 | tee cycles_8bit_results.txt"
noniid_main.py cycles_8bit.bin 8 | tee cycles_8bit_results.txt

## We nede to tell the tool that it's 8-bit symbols because our convertToBinary only seems to be able to output in byte blocks
echo; echo "===" $(basename `pwd`)" cycles_nodupes_6bit ============================================================================"
echo; echo "python noniid_main.py cycles_nodupes_6bit.bin 8 | tee cycles_nodupes_6bit_results.txt"
noniid_main.py cycles_nodupes_6bit.bin 8 | tee cycles_nodupes_6bit_results.txt

echo; echo "===" $(basename `pwd`)" cycles_nodupes_8bit ============================================================================"
echo; echo "python noniid_main.py cycles_nodupes_8bit.bin 8 | tee cycles_nodupes_8bit_results.txt"
noniid_main.py cycles_nodupes_8bit.bin 8 | tee cycles_nodupes_8bit_results.txt
