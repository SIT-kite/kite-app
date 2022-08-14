import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoItem {
  IconData iconData = Icons.person;
  String title = '';
  String subtitle = '';
  VoidCallback? onTap;
  IconData? trailIconData;
  InfoItem(this.iconData, this.subtitle, this.title, {this.onTap, this.trailIconData});
}

class BasicInfoPageWidget extends StatefulWidget {
  final String name;
  final String college;
  final List<InfoItem> infoItems;
  final Widget? avatar;
  const BasicInfoPageWidget({
    required this.name,
    required this.college,
    required this.infoItems,
    this.avatar,
    Key? key,
  }) : super(key: key);

  @override
  State<BasicInfoPageWidget> createState() => _BasicInfoPageWidgetState();
}

class _BasicInfoPageWidgetState extends State<BasicInfoPageWidget> {
  final double bgHeight = 250;

  @override
  Widget build(BuildContext context) {
    return _buildBackground(widget.name, widget.college, widget.infoItems);
  }

  /// 构造默认头像
  Widget buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 3, 99, 172), Color.fromARGB(255, 150, 97, 217)],
            end: Alignment.topCenter,
            begin: Alignment.bottomCenter,
          ),
          boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4.0)]),
      child: Container(
          alignment: const Alignment(0, -0.5),
          child: (widget.name).isEmpty
              ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
              : Text(widget.name[0],
                  style: const TextStyle(
                      fontFamily: 'calligraphy',
                      fontSize: 45,
                      color: Colors.white,
                      shadows: [BoxShadow(color: Colors.black54, offset: Offset(2.0, 4.0), blurRadius: 10.0)],
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none))),
    );
  }

  /// 构造背景
  Widget _buildBackground(String name, String college, List<InfoItem> list) {
    return Stack(
        alignment: AlignmentDirectional.center,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
        children: [
          //上背景
          Column(
            children: [
              Container(
                height: bgHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark]),
                ),
              ),
            ],
          ),

          //下背景
          Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white,
              )),

          //列表
          Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight,
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                body: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(list[index]);
                  },
                ),
              )),

          //头像，以后可以加载用户头像，如果有的话
          Positioned(
            top: bgHeight,
            height: MediaQuery.of(context).size.height - bgHeight,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: const Alignment(0.9, -1.2),
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: widget.avatar ?? buildDefaultAvatar(),
              ),
            ),
          ),

          //背景文字
          Positioned(
            top: bgHeight - 100,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.white, fontSize: 30, decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '$college新生',
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: CupertinoColors.white, fontSize: 16, decoration: TextDecoration.none),
                )
              ],
            ),
          ),

          ///返回按钮
          Positioned(
              left: 24,
              top: 54,
              child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.keyboard_double_arrow_left_sharp,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                  ))),
        ]);
  }

  /// 构造列表项
  Widget _buildItem(InfoItem infoItem) {
    return ListTile(
      textColor: Colors.black,
      leading: SizedBox(
          width: 45,
          height: 45,
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorDark,
              child: Icon(
                infoItem.iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
          )),
      subtitle: Text(infoItem.subtitle),
      title: Text(infoItem.title),
      onTap: () {
        if (infoItem.onTap != null) infoItem.onTap!();
      },
      trailing: Icon(infoItem.trailIconData),
    );
  }
}
