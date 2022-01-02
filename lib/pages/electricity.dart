import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const List<Color> _GRADIENTCOLORS = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
];

const List<Map<String, dynamic>> HOURSDATA = [
  {"time": "2021-11-21 22:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-21 23:00", "charge": 0, "consumption": 0.12200165},
  {"time": "2021-11-22 00:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 01:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 02:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 03:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 04:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 05:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 06:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 07:00", "charge": 0, "consumption": 0.06099701},
  {"time": "2021-11-22 08:00", "charge": 0, "consumption": 0.061000824},
  {"time": "2021-11-22 09:00", "charge": 0, "consumption": 0.061000824},
  {"time": "2021-11-22 10:00", "charge": 0, "consumption": 0.12200165},
  {"time": "2021-11-22 11:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 12:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 13:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 14:00", "charge": 0, "consumption": 0},
  {"time": "2021-11-22 15:00", "charge": 0, "consumption": 0.12199783},
  {"time": "2021-11-22 16:00", "charge": 0, "consumption": 0.12200165},
  {"time": "2021-11-22 17:00", "charge": 0, "consumption": 0.6100006},
  {"time": "2021-11-22 18:00", "charge": 0, "consumption": 0.18299866},
  {"time": "2021-11-22 19:00", "charge": 0, "consumption": 0.061000824},
  {"time": "2021-11-22 20:00", "charge": 0, "consumption": 0.06099701},
  {"time": "2021-11-22 21:00", "charge": 0, "consumption": 0.12200165},
  {"time": "2021-11-22 22:00", "charge": 0, "consumption": 0.12200165}
];

const List<Map<String, dynamic>> DAYSDATA = [
  {"date": "2021-11-15", "charge": 0, "consumption": 1.4640007},
  {"date": "2021-11-16", "charge": 0, "consumption": 1.341999},
  {"date": "2021-11-17", "charge": 0, "consumption": 1.2200012},
  {"date": "2021-11-18", "charge": 0, "consumption": 1.9519997},
  {"date": "2021-11-19", "charge": 0, "consumption": 1.0979996},
  {"date": "2021-11-20", "charge": 0, "consumption": 0.8540001},
  {"date": "2021-11-21", "charge": 0, "consumption": 1.8300018},
  {"date": "2021-11-22", "charge": 0, "consumption": 1.6469994}
];

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  bool showDays = false;
  List<String> daysBottomTitles = [];
  List<String> hoursBottomTitles = [];
  List<String> daysLeftTitles = [];
  List<String> hoursLeftTitles = [];
  List<Map<String, dynamic>> hoursData = [];
  List<Map<String, dynamic>> daysData = [];
  List<FlSpot> hoursAxisYData = [];
  List<FlSpot> daysAxisYData = [];

  @override
  _ElectricityPageState() {
    _initHoursAxisYData(HOURSDATA, hoursAxisYData);
    _initDaysAxisYData(DAYSDATA, daysAxisYData);
    _initHoursBottomTitles(HOURSDATA, hoursBottomTitles);
    _initDaysBottomTitles(DAYSDATA, daysBottomTitles);
  }

  void switchChart() {
    setState(() {
      showDays = !showDays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.grey[200],
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: _buildTitleLine(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: _buildTextInputBox('楼号', '房间号'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 80, right: 80),
          child: _buildButtonBox(
              '查询余额', const Color(0xFF2e62cd), '查询使用情况', const Color(0xFFf08c00)),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 30,
            left: 10,
            right: 10,
          ),
          child: _buildTextBlock(context),
        ),
        _buildChartBlock(
            switchChart,
            showDays,
            !showDays ? hoursBottomTitles : daysBottomTitles,
            !showDays ? hoursAxisYData : daysAxisYData,
            !showDays
                ? {'minX': 0, 'maxX': 24}
                : {
                    'minX': 0,
                    'maxX': 7,
                  },
            !showDays
                ? {'minY': 0, 'maxY': 6}
                : {
                    'minY': 0,
                    'maxY': 4.5,
                  },
            1,
            !showDays ? 3 : 1),
      ]),
    ));
  }
}

Widget _buildTitleLine() {
  return const Text('电费余额查询',
      style: TextStyle(fontSize: 22, color: Colors.black87));
}

Widget _buildTextInput(String _hintText) {
  return Expanded(
      child: TextField(
    maxLength: 2,
    maxLines: 1,
    textAlignVertical: const TextAlignVertical(y: 1),
    keyboardType: const TextInputType.numberWithOptions(),
    decoration: InputDecoration(
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
        hintText: _hintText,
        hintStyle: const TextStyle(color: Colors.grey)),
  ));
}

