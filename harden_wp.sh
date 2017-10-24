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
read -p "Enter user your web server runs as, i.e.: www-data or nginx (nginx): " serverUser
serverUser=${serverUser:-nginx}
echo " "
read -p "Your user account name ($SUDO_USER): " userAccount
userAccount=${userAccount:-$SUDO_USER}

echo " "
read -e -p "Path to WordPress ($PWD): " wordpressPath
wordpressPath=${wordpressPath:-$PWD}
wordpressPath=${wordpressPath%/}
if [ ! -f "$wordpressPath/wp-config.php" ]; then
	echo "Script exiting because could not find \"$wordpressPath/wp-config.php\"... i.e.: does not look like valid WordPress install."
	exit
fi

echo " "
echo "Choose option below:"
read -p "Enter 1 to harden or 2 to loose (1): " harden
harden=${harden:-"1"}

if [ $harden -eq "2" ]
then
	chown $serverUser:$serverUser -R $wordpressPath  #Let serverAccount be owner (usefull for upgrading/theme changes... I did this during some the7 changes)
else
	find $wordpressPath -type d -exec chmod 755 {} \; # Change directory permissions rwxr-xr-x
	find $wordpressPath -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
	chown $userAccount:$userAccount  -R $wordpressPath # Let your useraccount be owner
	chown $serverUser:$serverUser -R "$wordpressPath/wp-content/" # Let apache be owner of wp-content
	chown $userAccount:$userAccount  -R "$wordpressPath/wp-content/plugins/" # Let your useraccount be owner
fi
