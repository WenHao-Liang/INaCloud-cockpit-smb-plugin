#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit
fi

if ! which apt > /dev/null; then
   if rpm -q cockpit
   then
      version=`yum info cockpit | grep -i "Version" | awk '{ print $3 }'`
      echo "Installed version: $version"
	  
      mkdir /usr/share/cockpit/smb
      wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/manifest.json -O /usr/share/cockpit/smb/manifest.json
      wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/smb.js -O /usr/share/cockpit/smb/smb.js
      if [ "$version" -ge "196" ]; then
         wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/index.html -O /usr/share/cockpit/smb/index.html
      else
	     # all versions below 196 still use old gui
         wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/v1.0/index.html -O /usr/share/cockpit/smb/index.html
      fi
   else
      echo "Cockpit is not installed, please install cockpit first."
      exit
   fi
else
   PKG_OK=$(dpkg-query -W --showformat='${Status}\n' cockpit | grep "install ok installed")
   
   if [ "" == "$PKG_OK" ]; then
      echo "Cockpit is not installed, please install cockpit first."
      exit
   else
      version=`apt-cache policy cockpit | grep -i "Installed" | awk '{ print $2 }' | awk -F'-' '{ print $1 }'`
      echo "Installed version: $version"
      mkdir /usr/share/cockpit/smb
      wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/manifest.json -O /usr/share/cockpit/smb/manifest.json
      wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/smb.js -O /usr/share/cockpit/smb/smb.js
      if [ "$version" -ge "196" ]; then
         wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/index.html -O /usr/share/cockpit/smb/index.html
      else
	     # all versions below 196 still use old gui
         wget https://raw.githubusercontent.com/enira/cockpit-smb-plugin/v1.0/index.html -O /usr/share/cockpit/smb/index.html
      fi
   fi
fi
