#!/bin/bash

CONFIG="$1"
COMMAND="$2"
BOOLEAN="false"

if [ $# -ne 2 ]
then
    echo "ERROR: $0 requires two parameters {virtual-host} {restart|reload}"
    exit 1
fi

# List all of the configuration files in the _/etc/apache2/sites-available/_ directory
VHOSTS_PATH=/etc/apache2/sites-available/*.conf 

for FILENAME in ${VHOSTS_PATH}
do  
     
        if [ "$CONFIG" == "${FILENAME:29}" ]
        then
            BOOLEAN="true"
        fi
done

COUNTER=1

if [ $BOOLEAN == "false" ]
then    echo "ERROR: "$CONFIG" is not a valid virtual-host file."
        echo "Correct filenames include: "
        for FILENAME in ${VHOSTS_PATH}
        do echo "-" ${FILENAME:29}
        done
exit 1
fi

if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
then
    # Move the current execution state to the proper directory
    cd /etc/apache2/sites-available

    # Disable a vhost configuration
    sudo a2dissite "$CONFIG"
    sudo service apache2 "$COMMAND"

    # Enable a vhost configuration
    sudo a2ensite "$CONFIG"
    sudo service apache2 "$COMMAND"

else 
    echo "ERROR: $COMMAND is not a valid service directive {reload|restart}"
    exit 1
fi