
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
import json
import subprocess
import sys
import os
from typing import *
@dataclass
class MenuItem:
    keys: List[str]
    title: str
    callback: Callable


class Menu:
    def __init__(
            self,
            title: str = '',
            content: str = '',
            options: List[MenuItem] = [],
            title_builder: Optional[Callable[[], str]] = None,
            content_builder: Optional[Callable[[], str]] = None,
            options_builder: Optional[Callable[[], List[MenuItem]]] = None,
            backward_text: Optional[str] = '回到上一级',
            multiple_key_separator: str = '/'):
        if title_builder is None:
            title_builder = lambda: title
        if content_builder is None:
            content_builder = lambda: content
        if options_builder is None:
            options_builder = lambda: options

        self.__title = title_builder
        self.__content = content_builder
        self.__options = options_builder
        self.__has_next_loop = True
        self.__menu_item_dict = dict()
        self.__multiple_key_separator = multiple_key_separator
        self.__backward_text = backward_text

    def __generate_option_key(self):
        """
        生成一遍 key
        """
        for index, option in enumerate(self.__get_options()):
            if len(option.keys) == 0:
                option.keys = [str(index)]
            for key in option.keys:
                self.__menu_item_dict[key] = option

    def __display_title(self):
        """
        显示标题
        """
        print()
        print(self.__title())

    def __display_content(self):
        """
        显示内容
        """
        print(self.__content())

    def __get_options(self):
        if self.__backward_text is not None:
            return self.__options()+[MenuItem(
                keys=['q'],
                title=self.__backward_text,
                callback=self.terminal_next,
            )]
        else:
            return self.__options()

    def __select_option_menu(self):
        """
        选择菜单项
        """
        for option in self.__get_options():
            print(self.__multiple_key_separator.join(
                option.keys), option.title, sep=': ')

        while True:
            key = input('请选择: ')
            if key in self.__menu_item_dict.keys():
                break
            else:
                print('select error', f'cannot found {key}')

        return self.__menu_item_dict[key]

    def __show_once(self):
        """
        用于展示一次菜单
        """

        try:
            self.__display_title()
            self.__display_content()
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

    def loop(self):
        """
        菜单循环
        """
        self.__generate_option_key()
        while self.__has_next_loop:
            self.__show_once()


@dataclass
class Config:
    env: Dict[str, str]

    @staticmethod
    def fromJson(jsonStr: str):
        dic = json.loads(jsonStr)
        return Config(env=dic['env'])

    def toJson(self):
        return json.dumps({
            'env': self.env,
        })


class ConfigManager:
    def __init__(self, filename: str) -> None:
        self.filename = filename
        self.config = Config(env={})
        if os.path.exists(filename):
            self.load_config()
        else:
            self.save_config()

    def load_config(self):
        """
        加载配置文件
        """
        print(f'加载配置文件: {self.filename}')
        with open(file=self.filename, mode='r', encoding='utf-8') as f:
            self.config = Config.fromJson(f.read())

    def save_config(self):
        """
        保存配置文件
        """
        print(f'写入配置文件: {self.filename}')
        with open(file=self.filename, mode='w', encoding='utf-8') as f:
            f.write(self.config.toJson())

# ------------------以上为脚本运行所需的基本代码类库---------------
# ------------------以下为脚本的实例---------------


config_filename = os.path.join(os.path.dirname(
    os.path.realpath(__file__)), 'build.cfg')
config_manager = ConfigManager(filename=config_filename)


def get_envs():
    """
    继承系统环境变量后, 获取所有环境变量
    """
    env = os.environ.copy()
    env.update(config_manager.config.env)
    return env


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
        env=get_envs(),
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
                  split_per_abi: bool = False,
                  release: bool = True,
                  debug: bool = False,):
        cmds = ['flutter', 'build', 'apk']
        if target_platform is not None:
            cmds.append('--target-platform')
            cmds.append(target_platform)
        if split_per_abi:
            cmds.append('--split-per-abi')
        if release:
            cmds.append('--release')
        if debug:
            cmds.append('--debug')
        call(' '.join(cmds))

    Menu(
        title='Please select a platform',
        options=[
            MenuItem(keys=['a', 'arm'],
                     title='android-arm',
                     callback=lambda:build_apk(target_platform='android-arm')),
            MenuItem(keys=['a6', 'arm64'],
                     title='android-arm64',
                     callback=lambda:build_apk(target_platform='android-arm64')),
            MenuItem(keys=['x8', 'x86'],
                     title='android-x86',
                     callback=lambda:build_apk(target_platform='android-x86')),
            MenuItem(keys=['x6', 'x64'],
                     title='android-x64',
                     callback=lambda:build_apk(target_platform='android-x64')),
            MenuItem(keys=['d/default'],
                     title='arm/arm64/x64一键分包编译',
                     callback=lambda:build_apk(split_per_abi=True)),
            MenuItem(
                keys=['msp'],
                title='多架构一键分包编译',
                callback=lambda:build_apk(
                    split_per_abi=True,
                    target_platform=input('请输入目标平台, 用英文逗号隔开: '))),
        ],
    ).loop()


