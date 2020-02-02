#!/bin/bash

# Author: Firespindash
# License: MIT

if [[ $EUID != 0 ]] 
then
    printf "Please run as root user.\n"
    exit 
fi

resolution="1920 989"  # set the custom resolution here.

printf "Before using this script make sure you have xrandr and cvt installed. \n"
printf "And write the resolution you want in the variable 'resolution' of the script. \n\n" && sleep 5

printf "Detecting monitor name...\n"

monitor=$(xrandr | grep " connected " | awk '{ print$1 }')

printf "Detecting resolution...\n"

preferredresolution=$(cvt $resolution | grep Modeline | cut -d '"' -f2 | cut -d'_' -f1)

fix_resolution() { cvt $resolution | grep Modeline | cut -f2 | cut -d'_' -f1; }
detect_properties() { cvt $resolution | grep Modeline | cut -d '"' -f3 | cut -d'_' -f1; }

newfixedresolution="$(echo "$(cvt $resolution | grep Modeline | cut -d ' ' -f2 | cut -d'_' -f1)"'"'"$(detect_properties)")"

finalresolution="$(echo "$(fix_resolution)"'"'"$(detect_properties)")"

printf "Writing the resolution...\n"

xrandr --newmode $newfixedresolution

xrandr --addmode $monitor $preferredresolution

if [[ -f 10-monitor.conf && ! -f 10-monitor.conf.bak ]]
then
    cp /etc/X11/xorg.conf.d/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf.bak
fi

echo 'Section "Monitor"' > /etc/X11/xorg.conf.d/10-monitor.conf
echo "	Identifier \"$monitor\"" >> /etc/X11/xorg.conf.d/10-monitor.conf
echo "	$finalresolution" >> /etc/X11/xorg.conf.d/10-monitor.conf
echo "	Option \"PreferredMode\" \"$preferredresolution\"" >> /etc/X11/xorg.conf.d/10-monitor.conf
echo 'EndSection' >> /etc/X11/xorg.conf.d/10-monitor.conf

printf "Setting the resolution...\n"

xrandr --output $monitor --mode $preferredresolution

command=$(echo "xrandr --output $monitor --mode $preferredresolution")

printf "Generating command on file...\n"

sudo echo '#!/bin/bash' > ./fixscreen.sh
sudo echo ' ' >> ./fixscreen.sh
sudo echo "$command" >> ./fixscreen.sh

printf "Making file executable...\n\n"

chmod +x fixscreen.sh

printf "Now put the fixscreen.sh file in the initalization of your graphical system.\n"
printf "Then reboot your machine. \n"
