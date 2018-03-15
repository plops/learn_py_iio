;; c2ffi from arch linux
;; sudo mount /dev/mmcblk0p3 /mnt; export PATH=$PATH:/mnt/usr/local/bin

(ql:quickload :cl-autowrap)
(defparameter *spec-path* (merge-pathnames "stage/py_learn_iio/"
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

(autowrap::run-check autowrap::*c2ffi-program*
		     (autowrap::list "/tmp/iio0.h"
				     "-D" "null"
				     "-M" "/tmp/iio_macros.h"
				     "-A" "x86_64-pc-linux-gnu"))

(with-open-file (s "/tmp/iio1.h"
		   :direction :output
		   :if-does-not-exist :create
		   :if-exists :supersede)
  
  (format s "#include \"/tmp/iio0.h\"~%")
  #+nil (format s "#include \"/tmp/iio_macros.h\"~%"))

;; c2ffi  /usr/include/iio.h -i /usr/include/linux -x c --std=c99 --with-macro-defs -i   /usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include/ 2>&1
 



(autowrap:c-include "/tmp/iio1.h"
                    :spec-path *spec-path*
		    :sysincludes '("/usr/include")
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
                    #+nil :exclude-sources #+nil ( "/usr/include/_G_config.h"
						   "/usr/include/bits/stdio_lim.h"
						   "/usr/include/bits/sys_errlist.h"
						   "/usr/include/bits/types.h"
						   "/usr/include/bits/typesizes.h"
						   "/usr/include/bits/wordsize.h"
						   "/usr/include/features.h"
						   "/usr/include/fftw3.h"
						   "/usr/include/gnu/stubs-64.h"
						   "/usr/include/libio.h"
						   "/usr/include/stdc-predef.h"
						   "/usr/include/stdio.h"
						   "/usr/include/sys/cdefs.h"
						   "/usr/include/wchar.h")
					;:include-sources ("/usr/include/limits.h")
		    :trace-c2ffi t)
