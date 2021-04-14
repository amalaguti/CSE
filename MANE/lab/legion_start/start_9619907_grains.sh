#!/bin/bash

# Full vessel deploy for IMO: 9619907
_imo=9619907
# Link: https://www.marinetraffic.com/en/ais/details/ships/imo:9619907
_location=https://www.marinetraffic.com/en/ais/details/ships/imo:9619907
# Customer: MAERSK
_customer=maersk
# Vessel Name: Mc Kinney Moller
_vessel="Mc Kinney Moller"
# UDGs: [udg1]
# Engines (Master): [eng1, eng2]
engines=4
declare -a engines_serials=("E765036567" "E456000654" "E123404321" "E543444345")
declare -a engines_models=("S80ME-B" "S80ME-B" "S80ME-B" "S80ME-B")
# Devices x engine: [dev1, dev2, dev3, dev4]
declare -a eng1_devices=("MOP_A" "MOP_B")
declare -a eng2_devices=("MOP_A" "MOP_EMS" "PVU")
declare -a eng3_devices=("MOP_A")
declare -a eng4_devices=("MOP_A" "PVU")


# Grains set for all minions
# IMO
salt IMO_$_imo\* grains.set "udg:IMO" $_imo
# Customer
salt IMO_$_imo\* grains.set "udg:customer" "$_customer"
# Vessel Name
salt IMO_$_imo\* grains.set "udg:vessel" "$_vessel"
# Location link
salt IMO_$_imo\* grains.set "udg:location" "$_location"

# ---------------------------------
# Grains set for UDG1 minions
salt IMO_$_imo-udg1-\* grains.set "udg:udg_number" 1
salt IMO_$_imo-udg1-master\* grains.set "udg:role" udg_master
salt IMO_$_imo-udg1-minion\* grains.set "udg:role" udg_minion


# Per engine grains set
count=1
for engine_serial in ${engines_serials[@]}; do
   echo Engine iteration: $count
   base_minion_name="IMO""_""$_imo""-""$engine_serial"

   echo "Set grain engine_serial for engine minions"
   salt $base_minion_name\* grains.set "udg:engine_serial" $engine_serial

   echo "Set grain engine_type for engine minions"
   salt $base_minion_name\* grains.set "udg:engine_type" "$engines stroke"

   echo "Set grain engine_model"
   idx=$count-1
   salt $base_minion_name\* grains.set "udg:engine_model" ${engines_models[$idx]}

   echo "Grains set role VM Engine Master and Engine Minion"
   salt $base_minion_name-master\* grains.set "udg:role" engine_master
   salt $base_minion_name-minion\* grains.set "udg:role" engine_minion

   # Getting reference for eng?_devices variable
   engid=eng$count
   devices="${engid}_devices"[@]
   for device in ${!devices}; do
     echo "Set grain role for device $device"
     salt $base_minion_name-$device-\* grains.set "udg:role" engine_device
     salt $base_minion_name-$device-\* grains.set "udg:engine_device_name" $device
   done
   (( count++ ))
done

