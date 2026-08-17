import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';


class PreOnboardingItems extends StatefulWidget {
  const PreOnboardingItems({super.key});

  @override
  State<PreOnboardingItems> createState() => _PreOnboardingItemsState();
}
SessionManager shared = SessionManager();
String? levelOne;
String? levelTwo;
dynamic orgId;
String? setPreOnboardShow;
String? emailId;
String? pendingLeaveRequisitions;
class _PreOnboardingItemsState extends State<PreOnboardingItems> {
  int? empRole;
  int? empId;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  String userPanelPermission = "COMPANY_EMPLOYEE";

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
    empId= await shared.getEmpId();
    orgId= await shared.getOrgId();
    setPreOnboardShow= await shared.getPreOnboardShow();
    userPanelPermission= await shared.getUserPanel();
    emailId= await shared.getEmailId();
    levelOne = await shared.getLevelOne();
    levelTwo = await shared.getLevelTwo();
    pendingLeaveRequisitions = await shared.getPendingLeaveReq();



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
      if(setPreOnboardShow == "true" || empId == 75324 || emailId == "sid@voyageofwellness.co.in"  || orgId == 145 || orgId == 3
      || userPanelPermission == "COMPANY_EMPLOYEE" || userPanelPermission == "MSS" || userPanelPermission == "MSS_MO_ADMIN") {
        items.add(
          Hero(
            tag: 'preOnboardList',
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
                    Navigator.pushNamed(context, MyRoutings.preOnboardListRoute);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.pending_actions_rounded,
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
                            'Pre-Onboard List',
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
      //Permission activated on Shivank, SID, Privado, Thumbmatic - MSS
      if (empId == 75324 ||
          emailId == "sid@voyageofwellness.co.in" ||
          orgId == 145 ||
          orgId == 3 || userPanelPermission == "MSS") {
        items.add(
          Hero(
            tag: 'pendingPreOnboardList',
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
                    Navigator.pushNamed(context, MyRoutings.pendingPreOnboardListRoute);

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
                            'Approval',
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

      //Permission activated on Shivank, SID, Privado, Thumbmatic MSS MO
      if (userPanelPermission == "MSS_MO_ADMIN") {
        items.add(
          Hero(
            tag: 'pendingPreOnboardList',
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
                    Navigator.pushNamed(context, MyRoutings.pendingPreOnboardListRoute);

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
                            'Approval',
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
        title: "Pre-Onboarding".text.make(),
      ),
      body:  GridView.count(
        crossAxisCount: 3,
        children: generateGridViewItems(),
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
                MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0,)));
            //Navigator.of(context, rootNavigator: true).pop();
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.preOnboardItemRoute);
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
            icon: Icon(Icons.add_task_rounded),
            label: 'Pre-Onboard',
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
