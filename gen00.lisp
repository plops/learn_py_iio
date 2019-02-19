(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-py-generator"))
(in-package :cl-py-generator)

(progn
  (defparameter *path* "/home/martin/stage/learn_py_iio")
  (defparameter *code-file* "run_gui")
  (defparameter *source* (format nil "~a/source/~a" *path* *code-file*))

  (let* ((code
	  `(do0
	    "#!/usr/bin/env python2"


	    (string3 ,(format nil "trellis dataflow gui.
Usage:
  ~a [-vh]

Options:
  -h --help               Show this screen
  -v --verbose            Print debugging output
"
			      *code-file*))
	    
	    "# martin kielhorn 2019-02-19"
	    "# pip2 install --user PySide2"
	    "# example from https://pypi.org/project/Trellis/0.7a2/"
	    "#  pip install --user Trellis==0.7a2"
	    "# wget http://peak.telecommunity.com/snapshots/Contextual-0.7a1.dev-r2695.tar.gz http://peak.telecommunity.com/snapshots/Trellis-0.7a3-dev-r2610.tar.gz "
	    "#  pip2 install --user Contextual-0.7a1.dev-r2695.tar.gz"
	    "# i installed trellis by commenting out the contextual line in its setup.py and then extracting the egg file into ~/.local/lib/python2.7/site-packages/peak"
	    ;;"from peak.events import trellis"

	    (imports (os
		      sys
		      docopt
		      (np numpy)
		      (pd pandas)
		      pathlib
		      re
		      ))

	    
	    (imports (traceback))

	    (imports ((qw PySide2.QtWidgets)
		      (qc PySide2.QtCore)
		      (qg PySide2.QtGui)))
	    (imports (iio))
	    
	    (setf args (docopt.docopt __doc__ :version (string "0.0.1")))
	    (if (aref args (string "--verbose"))
		(print args))
	    #+nil(do0
	     (class PandasTableModel (qc.QAbstractTableModel)
		    (def __init__ (self dataframe &key (parent None))
		      (qc.QAbstractTableModel.__init__ self)
		      (setf self.dataframe dataframe))
		    (def flags (self index)
		      (if (not (index.isValid))
			  (return None))
		      (return (or qc.Qt.ItemIsEnabled qc.Qt.ItemIsSelectable)))
		    (def rowCount (self *args **kwargs)
		      (return (len self.dataframe.index)))
		    (def columnCount (self *args **kwargs)
		      (return (len self.dataframe.columns)))
		    (def headerData (self section orientation
					  role)
		      (if (!= qc.Qt.DisplayRole role)
			  (return None))
		      (try
		       (do0
			(if (== qc.Qt.Horizontal orientation)
			    (return (aref ("list" self.dataframe.columns) section)))
			(if (== qc.Qt.Vertical orientation)
			    (return (aref ("list" self.dataframe.index) section))))
		       (IndexError
			(return None))))
		    (def data (self index role)
		      (if (!= qc.Qt.DisplayRole role)
			  (return None))
		      (if (not (index.isValid))
			  (return None))
		      (return (str (aref self.dataframe.iloc
					 (index.row)
					 (index.column))))))
	     

	     (class PandasView (qw.QWidget)
		    (def __init__ (self df)
		      (dot (super PandasView self)
			   (__init__))
		      (setf self.model (PandasTableModel df)
			    self.table_view (qw.QTableView)
			    )
		      (self.table_view.setModel self.model)
		      (do0
		       (setf self.main_layout (qw.QHBoxLayout))
		       (self.main_layout.addWidget self.table_view)
		       (self.setLayout self.main_layout))
		      )))

	    (class PlutoTreeView (qw.QWidget)
		   (def __init__ (self ctx )
		     (dot (super PlutoTreeView self)
			  (__init__))
		     (setf self.model (qg.QStandardItemModel)
			   self.tree_view (qw.QTreeView))
		     (self.model.setHorizontalHeaderLabels
		      (list (string "key") (string "value")))
		     (self.tree_view.setModel self.model)
		     
		     (self.tree_view.setUniformRowHeights True)
		     (do0
			     (setf parent (qg.QStandardItem
					   (string attrs)))
			     (for ((ntuple key value)
					   (dot ctx.attrs (viewitems)))
				      (parent.appendRow
				       (list (qg.QStandardItem
					      (dot (string "{}")
						   (format key)))
					     (qg.QStandardItem
					      (dot (string "{}")
						   (format value))))))
			     (self.model.appendRow parent)
			     #+nil (self.tree_view.setFirstColumnSpanned
			      ,i
			      (self.tree_view.rootIndex)
			      True))

		     (do0
			     (setf parent (qg.QStandardItem
					   (string devices)))
			     (for (dev ctx.devices)
				  (setf l (list (qg.QStandardItem
					      (dot (string "{}")
						   (format dev.name)))
					     ))
				  (if (< 0 (len dev.attrs))
				      (for ((ntuple k v) (dev.attrs.viewitems))
				       ((dot (aref l 0)
					     appendRow)
					(list
					 (qg.QStandardItem
					  (dot (string "{}")
					       (format k)))
					 (qg.QStandardItem
					  (dot (string "{}")
					       (format v.value)))))))
				  
				  (parent.appendRow
				   l))
			     (self.model.appendRow parent))

		     (do0
		      (setf self.main_layout (qw.QHBoxLayout))
		      (self.main_layout.addWidget self.tree_view)
		      (self.setLayout self.main_layout))
		     ))
	    
	    (class MainWindow (qw.QMainWindow)
		   (def __init__ (self widget)
		     (dot (super MainWindow self) (__init__))
		     (self.setCentralWidget widget))
		   (do0
		    "@qc.Slot()"
		    (def exit_app (self checked)
		      (sys.exit))))
	    #+nil,(let ((coords `(x y)))
	     `(do0
	      (class Rectangle (trellis.Component)
		     ,(flet ((self (e &optional name)
			       (if name
				   (format nil "self.~a_~a" e name)
				   (format nil "self.~a" e)))
			     (variable (e &optional name)
                               (if name
				   (format nil "~a_~a" e name)
				   (format nil "~a" e))))
			`(do0
			  ,@(loop for e in coords collect
				 `(setf ,e (trellis.maintain
					    (lambda (self)
					      (+ ,(self e "min") (* .5 ,(self e "span"))))
					    :initially 0)
					,(variable e "span") (trellis.maintain
							      (lambda (self)
								(- ,(self e "max") ,(self e "min")))
							      :initially 0)
					,(variable e "min") (trellis.maintain
							     (lambda (self)
							       (- ,(self e)  (* .5 ,(self e "span"))))
							     :initially 0)
					,(variable e "max") (trellis.maintain
							     (lambda (self)
							       (+ ,(self e) (* .5 ,(self e "span"))))
							     :initially 0))
				 )
			  ,(let ((l (loop for e in coords append
					 (loop for f in '(nil span min max) collect
					      (self e f))))
				 (l-var (loop for e in coords append
					     (loop for f in '(nil span min max) collect
						  (variable e f)))))
			     `(do0
			       "@trellis.perform"
			       (def show_value (self)
				 (print (dot (string ,(format nil "rect ~{~a~^ ~}" (loop for e in l-var collect (format nil "~a={}" e))))
					     (format ,@l))))))
			  (do0
			   "@trellis.modifier"
			   (def translate (self r)
			     ,@(loop for e in coords and i from 0 collect
				    `(setf ,(self e) (+ ,(self e)
							(aref r ,i))))))
			  (do0
			   "@trellis.modifier"
			   (def grow (self r)
			     ,@(loop for e in coords and i from 0 collect
				    `(setf ,(self e "span") (+ ,(self e "span")
							       (aref r ,i)))))))))

	      (def make_rect_c (&key (r (np.array (list 0.0 0.0)))
				    (r_span (np.array (list 1.0 1.0))))
		(return (Rectangle ,@(loop for e in coords and i from 0 append
				    `(,(make-keyword (string-upcase e)) (aref r ,i)))
			     ,@(loop for e in coords and i from 0 append
				    `(,(make-keyword (string-upcase (format nil "~a_span" e))) (aref r_span ,i))))))
	      (def make_rect (&key (min (np.array (list 0.0 0.0)))
				  (max (np.array (list 1.0 1.0))))
		(return (Rectangle ,@(loop for e in coords and i from 0 append
				    `(,(make-keyword (string-upcase (format nil "~a_min" e))) (aref min ,i)))
			     ,@(loop for e in coords and i from 0 append
				    `(,(make-keyword (string-upcase (format nil "~a_max" e))) (aref max ,i))))))))

	    #+nil(setf r (make_rect_c))
;>>> [d.name for d in ctx.devices]
;[u'cf-ad9361-dds-core-lpc', u'ad9361-phy', u'cf-ad9361-lpc', u'xadc', u'adm1177']

	    (do0
	     (setf ctxs (iio.scan_contexts)
		   uri (next (iter ctxs) None)
		   ctx (iio.Context uri)
		   dev (ctx.find_device (string "cf-ad9361-lpc"))
		   phy (ctx.find_device (string "ad9361-phy"))
		   )
	     (print iio.version)
	     (print ctx.name)
	     (print ctx.attrs))
	    (setf df (pd.DataFrame (list ctx.attrs)))
	    
	    (do0		 ;if (== __name__ (string "__main__"))
	     (setf app (qw.QApplication sys.argv)
		   widget (PlutoTreeView ctx)
		   #+nil(PandasView (dot (aref df.iloc 0)
					   (to_frame)))
		   win (MainWindow widget))
	     
	     (win.show)
	     (sys.exit (app.exec_))))))
    (write-source *source* code)))
