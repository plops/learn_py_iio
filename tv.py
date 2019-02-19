#https://gist.github.com/skriticos/5415869
import sys, os, pprint, time
from PySide2.QtCore import *
from PySide2.QtWidgets import *
from PySide2.QtGui import *
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
app = QApplication(sys.argv)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# init widgets
view = QTreeView()
view.setSelectionBehavior(QAbstractItemView.SelectRows)
model = QStandardItemModel()
model.setHorizontalHeaderLabels(['col1', 'col2', 'col3'])
view.setModel(model)
view.setUniformRowHeights(True)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# populate data
for i in range(3):
    parent1 = QStandardItem('Family {}. Some long status text for sp'.format(i))
    for j in range(3):
        child1 = QStandardItem('Child {}'.format(i*3+j))
        child2 = QStandardItem('row: {}, col: {}'.format(i, j+1))
        child3 = QStandardItem('row: {}, col: {}'.format(i, j+2))
        parent1.appendRow([child1, child2, child3])
    model.appendRow(parent1)
    # span container columns
    view.setFirstColumnSpanned(i, view.rootIndex(), True)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# expand third container
index = model.indexFromItem(parent1)
view.expand(index)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# select last row
selmod = view.selectionModel()
index2 = model.indexFromItem(child3)
selmod.select(index2, QItemSelectionModel.Select|QItemSelectionModel.Rows)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
view.show()
sys.exit(app.exec_())
