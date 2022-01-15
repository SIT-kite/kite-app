import 'package:flutter/material.dart';

typedef SuggestionItemTap = void Function(String item);

class SuggestionItemView extends StatefulWidget {
  final SuggestionItemTap? onItemTap;
  final List<String> titleItems;
  const SuggestionItemView({
    Key? key,
    this.onItemTap,
    this.titleItems = const [],
  }) : super(key: key);

  @override
  _SuggestionItemViewState createState() => _SuggestionItemViewState();
}

class _SuggestionItemViewState extends State<SuggestionItemView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.titleItems.map((item) {
        return Container(
          padding: const EdgeInsets.all(3),
          child: SuggestionItem(
            title: item,
            onTap: () {
              (widget.onItemTap ?? () {})(item);
            },
          ),
        );
      }).toList(),
    );
  }
}

class SuggestionItem extends StatefulWidget {
  final String? title;
  final GestureTapCallback? onTap;
  const SuggestionItem({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  _SuggestionItemState createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<SuggestionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Chip(
          label: Text(widget.title ?? ""),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: widget.onTap,
      ),
      color: Colors.white,
    );
  }
}
