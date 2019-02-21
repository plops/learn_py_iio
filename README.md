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