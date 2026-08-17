import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:velocity_x/velocity_x.dart';


class QRAttTypes extends StatefulWidget {
  const QRAttTypes({super.key});

  @override
  State<QRAttTypes> createState() => _QRAttTypesState();
}

class _QRAttTypesState extends State<QRAttTypes> {
  var titleName = "QR Attendance";
  double boxText = 15;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: titleName.text.make(),
          ),
          body: GridView.count(
            crossAxisCount: 3,
            children: <Widget>[
              Hero(
                tag: 'qrItems',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.qrAttLocationRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.location_pin,
                            size: 50,
                            color: Mythemes.greyish,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 80, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Location',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Mythemes.blackish, fontSize: boxText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'onDuty2Anime',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.qrAttWithoutLocRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.qr_code_rounded,
                            size: 50,
                            color: Mythemes.greyish,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 80, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'QR',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Mythemes.blackish, fontSize: boxText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