@dataclass
class PubMirror:
    name: str
    pub_hosted_url: str
    flutter_storage_base_url: str


PUB_MIRRORS = [
    PubMirror(
        name='官方源',
        pub_hosted_url='https://pub.dev/',
        flutter_storage_base_url='https://cloud.google.com/',
    ),
    PubMirror(
        name='Flutter 社区',
        pub_hosted_url='https://pub.flutter-io.cn/',
        flutter_storage_base_url='https://storage.flutter-io.cn/'
    ),
    PubMirror(
        name='上海交大 Linux 用户组',
        pub_hosted_url='https://dart-pub.mirrors.sjtug.sjtu.edu.cn/',
        flutter_storage_base_url='https://mirrors.sjtug.sjtu.edu.cn/',
    ),
    PubMirror(
        name='清华大学 TUNA 协会',
        pub_hosted_url='https://mirrors.tuna.tsinghua.edu.cn/dart-pub/',
        flutter_storage_base_url='https://mirrors.tuna.tsinghua.edu.cn/flutter/',
    ),
    PubMirror(
        name='CNNIC',
        pub_hosted_url='http://mirrors.cnnic.cn/dart-pub/',
        flutter_storage_base_url='http://mirrors.cnnic.cn/flutter/'
    ),
    PubMirror(
        name='腾讯云开源镜像站',
        pub_hosted_url='https://mirrors.cloud.tencent.com/dart-pub/',
        flutter_storage_base_url='https://mirrors.cloud.tencent.com/flutter/',
    )
]


def change_pub():
    """
    一键换源
    """
    PUB_HOSTED_URL = 'PUB_HOSTED_URL'
    FLUTTER_STORAGE_BASE_URL = 'FLUTTER_STORAGE_BASE_URL'

    def on_select_pub(pub_mirror: PubMirror):
        config_manager.config.env[PUB_HOSTED_URL] = pub_mirror.pub_hosted_url
        config_manager.config.env[FLUTTER_STORAGE_BASE_URL] = pub_mirror.flutter_storage_base_url
        config_manager.save_config()

    def get_current_pub():
        envs = get_envs()
        pub_hosted_url = envs[PUB_HOSTED_URL]
        flutter_storage_base_url = envs[FLUTTER_STORAGE_BASE_URL]
        return f'PUB_HOSTED_URL: {pub_hosted_url}\nFLUTTER_STORAGE_BASE_URL: {flutter_storage_base_url}'

    Menu(
        title_builder=lambda: f'更换Flutter Pub源\n\n当前源\n{get_current_pub()}',
        options=list(map(lambda x: MenuItem(keys=[str(x[0]+1)],
                                            title=x[1].name,
                                            callback=lambda: on_select_pub(
                                                x[1])
                                            ),
                         enumerate(PUB_MIRRORS)))
    ).loop()


def main():
    Menu(
        title='欢迎使用小风筝App构建工具 (使用Ctrl-C可强制关闭构建过程)',
        options=[
            MenuItem(keys=['c'],
                     title='一键换源',
                     callback=change_pub),
            MenuItem(keys=['g'],
                     title='获取所有依赖',
                     callback=get_all_dependencies),
            MenuItem(keys=['br'],
                     title='运行 build_runner (用于根据注解生成部分代码)',
                     callback=run_build_runner),
            MenuItem(keys=['gb'],
                     title='获取依赖并生成代码',
                     callback=lambda:run_functions([get_all_dependencies, run_build_runner])),

            MenuItem(keys=['a'],
                     title='运行 android 平台构建向导',
                     callback=guide_build_for_android),

            MenuItem(keys=['l'],
                     title='构建 linux 平台应用程序',
                     callback=build_for_linux),
            MenuItem(keys=['w', 'wi'],
                     title='构建 windows 平台', callback=build_for_windows),
            MenuItem(keys=['we', 'web'],
                     title='构建 web 平台',
                     callback=build_for_web),

        ],
        backward_text='退出构建脚本'
    ).loop()


if __name__ == '__main__':
    main()
