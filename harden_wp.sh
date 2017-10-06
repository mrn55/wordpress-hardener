#!/bin/bash
# -----------------------------------------------------------------
# harden_wp.sh for WordPress (production)
# Harden your Wordpress install by Neal Blackburn
# Based on answers provided by ManuelSchneid3r here: https://stackoverflow.com/a/23755604
# and on information provided here: https://codex.wordpress.org/Hardening_WordPress
# -----------------------------------------------------------------

clear

echo "Run this script at the root of your wordpress install!"
echo " "
echo "Type user (commonly www-data or nginx) web runs as?"
read serverUser
echo " "
echo "Type your user account name:"
read userAccount

echo " "
echo "Choose option below:"
read -p "Enter [1] to harden or 2 to loose:" harden
harden=${harden:-"1"}

if [ $harden -eq "2" ]
then
	chown $serverUser:$serverUser -R $PWD  #Let serverAccount be owner (usefull for upgrading/theme changes... I did this during some the7 changes)
else
	find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
	find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
	chown $userAccount:$userAccount  -R ./ # Let your useraccount be owner
	chown $serverUser:$serverUser -R wp-content/ # Let apache be owner of wp-content
	chown $userAccount:$userAccount  -R wp-content/plugins/ # Let your useraccount be owner
fi
