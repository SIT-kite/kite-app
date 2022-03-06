from . import *
from .linux import show_linux_menu
from .git import show_git_menu
from .android import show_android_menu
from .mirror import show_mirror_menu

def clean():
    generated_dart_files = []
    for root,dirs,files in os.walk('lib'):
        if len(files) != 0:
            for file in files:
                dart_file = (f'{root}/{file}')
                if dart_file.endswith('.g.dart'):
                    generated_dart_files.append(dart_file)
    for d in generated_dart_files:
        print(d)

    if input('将删除以上文件与Y/(N)').strip() in ['Y','y']:
        for file in generated_dart_files:
            print(f'删除文件: {file}')
            os.remove(file)
    else:
        print('取消删除')
    pause()

def show_home_menu():
    menu = Menu(
        title='欢迎使用小风筝App构建工具 (使用Ctrl-C可强制关闭构建过程)',
        options=[
            MenuOption(keys=['mirror'],
                       title='换源',
                       callback=show_mirror_menu),

            MenuOption(keys=['clean'],
                       title='清理',
                       callback=clean),

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
                       callback=show_android_menu),

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
