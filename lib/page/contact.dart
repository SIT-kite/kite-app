import 'package:flutter/material.dart';
import 'package:kite/service/contact.dart';
import 'package:azlistview/azlistview.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("常用电话"),
        actions: [
          const Padding(padding: EdgeInsets.all(0)),
        ],
      ),
      body: const Text("sss"),
    );
  }
}
