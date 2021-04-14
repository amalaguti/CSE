#!/bin/bash
/usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=maersk &
/usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=msc &
/usr/local/bin/legion -m1 -l0 --master=127.0.0.1 --rand-uuid --name=cosco &

sleep 10
salt-key -Ay
sleep 10
salt cosco\* grains.set vessel_owner cosco
salt maersk\* grains.set vessel_owner maersk
salt msc\* grains.set vessel_owner msc



# skill legion
# ps auxfww
