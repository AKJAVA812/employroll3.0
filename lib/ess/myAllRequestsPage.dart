import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import '../adminPage/modelClass/dashboardModel.dart';
import '../adminPage/mssDashboard.dart';
import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../main.dart';
import '../modules/onDuty/reports/selfRequisition/selfOdRequisitionList.dart';
import '../profiles/profilePageWithHead.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../singUP/model/loginModel.dart';
import '../widgets/drawer_file.dart';
import 'dart:io';
import 'package:path/path.dart';

class MyAllRequestPage extends StatefulWidget {
  const MyAllRequestPage({Key? key}) : super(key: key);

  @override
  State<MyAllRequestPage> createState() => _MyAllRequestPageState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? userType;
String? emailId;
String? userPanel;
String? profileName;
dynamic profileId;
dynamic empIdNew;
bool? setShowPayroll;
String? setPreOnboardShow;
String? setExitShow;
int? orgId;
String? orgName;
int? empRoles;
int? roRoles;
int? adminRoles;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;

class _MyAllRequestPageState extends State<MyAllRequestPage> {
  int currentIndex = 1;
  final ImagePicker _picker = ImagePicker();
  File? image;


  /*Future monthAttendancePost(String sessionId) async{
   // http://35.154.190.199/restful/service/employee/profile?sessionId=2438b3da66423f389e578692c69d333dc86b648e5df
    var urlapi=Uri.parse("http://www.employroll.com/restful/service/employee/profile");
     final response= await http.post(urlapi,body: {
      "sessionId": sessionId,
    });
    print('Response status: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode==200){
      setState(() {
        //stringResponse= response.body;
        mapResponse=json.decode(response.body);
        print(stringResponse);
      });
    }
  }*/

  Future getSharedPrfanceList() async {

    sessionId = await shared!.getSessionId();
    userType = await shared!.getUserType();
    setState(() {

    });
    print("User Type - $userType");
    setShowPayroll = await shared!.getShowPayroll();
    orgId = await shared!.getOrgId();
    emailId = await shared!.getEmailId();
    empIdNew = await shared!.getEmpId();
    orgName = await shared!.getOrgName();
    empRoles= await shared.getEmpRoll();
    roRoles= await shared.getRoRole();
    adminRoles= await shared.getAdminRole();
    setPreOnboardShow= await shared.getPreOnboardShow();
    setExitShow= await shared.getExitShow();
    userPanel= await shared.getUserPanel();
    profileName= await shared.getDefaultProfileName();
    profileId= await shared.getDefaultProfileId();
    print("Default Profile Name - $profileName");
    print("Default Profile Id - $profileId");
    print("User Panel - $userPanel");
    print('Pre-Onboard $setPreOnboardShow');
    print('Exit Show $setExitShow');
    print('empRole $empRoles');
    print('roRole $roRoles');
    print('adminRole $adminRoles');
    print('Response snapshot: ${sessionId}');
    print('Show Payroll: ${setShowPayroll}');
    print('OrgId -  ${orgId}');
    print('OrgName - : ${orgName}');
    setState(() {

    });
    setState(() {
      if(empRoles==1){
        showHide=true;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRoles==0){
        showHide=false;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if (adminRoles == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRoles == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRoles == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRoles == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
  }

  @override
  void initState() {
    getSharedPrfanceList();
    //monthAttendance("ankurraj812@gmail.com","8882758942");
    //monthAttendancePost("1116a07f94bbd789c25280a8a480ced5d87a8811714");
    super.initState();
  }
  int value = 0;

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
      print("CheckOrg - $orgId");
      List<Widget> items = [];

      //My Attendance Requests
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
        items.add(
          Hero(
            tag: 'myAttRequests',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.pendingReqRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.list_alt,
                        size: 50,
                        color: Mythemes.lightBluishColor,
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
                            'Att. Request',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
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

      //My Leave Requests
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
        items.add(
          Hero(
            tag: 'myLeaveRequests',
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
                    Navigator.pushNamed(context, MyRoutings.requestedRequisitionRoute);
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
                            'Leave Request',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
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

      //OD Punch ESS
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
        items.add(
          Hero(
            tag: 'odPunch',
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
                    Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                    /*  Navigator.pushNamed(
                        context, MyRoutings.odSelfReqDateSelectRoute);*/
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: Mythemes.lightBluishColor,
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
                            'OD Punch',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
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
      //My OD Requests ESS
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
        items.add(
          Hero(
            tag: 'myOdRequest',
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
                            'OD Requests',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
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

      //My Claim Requests
      if(orgId == 3 || orgId == 145 || orgId == 171 || orgId == 179 || orgId == 186) {
        if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
          items.add(
            Hero(
              tag: 'raiseClaim',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
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
                      Navigator.pushNamed(context, MyRoutings.claimReqListRoute);
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.currency_rupee,
                          size: 50,
                          color: Mythemes.lightBluishColor,
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
                              'Add Claim',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
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
      }

      //My Loan Requests
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
          items.add(
            Hero(
              tag: 'raiseLoan',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
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
                      Navigator.pushNamed(context, MyRoutings.myLoanRequestListRoute);
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                        CupertinoIcons.money_dollar_circle_fill,
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
                              'My Loans',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
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
    var titleName = "My Requests";
    timeDilation = 0.5;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$titleName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: generateGridViewItems(),
                ),
              ),
            ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {
            String newTitle = "";
            if(index==0){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0,)));
              //Navigator.pop(context);
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 2,)));
            }
            if(index==2){
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Claim');
            }
            if(index==3){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
              );
              print('Profile');
            }
            /*if(index==3){
                title="Notifications";
              }*/
            setState(() => currentIndex = index);
            // Adjust index mapping if Profile is hidden
            int adjustedIndex = index;
            if (userType == 'COMPANY_ADMIN' && index >= 4) {
              adjustedIndex += 1;
            }

            switch (adjustedIndex) {
              case 0:
                newTitle = "Home";
                break;
              case 1:
                newTitle = "Workflow";
                break;
              case 2:
                newTitle = "Reports";
                break;
              case 3:
                newTitle = "Dashboard";
                break;
              case 4:
                newTitle = "Profile";
                break;
            }

            setState(() {
              currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: 'Reports',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            if (userType != 'COMPANY_ADMIN')
              const BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
          ],
        ),
      ),
      //debugShowCheckedModeBanner: false,
    );
  }
}
