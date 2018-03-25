# https://ez.analog.com/thread/97117-using-iiopy-with-m2k
# https://mirrors.dotsrc.org/fosdem/2018/AW1.120/plutosdr.webm
# https://wiki.analog.com/resources/tools-software/linux-software/fmcomms2_plugin
import iio, struct, time
import scipy.signal
import numpy as np
import matplotlib.pyplot as plt
ctxs = iio.scan_contexts()
uri = next(iter(ctxs),None)
ctx = iio.Context(uri)
dev = ctx.find_device('cf-ad9361-lpc')
phy = ctx.find_device('ad9361-phy')
phy.channels[0].attrs['frequency'].value = str(int(1575.42e6)) 
dev.channels[0].enabled = True
dev.channels[1].enabled = True
buf = iio.Buffer(dev,4096,cyclic=False)
ys = []
for i in range(1024):
    buf.refill()
    ys.append(buf.read())
d=np.frombuffer(np.array([inner for outer in ys for inner in outer]),dtype=np.int16)
q= d[::2]+1j*d[1::2]
f,t,z=scipy.signal.stft(q[0:32*4096])
plt.imshow(np.abs(z))
plt.show()


print(iio.version)

ctxs = iio.scan_contexts()

print(len(ctxs))

uri = next(iter(ctxs),None)

ctx = iio.Context(uri)


print(ctx.name)

print(ctx.attrs)

#{'hw_model': 'Analog Devices PlutoSDR Rev.B (Z7010-AD9363)', 'usb,release': '2.0', 'ad9361-phy,xo_correction': '40000035', 'usb,idVendor': '0456', 'usb,vendor': 'Analog Devices Inc.', 'usb,product': 'PlutoSDR (ADALM-PLUTO)', 'usb,idProduct': 'b673', 'fw_version': 'v0.26', 'hw_model_variant': '1', 'local,kernel': '4.9.0-10194-g40c2158', 'hw_serial': '', 'ad9361-phy,model': 'ad9364'}

[print(dev.id + ' ' + dev.name) for dev in ctx.devices]

# iio:device3 cf-ad9361-dds-core-lpc
# iio:device1 ad9361-phy
# iio:device4 cf-ad9361-lpc
# iio:device2 xadc
# iio:device0 adm1177

# [print(dev.name + ' ' + str(dev.channels)) for dev in ctx.devices]

dev = ctx.find_device('cf-ad9361-lpc')
phy = ctx.find_device('ad9361-phy')

print( len(phy.channels) )

for i in range(len(phy.channels) ):
    print(phy.channels[i].name)
# print rx lo
print(phy.channels[0].attrs['frequency'].value)
print(type(int(90e6)))
phy.channels[0].attrs['frequency'].value = str(int(2412e6)) 
    
# https://github.com/analogdevicesinc/libiio/issues/109
# https://ez.analog.com/thread/92031-ad9361-python-binding
print(dev.channels)
print(dev.sample_size)

print(dev.channels[0].enabled) 
dev.channels[0].enabled = True
dev.channels[1].enabled = True

buf = iio.Buffer(dev,4096,cyclic=False)

buf.refill()

x = buf.read()
#print(x)

import numpy as np

d = np.frombuffer(x,dtype=np.int16)

import matplotlib.pyplot as plt

import numpy.fft

print([0,1,2,3,4][1::2])

k = numpy.fft.fftshift(numpy.fft.fft(d[::2]+1j*d[1::2]))

plt.plot(np.abs(k))
plt.show()


ys = []
for i in range(1024):
    buf.refill()
    ys.append(buf.read())
1
d=np.frombuffer(np.array([inner for outer in ys for inner in outer]),dtype=np.int16)
print(d.shape)

d = np.array([np.frombuffer(y,dtype=np.int16) for y in ys])

q= d[::2]+1j*d[1::2]

f,t,z=scipy.signal.stft(q[0:32*4096])
print(z.shape)
plt.pcolormesh(f,t,np.abs(z))
plt.imshow(np.abs(z))
s.shape

plt.plot(d[::2])
plt.show()
