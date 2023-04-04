from PySide6.QtCore import Qt
from PySide6.QtGui import QMovie
from PySide6.QtWidgets import QApplication, QLabel

# Create the PySide6 application
app = QApplication()

# Load the GIF from file
gif_file_path = r"D:\github_repo\wallpaper_manager\images\test.gif"
movie = QMovie(gif_file_path)

# Create a label and set the movie as its pixmap
label = QLabel()
label.setAlignment(Qt.AlignCenter)
label.setMovie(movie)

# Start playing the movie
movie.start()

# Show the label and run the application
label.show()
app.exec()
