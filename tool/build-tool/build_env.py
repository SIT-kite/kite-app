from util import *
from base import ConfigManager

__config_manager = ConfigManager(filename=os.path.join(os.path.dirname(
    os.path.realpath(__file__)), 'build.cfg'))


def put_envs(envs: Dict[str, str]):
    __config_manager.config.env.update(envs)


def get_envs():
    return extend_envs(
        system_env=get_system_envs(),
        user_env=__config_manager.config.env)


def save_config():
    __config_manager.save_config()


@property
def config():
    return __config_manager.config


def call(script):
    call_with_env(script=script,
                  env_dic=get_envs())
