import 'package:flutter/cupertino.dart';
import 'package:kite/feature/web_page/browser.dart';

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

  static final Map<String, NamedRouteBuilder> routeTable = {
    home: (context, args) => HomePage(),
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
    libraryAppointment: (context, args) => AppointmentPage(),
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
    bbs: (context, args) => BbsPage(),
    scanner: (context, args) => const ScannerPage(),
    browser: (context, args) => BrowserPage(args['initialUrl']),
  };

  static NamedRouteBuilder? get(String path) {
    return routeTable[path];
  }
}
