import os
from dataclasses import dataclass
from typing import *
import json


@dataclass
class Config:
    env: Dict[str, str]

    @staticmethod
    def from_json(json_str: str):
        dic = json.loads(json_str)
        return Config(env=dic['env'])

    def to_json(self):
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
            self.config = Config.from_json(f.read())

    def save_config(self):
        """
        保存配置文件
        """
        print(f'写入配置文件: {self.filename}')
        with open(file=self.filename, mode='w', encoding='utf-8') as f:
            f.write(self.config.to_json())
