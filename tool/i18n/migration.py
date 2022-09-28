from rearrange import *
import resort

line = "----------------------------------------------"

log = []


class Config:
    def __init__(self):
        self.indent = 2
        self.prefix = "app_"
        self.folder = "lib/l10n"
        self.template_name = "app_en.arb"
        self.resort_method = resort.Alphabetical
        self.auto_add = True
        self.keep_unmatched_meta = False


other_arb_paths = []

x = Config()


def yn(reply: str) -> bool:
    return to_bool(reply, empty_means=True)


def D(*args):
    print(f"|>", *args)


def Log(*args):
    log.append(f"|> {' '.join(args)}", )


def C(prompt: str) -> str:
    return input(f"|>   {prompt}")


def template_path():
    return ntpath.join(x.folder, x.template_name)


def template_path_abs():
    return os.path.abspath(ntpath.join(x.folder, x.template_name))


def Dline(center: str = None):
    if center is None:
        print(line)
    else:
        print(f"|>-------------------{center}-------------------")


def cmd_add():
    D(f"enter a file name to be created.")
    name = input("% ")
    new = ntpath.join(x.folder, name)
    tplist, tpmap = load_arb(path=template_path())
    if x.auto_add:
        rearrange_others_saved_re([new], tplist, x.indent, x.keep_unmatched_meta, fill_blank=True)
        D(f"{new} was created and rearranged.")
    else:
        rearrange_others_saved_re([new], tplist, x.indent, x.keep_unmatched_meta, fill_blank=False)
        D(f"{new} was created.")


def cmd_rename():
    D(f"enter old name and then new name. enter \"#\" to quit.")
    while True:
        template_arb = load_arb_from(path=template_path())
        tplist, tpmap = template_arb.plist, template_arb.pmap
        old = C(f"old=")
        if old == "#":
            break
        if old not in tpmap.keys():
            # try to fuzzy match
            matched, ratio = fuzzy_match(old, tpmap.keys())
            if matched is not None:
                D(f"\"{old}\" isn't in template, do you mean \"{matched}\"?")
                confirmed = yn(C(f"y/n="))
                if not confirmed:
                    D("alright, let's start all over again.")
                    continue
                # if confirmed, do nothing
            else:
                D(f"\"{old}\" isn't in template, plz check typo.")
                continue
        while True:
            # for getting the
            new = C(f"new=")
            if new == "#":
                break
            valid = validate_key(new)
            if not valid:
                D(f"the new key \"{new}\" is invalid, please enter again.")
            else:
                break
        other_arbs = load_all_arb_in(paths=other_arb_paths)
        arbs = other_arbs + [template_arb]
        for arb in arbs:
            if old in arb.pmap:
                arb.rename_key(old=old, new=new)
                Log(f"renamed \"{old}\" to \"{new}\" in \"{arb.file_name()}\".")
            else:
                if x.auto_add:
                    p = Pair(key=new, value="")
                    arb.add(p)
                    Log(f"added \"{new}\" in \"{arb.file_name()}\".")

        if x.resort_method is not None:  # auto_resort
            resorted = resort.methods[x.resort_method](template_arb.plist, template_arb.pmap)
            template_arb.plist = resorted
            rearrange_others(other_arbs, template_arb, fill_blank=x.auto_add)
        for arb in arbs:
            save_flatten(arb, x.indent, x.keep_unmatched_meta)
            Log(f"{arb.file_name()} saved.")
        Dline("[renamed]")


def cmd_resort():
    size = len(resort.methods)
    if size == 0:
        D("No resort available.")
        return
    for index, name in resort.id2methods.items():
        D(f"{index}: {name}")  # index 2 name
    D("enter the number of method.")
    while True:
        try:
            inputted = C("method=")
            if inputted == "#":
                return
            i = int(inputted)
            if 0 <= i < size:
                break
            else:
                D(f"{i} is not in range(0<=..<{size})")
        except:
            D("input is invalid, plz try again.")
    template_arb = load_arb_from(path=template_path())
    method_name = resort.id2methods[i]
    template_arb.plist = resort.methods[method_name](template_arb.plist, template_arb.pmap)
    save_flatten(template_arb)
    rearrange_others_saved_re(other_arb_paths, template_arb.plist,
                              x.indent, x.keep_unmatched_meta,
                              fill_blank=x.auto_add)
    D("all .arb files were resorted and rearranged.")


def cmd_log():
    for ln in log:
        D(ln)


cmds: dict[str, Callable[[], None]] = {
    "add": cmd_add,
    "rename": cmd_rename,
    "resort": cmd_resort,
    "log": cmd_log,
}
cmd_names = list(cmds.keys())
cmd_full_names = ', '.join(cmd_names)


def run_cmd(name: str, func: Callable[[], None]):
    Dline(f"[{name}]")
    func()
    D(f"[{name}] exists")


