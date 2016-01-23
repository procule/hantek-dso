README
======

System installation
-------------------

### Linux (udev)

Since this module makes calls to a USB device via [libusb](https://en.wikipedia.org/wiki/Libusb), permissions have to be granted.

Most Linux distributions have [udev](https://en.wikipedia.org/wiki/Udev).
On Debian-based system, a group called *plugdev* is present and is used to give access to removable devices. Since the Hantek
 oscilloscope is USB-pluggable, this group is perfect.
 
Check to see if you are in the *plugdev* group:
> $ groups  
< **groups listed** > 

If not, add your user to the group:
> $ sudo usermod -a -G plugdev $USER

Add an udev rule to give read-write access to Hantek oscilloscope USB device for group *plugdev*:
> $ cat << EOF > /etc/udev/rules.d/46-Hantek.rules  
SUBSYSTEMS=="usb", ATTRS{idVendor}=="049f", ATTRS{idProduct}=="505a", SYMLINK+="hantek", GROUP=="plugdev   
EOF

Reload *udev* daemon:
> $ sudo service udev reload

Now, plug the USB cable of the scope and a new device should be visible in */dev* with the *plugdev* group owner:
> $ ls -lL /dev/hantek  
crw-rw-r-- 1 root plugdev 189, 699 Jan 1 00:00 /dev/hantek

