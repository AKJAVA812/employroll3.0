import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../ess/EssDashboarrddModel.dart';
import '../../../ess/essDashboardNavigate.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';


class LeaveManageReports extends StatefulWidget {
  const LeaveManageReports({Key? key}) : super(key: key);

  @override
  State<LeaveManageReports> createState() => _LeaveManageReportsState();
}
SessionManager shared = SessionManager();
String? levelOne;
String? levelTwo;
String? pendingLeaveRequisitions;
class _LeaveManageReportsState extends State<LeaveManageReports> {
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  String userPanelPermission = "COMPANY_EMPLOYEE";
  String pendingLeaveRequestMOPermission = "0";
  String pendingLeaveL1RequestMOPermission = "0";
  String pendingLeaveL2RequestMOPermission = "0";
  String pendingLeaveRequestMSSPermission = "0";
  String pendingLeaveL1RequestMSSPermission = "0";
  String pendingLeaveL2RequestMSSPermission = "0";
  String pendingLeaveRequestUISPermission = "0";
  String pendingLeaveL1RequestUISPermission = "0";
  String pendingLeaveL2RequestUISPermission = "0";
  String othersLeaveRequestUISPermission = "0";
  String othersLeaveRequestMOPermission = "0";
  String othersLeaveRequestMSSPermission = "0";

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }
  Future getSharedPrfanceList() async{
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    levelOne = await shared!.getLevelOne();
    levelTwo = await shared!.getLevelTwo();
    pendingLeaveRequisitions = await shared!.getPendingLeaveReq();
    userPanelPermission= await shared.getUserPanel();
    pendingLeaveRequestMOPermission= (await shared.getPendingLeaveReqMSSMOPermission())!;
    pendingLeaveL1RequestMOPermission= (await shared.getPendingLeaveReqL1MSSMOPermission())!;
    print("MO L1 - $pendingLeaveL1RequestMOPermission");
    pendingLeaveL2RequestMOPermission= (await shared.getPendingLeaveReqL2MSSMOPermission())!;
    print("MO L2 - $pendingLeaveL2RequestMOPermission");
    pendingLeaveRequestMSSPermission= (await shared.getPendingLeaveReqMSSPermission())!;
    pendingLeaveL1RequestMSSPermission= (await shared.getPendingLeaveReqL1MSSPermission())!;
    pendingLeaveL2RequestMSSPermission= (await shared.getPendingLeaveReqL2MSSPermission())!;
    pendingLeaveRequestUISPermission= (await shared.getPendingLeaveReqUISPermission())!;
    pendingLeaveL1RequestUISPermission= (await shared.getPendingLeaveReqL1UISPermission())!;
    pendingLeaveL2RequestUISPermission= (await shared.getPendingLeaveReqL2UISPermission())!;
    othersLeaveRequestMSSPermission= (await shared.getOthersLeaveReqMSSPermission())!;
    othersLeaveRequestMOPermission= (await shared.getOthersLeaveReqMSSMOPermission())!;
    othersLeaveRequestUISPermission= (await shared.getOthersLeaveReqUISPermission())!;
    print("User Panel - $userPanelPermission");
    print("Level 1 - $levelOne");
    print("Level 2 - $levelTwo");
    print("Pending Leave Requisitions - $pendingLeaveRequisitions");
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
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can use these values to determine the size of your widget
    double widgetWidth = screenWidth * 0.03; // 80% of the screen width
    double widgetHeight = screenHeight * 0.5; // 50% of the screen height
    double boxText = widgetWidth;
    List<Widget> generateGridViewItems() {
      List<Widget> items = [];


      /*if(showHide) {
        items.add(
          Hero(
            tag: 'leaveBalance',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.leaveBalanceRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        CupertinoIcons.doc_plaintext,
                        size: 50,
                        color: Mythemes.successColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Leave Balance',
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

      /*if(showHide) {
        items.add(
          Hero(
            tag: 'leaveRequisition',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        CupertinoIcons.doc_text,
                        size: 50,
                        color: Mythemes.lightBluishColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Leave Requisition',
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
      // L1 Pending
      if(userPanelPermission == "MSS" && pendingLeaveL1RequestMSSPermission == "1") {
        items.add(
          Hero(
            tag: 'myTeamLeavePendingReqL1',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssLevelOnePendingReqRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "L1",style: TextStyle(fontSize: 50, color: Mythemes.warningColor),
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending L1',
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

      // L2 Pending
      if(userPanelPermission == "MSS" && pendingLeaveL2RequestMSSPermission == "1") {
        items.add(
          Hero(
            tag: 'myTeamLeavePendingReqL1',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssLevelTwoPendingReqRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "L2",style: TextStyle(fontSize: 50, color: Mythemes.warningColor),
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending L2',
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


      //MSS Pending Leaves
      if(userPanelPermission == "MSS" && pendingLeaveRequestMSSPermission == "1") {
        items.add(
          Hero(
            tag: 'pendingLeave',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.mssPendingLeaveRequestRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending_actions_rounded,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending Leaves',
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

      //MSS Others Leave
      if(userPanelPermission == "MSS" && pendingLeaveRequestMSSPermission == "1") {
        items.add(
          Hero(
            tag: 'others',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.mssOtherLeaveReqRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Others Requisition',
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

      //MSS MO Pending Leaves
      //Pending MO l1
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingLeaveL1RequestMOPermission == "1") {
        items.add(
          Hero(
            tag: 'pendingLeaveL1MO',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.mssMoLevelOnePendingReqRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "L1",style: TextStyle(fontSize: 50, color: Mythemes.warningColor),
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending L1',
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

      //Pending MO l2
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingLeaveL2RequestMOPermission == "1") {
        items.add(
          Hero(
            tag: 'pendingLeaveL2MO',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.mssMoLevelTwoPendingReqRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "L2",style: TextStyle(fontSize: 50, color: Mythemes.warningColor),
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending L2',
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


      if(userPanelPermission == "MSS_MO_ADMIN" && pendingLeaveRequestMOPermission == "1") {
        items.add(
          Hero(
            tag: 'pendingLeave',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.mssMoPendingLeaveRequestRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending_actions_rounded,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending Leaves',
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

      //MSS MO Others Leave
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingLeaveRequestMOPermission == "1") {
        items.add(
          Hero(
            tag: 'others',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.mssMoOtherLeaveReqRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Others Requisition',
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

      //UIS Pending Leaves
      if(userPanelPermission == "USER" && pendingLeaveRequestUISPermission == "1") {
        items.add(
          Hero(
            tag: 'pendingLeave',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.uisPendingLeaveRequestRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending_actions_rounded,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Pending Leaves',
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
      //UIS Others Leave
      if(userPanelPermission == "USER" && pendingLeaveRequestUISPermission == "1") {
        items.add(
          Hero(
            tag: 'others',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.uisOtherLeaveReqRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Others Requisition',
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

     /* if(levelOne == "true") {
        items.add(
          Hero(
            tag: 'levelOne',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.levelOnePendingRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.looks_one_outlined,
                        size: 50,
                        color: Mythemes.dangerColorOne,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Level One',
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

      /*if(levelTwo == "true") {
        items.add(
          Hero(
            tag: 'levelTwo',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.levelTwoPendingRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.looks_two_outlined,
                        size: 50,
                        color: Mythemes.successColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Level Two',
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

     /* if(showRo || showAdmin) {
        items.add(
          Hero(
            tag: 'leaves',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.approvedLeaveReqListRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.filter_list,
                        size: 50,
                        color: Mythemes.lightBluishColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Leaves',
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Leave Management".text.make(),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 1,)));
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body:  GridView.count(
        crossAxisCount: 3,
        children: generateGridViewItems(),
      ),
      /*Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Hero(tag: 'leaveReport',
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: showHide,
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.leaveBalanceRoute);
                            }
                          },
                          leading:  Icon(
                            CupertinoIcons.doc_plaintext, size: 30,
                          ),

                          title: "Leave Balance".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: showHide,
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                            }
                          },
                          leading:  Icon(
                            CupertinoIcons.doc_text, size: 30,
                          ),

                          title: "Leave Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: showHide,
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.requestedRequisitionRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.pending_actions_rounded, size: 30,
                          ),

                          title: "Requested Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: pendingLeaveRequisitions == "true",
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.pendingLeaveReqListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.pending_actions_rounded, size: 30,
                          ),

                          title: "Pending Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    //Level One Leave Approval
                    Visibility(
                      visible: levelOne == "true",
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.levelOnePendingRoute);
                            }
                          },
                          leading:  "L1".text.letterSpacing(1.5).size(22).color(Mythemes.greyish).bold.make().px8(),

                          title: "Level One Pending".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    //Level Two Leave Approval
                    Visibility(
                      visible: levelTwo == "true",
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.levelTwoPendingRoute);
                            }
                          },
                          leading:  "L2".text.letterSpacing(1.5).size(22).color(Mythemes.greyish).bold.make().px8(),

                          title: "Level Two Pending".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),


                    Visibility(
                      visible: showRo || showAdmin,
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.approvedLeaveReqListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.account_circle_rounded, size: 30,
                          ),

                          title: "Approved Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: showRo || showAdmin,
                      child: Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: () async {
                            bool internetCheck = await InternetConnectionChecker().hasConnection;
                            if(internetCheck == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.pushNamed(context, MyRoutings.othersEmpReqRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.account_circle_rounded, size: 30,
                          ),

                          title: "Other's Employee Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).h64(context)




          ],

        ),
      ) ,*/

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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            //Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
            print('Leave');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);
            //Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('My Reports');
          }
          if(index==4){
            if(userPanelPermission != "USER") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel())));
            }
            /*Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );*/
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Dashboard');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_label_sharp),
            label: 'Leave Approval',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'My Reports',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),


    );
  }
}
