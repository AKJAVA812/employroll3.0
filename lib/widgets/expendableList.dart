/// ListTile
library;

import 'package:flutter/material.dart';

class TileApp extends StatelessWidget {
  const TileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('ExpansionTile App'),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: StuffInTiles(listOfTiles[index])
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
  const StuffInTiles(this.myTile, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty) {
      return ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          //subtitle: new Text("Subtitle"),
          //leading: new Text("Leading"),
          selected: true,
          //trailing: new Text("trailing"),
          title: Text(t.title));
    }

    return ExpansionTile(
      key: PageStorageKey<int>(3),
      title: Text(t.title),
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
          MyTile('OD Requistion'),
          MyTile('OD Approval'),
          MyTile('OD Approved '),
        ],
      ),
      MyTile('Cats'),
      MyTile('Birds'),
    ],
  ),
  MyTile(
    'Cars',
    <MyTile>[
      MyTile('Tesla'),
      MyTile('Toyota'),
    ],
  ),
  MyTile(
    'Phones',
    <MyTile>[
      MyTile('Google'),
      MyTile('Samsung'),
      MyTile(
        'OnePlus',
        <MyTile>[
           MyTile('1'),
           MyTile('2'),
          MyTile('3'),
          MyTile('4'),
          MyTile('5'),
          MyTile('6'),
          MyTile('7'),
          MyTile('8'),
          MyTile('9'),
          MyTile('10'),
          MyTile('11'),
          MyTile('12'),
        ],
      ),
    ],
  ),
];
