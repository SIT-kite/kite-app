from . import *

def get():
    call('flutter pub get')

def show_dependence_menu():
    menu = Menu(
        title='依赖管理',
        options=[
            MenuOption(
                keys='get',
                title='获取依赖',
                callback=get
            )
        ],
    )
    menu.loop()