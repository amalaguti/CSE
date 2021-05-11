#!/bin/bash
# ./RBAC_lab_deploy.sh imo=9632155 \
#    customer=Maersk \
#    eserial=939336368 \
#    etype="2 stroke" \
#    emodel=S80ME-B \
#    vessel=Mette \
#    master=127.0.0.1 \
#    edevices="mop-ems mop-b pvu" \
# Note on edevices:
# Include ONLY devices to be represented by Salt Legion (simulated) minions
# Exclude device mop-a from the list due it's real minion

shopt -s nocasematch
for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
    case "$KEY" in
            imo)              IMO=${VALUE} ;;
            customer)         CUSTOMER=${VALUE} ;;
            eserial)          ENGINE_SERIAL=${VALUE} ;;
            etype)            ENGINE_TYPE=${VALUE} ;;
            emodel)           ENGINE_MODEL=${VALUE} ;;
            vessel)           VESSEL=${VALUE} ;;
            master)           MASTER=${VALUE} ;;
            edevices)         ENGINE_DEVICES=${VALUE} ;;
            *)
    esac
done
LOCATION="https://www.marinetraffic.com/en/ais/details/ships/imo:"$IMO


BASE_MINION_NAME="imo-$IMO-$ENGINE_SERIAL"
echo "BASE_MINION_NAME = $BASE_MINION_NAME"

echo "Setting up RBAC LAB:"
echo "IMO = $IMO"
echo "CUSTOMER = $CUSTOMER"
echo "ENGINE SERIAL = $ENGINE_SERIAL"
echo "ENGINE TYPE = $ENGINE_TYPE"
echo "ENGINE MODEL = $ENGINE_MODEL"
echo "VESSEL NAME = $VESSEL"
echo "MASTER = $MASTER"
echo "ENGINE_DEVICES = $ENGINE_DEVICES"
echo "VESSEL LOCATION = $LOCATION"
# List engine devices
declare -a _ENGINE_DEVICES=($ENGINE_DEVICES)
for DEVICE in ${_ENGINE_DEVICES[@]}; do
  echo "ENGINE DEVICE = $DEVICE"
done


# TODO: Pick real minion name
echo "1- Installing reqs: git, Salt Legion, Salt Master"
salt $BASE_MINION_NAME-legion git.clone /opt/legion/ https://github.com/saltstack/legion
salt $BASE_MINION_NAME-legion cmd.run "pip3 install -e /opt/legion/."


# Deploy Legion Minions for engine devices
echo "2- Deploying Legion Minions for engine devices"
for DEVICE in ${_ENGINE_DEVICES[@]}; do
  echo Creating legion minion for device $DEVICE
  salt $BASE_MINION_NAME-legion cmd.run_bg \
    "/usr/local/bin/legion -m1 -l0 --master=$MASTER --rand-uuid --name=$BASE_MINION_NAME-$DEVICE --temp-dir=/opt/legion/legions --no-clean &"
  sleep 5
done
sleep 10
echo "Legion deployment completed"

# Accept keys on Salt-Master
# despite being in autoaccept mode, just in case it's not set
echo "3- Accept legion minions keys on Salt Master"
salt-key -y -a $BASE_MINION_NAME\*


# Create start legion script
echo "4- Generate legion start script on minion"
salt $BASE_MINION_NAME-legion file.write /opt/legion/legions/legions_start.sh "#!/bin/bash"
salt $BASE_MINION_NAME-legion file.set_mode /opt/legion/legions/legions_start.sh 0754
for DEVICE in ${_ENGINE_DEVICES[@]}; do
  echo "Adding entry for $DEVICE on legion start script"
  salt $BASE_MINION_NAME-legion file.append /opt/legion/legions/legions_start.sh \
    args="['/usr/bin/python3 /bin/salt-minion -c /opt/legion/legions/$BASE_MINION_NAME-$DEVICE-0 --pid-file /opt/legion/legions/$BASE_MINION_NAME-$DEVICE-0.pid -d']"
done

# Create stop legion script
echo "5- Generate legion stop script on minion"
salt $BASE_MINION_NAME-legion cp.get_file salt://rbac_lab/stop_legion.sh /opt/legion/legions/legions_stop.sh
salt $BASE_MINION_NAME-legion file.set_mode /opt/legion/legions/legions_stop.sh 0754


# Create and enable legion service
echo "6- Create and enable legion service"
salt $BASE_MINION_NAME-legion cp.get_file salt://rbac_lab/legions.service /etc/systemd/system/legions.service
salt $BASE_MINION_NAME-legion service.systemctl_reload
salt $BASE_MINION_NAME-legion service.enable "legions.service"



# Grains set for all minions
echo "7- Set grains for ALL minions for this Vessel"
# udg:IMO
echo "Grain udg:IMO"
salt $BASE_MINION_NAME\* grains.set "udg:IMO" $IMO

# udg:Customer
echo "Grain udg:Customer"
salt $BASE_MINION_NAME\* grains.set "udg:Customer" "$CUSTOMER"

# udg:Vessel
echo "Grain udg:Vessel"
salt $BASE_MINION_NAME\* grains.set "udg:Vessel" "$VESSEL"

# udg:Location link
echo "Grain udg:Location"
salt $BASE_MINION_NAME\* grains.set "udg:Location" "$LOCATION"

# udg:Engine_Serial
echo "Grain udg:Engine_Serial"
salt $BASE_MINION_NAME\* grains.set "udg:Engine_Serial" "$ENGINE_SERIAL"

# udg:Engine_Type
echo "Grain udg:Engine_Type"
salt $BASE_MINION_NAME\* grains.set "udg:Engine_Type" "$ENGINE_TYPE"

# udg:Engine_Model
echo "Grain udg:Engine_Model"
salt $BASE_MINION_NAME\* grains.set "udg:Engine_Model" "$ENGINE_MODEL"

# udg:Role
echo "Grain udg:Role"
salt $BASE_MINION_NAME\* grains.set "udg:Role" "engine_device"
# udg:Role grain for local master/minion
salt-call grains.set "udg:Role" "engine_master_minion"

# udg:Engine_Device_Name
# Legions minions
for DEVICE in ${_ENGINE_DEVICES[@]}; do
  echo "Grain udg:Engine_Device_Name on $DEVICE"
  salt $BASE_MINION_NAME-$DEVICE-0 grains.set "udg:Engine_Device_Name" "$DEVICE"
done
# REAL Windows MINION
salt $BASE_MINION_NAME-mop-a grains.set "udg:Engine_Device_Name" "mop-a"
