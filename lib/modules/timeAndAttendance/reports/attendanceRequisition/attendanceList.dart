import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../themes/empThemes.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'attendanceRequisitionCurrentMonth.dart';
import 'model/onDateReportModel.dart';

class AttendanceList extends StatefulWidget {
  final AttendanceReportModel attendanceReportModel1;

  AttendanceList(this.attendanceReportModel1);

  @override
  State<AttendanceList> createState() =>
      _AttendanceListState(attendanceReportModel1);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
AttendanceReportModel? attendanceModelGlobel;
OnDateAttModel? onDateAttModel;
int? empId;

class _AttendanceListState extends State<AttendanceList> with RouteAware {
  final AttendanceReportModel attendanceReportModel1;

  _AttendanceListState(this.attendanceReportModel1);

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
    // âœ… Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }

  @override
  void initState() {
    getSharedPrfanceList();
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empId = await shared.getEmpId();
    // await Future.delayed(Duration(seconds: 5));
    Future<AttendanceReportModel> getEmployeeList11 = getEmployeeList(
      sessionId!,
    );
    getEmployeeList11.then((value) {
      setState(() {
        attendanceModelGlobel = value;
      });
      print('employeeList00${attendanceModelGlobel!.data!.length}');
    });
  }

  Future<AttendanceReportModel> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.getAttendance;

    print('employeeList11: ${SessionId}');
    AttendanceReportModel employeeListModel;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&empId=$empId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel = AttendanceReportModel.fromJson(mapResponse);

    return employeeListModel;
  }

  int pageIndex = 0;
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Attendance List".text.make(),
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchItems());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),

      body: Container(
        color: context.canvasColor,
        child: Center(
          child:
              attendanceModelGlobel == null
                  ? CircularProgressIndicator()
                  : getAttList(attendanceModelGlobel!),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            //Navigator.pop(context);
            print('home tab');
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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

  getAttList(AttendanceReportModel attendanceReportModel) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => AttendanceList(AttendanceReportModel()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: attendanceModelGlobel!.data!.length,
        itemBuilder: (context, itemCount) {
          return InkWell(
            onTap: () {
              print('attendanceReport$attendanceModelGlobel!.data![itemCount]');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => AttendanceRequestCurrentMonth(
                        attendanceModelGlobel,
                        onDateAttModel,
                        itemCount,
                      ),
                ),
              );
            },
            child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        attendanceModelGlobel!
                            .data![itemCount]
                            .employeeName!
                            .text
                            .make()
                            .px8()
                            .py4(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              attendanceModelGlobel!
                                  .data![itemCount]
                                  .status!
                                  .text
                                  .bold
                                  .size(12)
                                  .color(
                                    attendanceModelGlobel!
                                                .data![itemCount]
                                                .status! ==
                                            "ABSENT"
                                        ? Mythemes.dangerColorOne
                                        : Mythemes.lightBluishColor,
                                  )
                                  .make()
                                  .px8(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        attendanceModelGlobel!
                            .data![itemCount]
                            .attendanceDate!
                            .text
                            .textStyle(context.captionStyle)
                            .make()
                            .px8(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Mythemes.lightBluishColor,
                              ).px24(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 25,
                              color: Mythemes.lightBluishColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            "In Time".text.sm.make(),
                            attendanceModelGlobel!.data![itemCount].inTime! ==
                                    "National Holiday"
                                ? "NH".text.sm.make()
                                : attendanceModelGlobel!
                                    .data![itemCount]
                                    .inTime!
                                    .text
                                    .sm
                                    .make(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 25,
                                color: Mythemes.dangerColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Out Time".text.sm.make(),
                              attendanceModelGlobel!
                                          .data![itemCount]
                                          .outTime! ==
                                      "National Holiday"
                                  ? "NH".text.sm.make()
                                  : attendanceModelGlobel!
                                      .data![itemCount]
                                      .outTime!
                                      .text
                                      .sm
                                      .make(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.update,
                                size: 25,
                                color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Work Hours".text.sm.make(),
                              attendanceModelGlobel!
                                  .data![itemCount]
                                  .workingHrs!
                                  .text
                                  .sm
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchItems extends SearchDelegate {
  List<String> searchTerms = [];
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
        return ListTile(title: Text(result));
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
        return ListTile(title: Text(result));
      },
    );
  }
}
