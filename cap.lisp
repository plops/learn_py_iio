;; c2ffi from arch linux
;; sudo mount /dev/mmcblk0p3 /mnt; export PATH=$PATH:/mnt/usr/local/bin



(ql:quickload :cl-autowrap/libffi)
(defparameter *spec-path* (merge-pathnames "stage/learn_py_iio/"
					   (user-homedir-pathname)))

(cffi:load-foreign-library "/usr/lib/libiio.so")

(with-open-file (s "/tmp/iio0.h"
		   :direction :output
		   :if-does-not-exist :create
		   :if-exists :supersede)
  ;(format s "#include \"/usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include/stddef.h\"~%") 
  ;(format s "#include \"/usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include/stdbool.h\"~%")
  ;(format s "#include \"/usr/include/limits.h\"~%") 
					;(format s "#  define INT_MAX       2147483647~%")
  (format s "#include <stddef.h>")
  (format s "#include \"/usr/include/iio.h\"~%"))

(autowrap:c-include "/tmp/iio0.h"
                    :spec-path *spec-path*
		    :exclude-definitions (".*")
		    :include-definitions
		    ("^iio.*"
		     "^IIO.*"
		     "size_t"
		     "uint32_t"
		     "ptrdiff_t"
		    )
		    :sysincludes '("/usr/include" "/usr/include/linux"
				   #+nil "/usr/lib64/clang/3.9.1/include/"
				   "/usr/lib64/clang/5.0.1/include/"
				   #+nil"/usr/lib64/gcc/x86_64-pc-linux-gnu/5.4.0/include")
		    #+nil :exclude-sources #+nil ("limits.h"
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

autowrap::*foreign-functions*


#+nil
((defparameter *sctx* (iio-create-scan-context (cffi:null-pointer) 0))
 (struct iio-context-info)

 (iio-scan-context-get-info-list *sctx* )

 (defparameter *ctx* (iio-create-default-context)))

(ql:quickload "cl-ppcre")

(defparameter *out*
 (with-output-to-string (s)
   (sb-ext:run-program "/usr/bin/iio_info" '("-s") :output s)))

(defparameter *uri* (elt (ppcre:all-matches-as-strings "usb:[^\]]*" *out*) 0))


(defparameter *ctx* (iio-create-context-from-uri *uri*))

"A_BALANCED"

(defparameter *rx-phy* (iio-context-find-device *ctx* "ad9361-phy"))

;; lo 2.4GHz
(iio-channel-attr-write-longlong
 (iio-device-find-channel *rx-phy*
			  "altvoltage0"
			  1)
 "frequency"
 (round 2.4e9))

;; baseband rate 5MS/s
(iio-channel-attr-write-longlong
 (iio-device-find-channel *rx-phy*
			  "voltage0"
			  0)
 "sampling_frequency"
 (round 5e6))

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Get the RX capture device structure ;;
    ;; Get the IQ input channels	   ;;
    ;; Enable I and Q channel		   ;;
    ;; Create the RX buffer		   ;;
    ;; Fill the buffer			   ;;
    ;; Process samples			   ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defparameter *dev* (iio-context-find-device *ctx* "cf-ad9361-lpc"))

(defparameter *i* (iio-device-find-channel *dev*
					    "voltage0"
					    0))
(defparameter *q* (iio-device-find-channel *dev*
					    "voltage1"
					    0))

(iio-channel-enable *i*)
(iio-channel-enable *q*)



;; __api struct iio_buffer * iio_device_create_buffer (const struct iio_device *dev,
;;        size_t samples_count, bool cyclic) 


(cffi:defcfun ("iio_device_create_buffer" %create-buffer) :pointer
  (dev :pointer)
  (sample-count size-t #+nil :uint64)
  (cyclic :uint8))


(AUTOWRAP:DEFINE-FOREIGN-FUNCTION
     '(IIO-DEVICE-CREATE-BUFFER "iio_device_create_buffer")
     '(:POINTER (AUTOWRAP::STRUCT (IIO-BUFFER :BIT-SIZE 0 :BIT-ALIGNMENT 0)))
     '((DEV
        (:POINTER
         (AUTOWRAP::STRUCT (IIO-DEVICE :BIT-SIZE 0 :BIT-ALIGNMENT 0))))
       (SAMPLES-COUNT SIZE-T) (CYCLIC :UNSIGNED-CHAR)))

(AUTOWRAP:DEFINE-FOREIGN-FUNCTION
     '(IIO-DEVICE-CREATE-BUFFER "iio_device_create_buffer")
     '(:POINTER)
     '((DEV
        :POINTER)
       (SAMPLES-COUNT :uint64)
       (CYCLIC :UNSIGNED-CHAR)))


(gethash 'IIO-DEVICE-CREATE-BUFFER autowrap::*foreign-functions*)
#+nil
(defparameter *buf*
  (iio-device-create-buffer *dev* 4096 0))

(defparameter *buf*
  (%create-buffer (iio-device-ptr *dev*) 4096 0))

(iio-buffer-refill *buf*)

(let ((p-inc (iio-buffer-step *buf*))
      (p-end (iio-buffer-end *buf*))
      (p-dat (iio-buffer-first *buf* *i*)))
  (loop 
     do       
       (setf p-dat (sb-sys:sap+ p-dat p-inc)
	     ;t-dat (sb-sys:sap+ t-dat p-inc)
	     )
      
       (let ((i (cffi:mem-aref p-dat :uint16 0))
	     (q (cffi:mem-aref p-dat :uint16 1)))
	 (format t
		 "~a~%" (list i q)))

     until (cffi:pointer-eq p-dat p-end)))
(iio-buffer-destroy *buf*)
(iio-context-destroy *ctx*)

#+nil
(autowrap:with-alloc (rx '(:struct stream-cfg))
  (setf stream-clear-))

;; examples/ad9361-iiostream.c

;; https://wiki.analog.com/university/tools/pluto/controlling_the_transceiver_and_transferring_data
