import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/adminPage/adminDashboard/presentEmpList.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/routes.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../adminPage/adminDashboard/absentEmpList.dart';
import '../../adminPage/adminDashboard/earlyGoEmpList.dart';
import '../../adminPage/adminDashboard/halfDayEmpList.dart';
import '../../adminPage/adminDashboard/lateInEmpList.dart';
import '../../adminPage/adminDashboard/missPunchempList.dart';
import '../../adminPage/adminDashboard/onDutyEmpList.dart';
import '../../adminPage/adminDashboard/overTimeEmpList.dart';
import '../../adminPage/modelClass/branchListModal.dart';
import '../../adminPage/modelClass/dashboardModel.dart';
import '../../adminPage/modelClass/eventListModal.dart';
import '../../adminPage/modelClass/shiftListModal.dart';

class Admin_UIS_Dashboard extends StatefulWidget {
  final DashboardModel dashboardModel1;

  Admin_UIS_Dashboard(this.dashboardModel1);

  @override
  State<Admin_UIS_Dashboard> createState() => _Admin_UIS_DashboardState(dashboardModel1);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
DashboardModel? dashboardModelGlobal;
BranchListModal? branchListModalGloabal;
ShiftListModal? shiftListModalGlobal;
EventsListModal? eventsListModalGlobal;
DateTime date = DateTime.now();
var branchId = 0;
bool isLoading = true;
var shift = 0;
var singleDateString;
var eventSingleDateString;
var day = new DateTime.now();
var single = new DateFormat('dd');
var singleDay = single.format(day);
late List<String?> list = [];
late List<String?> branchList = [];
late List<String?>? shiftList = [];

dynamic valuenew = "listText";
String shiftValue = "listText";
class _Admin_UIS_DashboardState extends State<Admin_UIS_Dashboard> {
  final DashboardModel dashboardModel1;

  _Admin_UIS_DashboardState(this.dashboardModel1);
  int? empRole;
  int? roRole;
  int? adminRole;
  var dateController;
  var dateEmpty;

  var todayDate = "dd/mm/yyyy";
  int? totalPresentEmp;
  int? totalEmp;
  int? totalAbsentEmp;
  int? misPunchEmp;
  int? onDuty;
  int? lateIn;
  int? earlyOutEmp;
  int? halfEmp;
  int? overTime;
  var dropdownNewvalue;
  var dropdownNewvalueShift;

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    setState(() {
      isLoading = true; // Start loading
    });
    Future<DashboardModel> getEmployeeList11 = getDashboardData(sessionId!);
    Future<BranchListModal> getEmployeeList12 = getBranchList(sessionId!);
    Future<ShiftListModal> getEmployeeList13 = getShiftList(sessionId!);
    Future<EventsListModal> getEmployeeList14 = getEventData(sessionId!);
    getEmployeeList11.then((value) {
      setState(() {
        dashboardModelGlobal = value;
        setState(() {
          isLoading = false; // End loading
        });
      });
      //print('Dashboard length ${dashboardModelGlobal!.result!.length}');
    });

    getEmployeeList12.then((value) {
      setState(() {
        branchListModalGloabal = value;
      });
      //print('Branch List length ${branchListModalGloabal!.data!.length}');
    });

    getEmployeeList13.then((value) {
      setState(() {
        shiftListModalGlobal = value;
      });
      //print('shift List length ${shiftListModalGlobal!.data!.length}');
    });

    getEmployeeList14.then((value) {
      setState(() {
        eventsListModalGlobal = value;
      });
      //print('employeeList00${eventsListModalGlobal!.bdayList!.length}');
    });

      empRole= await shared.getEmpRoll();
      roRole= await shared.getRoRole();
      //print('EmpRole $empRole');
      //print('roRole $roRole');


    setState(() {
      loader();
    });
  }

  Future getTodayDate() async {
    singleDateString = DateTime.now();
    singleDateString = DateFormat('dd-MM-yyyy').format(date);
    //print("SingleDate $singleDateString");
    //dateController.text = DateFormat("dd-MM-yyyy").format(date);
    //  DateFormat.yMd().format(date!).toString();
    //print("todayDate $date");
  }

