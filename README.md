# custom-resolution-x11
A program to set custom resolutions in xorg. It's a script to set probably any screen resolution you want to. (**default custom resolution is 1920x989**). \
This program was tested in openbox and i3wm, but it may work in any interface using X11. The script was made to run in bash and X11.

## Instructions
Run the script as root user. Before using the script write the resolution you want in the variable *resolution* inside the script and make sure you have xrandr, cvt and sudo installed. When writing the resolution you want to set, put the 2 numbers separated without an x between them. To run this program type on terminal `./setresolution.sh`. When it finish work put the 'fixscreen.sh' script into the initialization of programs of your graphical interface.

## Usability
This program is not mented to work with multiple monitors. And it set just one resolution a time. The '10-monitor.conf' file is to add permanently the custom resolution. With it when you reboot the machine the resolution will already be set. The 'fixscreen.sh' file is to set the resolution to screen when you run it at the initialization or when you just run it. If you have some issues you can look [here](https://wiki.archlinux.org/index.php/Xrandr). The program is based in the Arch Wiki Xrandr guide.
