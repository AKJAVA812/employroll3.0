import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert' show utf8;
import '../commanScreen/homePage.dart';
import '../main.dart';
import '../profiles/profilePageWithHead.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../singUP/model/loginModel.dart';
import '../widgets/drawer_file.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';

class MyAllReportsPage extends StatefulWidget {
  const MyAllReportsPage({Key? key}) : super(key: key);

  @override
  State<MyAllReportsPage> createState() => _MyAllReportsPageState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
bool? setShowPayroll;
int? orgId;
String? orgName;
int? empRoles;
int? roRoles;
int? adminRoles;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;
String? userPanel;
String? profileName;
dynamic profileId;

class _MyAllReportsPageState extends State<MyAllReportsPage> {
  int currentIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File? image;



  Future getSharedPrfanceList() async {

    sessionId = await shared!.getSessionId();
    setShowPayroll = await shared!.getShowPayroll();
    orgId = await shared!.getOrgId();
    orgName = await shared!.getOrgName();
    empRoles= await shared.getEmpRoll();
    roRoles= await shared.getRoRole();
    adminRoles= await shared.getAdminRole();
    print('empRole $empRoles');
    print('roRole $roRoles');
    print('adminRole $adminRoles');
    print('Response snapshot: ${sessionId}');
    print('Show Payroll: ${setShowPayroll}');
    print('OrgId -  ${orgId}');
    print('OrgName - : ${orgName}');
    userPanel= await shared.getUserPanel();
    profileName= await shared.getDefaultProfileName();
    profileId= await shared.getDefaultProfileId();
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

  var hideWidget = false;
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

      // My Attendance
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN"){
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
      }

      //My Leave Balance
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
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
                            'My Leave Balance',
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

      // My Documents
      if(setShowPayroll == true) {
        items.add(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);
              /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
            },
            child: Hero(
              tag: 'e-doc',
              child: Card(
                //color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.document_scanner_sharp,
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
                          'E-Doc',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold),
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


      //Work Done Report
      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN"){
        items.add(
          Hero(
            tag: 'workDoneReport',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
                  //Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                  /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
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
                            'Work Done',
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

      //My Loan Summary
      if(orgId == 3 || orgId == 145 || orgId == 179 || orgId == 186){
        items.add(
          Hero(
            tag: 'myLoanSummary',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MyRoutings.myLoanSummaryRoute);
                  //Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                  /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.summarize,
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
                            'Loan Summary',
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
      //My Loan Ledger
      if(orgId == 3 || orgId == 145){
        items.add(
          Hero(
            tag: 'myLoanLedger',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MyRoutings.myLoanLedgerRoute);
                  //Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                  /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.checklist_rounded,
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
                            'Loan Ledger',
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

    var titleName = "My Reports";
    timeDilation = 0.5;
    int currentIndex = 2;
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
        body: GridView.count(
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
                  MaterialPageRoute(builder: (context) => HomePage()));
              //Navigator.pop(context);
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            }
            if(index==2){
              //Navigator.pushNamed(context, MyRoutings.reportSectionHead);
              print('Reports');
            }
            if(index==3){
              Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
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
              icon: Icon(Icons.data_exploration_outlined),
              label: 'Reports',
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

        //IndexedStack(
        //index:currentIndex,
        //children: screens,
        //),


      ),
      //debugShowCheckedModeBanner: false,
    );
  }
}
