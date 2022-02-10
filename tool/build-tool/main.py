"""
本工具用于便捷地运行一些编译脚本, 省去繁琐的命令行操作
运行环境: python3.7 及以上
"""
import sys, os

sys.path.append(os.path.dirname(__file__))
print('当前脚本运行目录: ',os.path.dirname(__file__))
from page import show_home_menu

if __name__ == '__main__':
    show_home_menu()
