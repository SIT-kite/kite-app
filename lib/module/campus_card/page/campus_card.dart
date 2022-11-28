/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'dart:async';
import 'dart:typed_data';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../using.dart';
import '../init.dart';

class CampusCardRecord {
  final int cardId;

  bool isCardRecognized = false;
  final String studentName;
  final String studentId;
  final String major;

  final int ts = DateTime.now().millisecondsSinceEpoch;

  CampusCardRecord(this.cardId, this.studentName, this.studentId, this.major);

  static CampusCardRecord valid(int cardId, String studentName, String studentId, String major) {
    return CampusCardRecord(cardId, studentName, studentId, major);
  }

  static CampusCardRecord invalid(int cardId) {
    return CampusCardRecord(cardId, i18n.campusCardUnknownCard, '', i18n.unknown);
  }
}

class CampusCardPage extends StatefulWidget {
  const CampusCardPage({Key? key}) : super(key: key);

  @override
  State<CampusCardPage> createState() => _CampusCardPageState();
}

class _CampusCardPageState extends State<CampusCardPage> {
  bool isNfcAvailable = false;
  final List<CampusCardRecord> _cardsRead = [];

  static String _dateToString(DateTime date) {
    final local = date.toLocal();
    return dateFullNum(local);
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
    cardUid = (uid.elementAt(3) << 24) | (uid.elementAt(2) << 16) | (uid.elementAt(1) << 8) | uid.elementAt(0);

    final completer = Completer();
    context.showBlockDialog(dismissCompleter: completer);

    CampusCardInit.campusCardService.getCardInfo(cardUid).then((cardInfo) {
      completer.complete();

      setState(() {
        if (cardInfo != null) {
          _cardsRead.add(CampusCardRecord.valid(cardUid, cardInfo.studentName, cardInfo.studentId, cardInfo.major));
        } else {
          _cardsRead.add(CampusCardRecord.invalid(cardUid));
        }
      });
    }).catchError((_) {
      completer.complete();
      showBasicFlash(context, i18n.networkError.txt);
    });
  }

  @override
  void initState() {
    super.initState();

    // Start Session
    NfcManager.instance.isAvailable().then((value) {
      setState(() {
        isNfcAvailable = value;
      });
      if (isNfcAvailable) {
        NfcManager.instance.startSession(onDiscovered: onNewCardDiscovered);
      }
    });
  }

  @override
  void dispose() {
    // Stop session
    if (isNfcAvailable) {
      NfcManager.instance.stopSession();
    }
    super.dispose();
  }

  Widget buildFailedPrompt() {
    return Center(
      // TODO: better NFC tip
      child: Text(
        i18n.campusCardNfcUnavailableOrDisabled,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget buildPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            i18n.campusCardNfcPrompt,
            style: Theme.of(context).textTheme.headline3!,
          ),
          const SizedBox(height: 40.0),
          const Image(image: AssetImage('assets/campus_card/illustration.png'), height: 300, width: 300),
        ],
      ),
    );
  }

  Widget buildCardItem(CampusCardRecord cardRecord) {
    return ListTile(
      leading: const Icon(Icons.credit_card_sharp),
      title: Text('${cardRecord.studentName} ${cardRecord.studentId}'),
      subtitle: Text(cardRecord.major),
      trailing: Text(
        _tsToString(cardRecord.ts),
      ),
    );
  }

  Widget buildCardRecord() {
    return Column(children: [
      SizedBox(
          height: 30,
          child: Text(
            i18n.campusCardTip,
            style: Theme.of(context).textTheme.bodyText1,
          )),
      ListView(
        shrinkWrap: true,
        children: _cardsRead.map(
          (cardRecord) {
            return buildCardItem(cardRecord);
          },
        ).toList(),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.campusCardTool.txt),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: isNfcAvailable ? (_cardsRead.isNotEmpty ? buildCardRecord() : buildPrompt()) : buildFailedPrompt(),
        ),
      ),
    );
  }
}
