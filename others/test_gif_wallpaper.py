import pyglet
from PIL import Image
import win32gui


class AnimationSrn:
    def __init__(self):

        parenthwnd = self.getScreenHandle()
        # print(parenthwnd)
        left, top, right, bottom = win32gui.GetWindowRect(parenthwnd)
        self.size = (right - left, bottom - top)
        print(self.size)
        self.gifpath = self.resizeGif()

    def frameIterator(self, frames):
        for frame in frames:
            framecopy = frame.copy()
            # print (type (framecopy))
            framecopy = framecopy.resize(self.size, Image.Resampling.LANCZOS)
            yield framecopy

    # 返回一^迭代器，迭代gi仲的每一帧图像
    def resizeGif(self, originpath=r"邮件示例.gif"):
        # 太慢
        return originpath

    def getScreenHandle(self):
        hwnd = win32gui.FindWindow("Progman", "Program Manager")
        print("hwnd  ",  hwnd)
        win32gui.SendMessageTimeout(hwnd, 0x052C, 0, None, 0, 0x03E8)
        hwnd_WorkW = None
        while 1:
            hwnd_WorkW = win32gui.FindWindowEx(None, hwnd_WorkW, "WorkerW",
                                               None)
            if not hwnd_WorkW:
                continue
            hView = win32gui.FindWindowEx(hwnd_WorkW, None, "SHELLDLL_DefView",
                                          None)
            if not hView:
                continue
            h = win32gui.FindWindowEx(None, hwnd_WorkW, "WorkerW", None)
            while h:
                win32gui.SendMessage(h, 0x0010, 0, 0)
                # WM_CLOSE
                h = win32gui.FindWindowEx(None, hwnd_WorkW, "WorkerW", None)
            break
        return hwnd
        '''
        return win32gui.GetDesktopWindow()
        '''

    def putGifScreen(self):
        parenthwnd = self.getScreenHandle()
        print("parenthwnd  ", parenthwnd)

        #使用pyglet加载动画
        # print ("1ll", parenthwnd)
        animation = pyglet.image.load_animation(
            self.gifpath)  #使用pyglet 加载一个gif 动图
        sprite = pyglet.sprite.Sprite(animation)  # 创建一个动画

        print(sprite.height)
        print(sprite.width)

        #创建一个新的窗口
        #创建-个窗口, 并将其设置为图像大小
        newwin = pyglet.window.Window(
            width=1920,
            height=1080,
            style=pyglet.window.Window.WINDOW_STYLE_BORDERLESS)

        #将默认的背景图的父窗口改为新创建的窗口
        # print(win._hwnd)
        win32gui.SetParent(newwin._hwnd, parenthwnd)

        @newwin.event  #事件处理程序的函数装饰器.用來显示图像
        def on_draw():
            newwin.clear()
            sprite.draw()

        pyglet.app.run()


if __name__ == '__main__':
    AnimationSrn().putGifScreen()