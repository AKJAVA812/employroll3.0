/// ListTile

import 'package:flutter/material.dart';

class TileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: Text('ExpansionTile App'),
          ),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: new StuffInTiles(listOfTiles[index])
            );
          },
          itemCount: listOfTiles.length,
        ),
      ),
    );
  }
}

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;
  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => print("tap"),
          //subtitle: new Text("Subtitle"),
          //leading: new Text("Leading"),
          selected: true,
          //trailing: new Text("trailing"),
          title: new Text(t.title));

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList(),
    );
  }
}

class MyTile {
  String title;
  List<MyTile> children;
  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listOfTiles = <MyTile>[
  MyTile(
    'Time & Attendance ',
    <MyTile>[
      MyTile(
        'OD',
        <MyTile>[
          new MyTile('OD Requistion'),
          new MyTile('OD Approval'),
          new MyTile('OD Approved '),
        ],
      ),
      new MyTile('Cats'),
      new MyTile('Birds'),
    ],
  ),
  new MyTile(
    'Cars',
    <MyTile>[
      new MyTile('Tesla'),
      new MyTile('Toyota'),
    ],
  ),
  new MyTile(
    'Phones',
    <MyTile>[
      new MyTile('Google'),
      new MyTile('Samsung'),
      new MyTile(
        'OnePlus',
        <MyTile>[
          new MyTile('1'),
          new MyTile('2'),
          new MyTile('3'),
          new MyTile('4'),
          new MyTile('5'),
          new MyTile('6'),
          new MyTile('7'),
          new MyTile('8'),
          new MyTile('9'),
          new MyTile('10'),
          new MyTile('11'),
          new MyTile('12'),
        ],
      ),
    ],
  ),
];
