import 'package:flutter/material.dart';

class SearchBar extends SearchDelegate<String> {
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
    return const Center(
      child: Text('text'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('suggestions'),
    );
  }
}

class MarketPage extends StatelessWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('二手书广场'),
        actions: [
          IconButton(
              onPressed: () => showSearch(context: context, delegate: SearchBar()), icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.upload))
        ],
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("发布"),
        onPressed: () {},
      ),
    );
  }
}
