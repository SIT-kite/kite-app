import 'package:flutter/material.dart';
import 'package:kite/module/symbol.dart';

import '../using.dart';

class TimetableEditor extends StatefulWidget {
  final TimetableMeta meta;
  final DateTime? defaultStartDate;

  const TimetableEditor({super.key, required this.meta, this.defaultStartDate});

  @override
  State<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  late TextEditingController _metaDescController;

  @override
  void initState() {
    super.initState();
    _metaDescController = TextEditingController(text: widget.meta.description);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildTimetableEditor(context),
    );
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _metaDescController,
            maxLines: 2,
            decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
          )
        ]));
  }

  Widget buildTimetableEditor(BuildContext ctx) {
    final year = '${widget.meta.schoolYear} - ${widget.meta.schoolYear + 1}';
    final semesterNames = makeSemesterL10nName();
    final semster = semesterNames[Semester.values[widget.meta.semester]] ?? "";
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(widget.meta.name, style: ctx.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Text(year),
                  Text(semster),
                  Text("Start with: ${ctx.dateNum(widget.meta.startDate)}"),
                ]),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: buildDescForm(ctx)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Preview",
                  style: ctx.textTheme.titleLarge,
                ),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
