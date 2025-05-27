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
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/routes.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../sharedPrefancePage/ShardPre.dart';

class UIS_Dashboard extends StatefulWidget {
  final DashboardModel dashboardModel1;

  UIS_Dashboard(this.dashboardModel1);

  @override
  State<UIS_Dashboard> createState() => _UIS_DashboardState(dashboardModel1);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? userPanelPermission;
DashboardModel? dashboardModelGlobal;
BranchListModal? branchListModalGloabal;
ShiftListModal? shiftListModalGlobal;
EventsListModal? eventsListModalGlobal;
DateTime date = DateTime.now();
var branchId = 0;
var shift = 0;
var singleDateString;
var eventSingleDateString;
var day = new DateTime.now();
var single = new DateFormat('dd');
var singleDay = single.format(day);
late List<String?> list = [];
late List<String?> branchList = [];
late List<String?>? shiftList = [];
bool isLoading = true;
String valuenew = "listText";
String shiftValue = "listText";
class _UIS_DashboardState extends State<UIS_Dashboard> {
  final DashboardModel dashboardModel1;

  _UIS_DashboardState(this.dashboardModel1);
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
    setState(() {
      isLoading = true; // Start loading
    });
    sessionId = await shared!.getSessionId();
    userPanelPermission = await shared!.getUserPanel();
    Future<DashboardModel> getEmployeeList11 = getDashboardData(sessionId!);
    Future<BranchListModal> getEmployeeList12 = getBranchList(sessionId!);
    Future<ShiftListModal> getEmployeeList13 = getShiftList(sessionId!);
    Future<EventsListModal> getEmployeeList14 = getEventData(sessionId!);
    getEmployeeList11.then( (value) {
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

    setState(() async {
      empRole= await shared.getEmpRoll();
      roRole= await shared.getRoRole();
      //print('EmpRole $empRole');
      //print('roRole $roRole');
    });

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

    print('BRANCH URL ${response.request}');
    //print('response body ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    //print('Body Data $getData');
    branchListModal = BranchListModal.fromJson(mapResponse);
    for (int i = 0; i < branchListModal!.data!.length; i++) {
      var branchName = branchListModal!.data![i].branchName;
      branchList?.add(branchListModal!.data![i].branchName);
      //print('branchNameNew $branchName');
    }
    return branchListModal;
  }

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
  int pageIndex = 0;
  int currentIndex = 3;
  var titleName = "Dashboard";
  void _handleOption1(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Option 1 Selected')));
  }

  void _handleOption2(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Option 2 Selected')));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    //queryData = MediaQuery.of(context).size.width/2;
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
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
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            builder: (context) => FilterBottomSheet(),
          );
        },
        child: Icon(Icons.filter_list),
      ),
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$titleName - ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Mythemes.successColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'HR Manager - 1005',
                    style: TextStyle(
                      color: Mythemes.whitish,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'HR Manager - 1005') {
                _handleOption1(context);
              } else if (value == 'Reporting Manager - 1005') {
                _handleOption2(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'HR Manager - 1005',
                child: Text('HR Manager - 1005'),
              ),
              const PopupMenuItem<String>(
                value: 'Reporting Manager - 1005',
                child: Text('Reporting Manager - 1005'),
              ),
            ],
          ),
        ],
      ),
      body: dashboardModelGlobal == null
          ? loader()
          : RefreshIndicator(
          onRefresh: () {
            return getSharedPrfanceList();
          },
          child: DashboardWidgets(dashboardModelGlobal!)),

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
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.reportSectionHead);
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
            icon: Icon(Icons.pending_actions),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
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
    int value = 1;

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

    /*for(int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
      oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
      oldJobLength = eventsListModalGlobal!.joblist!.length;
      print("oldJobEvent $oldJobEvent");
    }
*/
    todayEvent = DateTime.now();
    todayEvent = DateFormat('dd-MM-yyyy').format(date);
    print("Todayevent $todayEvent");
    return DismissKeyboard(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: userPanelPermission == "MSS",
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
                          Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                        }
                        if(value == 0) {
                          Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
                        }
                      },
                    )
                  ],
                ),
              ),
              Visibility(
                visible: userPanelPermission == "MSS_MO_ADMIN",
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
                          Navigator.pushNamed(context, MyRoutings.mssMoNewDashboardRoute);
                        }
                        if(value == 0) {
                          Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
                        }
                      },
                    )
                  ],
                ),
              ),
              /*Row(
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
                        width: MediaQuery.of(context).size.width / 2,
                        child: Container(
                          child: Center(
                            child: DropdownButtonFormField(
                              alignment: AlignmentDirectional.centerStart,
                              icon: Visibility(
                                  visible: false,
                                  child: Icon(Icons.arrow_downward)),
                              value: dropdownNewvalue,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "All Branches",
                                hintStyle: TextStyle(
                                  fontSize: 14.2,
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                              items: branchList?.map<DropdownMenuItem<String>>(
                                      (String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text('$value'!, style: TextStyle(fontSize: 10)),
                                    );
                                  }).toList(),
                              onChanged: (newVal) {
                                valuenew = newVal.toString();
                                var i = branchList!.indexOf(valuenew);
                                branchId = branchListModalGloabal!.data![i].branchId!;
                                print("Branch ID $branchId");
                                setState(() {
                                  getSharedPrfanceList();


                                  dropdownNewvalue = newVal;
                                });
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


                              dropdownNewvalueShift = newVal;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Mythemes.whitish,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonFormField<int>(
                          isExpanded: true,
                          icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                          value: dropdownNewvalue, // Ensure this is initialized properly
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "All Branches",
                            hintStyle: TextStyle(fontSize: 14.2),
                            contentPadding: EdgeInsets.all(5),
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text("All Branches", style: TextStyle(fontSize: 10)),
                            ),
                            ...?branchListModalGloabal?.data?.map<DropdownMenuItem<int>>((branch) {
                              return DropdownMenuItem<int>(
                                value: branch.branchId, // Use branchId as the unique value
                                child: Text(
                                  branch.branchName!.trim(), // Ensure clean display
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (newVal) {
                            branchId = newVal!;
                            print("Branch ID $branchId");

                            setState(() {
                              getSharedPrfanceList();
                              dropdownNewvalue = newVal;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Mythemes.whitish,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonFormField<int>(
                          isExpanded: true,
                          icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                          value: dropdownNewvalueShift, // Ensure this is initialized properly
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "All Shifts",
                            hintStyle: TextStyle(fontSize: 14.2, overflow: TextOverflow.ellipsis),
                            contentPadding: EdgeInsets.all(5),
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text("All Shifts", style: TextStyle(fontSize: 10)),
                            ),
                            ...?shiftListModalGlobal?.data?.map<DropdownMenuItem<int>>((shift) {
                              return DropdownMenuItem<int>(
                                value: shift.shiftId, // Use shiftId as the unique value
                                child: Text(
                                  shift.shiftName!.trim(), // Remove unnecessary spaces/tabs
                                  style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 10),
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (newVal) {
                            shift = newVal!;
                            print("Shift ID $shift");

                            setState(() {
                              getSharedPrfanceList();
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
                            isLoading
                                ? SizedBox(
                              width: 24, // Set width
                              height: 24, // Set height
                                  child: CircularProgressIndicator(strokeWidth: 3).centered(),
                                ):
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
                                .py1():
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
                                    .py8() :
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
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedOrg;
  DateTime? selectedDate;
  String? selectedDateFormatted;
  final List<String> organizations = ['Org A', 'Org B', 'Org C'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // Increased height
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            'Filter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          /// Organization Dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select Organization',
              border: OutlineInputBorder(),
            ),
            value: selectedOrg,
            items: organizations.map((org) {
              return DropdownMenuItem(
                value: org,
                child: Text(org),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOrg = value;
              });
            },
          ),
          SizedBox(height: 8),

          /// Date Picker Field
          GestureDetector(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(1947),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                  selectedDateFormatted = DateFormat('dd-MM-yyyy').format(pickedDate);
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  hintText: 'dd-mm-yyyy',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: selectedDateFormatted ?? '',
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

          /// Filter Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                print("Selected Org: $selectedOrg");
                print("Selected Date: $selectedDateFormatted");
              },
              icon: Icon(Icons.filter_alt),
              label: Text("Apply Filter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mythemes.successColor,
              ),
            ),
          ),
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