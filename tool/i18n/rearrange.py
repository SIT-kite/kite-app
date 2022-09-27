from arb import *
import os
import ntpath

required_para = [
    "name",
    "template",
]


def wrapper(args):
    paras = util.split_para(args)
    util.check_para_exist(paras, required_para)
    prefix = paras["prefix"]
    template = paras["template"]
    fill_blank = util.From(paras, Get="fill_blank", Or="n") == "y"
    indent = int(util.From(paras, Get="indent", Or="2"))
    keep_unmatched_meta = util.From(paras, Get="keep_unmatched_meta", Or="n") == "y"
    teplt_head, teplt_tail = ntpath.split(template)
    rearrange(teplt_head, prefix, teplt_tail.removeprefix(prefix), indent, keep_unmatched_meta, fill_blank)


def rearrange(l10n_dir, prefix, template_suffix, indent=2, keep_unmatched_meta=False, fill_blank=False):
    """
    :param keep_unmatched_meta: keep a meta missing a pair
    :param l10n_dir: lib/l10n
    :param prefix: app_
    :param template_suffix: en.arb
    :param indent: 2
    :param fill_blank: False
    """
    teplt_full = prefix + template_suffix
    others_path = []
    for f in os.listdir(l10n_dir):
        full = ntpath.join(l10n_dir, f)
        if os.path.isfile(full):
            head, tail = ntpath.split(full)
            if tail != teplt_full and tail.endswith(".arb") and tail.startswith(prefix):
                others_path.append(full)
    tmplt_path = ntpath.join(l10n_dir, teplt_full)
    tmplt_li, tmplt_map = load_arb(tmplt_path)
    others_arb = []
    for other_path in others_path:
        plist, pmap = load_arb(other_path)
        others_arb.append(ArbFile(other_path, plist, pmap))
    for tp in tmplt_li:
        key = tp.key
        for arb in others_arb:
            if key in arb.pmap:
                arb.re.append(arb.pmap[key])
            else:
                if fill_blank:
                    arb.re.append(Pair(key, value=""))
    for arb in others_arb:
        ordered = flatten_pairs(arb.re, keep_unmatched_meta)
        txt = json.dumps(ordered, ensure_ascii=False, indent=indent)
        util.write_fi(arb.path, txt)
