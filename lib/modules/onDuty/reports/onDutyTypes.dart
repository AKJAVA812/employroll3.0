import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:er_flutter_project/commanScreen/homePage.dart';
import 'package:er_flutter_project/modules/onDuty/reports/selfRequisition/selfOdRequisitionList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';

class OnDutyTypes extends StatefulWidget {
  const OnDutyTypes({Key? key}) : super(key: key);

  @override
  State<OnDutyTypes> createState() => _OnDutyTypesState();
}
SessionManager shared = SessionManager();
class _OnDutyTypesState extends State<OnDutyTypes> {
  var titleName = "Out Duties";
  int pageIndex = 0;
  int currentIndex = 2;
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  String userPanelPermission = "COMPANY_EMPLOYEE";
  String odPendingPermissionMO = "0";
  String odPendingPermissionMSS = "0";
  String odPendingPermissionUIS = "0";

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }
  Future getSharedPrfanceList() async {
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    userPanelPermission= await shared.getUserPanel();
    odPendingPermissionMO= (await shared.getODPendingListMO())!;
    odPendingPermissionMSS= (await shared.getODPendingList())!;
    odPendingPermissionUIS= (await shared.getODPendingListUIS())!;
    print("User Panel - $userPanelPermission");
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');

    if(empRole==1){
      showHide=true;
      showRo = false;
      print('Show Emp $showHide');
      setState(() {
      });
    }
    if(empRole==0){
      showHide=false;
      print('Show Emp $showHide');
      setState(() {
      });
    }
    if (adminRole == 0) {
      showAdmin = false;
      print("Show Admin $showAdmin");
    }
    if (adminRole == 1) {
      showAdmin = true;
      print("Show Admin $showAdmin");
    }
    if (roRole == 0) {
      showRo = false;

      print("Show Ro $showRo");
    }
    if (roRole == 1) {
      showRo = true;
      print("Show Ro $showRo");
    }
  }

  @override
  Widget build(BuildContext context) {

    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can use these values to determine the size of your widget
    double widgetWidth = screenWidth * 0.03; // 80% of the screen width
    double widgetHeight = screenHeight * 0.5;
    double boxText = widgetWidth; // 50% of the screen height
    // Get the screen width and height using MediaQuery
    List<Widget> generateGridViewItems() {

      List<Widget> items = [];


      //MSS OD Pending
      if(userPanelPermission == "MSS" && odPendingPermissionMSS == "1") {
        items.add(
          Hero(
            tag: 'pendingOdReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck =
                  await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection"
                            .text
                            .make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please check your Internet connection."),
                      ));
                    });
                  } else {
                    Navigator.pushNamed(
                        context, MyRoutings.mssPendingOdRequisitionRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        CupertinoIcons.doc_plaintext,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending Requisition',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      //MSS MO OD Pending
      if(userPanelPermission == "MSS_MO_ADMIN" && odPendingPermissionMO == "1") {
        items.add(
          Hero(
            tag: 'pendingOdReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck =
                  await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection"
                            .text
                            .make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please check your Internet connection."),
                      ));
                    });
                  } else {
                    Navigator.pushNamed(
                        context, MyRoutings.mssMoPendingOdRequisitionRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        CupertinoIcons.doc_plaintext,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending Requisition',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      //UIS OD Pending
      if(userPanelPermission == "USER" && odPendingPermissionUIS == "1") {
        items.add(
          Hero(
            tag: 'pendingOdReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck =
                  await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection"
                            .text
                            .make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please check your Internet connection."),
                      ));
                    });
                  } else {
                    Navigator.pushNamed(
                        context, MyRoutings.uisPendingOdRequisitionRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        CupertinoIcons.doc_plaintext,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending Requisition',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      /* if(showHide){
        items.add(
          Hero(
            tag: 'odRequest',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck =
                      await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection"
                            .text
                            .make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please check your Internet connection."),
                      ));
                    });
                  } else {
                    Navigator.pushNamed(
                        context, MyRoutings.odRequisitionSelectRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.touch_app,
                        size: 50,
                        color: Mythemes.lightBluishColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'OD Requisition',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }*/


      return items;
    }
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: titleName.text.make(),
            leading: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          body: GridView.count(
            crossAxisCount: 3,
            children: generateGridViewItems(),
           /* <Widget>[
              Hero(
                tag: 'onDutyAnime',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.location_on,
                            size: 50,
                            color: Mythemes.successColor,
                          ),
                          *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'OD Punch',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold),
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
                      Navigator.pushNamed(context, MyRoutings.onDutyReportRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.transfer_within_a_station,
                            size: 50,
                            color: Mythemes.lightBluishColor,
                          ),
                          *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Requisitions',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],*/
          ),
        bottomNavigationBar:
        BottomNavigationBar (
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {

            if(index==0){

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
              //Navigator.of(context, rootNavigator: true).pop();
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Workflow');
            }
            if(index==2){
              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
              print('OD');
            }
            if(index==3){
              Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
             /* Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );*/
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
              );
              //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
              print('Profile');
            }
            /*if(index==3){
                title="Notifications";
              }*/
            setState(() => currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.outbond_outlined),
              label: 'OD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: 'Dashboard',
              //backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              //backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
