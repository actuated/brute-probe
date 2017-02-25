#!/bin/bash
# brute-probe.sh
# v1.1 - 2/24/2017 by Ted R (https://github.com/actuated)
# Simple script to loop aireplay-ng injection of possible (E)SSIDs, supplying a dictionary of possible SSIDs to aireplay
# Run airodump-ng while this is running to capture the probe response and identify your target BSSID's ESSID
# 2/25/2016 - Correction in airodump check
varDateCreated="2/24/2017"
varDateLastMod="2/25/2017"

varInt=""
varChannel=""
varChannelSet="N"
varBssid=""
varList=""

# Usage/Help
function fnUsage {
  echo
  echo "======================[ brute-probe.sh - Ted R (github: actuated) ]======================"
  echo
  echo "Script to loop aireplay-ng probe request injection attacks with a dictionary of (E)SSIDs."
  echo
  echo "Run airodump-ng separately to capture any valid probe responses."
  echo
  echo "Created $varDateCreated, last modified $varDateLastMod."
  echo
  echo "========================================[ usage ]========================================"
  echo
  echo "./brute-probe.sh [dictionary] -i [interface] -a [target BSSID] -c [channel]"
  echo
  echo "[dictionary]           A list of the SSIDs you want to send probe requests for, one per"
  echo "                       line. Must be the first parameter."
  echo
  echo "-i [interface]         Specify the interface to send probe requests for. This can be the"
  echo "                       same adapter your are using airmon-ng to listen with. It can also"
  echo "                       be a different adapter, and does not have to be in monitor mode."
  echo
  echo "-a / --bssid [BSSID]   Specify the target BSSID."
  echo
  echo "-c [channel]           Optionally specify the channel to set [interface] to."
  echo
  exit
}

# Check input file
varList="$1"
if [ ! -f "$varList" ]; then echo; echo "Error: Input file '$varList' does not exist."; fnUsage; fi
shift

# Read options
while [ "$1" != "" ]; do
  case "$1" in
    -i )
      shift
      varInt="$1"
      ;;
    -c | --channel )
      shift
      varChannel="$1"
      ;;
    -a | --bssid )
      shift
      varBssid="$1"
      ;;
  esac
  shift
done

# Check options
if [ "$varInt" = "" ]; then
  echo; echo "Error: Interface not set."; fnUsage
else
  varCheckInt=$(ifconfig | grep "$varInt:")
  if [ "$varCheckInt" = "" ]; then echo; echo "Error: Interface '$varInt' not listed in ifconfig."; fnUsage; fi
fi

if [ "$varChannel" != "" ]; then varChannelSet="Y"; fi

if [ "$varBssid" = "" ]; then echo; echo "Error: BSSID not set with '-a'."; fnUsage; fi

# Banner and confirmation
echo
echo "======================[ brute-probe.sh - Ted R (github: actuated) ]======================"
echo

if [ "$varChannelSet" = "N" ]; then
  echo "Channel is not being set, make sure $varInt is on the channel you want to send probes from."
  echo
fi

varCheckAirdump=$(ps aux | grep airodump-ng | grep -v grep)
if [ "$varCheckAirdump" = "" ]; then 
  echo "Can't tell if airodump-ng is running."
  echo "If not: airodump-ng -c $varChannel -a $varBssid [monitor interface]"
  echo
fi

varListCount=$(cat "$varList" | wc -l)
echo "Ready to use $varInt to send probes from $varList ($varListCount) for $varBssid."
read -p "Press Enter to start..."
echo

# Set channel
if [ "$varChannelSet" = "Y" ]; then echo "Setting channel $varChannel for $varInt..."; iwconfig $varInt channel $varChannel; fi

# Run aireplay
varThisCount="0"
while read varSsid; do
  let varThisCount=varThisCount+1
  echo -ne "Running aireplay-ng ($varThisCount/$varListCount)"        \\r
  aireplay-ng -9 -i $varInt $varInt -e "$varSsid" -a $varBssid > /dev/null
done < "$varList"
echo

echo
echo "=========================================[ fin ]========================================="
echo




