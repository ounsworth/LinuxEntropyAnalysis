#!/bin/bash

# TODO:
# - GNU Licence
# - Author blurb


# Usage: called with no arguments: it will run until either the data log contains
# the required number of samples, or the specified amount of time has elapsed.

# Flags:

# "-test"
# it will dump test harness data
# from the current session to the data file and print debugging info.

# "-clean"
# If a data file exists, copies it to /entropyExperiment.data.3989
# Removes files /entropyRebootCounter and /entropyExperiment.data so you can
# start a clean run.

# Note that this script was designed for Red Hat 7.x / CentOS 7.x and uses journalctl
# to fetch kernel logs.
# To use this script on other linux distributions, you may need to modify the
# logging command according to the syslog mechanism of your distro.


# Exit conditions for the reboot loop, whichever happens first
# Feel free to change these values.
(( NUM_SAMPLES_TO_COLLECT=1500000 ))    # overestimate a little to account for
                                        # non-data log messages and duplicates.
(( EXPRIMENT_MAX_RUNTIME=3*24*60*60 ))  # in seconds (days*hours*minutes*seconds)

START_TIME_FILE=/entropyExperimentStartTime
DATA_FILE=/entropyExperiment.data










if [[ $# -ne 0 ]] && [[ $1 != "-test" ]] && [[ $1 != "-clean" ]]
then
	echo "Usage: Reboot.sh [-test|-clean]"
	exit
fi

if [[ $1 == "-clean" ]]
then
	echo "Cleaning data files to restart experiment"
	echo "mv "$DATA_FILE" "$DATA_FILE.$RANDOM
	mv $DATA_FILE $DATA_FILE.$RANDOM
	echo "rm "$START_TIME_FILE
	rm $START_TIME_FILE
fi

touch $START_TIME_FILE
touch $DATA_FILE

# if the write failed, bail
if [[ $? -ne 0 ]]
then
	echo "Abort! Write to data file failed"
	exit
fi

CURRENT_TIME=$(date +%s)

# if file has 0 size then we are on the first iteration
if ! [[ -s $START_TIME_FILE ]]
then
	echo $CURRENT_TIME > $START_TIME_FILE

	# on 0th reboot, dump system specs
	echo $(uname -a) > $DATA_FILE
fi

# log data
# Red Hat / CentOS specific logging command
journalctl -k -p 7 | grep RANDOMNESS >> $DATA_FILE


EXPERIMENT_START_TIME=$(cat $START_TIME_FILE)
ELAPSED_TIME=`expr $CURRENT_TIME - $EXPERIMENT_START_TIME`

# print debugging info if in -test mode
if [[ $1 == "-test" ]]
then
	# print out debugging info
    echo "Time elapsed since experiment began : "$ELAPSED_TIME" seconds."

    echo "Entropy test harness: Logging to file: "$DATA_FILE

	# Red Hat / CentOS specific logging command
	echo "Entropy test harness: collected "$(journalctl -k -p 7 | grep RANDOMNESS | wc -l)" data points this reboot cycle."
    echo "Entropy test harness: collected "`wc -l < $DATA_FILE`" data points in total."
	exit
fi

# check exit conditions
if (( ELAPSED_TIME > EXPRIMENT_MAX_RUNTIME ))
then
    echo "Ending experiment: MAX_RUNTIME of "$EXPRIMENT_MAX_RUNTIME" seconds was hit."
    exit
fi

if (( `wc -l < $DATA_FILE` > NUM_SAMPLES_TO_COLLECT ))
then
    echo "Ending experiment: required number of samples recorded: "$NUM_SAMPLES_TO_COLLECT"."
    exit
fi

echo "Rebooting after "$ELAPSED_TIME" seconds of data collection with "`wc -l < $DATA_FILE`" data points collected" >> $DATA_FILE
reboot
