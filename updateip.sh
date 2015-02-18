#!/bin/bash
IFACE=${1:-eth0}
IP=`ifconfig $IFACE | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
HOSTNAME=`hostname`
# Assumes passwordless ssh enabled for the host
REMOTE_SERVER="palasi"
REMOTE_DIR="hosts/"
REMOTE_FILE=$HOSTNAME

function validateIP()
 {
         local ip=$1
         local stat=1
         if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                OIFS=$IFS
                IFS='.'
                ip=($ip)
                IFS=$OIFS
                [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
                && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
                stat=$?
        fi
        return $stat
}

validateIP $IP

if [[ $? -ne 0 ]]; then
    echo "This PC isn't assigned an IP address on $IFACE. Exiting gracefully."
    exit
fi


LAST_IP=`ssh $REMOTE_SERVER "tail -n 1 $REMOTE_DIR$REMOTE_FILE"`

if [[ $? -ne 0 ]]; then
    echo "Couldn't establish SSH connection to $REMOTE_SERVER. Exiting."
    exit
fi

if [ "$IP" = "$LAST_IP" ]; then
    echo "IP already exists. Nothing to do."
else
    ssh $REMOTE_SERVER "echo $IP >> $REMOTE_DIR$REMOTE_FILE"
    echo "Added entry to hosts file. Exiting"
fi
~                                                                                                                                                                                                            
~          
