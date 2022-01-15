import 'package:flutter/material.dart';

import './components/fake_search_field.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.blue),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                child: FakeSearchField(
                  onTap: () {
                    // showSearch(context: context, delegate: SearchBarDelegate());
                  },
                  suggestion: "Search",
                ),
                height: 40,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              icon: const Icon(
                Icons.person_pin,
                color: Colors.blue,
                size: 40,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(),
      ),
    );
    // backgroundColor: BaseColor.colorFFF5F5F5,
  }
}