  Future<DashboardModel> getDashboardData(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.adminDashboardAPi;

    //print('employeeList11: ${SessionId}');
    DashboardModel dashboardModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "branch=$branchId&"
        "shift=$shift&"
        "date=$singleDateString");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    //print('response body ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    //print('Body Data $getData');
    dashboardModel = DashboardModel.fromJson(mapResponse);
    return dashboardModel;
  }

  Future<BranchListModal> getBranchList(String SessionId) async {
    branchList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.branchListApi;

    //print('employeeList11: ${SessionId}');
    BranchListModal branchListModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    //print('response body ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    //print('Body Data $getData');
    branchListModal = BranchListModal.fromJson(mapResponse);

    for (int i = 0; i < branchListModal!.data!.length; i++) {
      var branchName = branchListModal!.data![i].branchName;
      branchList = branchList.toSet().toList();
      branchList?.add(branchListModal!.data![i].branchName);
      //print('branchNameNew $branchName');
    }

    return branchListModal;
  }

/*  Future<BranchListModal> getBranchList(String SessionId) async {
    branchList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.branchListApi;

    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    mapResponse = json.decode(response.body);

    BranchListModal branchListModal = BranchListModal.fromJson(mapResponse);

    for (int i = 0; i < branchListModal.data!.length; i++) {
      var branchName = branchListModal.data![i].branchName;
      if (!branchList.contains(branchName)) {
        branchList.add(branchName);
      }
    }

    //branchList = branchList.toSet().toList(); // Remove duplicates
    return branchListModal;
  }*/

  Future<ShiftListModal> getShiftList(String SessionId) async {
    shiftList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.shiftListApi;

    print('employeeList11: ${SessionId}');
    ShiftListModal shiftListModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.request}');
    //print('response body ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    print('Body Data $getData');
    shiftListModal = ShiftListModal.fromJson(mapResponse);
    for (int i = 0; i < shiftListModal!.data!.length; i++) {
      var shiftName = shiftListModal!.data![i].shiftName;
      shiftList?.add(shiftListModal!.data![i].shiftName);
      //print('shiftNames $shiftName');
    }
    return shiftListModal;
  }

  Future<EventsListModal> getEventData(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.eventListModalApi;

    print('employeeList11: ${SessionId}');
    EventsListModal eventsListModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "branch=$branchId&"
        "shift=$shift&"
        "date=$singleDateString");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.request}');
    //print('response body ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    print('Body Data $getData');
    eventsListModal = EventsListModal.fromJson(mapResponse);
    return eventsListModal;
  }

  loader() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          new Text("Please Wait...",
              style: TextStyle(
                fontSize: 20,
              )),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    todayDate = formatter.format(now);
    getSharedPrfanceList();
    setState(() {});

    getTodayDate();

    // TODO: implement initState
  }
  int value = 1;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    //queryData = MediaQuery.of(context).size.width/2;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          date = (await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(1947),
              lastDate: DateTime.now().add(Duration(days: 0))))!;

          setState(() {
            loader();
            getSharedPrfanceList();
            singleDateString = DateFormat('dd-MM-yyyy').format(date!);
            singleDay = DateFormat('dd').format(date!);
            print("SingleDateNew $singleDateString");
            print("singleDay $singleDay");
            //dateController.text = DateFormat("dd").format(date!);

            //  DateFormat.yMd().format(date!).toString();
          });
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: singleDay.toString().text.color(Mythemes.whitish).make(),
      ),
      body: dashboardModelGlobal == null
          ? loader()
          : RefreshIndicator(
          onRefresh: () {
            return getSharedPrfanceList();
          },
          child: DashboardWidgets(dashboardModelGlobal!)),


    );
  }

  DashboardWidgets(DashboardModel dashboardModel) {
    totalPresentEmp = dashboardModelGlobal!.totalPresentEmp;
    totalEmp = dashboardModelGlobal!.totalEmp;
    totalAbsentEmp = dashboardModelGlobal!.totalAbsentEmp;
    misPunchEmp = dashboardModelGlobal!.mispunchEmp;
    onDuty = dashboardModelGlobal!.workingEmp;
    lateIn = dashboardModelGlobal!.lateInEmp;
    earlyOutEmp = dashboardModelGlobal!.earlyOutEmp;
    halfEmp = dashboardModelGlobal!.halfEmp;
    overTime = dashboardModelGlobal!.otEmp;
    print("Total Employees $totalPresentEmp");
    shift = 0;
    branchId = 0;


    var todayEvent;
    var oldEvent;
    var oldEventLength;
    var oldJobLength;
    var oldJobEvent;
    if (eventsListModalGlobal != null && eventsListModalGlobal!.bdayList != null) {
      for (int i = 0; i < eventsListModalGlobal!.bdayList!.length; i++) {
        oldEvent = eventsListModalGlobal!.bdayList![i].dob;
        oldEventLength = eventsListModalGlobal!.bdayList!.length;
        print("oldEvent $oldEvent");
      }
    } else {
      print("bdayList is null or eventsListModalGlobal is null");
    }

    if (eventsListModalGlobal != null && eventsListModalGlobal!.joblist != null) {
      for (int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
        oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
        oldJobLength = eventsListModalGlobal!.joblist!.length;
        print("oldJobEvent $oldJobEvent");
      }
    } else {
      print("job list is null or eventsListModalGlobal is null");
    }

   /* for(int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
      oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
      oldJobLength = eventsListModalGlobal!.joblist!.length;
      print("oldJobEvent $oldJobEvent");
    }*/

    todayEvent = DateTime.now();
    todayEvent = DateFormat('dd-MM-yyyy').format(date);
    print("Todayevent $todayEvent");
    return DismissKeyboard(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
                      if(value == 0) {
                        Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
                      }
                    },
                  )
                ],
              ).py16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Mythemes.whitish,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        //margin: EdgeInsets.only(left: 10.0),
                        //height: 38,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Container(
                          child: Center(
                            child: DropdownButtonFormField(
                              alignment: AlignmentDirectional.centerStart,
                              icon: Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward),
                              ),
                              value: dropdownNewvalue,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "All Branches",
                                hintStyle: TextStyle(
                                  fontSize: 14.2,
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                              items: branchList.map<DropdownMenuItem<String>>((String? value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value ?? '',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                valuenew = newVal.toString();
                                var i = branchList!.indexOf(valuenew)+1;
                                branchId = branchListModalGloabal!.data![i].branchId!;
                                print("Branch ID $branchId");
                                setState(() {
                                  getSharedPrfanceList();
                                  dropdownNewvalue = newVal;
                                });
                               /* if (newVal != null) {
                                  valuenew = newVal;
                                  var i = branchList.indexOf(valuenew);
                                  branchId = branchListModalGloabal!.data![i].branchId!;
                                  print("Branch ID $branchId");

                                  setState(() {
                                    getSharedPrfanceList();
                                    dropdownNewvalue = newVal;
                                  });
                                }*/
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Mythemes.whitish,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        //margin: EdgeInsets.only(left: 10.0),
                        //height: 38,
                        width: MediaQuery.of(context).size.width / 2,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          // alignment: AlignmentDirectional.centerStart,
                          icon: Visibility(
                              visible: false, child: Icon(Icons.arrow_downward)),
                          value: dropdownNewvalueShift,
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            hintText: "All Shifts",
                            hintStyle: TextStyle(
                                fontSize: 14.2, overflow: TextOverflow.ellipsis),
                            contentPadding: EdgeInsets.all(5),
                          ),
                          items: shiftList
                              ?.map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                '$value'!,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 10),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            shiftValue = newVal.toString();
                            var i = shiftList!.indexOf(shiftValue);
                            shift = shiftListModalGlobal!.data![i].shiftId!;
                            print("Shift ID $shift");
                            setState(() {
                              getSharedPrfanceList();
                              //print('value1 $i');
                              //print('value $policyidnew');

                              dropdownNewvalueShift = newVal;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (totalPresentEmp == 0 || totalPresentEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PresentEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(right: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: Mythemes.purplish,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$totalPresentEmp / $totalEmp"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.lightBluishColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                          child: Icon(
                                            Icons.groups,
                                            size: 58,
                                            color: Mythemes.lightBluishColor,
                                          )).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Attendance"
                                          .text
                                          .xl
                                          .color(Mythemes.lightBluishColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (totalAbsentEmp == 0 || totalAbsentEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AbsentEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(left: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: Mythemes.greenColor,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$totalAbsentEmp"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.dangerColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                        child: Icon(
                                          Icons.not_interested,
                                          size: 55,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Not In"
                                          .text
                                          .xl
                                          .color(Mythemes.dangerColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (misPunchEmp == 0 || misPunchEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MissPunchEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(right: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: Mythemes.redish,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$misPunchEmp"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.warningColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                          child: Icon(
                                            Icons.touch_app,
                                            size: 58,
                                            color: Mythemes.warningColor,
                                          )).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Mispunch"
                                          .text
                                          .xl
                                          .color(Mythemes.warningColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (onDuty == 0 || onDuty == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OnDutyEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(left: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          // color: Mythemes.lightBluishColor,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$onDuty"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.successColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                        child: Icon(
                                          Icons.business_center,
                                          size: 55,
                                          color: Mythemes.successColor,
                                        ),
                                      ).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "On Duty"
                                          .text
                                          .xl
                                          .color(Mythemes.successColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (lateIn == 0 || lateIn == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  LateInEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(right: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          // color: Mythemes.BluishColor,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$lateIn"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.alertColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                          child: Icon(
                                            Icons.assignment_late,
                                            size: 58,
                                            color: Mythemes.alertColor,
                                          )).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Late In"
                                          .text
                                          .xl
                                          .color(Mythemes.alertColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (earlyOutEmp == 0 || earlyOutEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EarlyGoEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(left: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: Mythemes.VoiletColor,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$earlyOutEmp"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.lightBluishColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                        child: Icon(
                                          Icons.directions_run,
                                          size: 55,
                                          color: Mythemes.lightBluishColor,
                                        ),
                                      ).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Early Go"
                                          .text
                                          .xl
                                          .color(Mythemes.lightBluishColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (halfEmp == 0 || halfEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  HalfDayEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(right: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: Mythemes.greenColor,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      "$halfEmp"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.warningColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                          child: Icon(
                                            Icons.calendar_month,
                                            size: 58,
                                            color: Mythemes.warningColor,
                                          )).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Half Day"
                                          .text
                                          .xl
                                          .color(Mythemes.warningColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (overTime == 0 || overTime == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this date.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OverTimeEmpList(dashboardModelGlobal!)));
                        }

                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mythemes.whitish,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //margin: EdgeInsets.only(left: 10.0),
                          height: 88,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: Mythemes.redAccent,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          .centered()
                                          .py8()
                                          .px8():
                                      overTime == null ? "0".text.xl2
                                          .bold
                                          .color(Mythemes.dangerColor)
                                          .make()
                                          .py8()
                                          .px8() :
                                      "$overTime"
                                          .text
                                          .xl2
                                          .bold
                                          .color(Mythemes.dangerColor)
                                          .make()
                                          .py8()
                                          .px8(),
                                      Container(
                                        child: Icon(
                                          Icons.timelapse,
                                          size: 55,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ).px8()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      "Over Time"
                                          .text
                                          .xl
                                          .color(Mythemes.dangerColor)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).pLTRB(0, 0, 0, 10.0),
              empRole == 1 || roRole == 1 ?
              DefaultTabController(
                length: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxHeight: 150.0),
                      child: Material(
                        color: Mythemes.whitish,
                        child: TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.cake,
                                color: Mythemes.blackishade,
                              ),
                              text: "Birthday",
                            ),
                            Tab(
                              icon: Icon(
                                Icons.cake,
                                color: Mythemes.blackishade,
                              ),
                              text: "Anniversary",
                            ),
                            Tab(
                              icon: Icon(
                                Icons.calendar_month,
                                color: Mythemes.blackishade,
                              ),
                              text: "Today events",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(children: [

                        Container(
                          // height: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            oldEventLength == null ? "There is no data available.".text.center.make().py16() :
                            ListView.builder(
                                //scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: eventsListModalGlobal!.bdayList!.length,
                                itemBuilder: (context, itemCount) {
                                  return Card(
                                    child: ListTile(
                                      //title: Text({_loginModel.data?.userLoginned?.name}==null ?' ': " Name "),
                                      title: Text(eventsListModalGlobal!
                                          .bdayList![itemCount].fullName
                                          .toString()),
                                      subtitle: Text(eventsListModalGlobal!
                                          .bdayList![itemCount].department
                                          .toString()),
                                      trailing: Text(eventsListModalGlobal!
                                          .bdayList![itemCount].dob
                                          .toString()),
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              eventsListModalGlobal!
                                                  .bdayList![itemCount].image
                                                  .toString()),
                                          backgroundColor: Colors.grey,
                                          // child: Image.network(imageString!),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Container(
                          // height: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            oldJobLength == null ? "There is no data available.".text.center.make().py16() :
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: eventsListModalGlobal!.joblist!.length,
                                itemBuilder: (context, itemCount) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(eventsListModalGlobal!
                                          .joblist![itemCount].fullName
                                          .toString()),
                                      subtitle: Text(eventsListModalGlobal!
                                          .joblist![itemCount].department
                                          .toString()),
                                      trailing: Text(eventsListModalGlobal!
                                          .joblist![itemCount].doj
                                          .toString()),
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              eventsListModalGlobal!
                                                  .joblist![itemCount].image
                                                  .toString()),
                                          backgroundColor: Colors.grey,
                                          // child: Image.network(imageString!),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Container(
                          // height: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                oldEvent != todayEvent ? "There is no data available.".text.make().py16() :

                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: eventsListModalGlobal!.bdayList!.length,
                                    itemBuilder: (context, itemCount) {

                                      return Card(
                                        child: ListTile(
                                          title: Text(eventsListModalGlobal!
                                              .bdayList![itemCount].fullName
                                              .toString()),
                                          subtitle: Text(eventsListModalGlobal!
                                              .bdayList![itemCount].department
                                              .toString()),
                                          trailing: Text(eventsListModalGlobal!
                                              .bdayList![itemCount].dob
                                              .toString()),
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  eventsListModalGlobal!
                                                      .bdayList![itemCount].image
                                                      .toString()),
                                              backgroundColor: Colors.grey,
                                              // child: Image.network(imageString!),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                oldJobEvent != todayEvent ? "".text.make() :

                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: eventsListModalGlobal!.joblist!.length,
                                    itemBuilder: (context, itemCount) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(eventsListModalGlobal!
                                              .joblist![itemCount].fullName
                                              .toString()),
                                          subtitle: Text(eventsListModalGlobal!
                                              .joblist![itemCount].department
                                              .toString()),
                                          trailing: Text(eventsListModalGlobal!
                                              .joblist![itemCount].doj
                                              .toString()),
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  eventsListModalGlobal!
                                                      .bdayList![itemCount].image
                                                      .toString()),
                                              backgroundColor: Colors.grey,
                                              // child: Image.network(imageString!),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ) :
              //TabSection(EventsListModal()!) :
              SizedBox(
                height: 0,
              )
              ,
            ],
          ),
        ),
      ),
    );
  }

  TabSection(EventsListModal eventsListModal) {
    var todayEvent;
    var oldEvent;
    var oldEventLength;
    var oldJobLength;
    var oldJobEvent;
    for(int i = 0; i < eventsListModalGlobal!.bdayList!.length; i++) {
      oldEvent = eventsListModalGlobal!.bdayList![i].dob;
      oldEventLength = eventsListModalGlobal!.bdayList!.length;
      print("oldEvent $oldEvent");
    }

    for(int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
      oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
      oldJobLength = eventsListModalGlobal!.joblist!.length;
      print("oldJobEvent $oldJobEvent");
    }

    todayEvent = DateTime.now();
    todayEvent = DateFormat('dd-MM-yyyy').format(date);
    print("Todayevent $todayEvent");

    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: Material(
              color: Mythemes.whitish,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.cake,
                      color: Mythemes.blackishade,
                    ),
                    text: "Birthday",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.cake,
                      color: Mythemes.blackishade,
                    ),
                    text: "Anniversary",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Mythemes.blackishade,
                    ),
                    text: "Today events",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [

              Container(
                // height: 1,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  isLoading
                      ? CircularProgressIndicator()
                      .centered()
                      .py1() :
                  oldEventLength == null ? "There is no data available.".text.center.make().py16() :
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: eventsListModalGlobal!.bdayList!.length,
                      itemBuilder: (context, itemCount) {
                        return Card(
                          child: ListTile(
                            //title: Text({_loginModel.data?.userLoginned?.name}==null ?' ': " Name "),
                            title: Text(eventsListModalGlobal!
                                .bdayList![itemCount].fullName
                                .toString()),
                            subtitle: Text(eventsListModalGlobal!
                                .bdayList![itemCount].department
                                .toString()),
                            trailing: Text(eventsListModalGlobal!
                                .bdayList![itemCount].dob
                                .toString()),
                            leading: Container(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    eventsListModalGlobal!
                                        .bdayList![itemCount].image
                                        .toString()),
                                backgroundColor: Colors.grey,
                                // child: Image.network(imageString!),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Container(
                // height: 1,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  isLoading
                      ? CircularProgressIndicator()
                      .centered()
                      .py8():
    oldJobLength == null ? "There is no data available.".text.center.make().py16() :
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: eventsListModalGlobal!.joblist!.length,
                      itemBuilder: (context, itemCount) {
                        return Card(
                          child: ListTile(
                            title: Text(eventsListModalGlobal!
                                .joblist![itemCount].fullName
                                .toString()),
                            subtitle: Text(eventsListModalGlobal!
                                .joblist![itemCount].department
                                .toString()),
                            trailing: Text(eventsListModalGlobal!
                                .joblist![itemCount].doj
                                .toString()),
                            leading: Container(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    eventsListModalGlobal!
                                        .joblist![itemCount].image
                                        .toString()),
                                backgroundColor: Colors.grey,
                                // child: Image.network(imageString!),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Container(
                // height: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      isLoading
                          ? CircularProgressIndicator()
                          .centered()
                          .py1():
                      oldEvent != todayEvent ? "There is no data available.".text.make().py16() :

                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: eventsListModalGlobal!.bdayList!.length,
                          itemBuilder: (context, itemCount) {

                            return Card(
                              child: ListTile(
                                title: Text(eventsListModalGlobal!
                                    .bdayList![itemCount].fullName
                                    .toString()),
                                subtitle: Text(eventsListModalGlobal!
                                    .bdayList![itemCount].department
                                    .toString()),
                                trailing: Text(eventsListModalGlobal!
                                    .bdayList![itemCount].dob
                                    .toString()),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        eventsListModalGlobal!
                                            .bdayList![itemCount].image
                                            .toString()),
                                    backgroundColor: Colors.grey,
                                    // child: Image.network(imageString!),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      isLoading
                          ? CircularProgressIndicator()
                          .centered()
                          .py8():
                      oldJobEvent != todayEvent ? "".text.make() :

                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: eventsListModalGlobal!.joblist!.length,
                          itemBuilder: (context, itemCount) {
                            return Card(
                              child: ListTile(
                                title: Text(eventsListModalGlobal!
                                    .joblist![itemCount].fullName
                                    .toString()),
                                subtitle: Text(eventsListModalGlobal!
                                    .joblist![itemCount].department
                                    .toString()),
                                trailing: Text(eventsListModalGlobal!
                                    .joblist![itemCount].doj
                                    .toString()),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        eventsListModalGlobal!
                                            .bdayList![itemCount].image
                                            .toString()),
                                    backgroundColor: Colors.grey,
                                    // child: Image.network(imageString!),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}