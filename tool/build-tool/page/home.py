from . import *


def run_build_runner():
    call('flutter pub run build_runner build')


def get_all_dependencies():
    call('flutter pub get')


def build_for_linux():
    call('flutter build linux')

def run_linux_release():
    put_envs({
      'LC_ALL':'en_US.UTF-8'
    })
    call('./build/linux/x64/release/bundle/kite')

def build_for_windows():
    call('flutter build windows')


def build_for_web():
    call('flutter build web')


def change_pub():
    from .change_pub import show_change_pub_menu
    show_change_pub_menu()


def android_guide():
    from .android_guide import show_guide_build_for_android
    show_guide_build_for_android()

def git_pull():
    call('git stash push',True)
    call('git pull --rebase',True)
    call('git stash pop')

def show_home_menu():
    menu = Menu(
        title='欢迎使用小风筝App构建工具 (使用Ctrl-C可强制关闭构建过程)',
        options=[
            MenuOption(keys=['c'],
                       title='一键换源',
                       callback=change_pub),
            MenuOption(keys=['g'],
                       title='获取所有依赖',
                       callback=get_all_dependencies),
            MenuOption(keys=['b', 'br'],
                       title='运行 build_runner (用于根据注解生成部分代码)',
                       callback=run_build_runner),
            MenuOption(keys=['gb'],
                       title='获取依赖并生成代码',
                       callback=lambda: run_functions([get_all_dependencies, run_build_runner])),

            MenuOption(keys=['a'],
                       title='运行 android 平台构建向导',
                       callback=android_guide),

            MenuOption(keys=['l'],
                       title='构建 linux 平台应用程序',
                       callback=build_for_linux),
            MenuOption(keys=['rl'],
                     title='运行 linux release',
                     callback=run_linux_release),
            MenuOption(keys=['w', 'wi'],
                       title='构建 windows 平台',
                       callback=build_for_windows),
            MenuOption(keys=['we', 'web'],
                       title='构建 web 平台',
                       callback=build_for_web),
            MenuOption(keys=['gp', 'pull'],
                       title='git一键拉取最新更新',
                       callback=git_pull),
        ],
        backward_text='退出构建脚本'
    )
    menu.loop()
