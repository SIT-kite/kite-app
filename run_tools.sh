python .tool/i18n/main.py resort target=.\l10n\app_en.arb keep_unmatched_meta=y indent=2 method=alphabetical
python .tool/i18n/main.py rearrange template=.\l10n\app_en.arb prefix=app_  keep_unmatched_meta=y fill_blank=n
