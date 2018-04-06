# Linux Random Number Generator and Mass Storage Device Entropy

This repository contains procedures, test harnesses, and data relating to logging the internal state of the Linux Random Number Generator (LRNG)'s entropy collection for the purposes of analysing it with the [NIST entropy estimation tools](https://github.com/usnistgov/SP800-90B_EntropyAssessment).

## Conditions and disclaimers

Data, harness, and scripts are offered as-is, without any stated or implied guarantee of accuracy or fitness for any purpose. If further research work or publication are based on this data, findings, or methods we expect to be credited.


## Experimental goals

The goal of this research was to study whether the quality of entropy gathered by the LNRG deteriorates as we move to newer hard drive technology with higher throughputs and lower latency.

We are open-sourcing this repository for two reasons:

1.  To provide our raw data to the open-source community.
1.  To provide a procedure for collecting and analyzing Linux entropy for those undergoing NIST or NIAP certification of their Linux-based product.



## Repository Contents

- **data_tools**: scripts to extract and analyze data from Linux kernel logs produced by our test harness.
- **processed_data**: results of running our data analyzis tools on our raw data.
- **procedures**: our "standard operating procedure" for using our test harness: rebuilding the Linux kernel with entropy logging, and configuring the host for continuous reboots until a sufficient number of samples have been collected.
- **raw_data**: Raw kernel logs from our experiments.
- **test_harness**: modified kernel source and supporting scripts.
