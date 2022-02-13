from . import *


def show_android_menu():
    def build_apk(target_platform: Optional[str] = None,
                  split_per_abi: bool = False,
                  release: bool = True,
                  debug: bool = False, ):
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
            MenuOption(keys=['a', 'arm'],
                       title='android-arm',
                       callback=lambda: build_apk(target_platform='android-arm')),
            MenuOption(keys=['a6', 'arm64'],
                       title='android-arm64',
                       callback=lambda: build_apk(target_platform='android-arm64')),
            MenuOption(keys=['x8', 'x86'],
                       title='android-x86',
                       callback=lambda: build_apk(target_platform='android-x86')),
            MenuOption(keys=['x6', 'x64'],
                       title='android-x64',
                       callback=lambda: build_apk(target_platform='android-x64')),
            MenuOption(keys=['d/default'],
                       title='arm/arm64/x64一键分包编译',
                       callback=lambda: build_apk(split_per_abi=True)),
            MenuOption(
                keys=['msp'],
                title='多架构一键分包编译',
                callback=lambda: build_apk(
                    split_per_abi=True,
                    target_platform=input('请输入目标平台, 用英文逗号隔开: '))),
        ],
    ).loop()
