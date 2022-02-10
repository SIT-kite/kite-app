import os
import subprocess
import sys
from typing import *


def get_system_envs():
    """
    获取系统环境变量
    """
    env = os.environ
    return env


def extend_envs(system_env: Dict[str, str], user_env: Dict[str, str]):
    """
    用户环境变量扩展系统环境变量
    """
    env = system_env.copy()
    env.update(user_env)
    return env


def call_with_env(script, env_dic: Dict[str, str]):
    """
    调用系统命令
    """
    print('运行命令: ', script)

    subprocess.call(
        script.split(' '),
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr,
        env=env_dic,
    )


def run_functions(functions: Iterable[Callable]):
    """
    一次性运行多个函数
    """
    for function in functions:
        function()
