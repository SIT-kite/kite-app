import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'package:kite/services/campus_card.dart';

class CampusCardRecord {
  late final int cardId;

  bool isCardRecognized = false;
  late String studentName;
  late String studentId;
  late String major;

  final int ts = DateTime.now().millisecondsSinceEpoch;

  CampusCardRecord(this.cardId,
      [String studentId = '',
      String studentName = '未知卡',
      String major = 'Unknown']) {
    if (studentId != '') {
      this.studentId = studentId;
      this.studentName = studentName;
      this.major = major;
      isCardRecognized = true;
    }
  }
}

class CampusCardPage extends StatefulWidget {
  CampusCardPage({Key? key}) : super(key: key);

  @override
  _CampusCardPageState createState() => _CampusCardPageState();
}

class _CampusCardPageState extends State<CampusCardPage> {
  final List<CampusCardRecord> _cardsRead = [];

  static String _dateToString(DateTime date) {
    final local = date.toLocal();

    return '$local.year-$local.month-$local.day $local.hour-$local.minute';
  }

  static String _tsToString(int ts) {
    return _dateToString(DateTime.fromMillisecondsSinceEpoch(ts));
  }

  Future<void> onNewCardDiscovered(NfcTag tag) async {
    late Uint8List uid;
    for (var properties in tag.data.values) {
      if (properties is Map) {
        if (properties.containsKey('identifier')) {
          uid = properties['identifier'];
          break;
        }
      }
    } // End of for statement.

    int cardUid = 0;
    cardUid = (uid.elementAt(0) << 24) |
        (uid.elementAt(1) << 16) |
        (uid.elementAt(0) << 8) |
        uid.elementAt(0);

    var completer = Completer();

    context.showBlockDialog(dismissCompleter: completer);
    getCardInfo(cardUid).then((cardInfo) {
      completer.complete();

      setState(() {
        if (cardInfo != null) {
          _cardsRead.add(CampusCardRecord(cardUid, cardInfo.studentId,
              cardInfo.studentName, cardInfo.major));
        } else {
          _cardsRead.add(CampusCardRecord(cardUid));
        }
      });
    });
  }

  @override
  void initState() {
    // Start Session
    NfcManager.instance.startSession(onDiscovered: onNewCardDiscovered);

    super.initState();
  }

  @override
  void dispose() {
    // Stop session
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Widget buildFailedPrompt() {
    return const Center(
      child: Text(
        '设备的 NFC 功能不可用',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            '请将卡片贴合到手机背面 NFC 读卡器处',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40.0),
          Image(
              image: AssetImage('assets/campusCard/illustration.png'),
              height: 300,
              width: 300),
        ],
      ),
    );
  }

  Widget buildCardRecord() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => Row(
        children: [
          Column(
            children: [
              Text(_cardsRead[index].studentName),
              Text(_cardsRead[index].major),
            ],
          ),
          Column(
            children: [
              Text(_cardsRead[index].cardId.toString()),
              Text(_tsToString(_cardsRead[index].ts)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cardsRead.isNotEmpty) {
      return buildCardRecord();
    }

    return FutureBuilder<bool>(
      future: NfcManager.instance.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isAvailable = snapshot.data!;
          if (isAvailable) {
            return buildPrompt();
          }
        }
        return buildFailedPrompt();
      },
    );
  }
}
