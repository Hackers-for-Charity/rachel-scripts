#!/bin/bash
##############################################################################
# Hackers for Charity (http://hackersforcharity.org/education)
# 
# Description:  This file is used to test duration of various batteries 
# running the device.  It will ask whether or not you wish to set the  
# date/time, then create a file named in the LOG variable relative to  
# the current folder.
#
# Usage: Ensure script is executable: "chmod +x ./duration-test.sh" and 
# then start the script once you remove all but the battery as a power
# source.  The script will continually update until power fails.  When you
# reboot, you can then read the log file to determine how long the battery
# lasted.
##############################################################################

# Change the following, if desired
VERSION=4 #script version
LOG="duration-results-test"  #default log file

echo; echo "### Battery Duration Test Script (sam@hfc) ###"
# Do not change anything after this line
# Request if the user wants to set the log file
echo "[!] Current log file name: $PWD/$LOG"
read -r -p "[?] Do you want to rename your log file? [y/N] " response
response=${response,,}    # tolower
if [[ $response =~ ^(yes|y)$ ]]
then
	echo "[?] What do you want to call your log file?"
	read LOG
	echo "[+] Log file created: $PWD/$LOG" | tee -a $LOG
else
	echo "[-] Using default log file: $PWD/$LOG" | tee -a $LOG
fi

# Request info to set the current date/time
echo; read -r -p "[?] Do you want to set the date/time?? [y/N] " response
response=${response,,}    # tolower
if [[ $response =~ ^(yes|y)$ ]]
then
	echo "[?] What is the current date/time (use this format --> Jul 5 08:10)?"
	read DATE
	sudo date -s "$DATE" >/dev/null 2>&1
	echo "[+] Using manually entered date/time"
else
	echo "[+] Using system date/time"
fi

# Sends initial test start comments to log file
echo; echo "[+] Battery Duration Test Script - Version $VERSION" | tee $LOG
STARTDATE=$(date +"%s")
echo "[+] Test Started:  $(date -d @$STARTDATE)" | tee -a $LOG 

# Monitors device for failure
#while :; do sed -i '/Power failure/d' $LOG; FAILDATE=$(date); echo "[-] Power failure:  "$FAILDATE >> $LOG; sleep 5; done
echo "[!] Monitoring for battery failure..."
echo "[!] Ctrl-C to exit"
while :; \
do sed -i '/Power failure/d' $LOG; \
do sed -i '/Battery lasted/d' $LOG; \
FAILDATE=$(date +"%s"); \
echo "[-] Power failure:  "$(date -d @$FAILDATE) >> $LOG; \
DIFF=$(($FAILDATE-$STARTDATE)); \
echo "[!] Battery lasted:  $(($DIFF / 3600)) hours, $(($DIFF / 60)) minutes, $(($DIFF % 60)) seconds" >> $LOG; \
sleep 5; \
done
