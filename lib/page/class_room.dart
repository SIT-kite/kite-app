import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/entity/class_room.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/page/contact.dart';
import 'package:kite/page/index.dart';
import 'package:kite/service/class_room.dart';
import 'package:kite/util/url_launcher.dart';

String campusChoosed = '奉贤校区';
List<String> campus = ['奉贤校区', '徐汇校区'];
List<String> dates = [];
DateTime now = DateTime.now();
String dateChoosed = dates[0];
String buildingChoosed = 'A';

class ClassRoomPage extends StatefulWidget {
  const ClassRoomPage({Key? key}) : super(key: key);

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('空教室咨询'),
      ),
      body: Column(children: [
        Expanded(
          flex: 4,
          child: _classRoomButtonView(),
        ),
        Expanded(
          flex: 1,
          child: _headerTitle(),
        ),
        Expanded(
          flex: 18,
          child: _getData(),
        ),
      ]),
    );
  }

  Widget _freeview() {
    return Container(
      margin: const EdgeInsets.only(left: 1.0, right: 1.0),
      width: 10.0,
      height: 20.0,
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4.5)),
          color: Colors.green),
    );
  }

  Widget _whiteview() {
    return Container(
      margin: const EdgeInsets.only(left: 1.0, right: 1.0),
      width: 10.0,
      height: 20.0,
    );
  }

  Widget _bussView() {
    return Container(
      margin: const EdgeInsets.only(left: 1.0, right: 1.0),
      width: 10.0,
      height: 20.0,
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4.5)),
          color: Colors.red),
    );
  }

  Widget _headerTitle() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      height: MediaQuery.of(context).size.height / 20,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            _freeview(),
            Text('空闲',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500)),
            _whiteview(),
            _bussView(),
            Text('有课',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500))
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('|上午',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500)),
            _whiteview(),
            _whiteview(),
            Text('|下午',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500)),
            _whiteview(),
            _whiteview(),
            Text('|晚上',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ]),
    );
  }

  Widget _classRoomButtonView() {
    for (int i = 0; i < 9; i++) {
      int year = now.add(Duration(days: i)).year;
      int month = now.add(Duration(days: i)).month;
      int day = now.add(Duration(days: i)).day;
      dates.add('$year-$month-$day');
    }
    List<String> building = campusChoosed == '奉贤校区'
        ? ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']
        : ['教学楼', '南图'];
    return Container(
      // height: MediaQuery.of(context).size.height / 6,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                scrollDirection: Axis.horizontal,
                itemCount: 9,
                itemBuilder: (BuildContext context, int indexDate) {
                  return TextButton(
                    onPressed: () {
                      setState(() => dateChoosed = dates[indexDate]);
                      print(dateChoosed);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11))),
                      backgroundColor: MaterialStateProperty.all(
                          dateChoosed == dates[indexDate]
                              ? const Color.fromRGBO(250, 250, 250, 0.65)
                              : Theme.of(context).primaryColor),
                    ),
                    child: Center(
                      child: Text(dates[indexDate],
                          style: TextStyle(
                              color: dateChoosed == dates[indexDate]
                                  ? Theme.of(context).primaryColor
                                  : Colors.white)),
                    ),
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (BuildContext context, int indexCampus) {
                  return TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11))),
                      backgroundColor: MaterialStateProperty.all(
                          campusChoosed == campus[indexCampus]
                              ? const Color.fromRGBO(250, 250, 250, 0.65)
                              : Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      setState(() {
                        campusChoosed = campus[indexCampus];
                        building = campusChoosed == '奉贤校区'
                            ? ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']
                            : ['教学楼', '南图'];
                        buildingChoosed = building[0];
                      });
                    },
                    child: Center(
                      child: Text(campus[indexCampus],
                          style: TextStyle(
                              color: campusChoosed == campus[indexCampus]
                                  ? Theme.of(context).primaryColor
                                  : Colors.white)),
                    ),
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 3.0, bottom: 5.0),
                scrollDirection: Axis.horizontal,
                itemCount: building.length,
                itemBuilder: (BuildContext context, int indexBuilding) {
                  return TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11))),
                      backgroundColor: MaterialStateProperty.all(
                          buildingChoosed == building[indexBuilding]
                              ? const Color.fromRGBO(250, 250, 250, 0.65)
                              : Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      setState(() => buildingChoosed = building[indexBuilding]);
                      print(buildingChoosed);
                    },
                    child: Center(
                        child: Text(building[indexBuilding],
                            style: TextStyle(
                                color:
                                    buildingChoosed == building[indexBuilding]
                                        ? Theme.of(context).primaryColor
                                        : Colors.white))),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _roomData(String room, int busyTime, int? capacity) {
    List<Widget> _state = [];
    for (int i = 1; i < 12; i++) {
      if ((busyTime & (1 << i)) == 0) {
        _state.add(_freeview());
      } else {
        _state.add(_bussView());
      }
    }
    _state.insert(4, _whiteview());
    _state.insert(9, _whiteview());
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.03),
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  width: 1))),
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              Text('座位数:$capacity',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    fontSize: 10,
                  )),
            ],
          ),
          Row(
            children: _state,
          )
        ],
      ),
    );
  }

  Widget _buildBody(List<ClassRoomData> data) {
    if (data.isEmpty) {
      print(data);
      return Container(
          // alignment: Alignment(0, 0),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/timetable/free.png',
            width: 100,
            height: 100,
          ),
          Text('今天休息o(*≧▽≦)ツ',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500)),
          Container(height: 100),
        ],
      ));
    } else {
      List<Widget> _body = [];
      for (ClassRoomData room in data) {
        _body.add(_roomData(room.room, room.busyTime, room.capacity));
      }
      return ListView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        children: _body,
      );
    }
  }

  Widget _getData() {
    return FutureBuilder<List<ClassRoomData>>(
      future: ClassRoomRomoteService(SessionPool.ssoSession)
          .getClassRoomData(campusChoosed, '2021-12-7'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<ClassRoomData> data = snapshot.data!
              .where((e) => e.room.contains(buildingChoosed))
              .toList();
          return _buildBody(data);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
