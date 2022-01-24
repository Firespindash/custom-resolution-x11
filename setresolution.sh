#!/bin/bash

# Author: Firespindash
# License: MIT

xorgpath="/etc/X11/xorg.conf.d"

[ $EUID != 0 ] && { printf "Please run as root user.\n"; exit; }

command -v xrandr > /dev/null
[ $? -eq 0 ] || { printf "This script needs xrandr to run.\n"; exit; }
command -v cvt > /dev/null
[ $? -eq 0 ] || { echo "This script needs cvt to run."; exit; }

read -p "Choose the custom resolution you want? [1920x989] " resolution
[ "$resolution" ] && resolution="${resolution/x/ }" || resolution="1920 989"

cvt $resolution > /dev/null 2> /dev/null
[ $? -eq 0 ] || { echo "Not a valid input."; exit; }

printf "Detecting monitor name...\n"

monitor=$(xrandr | grep " connected " | awk '{ print $1 }')

printf "Detecting resolution...\n"

preferredresolution=$(cvt $resolution | grep Modeline | cut -d '"' -f2 | cut -d '_' -f1)

fix_resolution() { cvt $resolution | grep Modeline | cut -f2 | cut -d '_' -f1; }
detect_properties() { cvt $resolution | grep Modeline | cut -d '"' -f3 | cut -d '_' -f1; }

newfixedresolution="$(echo "$(cvt $resolution | grep Modeline | cut -d ' ' -f2 | cut -d '_' -f1)"'"'"$(detect_properties)")"
finalresolution="$(echo "$(fix_resolution)"'"'"$(detect_properties)")"

printf "Trying to write the new resolution...\n"

xrandr --newmode $newfixedresolution 
xrandr --addmode $monitor $preferredresolution 2> /dev/null

[ -f $xorgpath/10-monitor.conf ] &&
    cp $xorgpath/10-monitor.conf $xorgpath/10-monitor.conf.bak

echo 'Section "Monitor"' > $xorgpath/10-monitor.conf
echo "	Identifier \"$monitor\"" >> $xorgpath/10-monitor.conf
echo "	$finalresolution" >> $xorgpath/10-monitor.conf
echo "	Option \"PreferredMode\" \"$preferredresolution\"" >> $xorgpath/10-monitor.conf
echo 'EndSection' >> $xorgpath/10-monitor.conf

printf "Trying to set the new resolution...\n"

xrandr --output $monitor --mode $preferredresolution 2> /dev/null

printf "Generating command on file...\n"

echo '#!/bin/bash' > fixscreen.sh
echo '' >> fixscreen.sh
echo "xrandr --output $monitor --mode $preferredresolution" >> fixscreen.sh

printf "Making file executable...\n\n"

chmod +x fixscreen.sh
chown $USER:$USER fixscreen.sh

printf "Now put the fixscreen.sh file in the initalization of your graphical system.\n"
printf "Then reboot your machine. \n"
