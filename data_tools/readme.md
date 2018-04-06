# This readme file is part of the tool set provided by Kirill Sinitksi, and Mike Ounsworth
# for analyzing entropy events from a linux kernel modified with our test harness.
# Disclaimer: these notes were taken during experimentation and may not reflect final version of scripts. Please contact the authors if you encounter problems using them.

Our data analysis tools provided here automate the process of analysing the logs from our linux kernel random.c harness using the NIST-provided statistical tools (python90b-r3 was current at time of experiment). To use these tools, you will need to download a copy of the NIST tools: https://github.com/usnistgov/SP800-90B_EntropyAssessment/tree/master/python


Note that these tools are expected to be run on either a linux system, or in a linux emulator such as cygwin or MinGW. The expected order and usage for our scripts is:

1) Run the test harness and extract a file, say `kernelMsgs.log` containing all of the raw kernel messaged produced by the test harness.

2) Use either the tool `./extractJiffies.sh kernelMsgs.log jiffies.data` or `./extractCPUCycles.sh kernelMsgs.log cycles.data` to produce a file containing only one numerical value for each entropy event.

3) Use one of the following tools to clean up the data:
    - removeDuplicates.py jiffies.data

4) Finally, prior to feeding the data into the NIST statistical tool, convert the data to binary `python convertToBinary.py 32 jiffies.data jiffies.bin`.

5) Run the NIST stats tool, ex. `python python90b-r3/noniid_main.py jiffies.bin 32 8 | tee jiffies.results`.
