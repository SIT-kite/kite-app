from arb import *
import os
import ntpath
import rearrange as re
from datetime import datetime
import time

required_para = [
    "prefix",
    "template",
]


def wrapper(args):
    paras = split_para(args)
    check_para_exist(paras, required_para)
    prefix = paras["prefix"]
    template = paras["template"]
    fill_blank = From(paras, Get="fill_blank", Or="y") == "y"
    indent = int(From(paras, Get="indent", Or="2"))
    keep_unmatched_meta = From(paras, Get="keep_unmatched_meta", Or="n") == "y"
    teplt_head, teplt_tail = ntpath.split(template)
    template_suffix = teplt_tail.removeprefix(prefix)
    serve(teplt_head, prefix, template_suffix, indent, keep_unmatched_meta, fill_blank)


def serve(l10n_dir: str, prefix: str, template_suffix: str, indent=2, keep_unmatched_meta=False, fill_blank=True):
    template_fullname = prefix + template_suffix
    template_path = ntpath.join(l10n_dir, template_fullname)
    others_path = re.collect_others(l10n_dir, prefix, template_fullname)
    last_stamp = 0
    last_plist = []
    while True:
        stamp = os.stat(template_path).st_mtime
        if stamp != last_stamp:
            last_stamp = stamp
            try:
                tplist, tpmap = load_arb(path=template_path)
                if is_key_changed(last_plist, tplist):
                    last_plist = tplist
                    re.rearrange_others_saved_re(others_path, tplist, indent, keep_unmatched_meta, fill_blank)
                    print(f"[{datetime.now()}] refreshed.")
            except:
                pass
        time.sleep(1)


def is_key_changed(a: PairList, b: PairList) -> bool:
    if len(a) != len(b):
        return True
    for i in range(0, len(a)):
        if a[i].key != b[i].key:
            return True
    return False
