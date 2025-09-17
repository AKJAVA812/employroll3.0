import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:er_flutter_project/adminPage/modelClass/eventListModal.dart';
import 'package:er_flutter_project/commanScreen/homePage.dart';
import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:er_flutter_project/ess/EventsListModal.dart';
import 'package:er_flutter_project/ess/Model/absentEmpList.dart';
import 'package:er_flutter_project/ess/Model/earlyGoEmpList.dart';
import 'package:er_flutter_project/ess/Model/halfDayEmpList.dart';
import 'package:er_flutter_project/ess/Model/lateInEmpList.dart';
import 'package:er_flutter_project/ess/Model/missPunchempList.dart';
import 'package:er_flutter_project/ess/Model/onDutyEmpList.dart';
import 'package:er_flutter_project/ess/Model/overTimeEmpList.dart';
import 'package:er_flutter_project/ess/Model/presentEmpList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../commanScreen/allAPIList.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import 'dart:developer' as developer;

import '../adminPage/modelClass/dashboardModel.dart';
import '../adminPage/mssDashboard.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../modules/timeAndAttendance/calendarPage/attendanceRequetCalendar.dart';
import '../modules/timeAndAttendance/reports/attendanceRequisition/attendanceRequisition.dart';
import '../modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../modules/timeAndAttendance/reports/attendanceRequisition/model/onDateReportModel.dart';
import '../modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import '../profiles/profilePageWithHead.dart';
import 'Model/calendarModalClass.dart';
import 'Model/holidaylistEssModal.dart';



class EssAdminDashboard extends StatefulWidget {
  final EssDashboarrdModel dashboardModel1N;

  EssAdminDashboard(this.dashboardModel1N);

  @override
  State<EssAdminDashboard> createState() => _EssAdminDashboardState(dashboardModel1N);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? userPanel;
EssDashboarrdModel? essDashboardModelGlobal;
CalendarModalClass? calendarModalGlobal;
EssEventsListModal? eventsListModalGlobal;
HolidayESSModal? holidayListModalGlobal;
DateTime date = DateTime.now();
var branchId = 0;
var shift = 0;
var singleDateString;
var eventSingleDateString;
var day = new DateTime.now();
var single = new DateFormat('dd');
var singleDay = single.format(day);
bool isLoading = true;
bool isLoadingEvent = true;
String valuenew = "listText";
String shiftValue = "listText";

class _EssAdminDashboardState extends State<EssAdminDashboard> {

  final EssDashboarrdModel EssdashboardModel1;

  _EssAdminDashboardState(this.EssdashboardModel1);
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  String userPanelPermission = "COMPANY_EMPLOYEE";
  dynamic formattedDate;
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();

  //String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  //String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  String _currentMonth = DateFormat('MM-yyyy').format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  List<Map<String, String>> _legends = [];

  var todayDate = "dd-mm-yyyy";
  int? totalAttendance;
  int? presentCount;
  int? paidDaysCount;
  int? totalDays;
  int? totalAbsentEmp;
  int? misPunchEmp;
  int? onDuty;
  int? lateIn;
  int? earlyOutEmp;
  int? halfEmp;
  int? shortLeaveCount;
  int? overTime;


  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    userPanel = await shared.getUserPanel();
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    userPanelPermission= await shared.getUserPanel();
    adminRole= await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');

    Future<EssDashboarrdModel> getEmployeeList11 = getDashboardData(sessionId!);
    Future<EssEventsListModal> getEmployeeList14 = getEventData(sessionId!);
    Future<HolidayESSModal> getHolidayList = getHolidayData(sessionId!);
    Future<CalendarModalClass> getCalendar = getCalendarData(sessionId!);

    getEmployeeList11.then((value) {
      setState(() {
        essDashboardModelGlobal = value;
        isLoading = false;
      });
      //print('Dashboard length ${essDashboardModelGlobal!.result!.length}');
    });

    getCalendar.then((value) {
      setState(() {
        calendarModalGlobal = value;
        isLoading = false;
      });
      //print('Dashboard length ${essDashboardModelGlobal!.result!.length}');
    });

