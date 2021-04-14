#!/bin/bash

# Full vessel deploy for IMO: 9632155
_imo=9632155
# Link: https://www.marinetraffic.com/en/ais/details/ships/imo:9632155
_location=https://www.marinetraffic.com/en/ais/details/ships/imo:9632155
# Customer: MAERSK
_customer=maersk
# Vessel Name: Mette
_vessel=Mette
# UDGs: [udg1]
# Engines (Master): [eng1, eng2]
engines=2
declare -a engines_serials=("E939336363" "E939336368")
declare -a engines_models=("S80ME-B" "S80ME-B")
# Devices x engine: [dev1, dev2]
declare -a eng1_devices=("MOP_A" "MOP_B" "MOP_EMS")
declare -a eng2_devices=("MOP_A" "MOP_EMS" "PVU")


# ---------------------------------
# UDG1
/usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=IMO_$_imo-udg1-master &
/usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=IMO_$_imo-udg1-minion &
sleep 10

# Per engine config
# UDG1 - Engines (Master)
count=1
for engine_serial in ${engines_serials[@]}; do
   echo Engine iteration: $count
   base_minion_name="IMO""_""$_imo""-""$engine_serial"
   # Create VM Engine Master and Engine Minion
   echo Creating minions for master/minion engine serial $engine_serial
   /usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=$base_minion_name-master &
   /usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=$base_minion_name-minion &
   sleep 10

   # Getting reference for eng?_devices varaible
   engid=eng$count
   devices="${engid}_devices"[@]
   for device in ${!devices}; do
     echo Creating minion for device $device
     /usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=$base_minion_name-$device &
     sleep 10
   done
   (( count++ ))
done

