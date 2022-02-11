from . import *
from .linux_menu import show_linux_menu
from .git import show_git_menu

def change_pub():
    from .change_pub import show_change_pub_menu
    show_change_pub_menu()


def android_guide():
    from .android_guide import show_guide_build_for_android
    show_guide_build_for_android()

def show_home_menu():
    menu = Menu(
        title='欢迎使用小风筝App构建工具 (使用Ctrl-C可强制关闭构建过程)',
        options=[
            MenuOption(keys=['mirror'],
                       title='换源',
                       callback=change_pub),

            MenuOption(keys=['dependence'],
                       title='依赖管理',
                       # TODO 
                       callback=unimplementation),

            MenuOption(keys=['build_runner'],
                       title='运行 build_runner (用于根据注解生成部分代码)',
                       callback=lambda: call('flutter pub run build_runner build',no_pause=False)),
                       
            MenuOption(keys=['git'],
                       title='Git工具',
                       callback=show_git_menu),

            MenuOption(keys=['android'],
                       title='Android 开发',
                       callback=android_guide),

            MenuOption(keys=['linux'],
                       title='Linux 开发',
                       callback=show_linux_menu),
            MenuOption(keys=['windows'],
                       title='Windows 开发',
                       # TODO
                       callback=unimplementation),

            MenuOption(keys=['web'],
                       title='Web 开发',
                       # TODO
                       callback=unimplementation),
        ],
        backward_text='退出脚本'
    )
    menu.loop()
