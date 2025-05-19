import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:velocity_x/velocity_x.dart';


class AlarmSetRing extends StatefulWidget {
  const AlarmSetRing({Key? key}) : super(key: key);

  @override
  State<AlarmSetRing> createState() => _AlarmSetRingState();
}

class _AlarmSetRingState extends State<AlarmSetRing> {
  var titleName = 'Alarm Ring';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),




    );
  }
}
