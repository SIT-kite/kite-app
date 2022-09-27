from arb import *
import os
import ntpath

required_para = [
    "prefix",
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
    template_suffix = teplt_tail.removeprefix(prefix)
    rearrange(teplt_head, prefix, template_suffix, indent, keep_unmatched_meta, fill_blank)


def rearrange(l10n_dir: str, prefix: str, template_suffix: str, indent=2, keep_unmatched_meta=False, fill_blank=False):
    """
    :param keep_unmatched_meta: keep a meta missing a pair
    :param l10n_dir: lib/l10n
    :param prefix: app_
    :param template_suffix: en.arb
    :param indent: 2
    :param fill_blank: False
    """
    template_fullname = prefix + template_suffix
    others_path = collect_others(l10n_dir, prefix, template_fullname)
    template_path = ntpath.join(l10n_dir, template_fullname)
    tplist, tpmap = load_arb(path=template_path)
    rearrange_others(others_path, tplist, indent, keep_unmatched_meta, fill_blank)


def collect_others(l10n_dir: str, prefix: str = "app", template: str = "app_en.arb") -> list[str]:
    """
    :param template: the full name of template
    :param prefix: app_
    :param l10n_dir: lib/l10n
    :return: paths of other .arb files
    """
    others_path = []
    for f in os.listdir(l10n_dir):
        full = ntpath.join(l10n_dir, f)
        if os.path.isfile(full):
            head, tail = ntpath.split(full)
            if tail != template and tail.endswith(".arb") and tail.startswith(prefix):
                others_path.append(full)
    return others_path


def rearrange_others(others_path: list[str], template_plist: PairList, indent=2, keep_unmatched_meta=False,
                     fill_blank=False):
    others_arb = []
    for other_path in others_path:
        plist, pmap = load_arb(path=other_path)
        others_arb.append(ArbFile(other_path, plist, pmap))
    for tp in template_plist:
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
