import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'dart:io';
import 'package:velocity_x/velocity_x.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
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

class _ReportPageState extends State<ReportPage> {
  int currentIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File? image;



  Future getSharedPrfanceList() async {

    sessionId = await shared.getSessionId();
    setShowPayroll = await shared.getShowPayroll();
    orgId = await shared.getOrgId();
    orgName = await shared.getOrgName();
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
      }

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

      if(userPanel == "COMPANY_EMPLOYEE" || userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
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
      if(orgId == 3 || orgId == 145){
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
    timeDilation = 0.5;
    return Material(
      child: Scaffold(
        body: Column(
          children: [
           /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: userPanel == "MSS",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 2),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(150),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 2.0,
                        customSeparatorBuilder: (context, local, global) {
                          final opacity =
                          ((global.position - local.position).abs() - 0.5)
                              .clamp(0.0, 1.0);
                          return VerticalDivider(
                              indent: 10.0,
                              endIndent: 10.0,
                              color: Colors.white38.withOpacity(opacity));
                        },
                        customIconBuilder: (context, local, global) {
                          final text = const ['ESS', 'MSS'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {
                            value = i;
                            print(i);
                          });
                          if(value == 1) {
                            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                          }
                        },
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: userPanel == "MSS_MO_ADMIN",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 2),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(150),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 2.0,
                        customSeparatorBuilder: (context, local, global) {
                          final opacity =
                          ((global.position - local.position).abs() - 0.5)
                              .clamp(0.0, 1.0);
                          return VerticalDivider(
                              indent: 10.0,
                              endIndent: 10.0,
                              color: Colors.white38.withOpacity(opacity));
                        },
                        customIconBuilder: (context, local, global) {
                          final text = const ['ESS', 'MSS MO'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {
                            value = i;
                            print(i);

                          });
                          if(value == 1) {
                            //Navigator.pushNamed(context, MyRoutings.mssMoNewDashboardRoute);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ).pLTRB(0, 8, 0, 8),*/
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: generateGridViewItems(),
              ),
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
