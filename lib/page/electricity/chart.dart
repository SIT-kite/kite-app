import 'package:flutter/material.dart';

const List<Color> _gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
];

class ChartSection extends StatefulWidget {
  final String room;

  const ChartSection(this.room, {Key? key}) : super(key: key);

  @override
  _ChartSectionState createState() => _ChartSectionState(room);
}

class _ChartSectionState extends State<ChartSection> {
  final String room;
  bool isShowDays = false;

  _ChartSectionState(this.room);

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => setState(() {
            isShowDays = !isShowDays;
          }),
          child: Row(
            children: [
              Text('过去一天',
                  style: TextStyle(
                      fontSize: 20,
                      color: isShowDays ? Colors.grey : Colors.blue)),
              const Text(' / ',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              Text('过去一周',
                  style: TextStyle(
                      fontSize: 20,
                      color: isShowDays ? Colors.blue : Colors.grey))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildView() {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, top: 0, bottom: 0),
            // child: _buildLineChart(_getBottomTitles()),
          ),
        ),
        _buildModeSelector(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return FutureBuilder(
    //   future: fetchElecExpense(room, mode),
    //   builder: (context, snapshot) {},
    // );
  }
}
