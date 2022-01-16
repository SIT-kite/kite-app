import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/entity/edu/score.dart';
import 'package:kite/entity/edu/year_semester.dart';
import 'package:kite/pages/score/banner.dart';
import 'package:kite/pages/score/item.dart';
import 'package:kite/services/edu/score.dart';
import 'package:kite/services/session_pool.dart';

List<int> _generateYearList(int entranceYear) {
  final date = DateTime.now();
  final currentMonth = date.month;
  final currentYear = date.year % 100;
  final monthInterval = (currentYear - entranceYear) * 12 + currentMonth - 9;

  List<int> yearItems = [];
  for (int i = 0, year = entranceYear;
      i < (monthInterval / 12 as int) + 1;
      i++, year++) {
    yearItems.add(year);
  }
  return yearItems;
}

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int selectedYear = 2021;
  Semester selectedSemester = Semester.firstTerm; // todo: use proper value.
  late List<Score> _scoreList;

  final Widget _notFoundPicture = SvgPicture.asset(
    'assets/score/not-found.svg',
    width: 260,
    height: 260,
  );

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: _buildSelectorRow(),
    );
  }

  Widget _buildSelectorRow() {
    String buildYearString(int startYear) {
      return '20$startYear - 20${startYear + 1}';
    }

    Widget buildSelector(List<int> alternatives, void Function(int?) callback) {
      final items = alternatives
          .map(
            (e) => DropdownMenuItem<int>(
              value: e,
              child: Text(buildYearString(e)),
            ),
          )
          .toList();

      return DropdownButton<int>(
        isDense: true,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        style: const TextStyle(
          color: Color(0xFF002766),
        ),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: callback,
        items: items,
      );
    }

    Widget buildYearSelector() {
      final List<int> yearList =
          _generateYearList(18); // TODO: Use actual year here.
      return buildSelector(yearList, (int? selected) {
        if (selected != null && selected != selectedYear) {
          setState(() {
            selectedYear = selected;
          });
        }
      });
    }

    Widget buildSemesterSelector() {
      const List semesters = Semester.values;
      return buildSelector(semesters.cast(), (int? selected) {
        if (selected != null && selected != (selectedSemester as int)) {
          setState(() {
            selectedSemester = selected as Semester;
          });
        }
      });
    }

    return Row(children: [
      Container(
        child: buildYearSelector(),
      ),
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: buildSemesterSelector(),
      )
    ]);
  }

  Widget _buildListView() {
    return ListView(children: _scoreList.map((e) => ScoreItem(e)).toList());
  }

  Widget _buildNoResult() {
    return Column(children: [
      Container(
        child: _notFoundPicture,
      ),
      const Text('暂时还没有成绩', style: TextStyle(color: Colors.grey)),
      Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: const Text('如果成绩刚刚出炉，可点击右上角刷新按钮尝试刷新~',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      )
    ]);
  }

  Widget _buildScoreResult() {
    return FutureBuilder<List<Score>>(
      future: ScoreService(SessionPool.eduSession)
          .getScoreList(SchoolYear(selectedYear), selectedSemester),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final scoreList = snapshot.data!;

          if (scoreList.isNotEmpty) {
            return Column(
              children: [
                GpaBanner(selectedSemester, _scoreList),
                _buildListView(),
              ],
            );
          } else {
            return _buildNoResult();
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('成绩查询'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          )
        ],
      ),
      body: Column(children: [
        _buildHeader(),
        _buildScoreResult(),
      ]),
    );
  }
}
