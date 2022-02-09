
"""
上应小风筝(SIT-kite)  便利校园，一步到位
Copyright (C) 2022 上海应用技术大学 上应小风筝团队

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

"""
本工具用于便捷地运行一些编译脚本, 省去繁琐的命令行操作
运行环境: python3.7 及以上
"""




from dataclasses import dataclass
import subprocess
import sys
from typing import *
from click import option
@dataclass
class MenuItem:
    title: str
    callback: Callable


class Menu:
    def __init__(
            self,
            title: str,
            options: List[MenuItem] = [],
            backward_text: Optional[str] = '回到上一级'):
        self.__title = title
        self.__options = options
        self.__has_next_loop = True
        self.add_backward_option(backward_text=backward_text)

    def __display_title(self):
        """
        显示标题
        """
        print()
        print(self.__title)

    def __select_option_menu(self):
        """
        选择菜单项
        """
        options_len = 0
        for index, option in enumerate(self.__options):
            print(index+1, option.title, sep='. ')
            options_len += 1

        while True:
            try:
                index = int(input('请选择: '))
                if 1 <= index <= options_len:
                    break
                else:
                    print('select error', f'input must in [1,{options_len}]')
            except Exception as e:
                print('select error', str(e))

        return self.__options[index-1]

    def add_option(self, option: MenuItem):
        self.__options.append(option)

    def show_once(self):
        """
        用于展示一次菜单
        """

        try:
            self.__display_title()
            select_option = self.__select_option_menu()
            select_option.callback()

        except KeyboardInterrupt as _:
            print()
            print('Exit build script')
            exit(0)

    def terminal_next(self):
        """
        终止下次的菜单循环
        """
        self.__has_next_loop = False

    def add_backward_option(self, backward_text: str):
        self.add_option(MenuItem(
            title=backward_text,
            callback=self.terminal_next,
        ))

    def loop(self):
        """
        菜单循环
        """
        while self.__has_next_loop:
            self.show_once()


def call(script):
    """
    调用系统命令
    """
    print('运行命令: ', script)
    subprocess.call(
        script.split(' '),
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr,
    )

def run_functions(functions: Iterable[Callable]):
    """
    一次性运行多个函数
    """
    for function in functions:
        function()

# ------------------以上为脚本运行所需的基本代码---------------
# ------------------以下为脚本运行的真正构建命令---------------


def run_build_runner():
    call('flutter pub run build_runner build')


def get_all_dependencies():
    call('flutter pub get')

def build_for_linux():
    call('flutter build linux')


def build_for_windows():
    call('flutter build windows')

def build_for_web():
    call('flutter build web')


def guide_build_for_android():
    def build_apk(target_platform: Optional[str] = None,
                  split_per_abi: bool = False):
        cmds = ['flutter', 'build', 'apk']
        if target_platform is not None:
            cmds.append('--target-platform')
            cmds.append(target_platform)
        if split_per_abi:
            cmds.append('--split-per-abi')
        call(' '.join(cmds))

    Menu(
        title='Please select a platform',
        options=[
            MenuItem('android-arm',
                     lambda:build_apk(target_platform='android-arm')),
            MenuItem('android-arm64',
                     lambda:build_apk(target_platform='android-arm64')),
            MenuItem('android-x86',
                     lambda:build_apk(target_platform='android-x86')),
            MenuItem('android-x64',
                     lambda:build_apk(target_platform='android-x64')),
            MenuItem('arm/arm64/x64一键分包编译',
                     lambda:build_apk(split_per_abi=True)),
            MenuItem('多架构一键分包编译',
                     lambda:build_apk(
                         split_per_abi=True,
                         target_platform=input('请输入目标平台, 用英文逗号隔开: '))),
        ],
    ).loop()


if __name__ == '__main__':
    Menu(
        title='欢迎使用小风筝App构建工具(使用Ctrl-C可强制关闭构建过程)',
        options=[
            MenuItem('获取所有依赖', get_all_dependencies),
            MenuItem('运行 build_runner (用于根据注解生成部分代码)', run_build_runner),
            MenuItem('获取依赖并生成代码', lambda:run_functions([get_all_dependencies,run_build_runner])),

            MenuItem('运行 android 平台构建向导', guide_build_for_android),

            MenuItem('构建 linux 平台应用程序', build_for_linux),
            MenuItem('构建 windows 平台',build_for_windows),
            MenuItem('构建 web 平台',build_for_web),
        ],
        backward_text='退出构建脚本'
    ).loop()
