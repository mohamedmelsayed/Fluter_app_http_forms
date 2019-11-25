import 'package:hello_world/fragments/fifth_fragment.dart';
import 'package:hello_world/fragments/first_fragment.dart';
import 'package:hello_world/fragments/forth_fragment.dart';
import 'package:hello_world/fragments/second_fragment.dart';
import 'package:hello_world/fragments/third_fragment.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("المستخدمين", Icons.rss_feed),
    new DrawerItem("إستلام الطلبات", Icons.local_pizza),
    new DrawerItem("إستعراض الفرق  ", Icons.info),
     new DrawerItem("طلبات قيد التفيذ", Icons.rss_feed),
    new DrawerItem("جميع الطلبات ", Icons.local_pizza),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new FifthFragment();
      case 2:
        return new ThirdFragment();
      case 3:
        return new ForthFragment();
      case 4:
        return new SecondFragment();
   
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            _createHeader(),
            // new UserAccountsDrawerHeader(
            //     accountName: new Text("John Doe"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight, image: AssetImage('assets/icon.jpeg'))),
     /*   child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("International Team Clean",
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500))),
        ]));*/);
  }
}
