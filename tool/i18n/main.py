import sys
import resort
import rearrange
import serve

help_txt = """
* means optional
--------------------------
help: display help info.
--------------------------
resort: resort a .arb file.
args:
    target: .arb file path
        type: str
    method*: how to resort this file
        options: [
            cleanup : keep the meta following its pair,
            alphabetical : sort in alphabetical order,
            -alphabetical : sort in alphabetical order with a reversed key,
            lexicographical : sort in lexicographical order,
            tags : sort by weighted tags
        ]
        default: alphabetical 
    keep_unmatched_meta* : keep a meta missing a pair 
        options: [y,n]
        default: n
    indent*: indent of json output
        type: int
        default: 2
---------------------
rearrange: rearrange other .arb files in the same order of the template.
args:
    prefix: the prefix of all .arb file
    template: template path
    fill_blank*: fill all missing l10n pairs
        options: [y,n]
        default: n
    indent*: indent of json output
    keep_unmatched_meta* : keep a meta missing a pair
---------------------
serve: auto-rearrange other .arb files when any key changed in template.
args:
    prefix: the prefix of all .arb file
    template: template path
    fill_blank*: fill all missing l10n pairs
        default: y
    indent*: indent of json output
    keep_unmatched_meta* : keep a meta missing a pair
"""

all_tasks = {
    "help": lambda _: print(help_txt),
    "resort": resort.wrapper,
    "rearrange": rearrange.wrapper,
    "serve": serve.wrapper,
}


def main():
    if len(sys.argv) == 1:
        print(help_txt)
        return
    args = sys.argv[1:]
    arg0 = args[0]
    if arg0 in all_tasks.keys():
        params = args[1:] if len(args) > 0 else []
        task = all_tasks[arg0]
        task(params)
    else:
        print(f"no such command: \"{arg0}\", please check \"help\"")


if __name__ == '__main__':
    main()
