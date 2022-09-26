from json import JSONDecoder
from collections import OrderedDict
import sys

help_txt = """
h, help : display help info
--------------------------
resort : resort the .arb file
--target=path : target path
---------------------
rearrange : rearrange other .arb files in order of the template
--template=path : template path
"""

all_tasks = {"help", "resort", "rearrange"}


def error_args(txt):
    print(txt)
    exit(1)


def main():
    if len(sys.argv) == 0:
        print(help_txt)
        exit(0)
    args = sys.argv[1:]
    arg0 = args[0]
    if arg0 in all_tasks:
        task = (arg0, args[1:])
    else:
        error_args(f"no such command: \"{arg0}\", please check \"help\"")
    jcoder = JSONDecoder(object_hook=OrderedDict)


if __name__ == '__main__':
    main()
