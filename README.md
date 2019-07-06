# Installation

`aurman -S libiio` gets source from https://github.com/analogdevicesinc/libiio it also comes with python bindings https://github.com/analogdevicesinc/libiio/tree/master/bindings/python

```[martin@gpd learn_py_iio]$ iio_info -n 192.168.2.1 | grep device
IIO context has 5 devices:
        iio:device3: cf-ad9361-dds-core-lpc (buffer capable)
        iio:device1: ad9361-phy
                18 device-specific attributes found:
                                attr  0: dcxo_tune_coarse ERROR: No such device (-19)
                                attr  6: dcxo_tune_fine ERROR: No such device (-19)
        iio:device4: cf-ad9361-lpc (buffer capable)
                                attr  3: samples_pps ERROR: No such device (-19)
                                attr  3: samples_pps ERROR: No such device (-19)
        iio:device2: xadc
                1 device-specific attributes found:
        iio:device0: adm1177
```
Aurman and cmake only install iio for python 3. ccmake only shows PYTHON_BINDINGS. I just install it manually after the build:
```
cd bindings/python/
[martin@gpd python]$ ls
CMakeFiles  Makefile  build  cmake_install.cmake  setup.py
[martin@gpd python]$ sudo python2 setup.py install
```


`git clone https://github.com/analogdevicesinc/libad9361-iio`


`https://github.com/analogdevicesinc/plutosdr-fw` seems to contain the firmware sources, I haven't tried building it, yet


# References:

* https://wiki.analog.com/university/tools/pluto/users/customizing ssh root@192.168.2.1  password=analog
* broadcom wifi as sdr https://github.com/seemoo-lab/mobisys2018_nexmon_software_defined_radio
* https://www.analog.com/media/en/technical-documentation/data-sheets/ad9364.pdf datasheet
* https://ez.analog.com/university-program/f/q-a/97283/ad9361-iiostream-on-adalm-pluto bare metal transmitting
* https://archive.fosdem.org/2018/schedule/event/plutosdr/attachments/slides/2503/export/events/attachments/plutosdr/slides/2503/pluto_stupid_tricks.pdf fosdem 2018 slides, board pics, 64 qam, RXO3225M 40MHz oscillator,
* https://www.analog.com/media/en/training-seminars/design-handbooks/Software-Defined-Radio-for-Engineers-2018/SDR4Engineers.pdf adc only has 4.5bits, half band filters bring it up to 12 bits, they show timing recovery with all-digital pll, carrier recovery, 802.11a WLAN receiver
* https://wiki.analog.com/resources/tools-software/linux-software/libiio_internals docs on libiio, explains cyclic buffers (only useful for TX), iiod interface

# Firmware upgrade

https://wiki.analog.com/university/tools/pluto/users/firmware

## into ram

https://wiki.analog.com/university/tools/pluto/devs/reboot

```
pacman -S dfu-util sshpass

wget https://github.com/analogdevicesinc/plutosdr-fw/releases/download/v0.31/plutosdr-fw-v0.31.zip
sshpass -p analog ssh -o StrictHostKeyChecking=no,UserKnownHostsFile=/dev/null root@192.168.2.1
device_reboot ram
```

When the device is in DFU mode, the DONE LED is OFF, while LED1 is constantly ON. The device switches it’s USB PID to 0xB674 (PlutoSDR DFU)

in ram mode LED1 is on (but not bright)

```
~/stage/learn_py_iio $ lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 008: ID 0456:b674 Analog Devices, Inc.


sudo dfu-util -l
sudo dfu-util -d 0456:b673,0456:b674 -D pluto.dfu -a firmware.dfu
sudo dfu-util -d 0456:b673,0456:b674  -a firmware.dfu -e



Opening DFU capable USB device...
ID 0456:b674
Run-time device DFU version 0110
Claiming USB DFU Interface...
Setting Alternate Setting #1 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0110
Device returned transfer size 4096
Copying data from PC to DFU device
Download	[=========================] 100%     10100803 bytes
Download done.
state(7) = dfuMANIFEST, status(0) = No error condition is present
state(2) = dfuIDLE, status(0) = No error condition is present
Done!



Opening DFU capable USB device...
ID 0456:b674
Run-time device DFU version 0110
Claiming USB DFU Interface...
Setting Alternate Setting #1 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0110
Device returned transfer size 4096

# uname -a
Linux pluto 4.14.0-42540-g387d584 #301 SMP PREEMPT Wed Jul 3 15:06:53 CEST 2019 armv7l GNU/Linux
```

## store firmware in flash

sshpass -p analog ssh -o StrictHostKeyChecking=no,UserKnownHostsFile=/dev/null root@192.168.2.1 device_reboot sf

led1 is constant bright, the other off


## modify firmware and link applications

https://archive.fosdem.org/2018/schedule/event/plutosdr/attachments/slides/2503/export/events/attachments/plutosdr/slides/2503/pluto_stupid_tricks.pdf


# network analyzer

# gps antenna

https://www.youtube.com/watch?v=eVI2qv7pv88
section 3.2 in https://www.u-blox.com/sites/default/files/products/documents/GPS-Antenna_AppNote_%28GPS-X-08014%29.pdf?utm_source=en%2Fimages%2Fdownloads%2FProduct_Docs%2FGPS_Antennas_ApplicationNote%28GPS-X-08014%29.pdf      

# gps bandpass

epcos b9444 saw filter (50cent @ 15000) www.mouser.com/ds/2/400/B9444-525499.pdf