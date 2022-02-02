import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kite/entity/contact.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/contact.dart';
import 'package:kite/util/url_launcher.dart';

List<Color?> color = [
  Colors.red[50],
  Colors.green[50],
  Colors.blue[50],
  Colors.amber[50],
  Colors.purple[50],
];
List<ContactData> _contactData = StoragePool.contactData.getAllBydepartmentDesc();

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _stateIndex = StoragePool.contactData.getAllBydepartmentDesc().isEmpty ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('常用电话'),
        actions: [
          IconButton(onPressed: () => showSearch(context: context, delegate: Search()), icon: const Icon(Icons.search)),
          _onBillsRefresh(),
        ],
      ),
      body: _stateIndex == 1
          ? FutureBuilder<List<ContactData>>(
              future: ContactRemoteService(SessionPool.ssoSession).getContactData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  _contactData = snapshot.data!;
                  return _contactListview(context, _contactData);
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : _contactListview(context, _contactData),
    );
  }

  _onBillsRefresh() {
    return IconButton(
      tooltip: '刷新',
      icon: const Icon(Icons.refresh),
      onPressed: () {
        setState(() => _stateIndex = 1);
      },
    );
  }
}

class Search extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _contactListview(context, _contactData.where((e) => _search(query, e)).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? const Center(
            child: Text('搜索', style: TextStyle(fontSize: 22)),
          )
        : _contactListview(context, _contactData.where((e) => _search(query, e)).toList());
  }

  bool _search(String query, ContactData contactData) {
    return contactData.department.contains(query) ||
        (contactData.name == null ? false : contactData.name!.contains(query)) ||
        contactData.description!.contains(query) ||
        contactData.phone.contains(query);
  }
}

Widget _contactListview(BuildContext context, List<ContactData> contactData) {
  return GroupedListView<ContactData, int>(
    elements: contactData,
    groupBy: (element) => element.department.hashCode,
    useStickyGroupSeparators: true,
    order: GroupedListOrder.DESC,
    // 生成电话列表
    itemBuilder: (context, detail) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Container(
              child: detail.name == '' || detail.name == null
                  ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
                  : Text(
                      detail.name![0],
                      style: TextStyle(color: Colors.grey[50], fontSize: 20, fontWeight: FontWeight.w500),
                    )),
          radius: 20,
        ),
        title: Text('${detail.description}'),
        subtitle: Text((detail.name == null || detail.name == '') ? detail.phone : '${detail.name} ' + detail.phone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.content_copy),
              color: Theme.of(context).primaryColor,
              onPressed: () => Clipboard.setData(ClipboardData(text: detail.phone)),
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                final phone = detail.phone;
                launchInBrowser('tel:${phone.startsWith('1') ? phone : '021' + phone}');
              },
            )
          ],
        ),
      );
    },
    groupHeaderBuilder: (ContactData firstGroupData) {
      return ListTile(
        title: Text(firstGroupData.department, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
      );
    },
  );
}
