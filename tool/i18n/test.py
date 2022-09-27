import resort

f = "../../l10n/app_en.arb"
txt = open(f, mode="r", encoding="UTF-8").read()

resort.resort(
    target=txt,
    method=resort.do_tags_sort,
)