def migrate():
    while True:
        D(f"enter \"quit\" or \"#\" to quit migration.")
        D(f"all cmds: [{cmd_full_names}]")
        name = C("% ")
        if name == "quit" or name == "#":
            return
        if name in cmd_names:
            run_cmd(name, cmds[name])
        else:
            # try to fuzzy match
            matched, ratio = fuzzy_match(name, cmd_names)
            if matched is not None:
                D(f"cmd \"{name}\" is not found, do you mean \"{matched}\"?")
                confirmed = yn(C(f"y/n="))
                if not confirmed:
                    D("alright, let's start all over again.")
                else:
                    run_cmd(matched, cmds[matched])
            else:
                D(f"cmd \"{name}\" is not found, plz try again.")
        Dline()


def init():
    D("initializing .arb files...")
    for f in os.listdir(x.folder):
        full = ntpath.join(x.folder, f)
        if os.path.isfile(full):
            head, tail = ntpath.split(full)
            if tail != x.template_name and tail.endswith(".arb") and tail.startswith(x.prefix):
                other_arb_paths.append(full)
    Dline("[config]")
    D(f"{x.indent=},{x.prefix=},{x.folder=},{x.auto_add=}")
    D(f"{x.resort_method=}")
    Dline("[config]")
    D(f"l10n folder locates at {os.path.abspath(x.folder)}")
    D(f"all .arb file paths: [")
    for p in other_arb_paths:
        D(f"{os.path.abspath(p)}")
    D(f"]")
    D(f"template arb file path: \"{template_path_abs()}\"")
    D(f".arb files initialized.")


def setup_indent():
    D(f"please enter indent, \"{x.indent}\" as default")
    while True:
        inputted = C("indent=")
        try:
            if inputted == "#":
                return 1
            if inputted != "":
                x.indent = int(inputted)
            return
        except:
            D("input is invalid, plz try again.")


def setup_prefix():
    D(f"please enter prefix of .arb file name, \"{x.prefix}\" as default")
    while True:
        inputted = C("prefix=")
        if inputted == "#":
            return 1
        if inputted != "":
            x.prefix = inputted
        return


def setup_folder():
    D(f"please enter l10n folder path, \"{x.folder}\" as default")
    while True:
        inputted = C("folder=")
        if inputted == "#":
            return 1
        if inputted != "":
            x.folder = inputted
        return


def setup_template_name():
    D(f"please enter template file name without extension, \"{x.template_name}\" as default")
    while True:
        inputted = C("folder=")
        if inputted == "#":
            return 1
        if inputted != "":
            x.template_name = inputted
        return


def setup_auto_add():
    D(f"\"auto_add\" will add missing key automatically , \"{x.auto_add}\" as default")
    while True:
        inputted = C("auto_add=")
        if inputted == "#":
            return 1
        if inputted != "":
            x.auto_add = to_bool(inputted)
        return


def setup_keep_unmatched_meta():
    D(f"\"keep_unmatched_meta\" will keep a meta even missing a pair, \"{x.keep_unmatched_meta}\" as default")
    while True:
        inputted = C("keep_unmatched_meta=")
        if inputted == "#":
            return 1
        if inputted != "":
            x.keep_unmatched_meta = to_bool(inputted)
        return


def setup_auto_resort():
    D(f"\"auto_resort\" will resort when any file is change by migration, \"{x.resort_method}\" as default")
    while True:
        for index, name in resort.id2methods.items():
            D(f"{index}: {name}")  # index 2 name
        D(f"-1: None -- disable auto_resort")  # index 2 name
        inputted = C("id=")
        if inputted == "#":
            return 1
        try:
            i = int(inputted)
            if 0 <= i < len(resort.id2methods):
                x.resort_method = resort.id2methods[i]
            else:
                x.resort_method = None
            return
        except:
            D("input is invalid, plz try again.")


all_setups: list[Callable[[], int | None]] = [
    setup_folder,
    setup_indent,
    setup_prefix,
    setup_template_name,
    setup_auto_add,
    setup_keep_unmatched_meta,
    setup_auto_resort,
]


def wizard():
    D("enter \"#\" to go back to previous setup.")
    index = 0
    while index < len(all_setups):
        cur = all_setups[index]
        res = cur()
        if res == 1:
            index -= 2
        index += 1
        if index < 0:
            return 1
    return None


def read_config_from(args: list[str]):
    paras = split_para(args)
    x.folder = From(paras, Get="folder", Or=x.folder)
    x.indent = int(From(paras, Get="indent", Or=x.indent))
    x.prefix = From(paras, Get="prefix", Or=x.prefix)
    x.auto_add = From(paras, Get="auto_add", Or=x.auto_add)
    x.template_name = From(paras, Get="template_name", Or=x.template_name)
    x.keep_unmatched_meta = From(paras, Get="keep_unmatched_meta", Or=x.keep_unmatched_meta)


def main(args: list[str] = None):
    Dline()
    D("welcome to migration !")
    D("if no input, the default value will be used.")
    D("for y/n question, enter key means \"yes\".")
    wizard_res = None
    if args is None:
        wizard_res = wizard()
    else:
        read_config_from(args)
    Dline()
    if wizard_res is None:
        init()
        Dline()
        migrate()
    D(f"migration exited.")


if __name__ == '__main__':
    main()
