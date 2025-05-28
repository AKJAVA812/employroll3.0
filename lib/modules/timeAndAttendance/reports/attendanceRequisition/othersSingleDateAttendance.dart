import 'dart:collection';
import 'dart:convert';

import 'package:er_flutter_project/modules/timeAndAttendance/reports/otherEmpRequisitionAttendance.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/attendanceRequisition.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../MSS_Bundle/timeAndAttendance/otherEmpRequisitionAttendance.dart';
import '../../../../MSS_MO_Bundle/timeAndAttendance/otherEmpRequisitionAttendance.dart';
import '../../../../UIS_Bundle/timeAndAttendance/otherEmpRequisitionAttendance.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../themes/empThemes.dart';
import 'package:http/http.dart' as http;

import 'attendanceList.dart';
import 'model/onDateReportModel.dart';
import 'othersAttendanceRequisitionPage.dart';
import 'othersOnDateAttendanceModal.dart';


class OthersSingleDateAttendance extends StatefulWidget {
  //SingleDateAttendance({Key? key}) : super(key: key);

  final String singleDateString;
  final int empId;

  const OthersSingleDateAttendance(
      {Key? key, required this.singleDateString, required this.empId})
      : super(key: key);

  @override
  State<OthersSingleDateAttendance> createState() => _OthersSingleDateAttendanceState(singleDateString);
}
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;

var getData;

OthersOnDateAttendanceModal? onDateAttModelGlobel;
int? empId;

class _OthersSingleDateAttendanceState extends State<OthersSingleDateAttendance> {
  final String singleDateString;

  _OthersSingleDateAttendanceState(this.singleDateString);

  var userPanel;
  @override
  void initState() {

    print("single new date $singleDateString");

    getSharedPrfanceList();
    setState(() {
    });
    // TODO: implement initState
    super.initState();
  }
/*  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    empId=empNewId;
    print("EMPIDOTHER - $empId");
    // await Future.delayed(Duration(seconds: 5));
    Future<OthersOnDateAttendanceModal> getEmployeeList11 = getSingleAttList(sessionId!,singleDateString);
    getEmployeeList11.then((value) {
      setState(() {
        onDateAttModelGlobel=value;
        print("Value - $value");

      });
      // print('employeeList00${onDateAttModelGlobel!.data!.length}');
    });
  }*/
  Future<void> getSharedPrfanceList() async {
    try {
      sessionId = await shared!.getSessionId();
      userPanel = await shared!.getUserPanel();

      if (userPanel == "MSS") {
        empId = empNewIdMSS;
      } else if (userPanel == "MSS_MO_ADMIN") {
        empId = empNewIdMO;
      } else if (userPanel == "USER") {
        empId = empNewIdUSER;
      }

      final fetchedData = await getSingleAttList(sessionId!, singleDateString);

      if (!mounted) return; // 👈 check before calling setState
      setState(() {
        onDateAttModelGlobel = fetchedData;
      });

      if (getData == 0) {
        print("No data found in the model");
        if (!mounted) return; // 👈 check again before using context
        showNodata(context, "Oops", "No data available.");
      }
    } catch (e) {
      print("Error: $e");
      if (!mounted) return; // 👈 prevent error here too
      showNodata(context, "Error", "Failed to fetch data.");
    }
  }

  showNodata(BuildContext buildContext, result,reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(buildContext);
            setState(() {

            });
          },
          child: Text("Ok"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<OthersOnDateAttendanceModal> getSingleAttList(String SessionId , String singleDate) async {

    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.getOtherAttDetails;
    print('employeeList11: ${SessionId}');
    OthersOnDateAttendanceModal onDateAttModel;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId&"
        "date=$singleDate&"
        "empId=$empId"
    );
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    getData = mapResponse.length;
    print("My Get Data - $getData");
    if (getData == 0 )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
      var map={
        "inTime": "",
        "departmentName": "",
        "employeeName": "",
        "empId": 0,
        "workingHrs": "",
        "onDate": "1996-11-01",
        "branchName": "",
        "logId": 0,
        "outTime": "",
        "applicationDate": "",
        "status": ""
      };
      onDateAttModel=OthersOnDateAttendanceModal.fromJson(map);
    } else {
      getData=1;
      onDateAttModel = OthersOnDateAttendanceModal.fromJson(mapResponse);
    }

    return onDateAttModel;
  }
  int pageIndex = 0;
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: "Other's Attendance List".text.make(),
        elevation: 0.5,
      ),

      body: Container(
        color: context.canvasColor,
        child: Center(child: onDateAttModelGlobel==null?CircularProgressIndicator():AttList(onDateAttModelGlobel!)),
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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
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
            icon: Icon(Icons.pending_actions),
            label: 'Attendance',
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


class AttList extends StatefulWidget {
  final OthersOnDateAttendanceModal onDateAttModel;

  AttList(this.onDateAttModel);



  @override
  State<AttList> createState() => _AttListState(onDateAttModel);
}

class _AttListState extends State<AttList> {
  final OthersOnDateAttendanceModal onDateAttModel;

  _AttListState(this.onDateAttModel);

  @override
  Widget build(BuildContext context) {
    String dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(onDateAttModelGlobel!.onDate!.toString()));
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: getData,
      itemBuilder: (context, itemCount) {
        return InkWell(
          onTap: () {
            print('attendanceReport$onDateAttModel!.data![itemCount]');
            // Navigator.pushNamed(context, MyRoutings.attendanceRequisitionRoute);
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                OthersAttendanceRequisition(null, onDateAttModelGlobel,1)));
          },
          child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        onDateAttModelGlobel!.employeeName!.text.make().px8().py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                onDateAttModelGlobel!.status!.text.capitalize.make().px8(),
                              ],
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        dateFormate.text.textStyle(context.captionStyle).make().px8(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios, size: 15, color: Mythemes.lightBluishColor,
                                ).px24(),
                              ],
                            )


                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app, size: 35, color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "In Time".text.sm.make(),
                              onDateAttModelGlobel!.inTime!.text.sm.make()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app, size: 35, color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "Out Time".text.sm.make(),
                              onDateAttModelGlobel!.outTime!.text.sm.make()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.update, size: 35, color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [

                              "Work Hours".text.sm.make(),
                              onDateAttModelGlobel!.workingHrs!.text.sm.make()
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
        );
      },
    );
  }
}

