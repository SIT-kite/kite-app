import 'package:flutter/material.dart';
import 'package:kite/page/electricity/balance.dart';
import 'package:kite/page/electricity/rank.dart';
import 'package:kite/page/electricity/model.dart';
import 'package:kite/page/electricity/chart.dart';
import 'package:kite/service/electricity.dart';
import 'package:kite/entity/electricity.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  String building = '';
  String room = '';
  List<ConditionHours> hoursList = [];
  List<ConditionDays> daysList = [];
  bool isShowBalance = true;

  String checkRoomValid() {
    int buildingInt = 0;
    int roomInt = 0;
    try {
      buildingInt = int.parse(building);
      roomInt = int.parse(room);
    } catch (e) {
      buildModel(context, '输入格式有误');
      return 'error';
    }

    if (buildingInt >= 1 &&
        buildingInt < 27 &&
        roomInt > 100 &&
        roomInt / 100 >= 0 &&
        roomInt / 100 < 17 &&
        roomInt % 100 < 31 &&
        roomInt % 100 > 0) {
      final result = '10${buildingInt}${roomInt}';
      return result;
    } else {
      buildModel(context, '输入格式有误');
      return 'error';
    }
  }

  Widget _buildTextInputBox() {
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

    return SizedBox(
      width: 300,
      height: 60,
      child: Row(children: [
        _buildTextInput('楼号', 2, (newValue) {
          setState(() {
            building = newValue;
          });
        }),
        _buildTextInput('房间号', 4, (newValue) {
          setState(() {
            room = newValue;
          });
        })
      ]),
    );
  }

  Widget _buildButtonBox() {
    Widget _buildButton(String label, Color color, callBack) {
      return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
        onPressed: callBack,
        child: Text(label),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton('查询余额', Color(0xFF2e62cd), () {
          String result = checkRoomValid();
          if (result != 'error') {
            setState(() {
              isShowBalance = true;
            });
          }
        }),
        _buildButton('查询使用情况', Color(0xFFf08c00), () {
          String result = checkRoomValid();
          if (result != 'error') {
            setState(() {
              isShowBalance = false;
            });
            fetchConditionHours(room).then((res) {
              setState(() {
                hoursList = res;
              });
            });
            fetchConditionDays(room).then((res) {
              setState(() {
                daysList = res;
              });
            });
          }
        }),
      ],
    );
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
                child: _buildTextInputBox()),
            Container(
                margin: const EdgeInsets.only(left: 80, right: 80),
                child: _buildButtonBox()),
            isShowBalance
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 30,
                      left: 10,
                      right: 10,
                    ),
                    child: buildBalance(context, '10$building$room'),
                  )
                : Container(),
            isShowBalance
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(
                      top: 40,
                      bottom: 40,
                      left: 40,
                      right: 40,
                    ),
                    child: buildRank('10$building$room', daysList),
                  ),
            isShowBalance ? Container() : Chart(hoursList, daysList),
          ]),
        ))));
  }
}
