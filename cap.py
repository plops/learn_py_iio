# https://ez.analog.com/thread/97117-using-iiopy-with-m2k
# https://mirrors.dotsrc.org/fosdem/2018/AW1.120/plutosdr.webm
# https://wiki.analog.com/resources/tools-software/linux-software/fmcomms2_plugin
import iio, struct, time

print(iio.version)

ctxs = iio.scan_contexts()

print(len(ctxs))

uri = next(iter(ctxs),None)

ctx3 = iio.Context(uri)


prin3t(ctx.name)

print(ctx.attrs)

#{'hw_model': 'Analog Devices PlutoSDR Rev.B (Z7010-AD9363)', 'usb,release': '2.0', 'ad9361-phy,xo_correction': '40000035', 'usb,idVendor': '0456', 'usb,vendor': 'Analog Devices Inc.', 'usb,product': 'PlutoSDR (ADALM-PLUTO)', 'usb,idProduct': 'b673', 'fw_version': 'v0.26', 'hw_model_variant': '1', 'local,kernel': '4.9.0-10194-g40c2158', 'hw_serial': '', 'ad9361-phy,model': 'ad9364'}

print(ctx.devices)

[print(dev.id + ' ' + dev.name) for dev in ctx.devices]

# iio:device3 cf-ad9361-dds-core-lpc
# iio:device1 ad9361-phy
# iio:device4 cf-ad9361-lpc
# iio:device2 xadc
# iio:device0 adm1177


[print(dev.name + ' ' + str(dev.channels)) for dev in ctx.devices]

dev = ctx.find_device('cf-ad9361-lpc')

c0 = dev.find_channel('voltage0',True)
c1 = dev.find_channel('voltage1',True)
# https://github.com/analogdevicesinc/libiio/issues/109
# https://ez.analog.com/thread/92031-ad9361-python-binding
print(dev.channels)

print(dev.enabled)

print(dev.sample_size)

print(dev.channels[0].enabled) 
dev.channels[0].enabled = True
dev.channels[1].enabled = True


c0.enabled = True
c1.enabled = True

buf = iio.Buffer(dev,4096,cyclic=False)

buf.refill()

x = buf.read()
print(x)