Widget _buildTextInputBox(hintText1, hintText2) {
  return SizedBox(
    width: 300,
    height: 60,
    child:
        Row(children: [_buildTextInput(hintText1), _buildTextInput(hintText2)]),
  );
}

Widget _buildButton(String label, Color color) {
  return ElevatedButton(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
    onPressed: () {},
    child: Text(label),
  );
}

Widget _buildButtonBox(
    String label1, Color color1, String label2, Color color2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildButton(label1, color1),
      _buildButton(label2, color2),
    ],
  );
}

Widget _buildTextBlock(context) {
  return Container(
      padding: const EdgeInsets.only(
        top: 5,
        right: 10,
        left: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        //设置四周边框
        border: Border.all(width: 2, color: Colors.blue.shade400),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          GestureDetector(
            onTap: () {
              _showInfo(context, '此数据来源于校内在线电费查询平台。如有错误，请以充值机显示金额为准～');
            },

            // Change button text when light changes state.
            child: Text('数据不一致?',
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          )
        ]),
        Text('房间号:'),
        Text('剩余金额:'),
        Text('剩余电量:'),
        Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text('更新时间:',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12))),
      ]));
}

Widget _buildChartBlock(
    switchChart,
    bool showDays,
    List<String> bottomTitles,
    List<FlSpot> axisYData,
    Map<String, double> xConstrains,
    Map<String, double> yConstrains,
    double leftInterval,
    double bottomInterval) {
  return SafeArea(
      child: Stack(
    children: <Widget>[
      AspectRatio(
        aspectRatio: 1.70,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff232d37)),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 22.0, left: 2.0, top: 30, bottom: 2),
            child: _buildLineChart(bottomTitles, axisYData, xConstrains,
                yConstrains, leftInterval, bottomInterval),
          ),
        ),
      ),
      SizedBox(
          width: null,
          height: 34,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              onPressed: switchChart,
              child: Row(children: [
                Text(
                  '过去一天',
                  style: TextStyle(
                      fontSize: 12,
                      color: showDays ? Colors.grey : Colors.blue),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Text(
                  '过去一周',
                  style: TextStyle(
                      fontSize: 12,
                      color: showDays ? Colors.blue : Colors.grey),
                )
              ]),
            ),
          ])),
    ],
  ));
}

LineChart _buildLineChart(
    List<String> bottomTitles,
    List<FlSpot> axisYData,
    Map<String, double> xConstrains,
    Map<String, double> yConstrains,
    double leftInterval,
    double bottomInterval) {
  return LineChart(LineChartData(
    lineTouchData: LineTouchData(touchTooltipData:
        LineTouchTooltipData(getTooltipItems: (List<LineBarSpot> touchedSpots) {
      return touchedSpots.map((LineBarSpot touchedSpot) {
        final textStyle = TextStyle(
          color: touchedSpot.bar.colors[0],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
        return LineTooltipItem(touchedSpot.y.toStringAsFixed(3), textStyle);
      }).toList();
    })),
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: bottomInterval,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 14),
        getTitles: (value) => bottomTitles.length == 8 && value.toInt() > 7? '' : bottomTitles[value.toInt()],
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: leftInterval,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) => value.toInt().toString() + '.00',
        reservedSize: 32,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: xConstrains['minX'],
    maxX: xConstrains['maxX'],
    minY: yConstrains['minY'],
    maxY: yConstrains['maxY'],
    lineBarsData: [
      LineChartBarData(
        spots: axisYData,
        isCurved: true,
        colors: _GRADIENTCOLORS,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              _GRADIENTCOLORS.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  ));
}

Future<void> _showInfo(context, String _content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text(_content),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('知道啦!'),
          ),
        ],
      );
    },
  );
}

void _initHoursAxisYData(
    List<Map<String, dynamic>> hoursData, List<FlSpot> hoursAxisYData) {
  for (int i = 0; i < hoursData.length; i++) {
    hoursAxisYData
        .add((FlSpot(i.toDouble(), hoursData[i]['consumption'] / 0.15)));
  }
}

void _initDaysAxisYData(
    List<Map<String, dynamic>> daysData, List<FlSpot> daysAxisYData) {
  for (int i = 0; i < daysData.length; i++) {
    daysAxisYData.add((FlSpot(i.toDouble(), daysData[i]['consumption'])));
  }
}

void _initHoursBottomTitles(
    List<Map<String, dynamic>> hoursData, List<String> hoursBottomTitles) {
  for (int i = 0; i < hoursData.length; i++) {
    hoursBottomTitles.add(hoursData[i]['time'].substring(11));
  }
}

void _initDaysBottomTitles(
    List<Map<String, dynamic>> daysData, List<String> daysBottomTitles) {
  for (int i = 0; i < daysData.length; i++) {
    daysBottomTitles.add(daysData[i]['date'].substring(5));
  }
}
