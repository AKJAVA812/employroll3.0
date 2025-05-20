import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../main.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import 'modelClass/attendanceShiftDetModal.dart';

Map<String, dynamic> mapResponse = {};

class AttendanceReport extends StatefulWidget {
  final String forDateString;
  final String toDateString;

  const AttendanceReport(
      {Key? key, required this.forDateString, required this.toDateString})
      : super(key: key);

  @override
  State<AttendanceReport> createState() =>
      _AttendanceReportState(forDateString, toDateString);
}

SessionManager shared = SessionManager();
String? sessionId;
late AttendanceReportModel? employeeListModelglobel = AttendanceReportModel(data: List.empty());
var status = "Present";
AttendanceShiftDetailsModal? attendanceShiftDetailsModalGlobal;
AttendanceShiftDetailsModal? attendanceShiftDetailsModalGlobaled;

dynamic isAbsent;
dynamic isHalfDay;
dynamic isShortLeave;
dynamic isPresent;
dynamic presentWh;
dynamic absentWh;
dynamic shortLeaveMin;
dynamic shortLeaveMax;
dynamic halfDayMin;
dynamic halfDayMax;

class _AttendanceReportState extends State<AttendanceReport> with RouteAware{
  final String forDateString;
  final String toDateString;

  _AttendanceReportState(this.forDateString, this.toDateString);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // ✅ Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }
  @override
  void initState() {
    getSharedPrfanceList();

    // TODO: implement initState
    super.initState();
  }



  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    print('ResponseAttendance: ${sessionId}');
    print('ResponseAttendance: ${forDateString}');
    print('ResponseAttendance: ${toDateString}');
    //await Future.delayed(Duration(seconds: 3));
    Future<AttendanceReportModel> getEmployeeList11 =
        getEmployeeList(sessionId!, toDateString, forDateString);
    //Shift Check
    Future<AttendanceShiftDetailsModal> getEmployeeList12 =
      getStatus(sessionId!);
    if (getEmployeeList11 == null) {
      return Center(child: "HIi".text.make()
          //CircularProgressIndicator()
          );
    }
    getEmployeeList11.then((value) {
      setState(() {
        employeeListModelglobel = value;
      });
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });

    getEmployeeList12.then((value) {
      setState(() {
        attendanceShiftDetailsModalGlobaled = value;
      });

      /*print('Shift Result - ${attendanceShiftDetailsModalGlobaled!.result}');
      print('Shift Absent - ${attendanceShiftDetailsModalGlobaled!.isAbsentWorkHour}');
      print('Shift Half Day- ${attendanceShiftDetailsModalGlobaled!.isHalfdayWorkHour}');
      print('Shift Short Leave WH - ${attendanceShiftDetailsModalGlobaled!.isShortWorkHour}');
      print('Shift Absent WH - ${attendanceShiftDetailsModalGlobaled!.absentWorkHour}');
      print('Shift Half Day Max WH- ${attendanceShiftDetailsModalGlobaled!.halfdayMaxWorkHour}');
      print('Shift Half Day Min WH- ${attendanceShiftDetailsModalGlobaled!.halfdayMinWorkHour}');
      print('Shift Present WH - ${attendanceShiftDetailsModalGlobaled!.presentWorkHour}');*/
    });
  }

  Future<AttendanceShiftDetailsModal> getStatus(
      String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.outPunchStatusCheck;
    print('employeeList11: ${sessionId}');
    AttendanceShiftDetailsModal employeeListModel;
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
            "sessionId=$sessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');

    print("Shift API - ${response.request}");

    mapResponse = json.decode(response.body);
    employeeListModel = AttendanceShiftDetailsModal.fromJson(mapResponse);

    return employeeListModel;
  }


  Future<AttendanceReportModel> getEmployeeList(
      String sessionId, String fromdate, String toDate) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.attendanceReport;
    print('employeeList11: ${sessionId}');
    AttendanceReportModel employeeListModel;
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
        "sessionId=$sessionId&toDate=$fromdate&fromDate=$toDate");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');
    print('API - ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel = AttendanceReportModel.fromJson(mapResponse);

    return employeeListModel;
  }

  int pageIndex = 0;
  int currentIndex = 2;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Attendance Report".text.make(),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context, delegate: SearchItems(),
                );

              }, icon: Icon(Icons.search))
        ],
      ),

      body: Container(
        color: context.canvasColor,
        child: Center(child: employeeListModelglobel==null?CircularProgressIndicator():AttList(employeeListModelglobel!)),
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
  final AttendanceReportModel attendanceReportModel1;

  AttList(this.attendanceReportModel1);


  @override
  State<AttList> createState() => _AttListState(attendanceReportModel1);
}

class _AttListState extends State<AttList> {
  final AttendanceReportModel attendanceReportModel1;