    getEmployeeList14.then((value) {
      setState(() {
        eventsListModalGlobal = value;
        setState(() {
          isLoading = false; // End loading
        });
      });
      //print('employeeList00${eventsListModalGlobal!.bdayList!.length}');
    });
    getHolidayList.then((value) {
      setState(() {
        holidayListModalGlobal = value;
        setState(() {
          isLoading = false; // End loading
        });
      });
      //print('employeeList00${eventsListModalGlobal!.bdayList!.length}');
    });
    setState(() {
      if(empRole==1){
        showHide=true;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRole==0){
        showHide=false;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
    setState(() {
      loader();
    });


  }

  var showNoData;
  dynamic cardLoader = false;

  Future getTodayDate() async {
    singleDateString = DateTime.now();
    singleDateString = DateFormat('dd-MM-yyyy').format(date);
    //print("SingleDate $singleDateString");
    //dateController.text = DateFormat("dd-MM-yyyy").format(date);
    //  DateFormat.yMd().format(date!).toString();
    //print("todayDate $date");
  }

  Future<EssDashboarrdModel> getDashboardData(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.essDashboardAPi;

    //print('employeeList11: ${SessionId}');
    EssDashboarrdModel dashboardModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "branch=$branchId&"
        "shift=$shift&"
        "date=$singleDateString");
    final response = await http.post(urlapi);
    setState(() {
      isLoading = true; // Start loading
    });
    print('URL ${response.request}');
    print('response body ${response.body}');
    developer.log("response:- " ,name: response.body);

    mapResponse = json.decode(response.body);
    dashboardModel = EssDashboarrdModel.fromJson(mapResponse);
    return dashboardModel;
  }

  Future<HolidayESSModal> getHolidayData(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.holidayListEss;

    //print('employeeList11: ${SessionId}');
    HolidayESSModal holidayESSModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId");
    final response = await http.post(urlapi);
    setState(() {
      isLoading = true; // Start loading
    });
    print('Holiday URL ${response.request}');
    print('response body ${response.body}');
    developer.log("response:- " ,name: response.body);
    mapResponse = json.decode(response.body);
    var getData = mapResponse.length;
    if (getData == 0 )  {
      print("getData111 $getData");
      showNoData = true;
    }
    holidayESSModal = HolidayESSModal.fromJson(mapResponse);
    return holidayESSModal;
  }

  /*Future<CalendarModalClass> getCalendarData(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.calendarApi;
    print("Current Month - $_currentMonth");
    //print('employeeList11: ${SessionId}');
    CalendarModalClass calendarModalClass;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "month=$_currentMonth");
    final response = await http.post(urlapi);
    setState(() {
      isLoading = true; // Start loading
    });
    print('Calendar URL -  ${response.request}');
    print('response body ${response.body}');
    developer.log("response:- " ,name: response.body);

    mapResponse = json.decode(response.body);
    calendarModalClass = CalendarModalClass.fromJson(mapResponse);
    return calendarModalClass;
  }*/

  Future<CalendarModalClass> getCalendarData(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.calendarApi;
    print("Current Month - $_currentMonth");
    CalendarModalClass calendarModalClass;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "month=$_currentMonth");

    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final response = await http.post(urlapi);
      if (response.statusCode == 200) {
        print('Calendar URL - ${response.request}');
        print('response body ${response.body}');

        var mapResponse = json.decode(response.body);

        List<dynamic> data = mapResponse['data'];
        List<dynamic> legends = mapResponse['legends'];

        // Clear and rebuild _legends dynamically
        _legends = legends.map((legend) {
          return {
            "mobColor": legend["mobColor"].toString(),
            "status": legend["status"].toString(),
          };
        }).toList();

        _markedDateMap.clear();

        for (var event in data) {
          DateTime eventDate = DateTime.parse(event['logDate']);
          String title = event['status'] ?? "Event";
          String logDate = event['logDate'];
          String mobColor = event['mobColor'] ?? "0xff2196F3"; // Default color if not provided

          print("Color - $mobColor");
          // Add event to _markedDateMap
          _markedDateMap.add(
            eventDate,
            Event(
              date: eventDate,
              title: title,
              icon: _buildEventIcon(mobColor, logDate),
            ),
          );
        }
      } else {
        print('Failed to load calendar data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }

    calendarModalClass = CalendarModalClass.fromJson(mapResponse);
    return calendarModalClass;
  }

  // Helper function to build event icon
  Widget _buildEventIcon(String colorHex, String logDate) {
    return Container(
      width: 36, // Adjust size to fit the text
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(int.parse(colorHex)), // Parse color from string
      ),
      alignment: Alignment.center,
      child: Text(
        logDate.split('-').last, // Extract the day from 'logDate' (e.g., "01" from "2024-12-01")
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Future<EssEventsListModal> getEventData(String sessionId) async {
    setState(() {
      isLoadingEvent = true; // Show loader before fetching
    });

    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.eventListModalESSApi;

    print('employeeList11: $sessionId');

    EssEventsListModal eventsListModal;

    var urlapi = Uri.parse(
        "$conn$apiUrl?sessionId=$sessionId&"
            "branch=$branchId&"
            "shift=$shift&"
            "date=$singleDateString&"
            "userPermission=COMPANY_EMPLOYEE");

    final response = await http.post(urlapi);
    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    print('Body Data $mapResponse');

    eventsListModal = EssEventsListModal.fromJson(mapResponse);

    // assign to global
    eventsListModalGlobal = eventsListModal;

    setState(() {
      isLoadingEvent = false; // Hide loader AFTER everything is ready
    });

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

  static Widget _eventIcon = new Container(
    decoration:  BoxDecoration(
      //color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.blue, width: 4.0)),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      /*new DateTime(2024, 2, 1): [
        new Event(
          date: new DateTime(2024, 2, 1),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2024, 2, 1),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2024, 2, 1),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],*/
    },
  );

  @override
  void initState() {
    /*_markedDateMap.add(
        DateTime(2024, 12, 10),
        Event(
          date:  DateTime(2024, 12, 10),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        DateTime(2024, 12, 12),
        Event(
          date:  DateTime(2024, 12, 12),
          title: 'Event 4',
          icon: _eventIcon,
        ));*/
    super.initState();
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    todayDate = formatter.format(now);
    _scrollController = ScrollController();
    // Delay scroll start slightly to ensure build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
    getSharedPrfanceList();

    setState(() {
      if(empRole==1){
        showHide=true;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRole==0){
        showHide=false;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
    setState(() {});

    getTodayDate();

    // TODO: implement initState
  }
  int pageIndex = 0;
  int currentIndex = 2;
  var titleName = "My Dashboard";

  var holidayDate;
  var holidayLength;


  final Map<String, Color> punchColors = {
    "In": Colors.green,
    "Out": Colors.redAccent,
  };

  final List<Map<String, String>> punches = [
    {"type": "In", "time": "09:15 AM"},
    {"type": "Out", "time": "01:00 PM"},
    {"type": "In", "time": "02:00 PM"},
    {"type": "Out", "time": "06:30 PM"},
    {"type": "In", "time": "07:00 PM"},
    {"type": "Out", "time": "10:00 PM"},
  ];

  late final ScrollController _scrollController;
  late Timer _scrollTimer;
  final double scrollStep = 1.0; // how many pixels to scroll each tick
  final Duration scrollDuration = Duration(milliseconds: 30); // speed

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(scrollDuration, (_) {
      if (!_scrollController.hasClients) return;

     /* final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      print("Max - $maxScroll");
      print("Current - $currentScroll");
      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0); // Reset back to start
      } else {
        _scrollController.jumpTo(currentScroll + scrollStep);
      }*/
     /* for(double i=0 ;i>=10;i++){
        _scrollController.jumpTo(i);
      }*/

    });
  }

  void scrollToFirstPunch() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(

     /* appBar: AppBar(
        title: titleName.text.make(),
      ),*/
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
            singleDateString = DateFormat('dd-MM-yyyy').format(date);
            singleDay = DateFormat('dd').format(date);
            print("SingleDateNew $singleDateString");
            print("singleDay $singleDay");
            //dateController.text = DateFormat("dd").format(date!);

            //  DateFormat.yMd().format(date!).toString();
          });
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: singleDay.toString().text.color(Mythemes.whitish).make(),
      ),*/
      body: essDashboardModelGlobal == null
          ? loader()
          : RefreshIndicator(
          onRefresh: () {
            return getSharedPrfanceList();
          },
          child: DashboardWidgets(essDashboardModelGlobal!)),

      /*bottomNavigationBar:
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
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );
            print('Profile');
          }

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
      ),*/
    );
  }


  DashboardWidgets(EssDashboarrdModel dashboardModel) {
    paidDaysCount = essDashboardModelGlobal!.countData!.paidDaysCount;
    totalAttendance = essDashboardModelGlobal!.countData!.totalAtt;
    totalDays = essDashboardModelGlobal!.countData!.totalDays;
    totalAbsentEmp = essDashboardModelGlobal!.countData!.absentCount;
    misPunchEmp = essDashboardModelGlobal!.countData!.mispunch;
    lateIn = essDashboardModelGlobal!.countData!.late;
    earlyOutEmp = essDashboardModelGlobal!.countData!.earlygo;
    halfEmp = essDashboardModelGlobal!.countData!.halfday;
    shortLeaveCount = essDashboardModelGlobal!.countData!.shortlev;

    presentCount = (totalDays ?? 0) - (totalAbsentEmp ?? 0);
    print("Total Employees $totalAttendance");
    shift = 0;
    branchId = 0;
    int value = 0;

    var todayEvent;
    var oldEvent;
    var oldEventLength;
    var oldJobLength;
    var oldJobEvent;

    /*for(int i = 0; i < eventsListModalGlobal!.bdayList!.length; i++) {
      oldEvent = eventsListModalGlobal!.bdayList![i].dob;
      oldEventLength = eventsListModalGlobal!.bdayList!.length;
      print("oldEvent $oldEvent");
    }

    for(int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
      oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
      oldJobLength = eventsListModalGlobal!.joblist!.length;
      print("oldJobEvent $oldJobEvent");
    }*/

    if (eventsListModalGlobal?.bdayList != null) {
      for (int i = 0; i < eventsListModalGlobal!.bdayList!.length; i++) {
        oldEvent = eventsListModalGlobal!.bdayList![i].dob;
        oldEventLength = eventsListModalGlobal!.bdayList!.length;
        print("oldEvent $oldEvent");
      }
    } else {
      print("bdayList is null");
    }

    if (eventsListModalGlobal?.joblist != null) {
      for (int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
        oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
        oldJobLength = eventsListModalGlobal!.joblist!.length;
        print("oldJobEvent $oldJobEvent");
      }
    } else {
      print("joblist is null");
    }

    if (holidayListModalGlobal?.result == "success") {
      for (int i = 0; i < holidayListModalGlobal!.viewHolidayList!.length; i++) {
        holidayDate = holidayListModalGlobal!.viewHolidayList![i].dateOfHoliday;
        holidayLength = holidayListModalGlobal!.viewHolidayList!.length;
        print("Holiday Length $holidayLength");
      }
    } else {
      print("holiday list is null");
    }

    /*if(holidayListModalGlobal?.viewHolidayList!.length != null) {
      for (int i = 0; i < holidayListModalGlobal!.viewHolidayList!.length; i++) {
        holidayLength = holidayListModalGlobal!.viewHolidayList!.length;
      }
    }*/

    //final repeatedPunches = List.generate(20, (_) => punches).expand((x) => x).toList();
    final double cardWidth = MediaQuery.of(context).size.width * 0.3;

    todayEvent = DateTime.now();
    todayEvent = DateFormat('dd-MM-yyyy').format(date);
// Repeat data enough times to scroll indefinitely
    final repeatedPunches = List.generate(
      1000,
          (index) => punches[index % punches.length],
    );


    return DismissKeyboard(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
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
                          Navigator.pushNamed(context, MyRoutings.mssNewDashboardRoute);
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
             /* Visibility(
                visible: showRo  || showAdmin,
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
                      },
                    )
                  ],
                ),
              ),*/
              /*Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  "Today's Punches".text.align(TextAlign.left).bold.make(),
                ],
              ).pLTRB(10, 10, 10, 5),*/

          /*SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: punches.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final punch = punches[index];
                final type = punch["type"]!;
                final time = punch["time"]!;
                final color = punchColors[type] ?? Colors.blue;

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Mythemes.lightBluishColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Mythemes.lightBluishColor, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Mythemes.whitish,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Mythemes.whitish,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ).pLTRB(6, 6, 6, 2),*/
          /*Container(
            color: Colors.white,
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: repeatedPunches.length,
              itemBuilder: (context, index) {
                final item = repeatedPunches[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${item['type']} - ${item['time']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: punchColors[item['type']] ?? Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),*/

          /*Container(
            color: Colors.white,
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(), // 💡 Enables manual scroll
              itemCount: repeatedPunches.length,
              itemBuilder: (context, index) {
                final punch = repeatedPunches[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Chip(
                    backgroundColor: Colors.grey.shade200,
                    label: Text(
                      "${punch['type']} - ${punch['time']}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: punch['type'] == 'In' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),*/
              /*Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  scrollToFirstPunch();
                }, icon: Icon(Icons.arrow_left_outlined)),
              ),*/
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
                        if (presentCount == 0 || presentCount == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this month.",
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
                                  PresentEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          : "$presentCount / $totalDays"
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
                              msg: "There is no data available for this month.",
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
                                  AbsentEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
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
                                      "Absent"
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
                              msg: "There is no data available for this month.",
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
                                  MissPunchEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
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
                        if (totalAttendance == 0 || totalAttendance == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this month.",
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
                                  OnDutyEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
                                      "$totalAttendance"
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
                                      "Working Days"
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
                        if (earlyOutEmp == 0 || earlyOutEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this month.",
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
                                  EarlyGoEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (lateIn == 0 || lateIn == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this month.",
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
                                  LateInEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (overTime == 0 || overTime == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this month.",
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
                                  OverTimeEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
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
                                      "Short Leave"
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (halfEmp == 0 || halfEmp == null) {
                          Fluttertoast.showToast(
                              msg: "There is no data available for this month.",
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
                                  HalfDayEmpList(essDashboardModelGlobal!)));
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
                                          .px8()
                                          :
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
                ],
              ),
              SizedBox(
                height: 0,
              ),

              CalendarShow(),

              empRole == 1 || roRole == 1 ?
              /*DefaultTabController(
                length: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints(maxHeight: 150.0),
                      child: Material(
                        color: Mythemes.whitish,
                        child: TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.celebration,
                                color: Mythemes.blackishade,
                              ),
                              text: "Birthday",
                            ),
                            Tab(
                              icon: Icon(
                                Icons.workspace_premium_rounded,
                                color: Mythemes.blackishade,
                              ),
                              text: "Work Anniversary",
                            ),
                            Tab(
                              icon: Icon(
                                Icons.today,
                                color: Mythemes.blackishade,
                              ),
                              text: "Today events",
                            ),
                            Tab(
                              icon: Icon(
                                Icons.holiday_village,
                                color: Mythemes.blackishade,
                              ),
                              text: "Holidays",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(children: [

                        //Birthday
                        Container(
                          // height: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            isLoading
                                ? CircularProgressIndicator()
                                .centered()
                                .py8()
                                .px8():
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
                        //Work Anievarsary
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
                        //Today Events
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
                                    .py8():
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
                        //Holiday
                        Container(
                          // height: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            isLoading
                                ? CircularProgressIndicator()
                                .centered()
                                .py8():
                            holidayLength == null ? "There is no data available.".text.make().py16() :

                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: holidayLength,
                                itemBuilder: (context, itemCount) {

                                  return Card(
                                    child: ListTile(
                                      title: Text(holidayListModalGlobal!
                                          .viewHolidayList![itemCount].holidayName
                                          .toString()),
                                      subtitle: Text(holidayListModalGlobal!
                                          .viewHolidayList![itemCount].dateOfHoliday
                                          .toString()),
                                      trailing: Text(holidayListModalGlobal!
                                          .viewHolidayList![itemCount].holidayType
                                          .toString()),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              )*/
              DefaultTabController(
                length: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // TabBar
                    Material(
                      color: Mythemes.whitish,
                      child: TabBar(
                        indicatorColor: Colors.deepPurple,
                        indicatorWeight: 4,
                        labelColor: Colors.deepPurple,
                        unselectedLabelColor: Mythemes.blackishade,
                        tabs: const [
                          Tab(icon: Icon(Icons.celebration), text: "Birthday"),
                          Tab(icon: Icon(Icons.workspace_premium_outlined), text: "Work Anniversary"),
                          Tab(icon: Icon(Icons.today), text: "Today Events"),
                          Tab(icon: Icon(Icons.holiday_village), text: "Holidays"),
                        ],
                      ),
                    ),

                    // Tab Views
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        children: [
                          // 🎂 Birthday Tab
                          buildEventList(
                            isLoading: isLoadingEvent,
                            items: eventsListModalGlobal?.bdayList ?? [],
                            emptyText: "No birthdays today 🎉",
                            titleBuilder: (item) => item.fullName,
                            subtitleBuilder: (item) => item.department,
                            trailingBuilder: (item) => item.dob,
                            imageBuilder: (item) => item.image,
                          ),

                          // 🏅 Anniversary Tab
                          buildEventList(
                            isLoading: isLoadingEvent,
                            items: eventsListModalGlobal?.joblist ?? [],
                            emptyText: "No anniversaries today 🎊",
                            titleBuilder: (item) => item.fullName,
                            subtitleBuilder: (item) => item.department,
                            trailingBuilder: (item) => item.doj,
                            imageBuilder: (item) => item.image,
                          ),



                          // 📅 Today Events Tab (combine lists)

                            /*  buildEventList(
                                isLoading: isLoadingEvent,
                                items: eventsListModalGlobal?.bdayList ?? [],
                                emptyText: "No events today 🎂",
                                titleBuilder: (item) => item.fullName,
                                subtitleBuilder: (item) => item.department,
                                trailingBuilder: (item) => item.dob,
                                imageBuilder: (item) => item.image,
                              ),*/

                              buildEventList(
                                isLoading: isLoadingEvent,
                                items: eventsListModalGlobal?.joblist ?? [],
                                emptyText: "No events today 🎂",
                                titleBuilder: (item) => item.fullName,
                                subtitleBuilder: (item) => item.department,
                                trailingBuilder: (item) => item.doj,
                                imageBuilder: (item) => item.image,
                              ),

                          buildHolidayList(
                            isLoading: isLoadingEvent,
                            items: holidayListModalGlobal!
                                .viewHolidayList ?? [],
                            emptyText: "No Holidays",
                            holidayName: (item) => item.holidayName,
                            holidayDate: (item) => item.dateOfHoliday,
                            holidayType: (item) => item.holidayType,
                          ),

                        ],
                      ),
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

  Widget buildHolidayList<T>({
    required bool isLoading,
    required List<T> items,
    required String emptyText,
    required String Function(T) holidayName,
    required String Function(T) holidayType,
    required String Function(T) holidayDate,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),

            title: Text(
              holidayName(item),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              holidayDate(item),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            trailing: Text(
              holidayType(item),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildEventList<T>({
    required bool isLoading,
    required List<T> items,
    required String emptyText,
    required String Function(T) titleBuilder,
    required String Function(T) subtitleBuilder,
    required String Function(T) trailingBuilder,
    required String Function(T) imageBuilder,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(imageBuilder(item)),
              backgroundColor: Colors.grey[200],
            ),
            title: Text(
              titleBuilder(item),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              subtitleBuilder(item),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            trailing: Text(
              trailingBuilder(item),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ),
        );
      },
    );
  }

CalendarShow() {
  /// Example with custom icon
  final _calendarCarousel = Container(
    constraints: BoxConstraints(
      maxHeight: 300.0, // Set a valid maximum height
    ),
    child: CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
      headerText: 'Custom Header',
      weekFormat: true,
      markedDatesMap: _markedDateMap,
      height: 300.0, // Provide a valid height
      selectedDateTime: _currentDate2,
      showIconBehindDayText: true,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Mythemes.lightBluishColor,
      ),
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      markedDateMoreShowTotal: true,
    ),
  );

  /// Example Calendar Carousel without header and custom prev & next button
  final _calendarCarouselNoHeader = CalendarCarousel<Event>(
    todayBorderColor: Mythemes.lightBluishColor,
    onDayPressed: (date, events) {

      this.setState(() => _currentDate = date);
      this.setState(() => _currentDate2 = date);
      events.forEach((event) => print(event.title));
      print(date);
      setState(() {
        formattedDate = DateFormat('dd-MM-yyyy').format(_currentDate);
        print("Formatted Date - $formattedDate");
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
          AttendanceRequisitionCalendar(new AttendanceReportModel(), OnDateAttModel(),0, "$formattedDate")));
      //Nevigate Next Page

    },
    daysHaveCircularBorder: true,
    showOnlyCurrentMonthDate: false,
    weekendTextStyle: TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    thisMonthDayBorderColor: Colors.grey,
    weekFormat: false,
    //firstDayOfWeek: 4,
    markedDatesMap: _markedDateMap,
    height: 300.0,
    selectedDateTime: _currentDate2,
    targetDateTime: _targetDateTime,
    customGridViewPhysics: NeverScrollableScrollPhysics(),

    markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: Colors.grey)),
    markedDateCustomTextStyle: TextStyle(
      fontSize: 18,
      color: Colors.amberAccent,
    ),
    showHeader: false,
    todayTextStyle: TextStyle(
      color: Colors.white,
    ),
    markedDateShowIcon: true,
    markedDateIconMaxShown: 2,
    markedDateIconBuilder: (event) {
      return event.icon;
    },
    markedDateMoreShowTotal: true,
    todayButtonColor: Mythemes.lightBluishColor,
    selectedDayTextStyle: TextStyle(
      color: Mythemes.whitish,
    ),
    //minSelectedDate: _currentDate.subtract(Duration(days: 360)),
    //maxSelectedDate: _currentDate.add(Duration(days: 360)),
    prevDaysTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.pinkAccent,
    ),
    inactiveDaysTextStyle: TextStyle(
      color: Colors.tealAccent,
      fontSize: 20,
    ),
    onCalendarChanged: (DateTime date) {
      _targetDateTime = date;
      _currentMonth = DateFormat('MM-yyyy').format(_targetDateTime);
      //_currentMonth = DateFormat.yMMM().format(_targetDateTime);
      print('change date $date.month$_targetDateTime');
      singleDateString = DateFormat('dd-MM-yyyy').format(date);
      print("Updated Date Change - $singleDateString");
      getSharedPrfanceList();
      setState(() {
        Future<CalendarModalClass> getCalendar = getCalendarData(sessionId!);
        getCalendar.then((value) {
          setState(() {
            calendarModalGlobal = value;
          });
          //print('Dashboard length ${essDashboardModelGlobal!.result!.length}');
        });
        //API month change call
      });
    },
    onDayLongPressed: (DateTime date) {
      print('long pressed date $date');
    },
  );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //custom icon
         /* Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: _calendarCarousel,
          ),*/ // This trailing comma makes auto-formatting nicer for build methods.
          //custom icon without header
          Container(
            margin: EdgeInsets.only(
              top: 30.0,
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: new Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 24.0,
                      ),
                    )),
                TextButton(
                  child: Text('PREV'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month - 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                ),
                TextButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 22.0),
            child: _calendarCarouselNoHeader,
          ), //
          if (_legends.isNotEmpty)
            LegendWidget(legends: _legends), // Dynamically show legends
          if (isLoading)
            CircularProgressIndicator(),
        ],
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
      //print("oldEvent $oldEvent");
      //developer.log("message",name: oldJobEvent);
    }

