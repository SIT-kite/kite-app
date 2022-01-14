import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
  String building = '';
  String room = '';
  bool isShowBalance = true;
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

  String checkRoomValid() {
    int buildingInt = 0;
    int roomInt = 0;
    try {
      buildingInt = int.parse(building);
      roomInt = int.parse(room);
    } catch (e) {
      _showInfo(context, '输入格式有误');
      return 'error';
    }

    if (buildingInt >= 1 &&
        buildingInt < 27 &&
        roomInt > 100 &&
        roomInt / 100 >= 0 &&
        roomInt / 100 < 17 &&
    roomInt % 100 < 31 && roomInt % 100 > 0) {
      final result = '10${buildingInt}${roomInt}';
      return result;
    } else {
      _showInfo(context, '输入格式有误');
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('电费余额查询'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(

          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: _buildTextInputBox(
                  '楼号',
                  (newValue) {
                    setState(() {
                      building = newValue;
                    });
                  },
                  '房间号',
                  (newValue) {
                    setState(() {
                      room = newValue;
                    });
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(left: 80, right: 80),
              child: _buildButtonBox(
                  '查询余额',
                  () {
                    String result = checkRoomValid();
                    if(result != 'error') {
                      setState(() {
                        isShowBalance = true;
                      });
                    }
                  },
                  '查询使用情况',
                  () {
                    String result = checkRoomValid();
                    if(result != 'error') {
                      setState(() {
                        isShowBalance = false;
                      });
                    }
                  }),
            ),
            isShowBalance
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 30,
                      left: 10,
                      right: 10,
                    ),
                    child: _buildBalanceTextBlock(context),
                  )
                : Container(),
            isShowBalance? Container() : Container(
              margin: const EdgeInsets.only(
                top: 40,
                bottom: 40,
                left: 40,
                right: 40,
              ),
              child: _buildRankTextBlock(),
            ) ,
            isShowBalance? Container() :_buildChartBlock(
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
                    ? {'minY': 0, 'maxY': _getMaxY(HOURSDATA)}
                    : {
                        'minY': 0,
                        'maxY': _getMaxY(DAYSDATA),
                      },
                1,
                !showDays ? 3 : 1),
          ]),
        ))));
  }
}

Widget _buildTextInput(String _hintText, int _maxLength, callBack) {
  return Expanded(
      child: TextField(
          maxLength: _maxLength,
          maxLines: 1,
          textAlignVertical: const TextAlignVertical(y: 1),
          keyboardType: const TextInputType.numberWithOptions(),
          decoration: InputDecoration(
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              hintText: _hintText,
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (newValue) {
            callBack(newValue);
          }));
}

Widget _buildTextInputBox(hintText1, callBack1, hintText2, callBack2) {
  return SizedBox(
    width: 300,
    height: 60,
    child: Row(children: [
      _buildTextInput(hintText1, 2, callBack1),
      _buildTextInput(hintText2, 4, callBack2)
    ]),
  );
}

Widget _buildButton(String label, Color color, callBack) {
  return ElevatedButton(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
    onPressed: callBack,
    child: Text(label),
  );
}

Widget _buildButtonBox(String label1, callBack1, String label2, callBack2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildButton(label1, Color(0xFF2e62cd), callBack1),
      _buildButton(label2, Color(0xFFf08c00), callBack2),
    ],
  );
}

Widget _buildBalanceTextBlock(context) {
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

Widget _buildRankTextBlock() {
  return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        //设置四周边框
        border: Border.all(width: 2, color: Colors.blue.shade400),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('0.00',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black)),
            Text('元',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey)),
          ]),
          Text('24小时消费超越了 ${0.00}% 的寝室', style: TextStyle(fontSize: 16)),
          Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              height: 1,
              color: Colors.blue),
          Text('上次充值 ${_getCharge(DAYSDATA)} 元'),
          Text('( 仅可查询七天内且最新一次充值记录 )')
        ],
      ));
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
  return Column(
    children: <Widget>[
      AspectRatio(
        aspectRatio: 1.70,
        child: Container(
          // decoration: const BoxDecoration(
          //   color: Colors.white,
          // ),
          child: Padding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, top: 20, bottom: 0),
            child: _buildLineChart(bottomTitles, axisYData, xConstrains,
                yConstrains, leftInterval, bottomInterval),
          ),
        ),
      ),
      Container(
        // color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            onPressed: switchChart,
            child: Row(children: [
              Text(
                '过去一天',
                style: TextStyle(
                    fontSize: 20, color: showDays ? Colors.grey : Colors.blue),
              ),
              const Text(
                ' / ',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Text(
                '过去一周',
                style: TextStyle(
                    fontSize: 20, color: showDays ? Colors.blue : Colors.grey),
              )
            ]),
          ),
        ]),
      )
    ],
  );
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
        reservedSize: 20,
        interval: bottomInterval,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 14),
        getTitles: (value) => bottomTitles.length == 8 && value.toInt() > 7
            ? ''
            : bottomTitles[value.toInt()],
        margin: 4,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: leftInterval,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) => value.toInt().toString(),
        reservedSize: 0,
        margin: 8,
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
        .add((FlSpot(i.toDouble(), hoursData[i]['consumption'].toDouble())));
  }
}

void _initDaysAxisYData(
    List<Map<String, dynamic>> daysData, List<FlSpot> daysAxisYData) {
  for (int i = 0; i < daysData.length; i++) {
    daysAxisYData
        .add((FlSpot(i.toDouble(), daysData[i]['consumption'].toDouble())));
  }
}

void _initHoursBottomTitles(
    List<Map<String, dynamic>> hoursData, List<String> hoursBottomTitles) {
  for (int i = 0; i < hoursData.length; i++) {
    hoursBottomTitles.add(hoursData[i]['time'].substring(11, 13));
  }
}

void _initDaysBottomTitles(
    List<Map<String, dynamic>> daysData, List<String> daysBottomTitles) {
  for (int i = 0; i < daysData.length; i++) {
    daysBottomTitles.add(daysData[i]['date'].substring(8, 10));
  }
}

double _getMaxY(List<Map<String, dynamic>> data) {
  double maxY = 0;
  data.forEach((item) {
    maxY = maxY > item['consumption'].toDouble()
        ? maxY
        : item['consumption'].toDouble();
  });
  return maxY;
  // return maxY.toInt() - maxY < 0? maxY.toInt() + 1 : maxY.toInt();
}

String _getCharge(List<Map<String, dynamic>> data) {
  double charge = 0.0;
  data.forEach((item) {
    charge = item['consumption'].toDouble() > charge
        ? item['consumption'].toDouble()
        : charge;
  });
  return charge.toStringAsFixed(2);
}
