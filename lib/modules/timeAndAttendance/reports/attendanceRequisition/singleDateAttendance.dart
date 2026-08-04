import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/attendanceRequisition.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../themes/empThemes.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';

import 'model/onDateReportModel.dart';

class SingleDateAttendance extends StatefulWidget {
  //SingleDateAttendance({Key? key}) : super(key: key);

  final String singleDateString;

  const SingleDateAttendance({Key? key, required this.singleDateString})
    : super(key: key);

  @override
  State<SingleDateAttendance> createState() =>
      _SingleDateAttendanceState(singleDateString);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;

OnDateAttModel? onDateAttModelGlobel;
int? empId;

class _SingleDateAttendanceState extends State<SingleDateAttendance>
    with RouteAware {
  final String singleDateString;

  _SingleDateAttendanceState(this.singleDateString);

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
    print("single new date $singleDateString");

    getSharedPrfanceList();
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empId = await shared.getEmpId();
    // await Future.delayed(Duration(seconds: 5));
    Future<OnDateAttModel> getEmployeeList11 = getSingleAttList(
      sessionId!,
      singleDateString,
    );
    getEmployeeList11.then((value) {
      setState(() {
        onDateAttModelGlobel = value;
      });
      // print('employeeList00${onDateAttModelGlobel!.data!.length}');
    });
  }

  Future<OnDateAttModel> getSingleAttList(
    String SessionId,
    String singleDate,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.getAttDetails;
    print('employeeList11: ${SessionId}');
    OnDateAttModel onDateAttModel;
    var urlapi = Uri.parse(
      "$conn$apiUrl?sessionId=$sessionId&date=$singleDate",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    onDateAttModel = OnDateAttModel.fromJson(mapResponse);

    return onDateAttModel;
  }

  int pageIndex = 0;
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Attendance List".text.make(), elevation: 0.5),

      body: Container(
        color: context.canvasColor,
        child: Center(
          child:
              onDateAttModelGlobel == null
                  ? CircularProgressIndicator()
                  : AttList(onDateAttModelGlobel!),
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
}

class AttList extends StatefulWidget {
  final OnDateAttModel onDateAttModel;

  AttList(this.onDateAttModel);

  @override
  State<AttList> createState() => _AttListState(onDateAttModel);
}

class _AttListState extends State<AttList> {
  final OnDateAttModel onDateAttModel;

  _AttListState(this.onDateAttModel);

  @override
  Widget build(BuildContext context) {
    String dateFormate = DateFormat(
      "dd-MM-yyyy",
    ).format(DateTime.parse(onDateAttModelGlobel!.date!.toString()));
    print("helooo $dateFormate");
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: 1,
      itemBuilder: (context, itemCount) {
        return InkWell(
          onTap: () {
            print('attendanceReport$onDateAttModel!.data![itemCount]');
            // Navigator.pushNamed(context, MyRoutings.attendanceRequisitionRoute);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        AttendanceRequisition(null, onDateAttModelGlobel, 1),
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
                      onDateAttModelGlobel!.empName!.text.make().px8().py4(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            onDateAttModelGlobel!.status!.text.capitalize
                                .make()
                                .px8(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      dateFormate.text
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
                              size: 35,
                              color: Mythemes.lightBluishColor,
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
                            "In Time".text.sm.make(),
                            onDateAttModelGlobel!.inTime! == "Govardhan Puja"
                                ? "G P".text.sm.make()
                                : onDateAttModelGlobel!.inTime!.text.sm.make(),
                            //onDateAttModelGlobel!.inTime!.text.sm.make()
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
                              Icons.touch_app,
                              size: 35,
                              color: Mythemes.lightBluishColor,
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
                            onDateAttModelGlobel!.outTime! == "Govardhan Puja"
                                ? "G P".text.sm.make()
                                : onDateAttModelGlobel!.outTime!.text.sm.make(),
                            //onDateAttModelGlobel!.outTime!.text.sm.make()
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
                              size: 35,
                              color: Mythemes.lightBluishColor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Work Hours".text.sm.make(),
                              onDateAttModelGlobel!.workingHrs!
                                  .toString()
                                  .text
                                  .sm
                                  .make(),
                            ],
                          ),
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
    );
  }
}
