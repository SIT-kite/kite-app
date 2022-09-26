import sys
import cleanup
import rearrange

help_txt = """
* means optional
--------------------------
help : display help info.
--------------------------
cleanup : clean up the .arb file. keep the meta following its pair.
args:
    target : target path
        type: str
    keep_unmatched_meta* : keep a meta missing a pair 
        options: [y/n]
        default: n
    indent*: indent of json output
        type: int
        default: 2
---------------------
rearrange : rearrange other .arb files in order of the template.
args:
    name : 
    template : template path
"""

all_tasks = {
    "help": lambda _: print(help_txt),
    "cleanup": cleanup.wrapper,
    "rearrange": rearrange.wrapper
}


def error_args(txt):
    print(txt)
    exit(1)


def main():
    if len(sys.argv) == 0:
        print(help_txt)
        exit(0)
    args = sys.argv[1:]
    arg0 = args[0]
    if arg0 in all_tasks.keys():
        params = args[1:] if len(args) > 0 else []
        task = all_tasks[arg0]
        task(params)
    else:
        error_args(f"no such command: \"{arg0}\", please check \"help\"")


if __name__ == '__main__':
    main()
