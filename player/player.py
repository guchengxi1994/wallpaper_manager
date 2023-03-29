from PySide6.QtWidgets import (
    QMainWindow,
    QApplication,
    QSlider,
    QHBoxLayout,
    QVBoxLayout,
    QWidget,
)
from PySide6 import QtCore
from PySide6.QtMultimedia import QMediaPlayer
from PySide6.QtMultimediaWidgets import QVideoWidget


class VideoPlayerConfig:
    def __init__(
        self,
        videoPath: str = None,
        showBorder: bool = False,
        width: int = 800,
        height: int = 600,
    ) -> None:
        self.showBorder = showBorder
        self.width = width
        self.height = height
        self.videoPath = videoPath


class VideoPlayer(QMainWindow):
    def __init__(
        self, parent=None, config: VideoPlayerConfig = VideoPlayerConfig()
    ) -> None:
        super().__init__(parent)

        self.resize(config.width, config.height)
        if not config.showBorder:
            self.setWindowFlags(QtCore.Qt.Window | QtCore.Qt.FramelessWindowHint)
        self.mediaPlayer = QMediaPlayer(self)
        videoWidget = QVideoWidget()
        self.positionSlider = QSlider(QtCore.Qt.Horizontal)
        self.positionSlider.setRange(0, 0)
        self.positionSlider.sliderMoved.connect(self.setPosition)
        controlLayout = QHBoxLayout()
        controlLayout.addWidget(self.positionSlider)
        layout = QVBoxLayout()
        layout.addWidget(videoWidget)
        if config.showBorder:
            layout.addLayout(controlLayout)
            self.mediaPlayer.positionChanged.connect(self.positionChanged)
            self.mediaPlayer.durationChanged.connect(self.durationChanged)
        if config.videoPath is not None:
            self.mediaPlayer.setSource(QtCore.QUrl.fromLocalFile(config.videoPath))
            self.mediaPlayer.setLoops(QMediaPlayer.Loops.Infinite)
            self.mediaPlayer.play()
        self.mediaPlayer.setVideoOutput(videoWidget)
        self.mainWidget = QWidget()
        self.mainWidget.setLayout(layout)
        self.setCentralWidget(self.mainWidget)

    def setPosition(self, position):
        self.mediaPlayer.setPosition(position)

    def positionChanged(self, position):
        self.positionSlider.setValue(position)

    def durationChanged(self, duration):
        self.positionSlider.setRange(0, duration)


if __name__ == "__main__":
    import sys
    import argparse

    parser = argparse.ArgumentParser(description="简易播放器")
    parser.add_argument("--width", type=int, help="video width", default=800)
    parser.add_argument("--height", type=int, help="video height", default=600)
    parser.add_argument("--video_path", type=str, help="video path")
    parser.add_argument("--show_border", type=bool, help="show border?", default=False)

    try:
        args = parser.parse_args()
        vconfig = VideoPlayerConfig(
            videoPath=args.video_path,
            showBorder=args.show_border,
            width=args.width,
            height=args.height,
        )
        # print(args.show_border)
        # print(vconfig.showBorder)
        app = QApplication(sys.argv)
        player = VideoPlayer(config=vconfig)
        player.setWindowTitle("Player")
        player.show()
        sys.exit(app.exec())
    except:
        parser.print_help()
