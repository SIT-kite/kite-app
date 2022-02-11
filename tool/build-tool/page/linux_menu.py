from . import *


def build_linux(target_platform: str = 'linux-x64'):
    cmds = ['flutter', 'build', 'linux']
    cmds.append('--target-platform')
    cmds.append(target_platform)
    call(' '.join(cmds))


def run_linux_release():
    put_envs({
        'LC_ALL': 'en_US.UTF-8'
    })
    call('./build/linux/x64/release/bundle/kite')


def build_arm64():
    build_linux('linux-arm64')


def build_x64():
    build_linux('linux-x64')


def run_hot_load():
    put_envs({
        'LC_ALL': 'en_US.UTF-8'
    })
    call('flutter run -d linux')


def show_linux_menu():
    menu = Menu(
        title='Linux 编译工具菜单',
        options=[
            MenuOption(keys=['linux arm64'],
                       title='构建 linux-arm64 应用(release)',
                       callback=build_arm64),
            MenuOption(keys=['linux x64'],
                       title='构建 linux-x64 应用(release)',
                       callback=build_x64),
            MenuOption(keys=['run liunx release'],
                       title='运行 linux-x64 应用(release)',
                       callback=run_linux_release),
            MenuOption(keys=['build && run'],
                       title='编译并运行 linux-x64 应用(release)',
                       callback=lambda:run_functions([
                           build_x64,
                           run_linux_release
                       ])),
            MenuOption(keys=['run hotload'],
                       title='热重载模式开发 linux-x64 应用',
                       callback=run_hot_load),
        ],
        backward_text='返回主菜单'
    )
    menu.loop()
