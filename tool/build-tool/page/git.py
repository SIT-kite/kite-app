from . import *


def push():
    call('git push', no_pause=False)


def pull():
    call('git stash push')
    call('git pull --rebase')
    call('git stash pop', no_pause=False)


def open_credential_cache():
    call('git config credential.helper store', no_pause=False)


def proxy():
    print('当前Git代理: ')
    print('http_proxy: ', end='', flush=True)
    call('git config http.proxy', no_print_cmd=True)
    print('https_proxy: ', end='', flush=True)
    call('git config https.proxy', no_print_cmd=True)
    
    input_proxy = input('请输入新代理: ').strip()
    call(f'git config http.proxy {input_proxy}')
    call(f'git config https.proxy {input_proxy}')
    pause()


def show_git_menu():
    menu = Menu(
        title='Git 常用工具',
        options=[
            MenuOption(keys=['push'],
                       title='推送本地提交',
                       callback=push),
            MenuOption(keys=['pull'],
                       title='拉取最新提交',
                       callback=pull),
            MenuOption(keys=['credential'],
                       title='开启 git 账户验证信息缓存',
                       callback=open_credential_cache),
            MenuOption(keys=['proxy'],
                       title='配置 git 代理',
                       callback=proxy),
            MenuOption(keys=['water'],
                       title='一键水commit',
                       callback=lambda:print('成功水commit')),
        ],
        backward_text='返回主菜单'
    )
    menu.loop()
