#! /bin/bash

echo "<=== Discord Updater Tool v1.1 ===>"
echo "<=== by AlekSmola https://github.com/AlekSmola/Discord-Terminal-Updater ===>"
echo ""
echo "Getting current version..."
CURRENT_VERSION=$(dpkg-query --showformat='${Version}' --show discord)
URL=https://discordapp.com/api/download?platform=linux
TEMP_LOCATION=~/Downloads/discord_update.deb
NEWER_VERSION=$(wget --spider $URL 2>&1 | grep "Location")
# echo "/var/cpanel/users/joebloggs:DNS9=domain.example" | sed 's/.*\/\(.*\):.*/\1/'
NEWER_VERSION=$( echo ${NEWER_VERSION##*/} | cut -d'-' -f 2 | cut -d'd' -f 1 | rev | cut -c 2- | rev )
echo "Current version installed: $CURRENT_VERSION versus newest version: $NEWER_VERSION"

if [ "$CURRENT_VERSION" = "$NEWER_VERSION" ]; then
    echo "You are using the newest version. Nothing to do."
    exit 0
else
    echo "Update is required, gathering package..."
    wget $URL -O $TEMP_LOCATION
    if [ "$?" = "0" ]; then 
        echo echo "Gathered package"
        echo "Installing, sudo rights will be required:"
    else 
        echo "Something went wrong. URL used to gather package: $URL. Exiting."
        exit 1 
    fi
    sudo apt install $TEMP_LOCATION

    echo "Removing update packege: $TEMP_LOCATION"
    \rm $TEMP_LOCATION
    echo "Done doing, thank you"
    exit 0
fi
