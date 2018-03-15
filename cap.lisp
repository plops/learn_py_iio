;; c2ffi from arch linux
;; sudo mount /dev/mmcblk0p3 /mnt; export PATH=$PATH:/mnt/usr/local/bin



(ql:quickload :cl-autowrap)
(defparameter *spec-path* (merge-pathnames "stage/learn_py_iio/"
					   (user-homedir-pathname)))

(cffi:load-foreign-library "/usr/lib/libiio.so")

(with-open-file (s "/tmp/iio0.h"
		   :direction :output
		   :if-does-not-exist :create
		   :if-exists :supersede)
  (format s "#include \"/usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include/stddef.h\"~%") 
  (format s "#include \"/usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include/stdbool.h\"~%")
  ;(format s "#include \"/usr/include/limits.h\"~%") 
  (format s
	  "#  define INT_MAX       2147483647~%")
  (format s "#include \"/usr/include/iio.h\"~%"))

(autowrap:c-include "/tmp/iio0.h"
                    :spec-path *spec-path*
		    :exclude-definitions
		    (".*")
		    :include-definitions
		    ("^iio.*"
		     "^IIO.*")
		    :sysincludes '("/usr/include" "/usr/include/linux"
				   "/usr/lib64/clang/3.9.1/include/"
				   #+nil"/usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include")
		    :exclude-sources ("limits.h"
				      "stdint.h"
				      "stdlib.h"
				      "stddef.h"
				      )
		    :exclude-constants (".*")
		    :exclude-definitions ("^_" "^va_list$")
		    :no-accessors t
                    :exclude-arch ("arm-pc-linux-gnu"
                                   "i386-unknown-freebsd"
				   "i386-unknown-openbsd"
                                   "i686-apple-darwin9"
                                   "i686-pc-linux-gnu"
                                   "i686-pc-windows-msvc"
                                   "x86_64-apple-darwin9"
                                        ;"x86_64-pc-linux-gnu"
                                   "x86_64-pc-windows-msvc"
                                   "x86_64-unknown-freebsd"
				   "x86_64-unknown-openbsd")
		    :trace-c2ffi t)


#+nil
((defparameter *sctx* (iio-create-scan-context (cffi:null-pointer) 0))
 (struct iio-context-info)

 (iio-scan-context-get-info-list *sctx* )

 (defparameter *ctx* (iio-create-default-context)))


(defparameter *ctx* (iio-create-context-from-uri "usb:1.4.5"))
(defparameter *rx-stream-dev* (iio-context-find-device *ctx* "cf-ad9361-lpc"))
"A_BALANCED"
examples/ad9361-iiostream.c
