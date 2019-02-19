#!/usr/bin/env python2
"""trellis dataflow gui.
Usage:
  run_gui [-vh]

Options:
  -h --help               Show this screen
  -v --verbose            Print debugging output
"""
# martin kielhorn 2019-02-19
# pip2 install --user PySide2
# example from https://pypi.org/project/Trellis/0.7a2/
#  pip install --user Trellis==0.7a2
# wget http://peak.telecommunity.com/snapshots/Contextual-0.7a1.dev-r2695.tar.gz http://peak.telecommunity.com/snapshots/Trellis-0.7a3-dev-r2610.tar.gz 
#  pip2 install --user Contextual-0.7a1.dev-r2695.tar.gz
# i installed trellis by commenting out the contextual line in its setup.py and then extracting the egg file into ~/.local/lib/python2.7/site-packages/peak
import os
import sys
import docopt
import numpy as np
import pandas as pd
import pathlib
import re
import traceback
import PySide2.QtWidgets as qw
import PySide2.QtCore as qc
import PySide2.QtGui as qg
import iio
args=docopt.docopt(__doc__, version="0.0.1")
if ( args["--verbose"] ):
    print(args)
class PlutoTreeView(qw.QWidget):
    def __init__(self, ctx):
        super(PlutoTreeView, self).__init__()
        self.model=qg.QStandardItemModel()
        self.tree_view=qw.QTreeView()
        self.model.setHorizontalHeaderLabels(["key", "value"])
        self.tree_view.setModel(self.model)
        self.tree_view.setUniformRowHeights(True)
        parent=qg.QStandardItem("attrs")
        for key, value in ctx.attrs.viewitems():
            parent.appendRow([qg.QStandardItem("{}".format(key)), qg.QStandardItem("{}".format(value))])
        self.model.appendRow(parent)
        self.tree_view.setFirstColumnSpanned(0, self.tree_view.rootIndex(), True)
        self.main_layout=qw.QHBoxLayout()
        self.main_layout.addWidget(self.tree_view)
        self.setLayout(self.main_layout)
class MainWindow(qw.QMainWindow):
    def __init__(self, widget):
        super(MainWindow, self).__init__()
        self.setCentralWidget(widget)
    @qc.Slot()
    def exit_app(self, checked):
        sys.exit()
ctxs=iio.scan_contexts()
uri=next(iter(ctxs), None)
ctx=iio.Context(uri)
dev=ctx.find_device("cf-ad9361-lpc")
phy=ctx.find_device("ad9361-phy")
print(iio.version)
print(ctx.name)
print(ctx.attrs)
df=pd.DataFrame([ctx.attrs])
app=qw.QApplication(sys.argv)
widget=PlutoTreeView(ctx)
win=MainWindow(widget)
win.show()
sys.exit(app.exec_())