import 'package:er_flutter_project/modules/onDuty/reports/selfRequisition/selfOdRequisitionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../../../themes/empThemes.dart';

class OnDutyReports extends StatefulWidget {
  const OnDutyReports({super.key});

  @override
  State<OnDutyReports> createState() => _OnDutyReportsState();
}

SessionManager shared = SessionManager();
class _OnDutyReportsState extends State<OnDutyReports> {
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;

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

    if(empRole==1){
      showHide=true;
      showRo = false;
      setState(() {
      });
    }
    if(empRole==0){
      showHide=false;
      setState(() {
      });
    }
    if (adminRole == 0) {
      showAdmin = false;
    }
    if (adminRole == 1) {
      showAdmin = true;
    }
    if (roRole == 0) {
      showRo = false;

    }
    if (roRole == 1) {
      showRo = true;
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

      if(showHide) {
        items.add(
          Hero(
            tag: 'myRequest',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async{
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelfODRequisitionList(
                          startDate: "",
                          endDate: "",
                        )));
                  /*  Navigator.pushNamed(
                        context, MyRoutings.odSelfReqDateSelectRoute);*/
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.work_history,
                        size: 50,
                        color: Mythemes.successColor,
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
                            'My Request',
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

      if(showRo || showAdmin) {
        items.add(
          Hero(
            tag: 'leaveBalance',
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
                        context, MyRoutings.pendingRequisitionListRoute);
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


      return items;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "OD Requisition".text.make(),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: generateGridViewItems(),
      ),
      /*Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Hero(
              tag: 'odReport',
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: showHide,
                      child: Card(
                        elevation: 3,
                        child: ListTile(
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
                          leading: Icon(
                            CupertinoIcons.doc_plaintext,
                            size: 30,
                          ),
                          title: "OD Requisition".text.make(),
                          trailing: Icon(CupertinoIcons.chevron_forward),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showRo || showAdmin,
                      child: Card(
                        elevation: 3,
                        child: ListTile(
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
                                  context, MyRoutings.pendingRequisitionListRoute);
                            }
                          },
                          leading: Icon(
                            Icons.more_time,
                            size: 30,
                          ),
                          title: "Pending Requisition".text.make(),
                          trailing: Icon(CupertinoIcons.chevron_forward),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showHide,
                      child: Card(
                        elevation: 3,
                        child: ListTile(
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
                                  context, MyRoutings.odSelfReqDateSelectRoute);
                            }
                          },
                          leading: Icon(
                            Icons.more_time,
                            size: 30,
                          ),
                          title: "Self Requisition List".text.make(),
                          trailing: Icon(CupertinoIcons.chevron_forward),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).h64(context)
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
                MaterialPageRoute(builder: (context) => HomePage()));
            //Navigator.of(context, rootNavigator: true).pop();
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.onDutyTypes);
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if(index==4){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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
    );
  }
}
