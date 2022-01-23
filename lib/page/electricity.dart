import 'package:flutter/material.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/electricity/util.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/electricity/balance.dart';
import 'package:kite/page/electricity/chart.dart';
import 'package:kite/page/electricity/model.dart';
import 'package:kite/page/electricity/rank.dart';
import 'package:kite/service/electricity.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  String building = '';
  String room = '';
  Balance balance = Balance(0, 0, '', ''); // TODO: Refactor
  Map<String, double> rank = {};
  List<ConditionHours> hoursList = [];
  List<ConditionDays> daysList = [];
  bool isShowBalance = true;

  String _checkRoomValid() {
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
      final result = '10$buildingInt$roomInt';
      return result;
    } else {
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
        _buildButton('查询余额', const Color(0xFF2e62cd), () {
          String result = _checkRoomValid();
          if (result != 'error') {
            StoragePool.electricity.lastBuilding = building;
            StoragePool.electricity.lastRoom = room;
            fetchBalance('10$building$room')
                .then((res) => {
                      res.room != ''
                          ? setState(() {
                              balance = res;
                            })
                          : buildModel(context, '该房间不存在, 请重新输入!')
                    })
                .then((res) => setState(() {
                      isShowBalance = true;
                    }));
          } else {
            buildModel(context, '输入格式有误');
          }
        }),
        _buildButton('查询使用情况', const Color(0xFFf08c00), () {
          String result = _checkRoomValid();
          if (result != 'error') {
            StoragePool.electricity.lastBuilding = building;
            StoragePool.electricity.lastRoom = room;
            getRank('10$building$room').then((res) {
              setState(() {
                rank = res;
              });
              fetchConditionHours('10$building$room').then((res) {
                setState(() {
                  hoursList = res;
                });
              }).then((res) {
                setState(() {
                  isShowBalance = false;
                });
              });
              fetchConditionDays('10$building$room').then((res) {
                setState(() {
                  daysList = res;
                });
              });
            });
          } else {
            buildModel(context, '输入格式有误');
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
                child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 30), child: _buildTextInputBox()),
          Container(margin: const EdgeInsets.only(left: 80, right: 80), child: _buildButtonBox()),
          isShowBalance && balance.room != ''
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                  ),
                  child: buildBalance(context, balance),
                )
              : Container(),
          isShowBalance
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    left: 40,
                    right: 40,
                  ),
                  child: buildRank(rank, daysList),
                ),
          isShowBalance ? Container() : Chart(hoursList, daysList),
        ]))));
  }
}
