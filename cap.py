import iio, struct, time

print(iio.version)

ctxs = iio.scan_contexts()

print(len(ctxs))

uri = next(iter(ctxs),None)

ctx = iio.Context(uri)

print(ctx.name)

print(ctx.attrs)

#{'hw_model': 'Analog Devices PlutoSDR Rev.B (Z7010-AD9363)', 'usb,release': '2.0', 'ad9361-phy,xo_correction': '40000035', 'usb,idVendor': '0456', 'usb,vendor': 'Analog Devices Inc.', 'usb,serial': '104400b83991000b0d000f00bbd8642eff', 'usb,product': 'PlutoSDR (ADALM-PLUTO)', 'usb,idProduct': 'b673', 'fw_version': 'v0.26', 'hw_model_variant': '1', 'local,kernel': '4.9.0-10194-g40c2158', 'hw_serial': '104400b83991000b0d000f00bbd8642eff', 'ad9361-phy,model': 'ad9364'}





