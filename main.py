import sys
from PyQt6.QtWidgets import QApplication, QMainWindow, QPushButton
from PyQt6.QtCore import Qsize


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("My App")
        button = QPushButton("PRESS ME!!!")
        button.setFixedSize(Qsize(100, 100))
        self.setCentralWidget(button)
        self.setFixedSize(Qsize(800, 800))


app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()
