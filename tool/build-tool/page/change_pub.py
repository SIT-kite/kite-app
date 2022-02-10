from . import *
from dataclasses import dataclass


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


def show_change_pub_menu():
    """
    一键换源
    """
    pub_hosted_url_name = 'PUB_HOSTED_URL'
    flutter_storage_base_url_name = 'FLUTTER_STORAGE_BASE_URL'

    def on_select_pub(pub_mirror: PubMirror):
        put_envs({
            pub_hosted_url_name: pub_mirror.pub_hosted_url,
            flutter_storage_base_url_name: pub_mirror.flutter_storage_base_url,
        })
        save_config()

    def get_current_pub():
        envs = get_envs()
        pub_hosted_url = envs[pub_hosted_url_name]
        flutter_storage_base_url = envs[flutter_storage_base_url_name]
        return f'PUB_HOSTED_URL: {pub_hosted_url}\nFLUTTER_STORAGE_BASE_URL: {flutter_storage_base_url}'

    Menu(
        title_builder=lambda: f'更换Flutter Pub源\n\n当前源\n{get_current_pub()}',
        options=list(map(lambda x: MenuOption(keys=[str(x[0] + 1)],
                                              title=x[1].name,
                                              callback=lambda: on_select_pub(
                                                  x[1])
                                              ),
                         enumerate(PUB_MIRRORS)))
    ).loop()