  _AttListState(this.attendanceReportModel1);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: employeeListModelglobel!.data!.length,
      itemBuilder: (context, itemCount) {
        isAbsent = attendanceShiftDetailsModalGlobaled!.isAbsentWorkHour;
        isHalfDay = attendanceShiftDetailsModalGlobaled!.isHalfdayWorkHour;
        isShortLeave = attendanceShiftDetailsModalGlobaled!.isShortWorkHour;
        isPresent = attendanceShiftDetailsModalGlobaled!.isPresentWorkHour;
        presentWh = attendanceShiftDetailsModalGlobaled!.presentWorkHour;
        absentWh = attendanceShiftDetailsModalGlobaled!.absentWorkHour;
        shortLeaveMin = attendanceShiftDetailsModalGlobaled!.shortMinWorkHour;
        shortLeaveMax = attendanceShiftDetailsModalGlobaled!.shortMaxWorkHour;
        halfDayMin = attendanceShiftDetailsModalGlobaled!.halfdayMinWorkHour;
        halfDayMax = attendanceShiftDetailsModalGlobaled!.halfdayMaxWorkHour;
        double workingHrs = double.tryParse(employeeListModelglobel!.data![itemCount].workingHrs!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
        double absentThreshold = double.tryParse(absentWh) ?? 0.0;
        double minHalfWorkHrs = double.tryParse(halfDayMin) ?? 0.0;
        double maxHalfWorkHrs = double.tryParse(halfDayMax) ?? 0.0;
        double maxShortHrs = double.tryParse(shortLeaveMax) ?? 0.0;
        double minShortHrs = double.tryParse(shortLeaveMin) ?? 0.0;


        print('Shift Absent - $isAbsent');
        print('Working Hour - $workingHrs');
        print('Shift Absent WH - $absentThreshold');
// Extract numbers from 'workingHrs' and convert safely
        if(workingHrs != 0 && employeeListModelglobel!.data![itemCount].status! == "Absent") {
          status = "Present";
          if(isAbsent == true) {

            if (workingHrs <= absentThreshold) {
              status = "Absent";
              print("STATUS = $status");
            }
          }
          if(isHalfDay == true) {
            if (workingHrs >= minHalfWorkHrs && workingHrs <= maxHalfWorkHrs) {
              status = "Half Day";
            }
          }
          if(isShortLeave == true) {
            if (workingHrs >= minShortHrs && workingHrs <= maxShortHrs) {
              status = "Short Leave";
            }
          }
        } else {
          print("i am else");
          status = employeeListModelglobel!.data![itemCount].status!;
        }
        return Card(
            elevation: 2,
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      employeeListModelglobel!.data![itemCount].employeeName!.text.make().px8().py4(),
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              "$status".text.bold.color(status == "Absent" ? Mythemes.dangerColor : Mythemes.successColor).make().px8()
                              //employeeListModelglobel!.data![itemCount].status!.text.color(employeeListModelglobel!.data![itemCount].status! == "Absent" ? Mythemes.dangerColorOne : Mythemes.lightBluishColor).make().px8(),
                            ],
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      employeeListModelglobel!.data![itemCount].attendanceDate!.text.textStyle(context.captionStyle).make().px8(),
                      /*Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios, size: 15, color: Mythemes.lightBluishColor,
                              ).px24(),
                            ],
                          )


                      )*/
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
                              Icons.touch_app, size: 25, color: Mythemes.lightBluishColor,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                        child: Column(
                          children: [
                            "In Time".text.sm.make(),
                            employeeListModelglobel!.data![itemCount].inTime == null ||
                                employeeListModelglobel!.data![itemCount].inTime == 'Casual Leave'
                                ? ''.text.make() :
                            employeeListModelglobel!.data![itemCount].inTime!.text.sm.make()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                        child: Column(
                          children: [
                            Icon(
                              Icons.touch_app, size: 25, color: Mythemes.lightBluishColor,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                        child: Column(
                          children: [
                            "Out Time".text.sm.make(),
                            employeeListModelglobel!.data![itemCount].outTime == null ||
                                employeeListModelglobel!.data![itemCount].outTime == 'Casual Leave'
                                ? ''.text.make() :
                            employeeListModelglobel!.data![itemCount].outTime!.text.sm.make()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:15, left: 5, right: 3, bottom: 18),
                        child: Column(
                          children: [
                            Icon(
                              Icons.update, size: 25, color: Mythemes.lightBluishColor,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                        child: Column(
                          children: [

                            "Work Hours".text.sm.make(),
                            employeeListModelglobel!.data![itemCount].workingHrs!.text.sm.make()
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ).py2();
      },
    );
  }
}

class SearchItems extends SearchDelegate {

  List<String> searchTerms = [

  ];
  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
