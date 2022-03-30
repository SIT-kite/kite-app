import 'package:flutter/cupertino.dart';

import 'feature/page_index.dart';
import 'setting/page/index.dart';

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

  static final routeTable = {
    home: (context) => const HomePage(),
    report: (context) => const DailyReportPage(),
    login: (context) => const LoginPage(),
    welcome: (context) => const WelcomePage(),
    about: (context) => const AboutPage(),
    expense: (context) => const ExpensePage(),
    connectivity: (context) => const ConnectivityPage(),
    campusCard: (context) => const CampusCardPage(),
    electricity: (context) => const ElectricityPage(),
    score: (context) => const ScorePage(),
    office: (context) => const OfficePage(),
    game: (context) => const GamePage(),
    game2048: (context) => Game2048Page(),
    gameWordle: (context) => const WordlePage(),
    gameComposeSit: (context) => const ComposeSitPage(),
    wiki: (context) => WikiPage(),
    library: (context) => const LibraryPage(),
    libraryAppointment: (context) => AppointmentPage(),
    market: (context) => const MarketPage(),
    timetable: (context) => const TimetablePage(),
    timetableImport: (context) => const TimetableImportPage(),
    setting: (context) => SettingPage(),
    feedback: (context) => const FeedbackPage(),
    notice: (context) => const NoticePage(),
    contact: (context) => const ContactPage(),
    bulletin: (context) => const BulletinPage(),
    mail: (context) => const MailPage(),
    night: (context) => const NightPage(),
    event: (context) => const EventPage(),
    lostFound: (context) => const LostFoundPage(),
    classroom: (context) => const ClassroomPage(),
    exam: (context) => const ExamPage(),
    egg: (context) => const EggPage(),
    bbs: (context) => const BbsPage(),
    scanner: (context) => const ScannerPage(),
  };

  static WidgetBuilder? get(String path) {
    return routeTable[path];
  }
}
