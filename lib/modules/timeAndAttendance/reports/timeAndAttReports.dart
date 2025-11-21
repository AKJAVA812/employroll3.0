import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../ess/EssDashboarrddModel.dart';
import '../../../ess/essDashboardNavigate.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../../../themes/empThemes.dart';
import 'attendanceRequisition/getAttendanceDetails.dart';


class TimeAndAttendanceReports extends StatefulWidget {
  const TimeAndAttendanceReports({Key? key}) : super(key: key);

  @override
  State<TimeAndAttendanceReports> createState() => _TimeAndAttendanceReportsState();
}
SessionManager shared = SessionManager();
class _TimeAndAttendanceReportsState extends State<TimeAndAttendanceReports> {
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  String userPanelPermission = "COMPANY_EMPLOYEE";
  String pendingAttRequestMOPermission = "0";
  String pendingAttRequestMSSPermission = "0";
  String pendingAttRequestUISPermission = "0";
  String pendingAttReqL1MSS = "0";
  String pendingAttReqL2MSS = "0";
  String pendingAttReqL1MSSMO = "0";
  String pendingAttReqL2MSSMO = "0";
  String pendingAttReqL1UIS = "0";
  String pendingAttReqL2UIS = "0";
  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }
  Future getSharedPrfanceList() async{
      empRole= await shared.getEmpRoll();
      roRole= await shared.getRoRole();
      userPanelPermission= await shared.getUserPanel();
      pendingAttRequestMOPermission= (await shared.getPendingAttendanceReqMSSMOPermission())!;
      pendingAttRequestMSSPermission= (await shared.getPendingAttendanceReqMSSPermission())!;
      pendingAttRequestUISPermission= (await shared.getPendingAttendanceReqUISPermission())!;
      pendingAttReqL1MSS= (await shared.getPendingAttendanceReqL1MSS())!;
      pendingAttReqL2MSS= (await shared.getPendingAttendanceReqL2MSS())!;
      pendingAttReqL1MSSMO= (await shared.getPendingAttendanceReqL1MO())!;
      pendingAttReqL2MSSMO= (await shared.getPendingAttendanceReqL2MO())!;
      pendingAttReqL1UIS= (await shared.getPendingAttendanceReqL1UIS())!;
      pendingAttReqL2UIS= (await shared.getPendingAttendanceReqL2UIS())!;
      print("Pending Attendance Request MSS MO- $pendingAttRequestMOPermission");
      print("Pending Attendance Request MSS- $pendingAttRequestMSSPermission");
      print("Pending Attendance Request UIS- $pendingAttRequestUISPermission");
      print("Pending Attendance Request MSS L1- $pendingAttReqL1MSS");
      print("User Panel - $userPanelPermission");
      adminRole= await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');


      setState(() {
        if(empRole==1){
          showHide=true;
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
      });

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
      // Attendance Report
      /*if(showHide || showAdmin) {
        items.add(
          Hero(
            tag: 'myAttendance',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.attReportRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.touch_app,
                        size: 50,
                        color: Mythemes.successColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'My Attendance',
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
      //Attendance Requisition
      /*if(showHide || showAdmin) {
        items.add(
          Hero(
            tag: 'myAttendanceReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAttendanceDet()));
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.access_time_filled,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Add Requisition',
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
      //Pending Requisition List Ro
      if(userPanelPermission == "MSS" && pendingAttRequestMSSPermission == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssAttPendingRequestRoRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending,
                        size: 50,
                        color: Mythemes.VoiletColor,
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
                            'Pending Requests',
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

      //L1 MSS
      if(userPanelPermission == "MSS" && pendingAttReqL1MSS == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReqL1',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssAttPendingRequestL1Route);
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
      //L2 MSS
      if(userPanelPermission == "MSS" && pendingAttReqL2MSS == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReqL2',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssAttPendingRequestL2Route);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "L2",style: TextStyle(fontSize: 50, color: Mythemes.successColor),
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

      //L1 MO
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingAttReqL1MSSMO == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReqL1',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssMOPendingAttReqL1);
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

      //L2 MO
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingAttReqL2MSSMO == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReqL2',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssMOPendingAttReqL2);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "L2",style: TextStyle(fontSize: 50, color: Mythemes.successColor),
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


      //Other Employee Requisition
      if(userPanelPermission == "MSS" && pendingAttRequestMSSPermission == "1") {
        items.add(
          Hero(
            tag: 'otherAttendanceReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssOthersAttRequestPageRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                        color: Mythemes.dangerColorOne,
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


      //Pending Requisition List MSS MO
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingAttRequestMOPermission == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssMoAttPendingRequestRoRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending,
                        size: 50,
                        color: Mythemes.VoiletColor,
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
                            'Pending Requests',
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

      //Other Employee Requisition MSS MO
      if(userPanelPermission == "MSS_MO_ADMIN" && pendingAttRequestMOPermission == "1") {
        items.add(
          Hero(
            tag: 'otherAttendanceReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mssMoOthersAttRequestPageRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                        color: Mythemes.dangerColorOne,
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

      //Pending Requisition List UIS
      if(userPanelPermission == "USER" && pendingAttRequestUISPermission == "1") {
        items.add(
          Hero(
            tag: 'myTeamPendingReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.uisAttPendingRequestRoRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending,
                        size: 50,
                        color: Mythemes.VoiletColor,
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
                            'Pending Requests',
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

      //Other Employee Requisition UIS
      if(userPanelPermission == "USER" && pendingAttRequestUISPermission == "1") {
        items.add(
          Hero(
            tag: 'otherAttendanceReq',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.uisOthersAttRequestPageRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                        color: Mythemes.dangerColorOne,
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


      return items;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: true,
        title: "Time and Attendance".text.make(),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 1,)));
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body:   GridView.count(
          crossAxisCount: 3,
          children: generateGridViewItems(),
      ),
      /*Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Hero(tag: 'reportAnimate', child:
        SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                visible: showHide || showAdmin,
                child: Card(
                  elevation: 3,
                  child:
                  ListTile(
                    onTap: (){
                      setState(() {
                        // _isVisible = !_isVisible;
                      });
                      Navigator.pushNamed(context, MyRoutings.attReportRoute);
                    },
                    leading:  Icon(
                      CupertinoIcons.doc_plaintext, size: 30,
                    ),

                    title: "Attendance Report".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible: showHide || showAdmin,
                child: Card(
                  elevation: 3,
                  child:
                  ListTile(
                    onTap: () {
                      // Navigator.pushNamed(context, MyRoutings.getAttendanceDetRoute);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAttendanceDet()));
                    },
                    leading:  Icon(
                      CupertinoIcons.doc_text, size: 30,
                    ),

                    title: "Attendance Requisition".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible: showRo  || showAdmin,
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
                        Navigator.pushNamed(context, MyRoutings.otherEmpReqAttendance);
                      }
                    },
                    leading:  Icon(
                      Icons.account_circle_rounded, size: 30,
                    ),

                    title: "Other Employee's Requisition".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible: showHide || showAdmin,
                child: Card(
                  elevation: 3,
                  child:
                  ListTile(
                    onTap: () async{
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
                        Navigator.pushNamed(context, MyRoutings.pendingReqRoute);
                      }

                    },
                    leading:  Icon(
                      CupertinoIcons.list_bullet_below_rectangle, size: 30,
                    ),

                    title: "Self Requisition List".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible:  showRo  || showAdmin,
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
                        Navigator.pushNamed(context, MyRoutings.pendingReqRoRoute);
                      }
                    },
                    leading:  Icon(
                      CupertinoIcons.list_bullet, size: 30,
                    ),

                    title: "Pending Requisition RO".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible: showHide || showAdmin,
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
                        Navigator.pushNamed(context, MyRoutings.approvedReqRoute);
                      }
                    },
                    leading:  Icon(
                      CupertinoIcons.person_crop_circle_badge_checkmark, size: 30,
                    ),

                    title: "Approved Requisition".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible: showHide || showAdmin,
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
                        Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                      }
                    },
                    leading:  Icon(
                      CupertinoIcons.person_crop_circle_badge_xmark, size: 30,
                    ),

                    title: "Disapproved List".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible: showHide || showAdmin,
                child: Card(
                  elevation: 3,
                  child:
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
                    },
                    leading:  Icon(
                      CupertinoIcons.text_badge_checkmark, size: 30,
                    ),

                    title: "Self Workrdone Report".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
              Visibility(
                visible:  showRo  || showAdmin,
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
                        Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                      }
                    },
                    leading:  Icon(
                      CupertinoIcons.doc_text_search, size: 30,
                    ),

                    title: "RO Workdone Report".text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
            ).h64(context),
          ],

        ),
      ),*/

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
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if(index==3){
              Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);
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
            print('Profile');
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
            icon: Icon(Icons.approval_sharp),
            label: 'Att. Approval',
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
 /* reportWidget() {
    bool showHide=false;
    if(empRole==1 || roRole ==1){
      showHide=true;
      print('object$showHide');
      setState(() {
      });
    }
    return Column(
      children: [
        Visibility(
          maintainState: true,
          maintainAnimation: true,
          //
          visible: showHide,
          child: Card(
            elevation: 3,
            child:
            ListTile(
              onTap: (){
                setState(() {
                  // _isVisible = !_isVisible;
                });
                Navigator.pushNamed(context, MyRoutings.attReportRoute);
              },
              leading:  Icon(
                CupertinoIcons.doc_plaintext, size: 30,
              ),

              title: "Attendance Report".text.make(),
              trailing:  Icon(
                  CupertinoIcons.chevron_forward
              ),

            ),
          ),
        ),
        Card(
          elevation: 3,
          child:
          ListTile(
            onTap: () {
              // Navigator.pushNamed(context, MyRoutings.getAttendanceDetRoute);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAttendanceDet()));
            },
            leading:  Icon(
              CupertinoIcons.doc_text, size: 30,
            ),

            title: "Attendance Requisition".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
        Card(
          elevation: 3,
          child:
          ListTile(
            onTap: () async{
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
                Navigator.pushNamed(context, MyRoutings.pendingReqRoute);
              }

            },
            leading:  Icon(
              CupertinoIcons.list_bullet_below_rectangle, size: 30,
            ),

            title: "Self Requisition List".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
        Card(
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
                Navigator.pushNamed(context, MyRoutings.pendingReqRoRoute);
              }
            },
            leading:  Icon(
              CupertinoIcons.list_bullet, size: 30,
            ),

            title: "Pending Requisition RO".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
        Card(
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
                Navigator.pushNamed(context, MyRoutings.approvedReqRoute);
              }
            },
            leading:  Icon(
              CupertinoIcons.person_crop_circle_badge_checkmark, size: 30,
            ),

            title: "Approved Requisition".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
        Card(
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
                Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
              }
            },
            leading:  Icon(
              CupertinoIcons.person_crop_circle_badge_xmark, size: 30,
            ),

            title: "Disapproved List".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
        Card(
          elevation: 3,
          child:
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
            },
            leading:  Icon(
              CupertinoIcons.text_badge_checkmark, size: 30,
            ),

            title: "Workrdone Report".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),

      ],
    );
  }*/
}

/*class reportWidget extends StatefulWidget {
  const reportWidget({Key? key}) : super(key: key);

  @override
  State<reportWidget> createState() => _reportWidgetState();
}

class _reportWidgetState extends State<reportWidget> {
  late bool  _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return
  }
}*/
