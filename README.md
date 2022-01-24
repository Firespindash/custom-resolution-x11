# custom-resolution-x11
A program to set custom resolutions in xorg. It's a script to set probably any screen resolution you want to. (**default custom resolution is 1920x989**). \
This program was tested in openbox and i3wm, but it may work in any interface using X11. This script was mint to be used for VMs.

## Instructions
Run the script as root user. To run this program type on terminal `./setresolution.sh`. When it finishes work put the 'fixscreen.sh' script into the initialization of programs of your graphical interface. Then reboot your machine. If your environment overrides the resolution, you will need to set the new resolution using your graphical interface.

## Usability
This script was made to work only on single-head monitor configurations. And it sets just one resolution a time. The script creates a '10-monitor.conf' file to add permanently the custom resolution. With it, when you reboot the machine the resolution will already be set. And a 'fixscreen.sh' file for you to set the resolution to the screen on your graphical environment, if it doesn't override it. If you have some issues you can look [here](https://wiki.archlinux.org/index.php/Xrandr). This script is based in the Arch Wiki Xrandr guide. Depending on the issue make sure your system is updated.
