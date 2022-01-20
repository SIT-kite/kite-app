import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

export 'item/electricity.dart';
export 'item/expense.dart';
export 'item/library.dart';
export 'item/office.dart';
export 'item/report.dart';
export 'item/score.dart';
export 'item/timetable.dart';

class HomeItem extends StatelessWidget {
  final String route;
  final String icon;
  final String title;
  final Future<String?> Function()? callback;

  const HomeItem({required this.route, required this.icon, required this.title, this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.bold);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
        ),
        child: ListTile(
          leading: SvgPicture.asset(icon, height: 30, width: 30, color: Theme.of(context).primaryColor),
          title: Text(title, style: titleStyle),
          subtitle: callback != null
              ? FutureBuilder(
                  future: callback!(),
                  builder: (BuildContext build, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data ?? '');
                    }
                    return const Text('加载中…');
                  },
                )
              : Container(),
          dense: true,
        ),
      ),
    );
  }
}
