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
class PandasTableModel(qc.QAbstractTableModel):
    def __init__(self, dataframe, parent=None):
        qc.QAbstractTableModel.__init__(self)
        self.dataframe=dataframe
    def flags(self, index):
        if ( not(index.isValid()) ):
            return None
        return ((qc.Qt.ItemIsEnabled) or (qc.Qt.ItemIsSelectable))
    def rowCount(self, *args, **kwargs):
        return len(self.dataframe.index)
    def columnCount(self, *args, **kwargs):
        return len(self.dataframe.columns)
    def headerData(self, section, orientation, role):
        if ( ((qc.Qt.DisplayRole)!=(role)) ):
            return None
        try:
            if ( ((qc.Qt.Horizontal)==(orientation)) ):
                return list(self.dataframe.columns)[section]
            if ( ((qc.Qt.Vertical)==(orientation)) ):
                return list(self.dataframe.index)[section]
        except IndexError:
            return None
    def data(self, index, role):
        if ( ((qc.Qt.DisplayRole)!=(role)) ):
            return None
        if ( not(index.isValid()) ):
            return None
        return str(self.dataframe.iloc[index.row(),index.column()])
class PandasView(qw.QWidget):
    def __init__(self, df):
        super(PandasView, self).__init__()
        self.model=PandasTableModel(df)
        self.table_view=qw.QTableView()
        self.table_view.setModel(self.model)
        self.main_layout=qw.QHBoxLayout()
        self.main_layout.addWidget(self.table_view)
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
widget=PandasView(df.iloc[0].to_frame())
win=MainWindow(widget)
win.show()
sys.exit(app.exec_())