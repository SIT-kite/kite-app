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

import 'package:flutter/cupertino.dart';
import 'package:kite/feature/board/page/index.dart';
import 'package:kite/feature/freshman/page/login.dart';
import 'package:kite/feature/web_page/browser.dart';

import 'feature/freshman/page/analysis.dart';
import 'feature/freshman/page/classmate.dart';
import 'feature/freshman/page/familiar.dart';
import 'feature/freshman/page/index.dart';
import 'feature/freshman/page/roommate.dart';
import 'feature/freshman/page/update.dart';
import 'feature/page_index.dart';
import 'setting/page/index.dart';

typedef NamedRouteBuilder = Widget Function(BuildContext context, Map<String, dynamic> args);

class RouteTable {
  static const home = '/home';
  static const report = '/report';
  static const login = '/login';
  static const welcome = '/welcome';
  static const about = '/about';
  static const expense = '/expense';
  static const connectivity = '/connectivity';
  static const campusCard = '/campusCard';
  static const electricity = '/electricity';
  static const score = '/score';
  static const office = '/office';
  static const game = '/game';
  static const game2048 = '$game/2048';
  static const gameWordle = '$game/wordle';
  static const gameComposeSit = '$game/composeSit';
  static const wiki = '/wiki';
  static const library = '/library';
  static const libraryAppointment = '$library/appointment';
  static const market = '/market';
  static const timetable = '/timetable';
  static const timetableImport = '$timetable/import';
  static const setting = '/setting';
  static const feedback = '/feedback';
  static const notice = '/notice';
  static const contact = '/contact';
  static const bulletin = '/bulletin';
  static const mail = '/mail';
  static const night = '/night';
  static const event = '/event';
  static const lostFound = '/lostFound';
  static const classroom = '/classroom';
  static const exam = '/exam';
  static const egg = '/egg';
  static const bbs = '/bbs';
  static const scanner = '/scanner';
  static const browser = '/browser';
  static const freshman = '/freshman';
  static const freshmanFamiliar = '$freshman/familiar';
  static const freshmanInfo = '$freshman/info';
  static const freshmanClass = '$freshman/class';
  static const freshmanAnalysis = '$freshman/analysis';
  static const freshmanRoommate = '$freshman/roommate';
  static const freshmanLogin = '$freshman/login';
  static const freshmanContact = '$freshman/contact';
  static const board = '/board';

  static final Map<String, NamedRouteBuilder> routeTable = {
    home: (context, args) => const HomePage(),
    report: (context, args) => const DailyReportPage(),
    login: (context, args) => const LoginPage(),
    welcome: (context, args) => const WelcomePage(),
    about: (context, args) => const AboutPage(),
    expense: (context, args) => const ExpensePage(),
    connectivity: (context, args) => const ConnectivityPage(),
    campusCard: (context, args) => const CampusCardPage(),
    electricity: (context, args) => const ElectricityPage(),
    score: (context, args) => const ScorePage(),
    office: (context, args) => const OfficePage(),
    game: (context, args) => const GamePage(),
    game2048: (context, args) => Game2048Page(),
    gameWordle: (context, args) => const WordlePage(),
    gameComposeSit: (context, args) => const ComposeSitPage(),
    wiki: (context, args) => WikiPage(),
    library: (context, args) => const LibraryPage(),
    libraryAppointment: (context, args) => const AppointmentPage(),
    market: (context, args) => const MarketPage(),
    timetable: (context, args) => const TimetablePage(),
    timetableImport: (context, args) => const TimetableImportPage(),
    setting: (context, args) => SettingPage(),
    feedback: (context, args) => const FeedbackPage(),
    notice: (context, args) => const NoticePage(),
    contact: (context, args) => const ContactPage(),
    bulletin: (context, args) => const BulletinPage(),
    mail: (context, args) => const MailPage(),
    night: (context, args) => const NightPage(),
    event: (context, args) => const EventPage(),
    lostFound: (context, args) => const LostFoundPage(),
    classroom: (context, args) => const ClassroomPage(),
    exam: (context, args) => const ExamPage(),
    egg: (context, args) => const EggPage(),
    bbs: (context, args) => const BbsPage(),
    scanner: (context, args) => const ScannerPage(),
    browser: (context, args) => BrowserPage(args['initialUrl']),
    freshman: (context, args) => const FreshmanPage(),
    freshmanFamiliar: (context, args) => const FamiliarPeopleWidget(),
    freshmanClass: (context, args) => const ClassmateWidget(),
    freshmanAnalysis: (context, args) => const FreshmanAnalysisPage(),
    freshmanRoommate: (context, args) => const RoommateWidget(),
    freshmanLogin: (context, args) => const FreshmanLoginPage(),
    freshmanContact: (context, args) => const FreshmanUpdatePage(),
    board: (context, args) => BoardPage(),
  };

  static NamedRouteBuilder? get(String path) {
    return routeTable[path];
  }
}
