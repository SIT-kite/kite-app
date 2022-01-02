import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'chart.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(children: [
            Container(
              child: Text('电费余额查询',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 22, color: Colors.black87)),
              margin: EdgeInsets.only(top: 50),
            ),
            Container(
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                          maxLength: 2,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical(y: 1),
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                              hintText: '楼号',
                              hintStyle: TextStyle(color: Colors.grey)),
                        )),
                    Expanded(
                        child: TextField(
                          maxLength: 4,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical(y: 1),
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                              hintText: '寝室号',
                              hintStyle: TextStyle(color: Colors.grey)),
                        )),
                  ]),
                ),
                margin: EdgeInsets.only(top: 30)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFF2e62cd))),
                    onPressed: () {},
                    child: const Text('查询余额'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFFf08c00))),
                    onPressed: () {},
                    child: const Text('查询使用情况'),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 80, right: 80),
            ),
            Container(
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            // Change button text when light changes state.
                            child: Text('数据不一致?',
                                style:
                                TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ),
                        )
                      ])),
                  Container(child: Text('房间号:')),
                  Container(child: Text('剩余金额:')),
                  Container(child: Text('剩余电量:')),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('更新时间:',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12))),
                ]),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //设置四周边框
                  border: new Border.all(width: 2, color: Colors.blue.shade400),
                ),
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 5,
                  right: 10,
                  left: 10,
                  bottom: 10,
                ),
                margin: EdgeInsets.only(
                  top: 30,
                  left: 10,
                  right: 10,
                )),
            Container(
              child: SafeArea(child: Chart()),
            ),
          ]),
          color: Colors.grey[200],
        ));
  }
}