    for(int i = 0; i < eventsListModalGlobal!.joblist!.length; i++) {
      oldJobEvent = eventsListModalGlobal!.joblist![i].doj;
      oldJobLength = eventsListModalGlobal!.joblist!.length;
      print("oldJobEvent $oldJobEvent");
    }

    todayEvent = DateTime.now();
    todayEvent = DateFormat('dd-MM-yyyy').format(date);
    //print("Todayevent $todayEvent");

    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(maxHeight: 150.0),
            child: Material(
              color: Mythemes.whitish,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.celebration,
                      color: Mythemes.blackishade,
                    ),
                    text: "Birthday",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.workspace_premium_rounded,
                      color: Mythemes.blackishade,
                    ),
                    text: "Work Anniversary",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Mythemes.blackishade,
                    ),
                    text: "Today events",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.holiday_village,
                      color: Mythemes.blackishade,
                    ),
                    text: "Holidays",
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

class LegendWidget extends StatelessWidget {
  final List<Map<String, String>> legends;

  LegendWidget({required this.legends});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Wrap(
        spacing: 16, // Space between items
        runSpacing: 8, // Space between rows
        children: legends.map((legend) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(int.parse(legend['mobColor']!)), // Parse color
                ),
              ),
              SizedBox(width: 8), // Space between circle and text
              Text(
                legend['status']!,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ).py1();
        }).toList(),
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