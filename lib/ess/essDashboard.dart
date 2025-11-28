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
import 'package:er_flutter_project/ess/todayEventListModal.dart';
import 'package:er_flutter_project/ess/todayPunchesModal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
final DateTime _today = DateTime.now();
final DateTime _minDateAllowed = DateTime(_today.year, _today.month - 2); // 2 months before
final DateTime _maxDateAllowed = DateTime(_today.year, _today.month + 1); // 1 month ahead

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
dynamic orgId;
dynamic currentDateCheck;
dynamic lastSavedDateCheck;
String? userPanel;
EssDashboarrdModel? essDashboardModelGlobal;
CalendarModalClass? calendarModalGlobal;
EssEventsListModal? eventsListModalGlobal;
HolidayESSModal? holidayListModalGlobal;
TodayEventListModal? todayEventModalGlobal;
TodayPunchesModal? todayPunchesModalGlobal;
DateTime date = DateTime.now();
var branchId = 0;
var shift = 0;
var singleDateString;
var todayDateFetch;
var eventSingleDateString;
var day = new DateTime.now();
var single = new DateFormat('dd');
var singleDay = single.format(day);
bool isLoading = true;
bool isLoadingEvent = true;
bool isLoadingTodayEvent = true;
bool isLoadingTodayPunch = true;
String valuenew = "listText";
String shiftValue = "listText";
List<dynamic> data=[];
var calendarSendData;

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

  var deadlineStartDate;
  var deadlineEndDate;
  String lockDateStr="";


  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    orgId = await shared.getOrgId();
    userPanel = await shared.getUserPanel();
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    userPanelPermission= await shared.getUserPanel();
    adminRole= await shared.getAdminRole();
    deadlineStartDate = await shared.getPayCycleStart() ?? "0";
    deadlineEndDate = await shared.getPayCycleEnd() ?? "0";
    lockDateStr = await shared.getRaiseRequisition() ?? "0";
    //lockDateStr = "20-11-2025 11:59 PM";

    print("Start Pay ${lockDateStr.isEmpty}");
    print("End Pay $deadlineEndDate");

    //print('empRole $empRole');
    //print('roRole $roRole');
    //print('adminRole $adminRole');

    //Future<EssDashboarrdModel> getEmployeeList11 = getDashboardData(sessionId!);
    getRealTimeAttButtonShow = true;
    getRealTimeAttShow = false;
    /*getEmployeeList11.then((value) {
      setState(() {
        essDashboardModelGlobal = value;
        isLoading = false;
      });

    });*/
    //Future<TodayPunchesModal> getTodayPunch = getTodayPunchData(sessionId!);
    /*Future<EssEventsListModal?> getEmployeeList14 = getEventData(sessionId!);
    Future<HolidayESSModal> getHolidayList = getHolidayData(sessionId!);
    Future<TodayEventListModal> getTodayEventList = getTodayEventData(sessionId!);*/
    /*Future<CalendarModalClass> getCalendar = getCalendarData(sessionId!);


    getCalendar.then((value) {
      setState(() {
        calendarModalGlobal = value;
        isLoading = false;
      });

    });*/
    checkAndRunApi();
    /*getEmployeeList14.then((value) {
      setState(() {
        eventsListModalGlobal = value;
        setState(() {
          isLoading = false; // End loading
        });
      });

    });
    getHolidayList.then((value) {
      setState(() {
        holidayListModalGlobal = value;
        setState(() {
          isLoading = false; // End loading
        });
      });

    });
    getTodayEventList.then((value) {
      setState(() {
        todayEventModalGlobal = value;
        setState(() {
          isLoading = false; // End loading
        });
      });

    });*/
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
    todayDateFetch = DateTime.now();
    singleDateString = DateFormat('dd-MM-yyyy').format(date);
    todayDateFetch = DateFormat('dd-MM-yyyy').format(date);
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
    // ✅ Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashboardData', jsonEncode(mapResponse));
    return dashboardModel;
  }

  /*Future<HolidayESSModal> getHolidayData(String sessionId) async {
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
  }*/

  Future<HolidayESSModal?> getHolidayData(String sessionId) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.holidayListEss;

      var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");

      final response = await http.post(urlapi);

      print('Holiday URL: ${response.request}');
      print('Response body: ${response.body}');
      developer.log("Response :- ", name: response.body);

      final mapResponse = json.decode(response.body);

      // ✅ Handle empty data
      if (mapResponse == null || mapResponse.isEmpty) {
        print("No holiday data found");
        showNoData = true;
        setState(() {
          isLoading = false;
        });
        return null;
      }

      // ✅ Convert response to model
      final holidayESSModal = HolidayESSModal.fromJson(mapResponse);

      // ✅ Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('holidayData', jsonEncode(mapResponse));

      print("✅ Holiday data saved to SharedPreferences");

      return holidayESSModal;
    } catch (e) {
      print("❌ Error fetching holiday data: $e");
      return null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  /*Future<CalendarModalClass> getCalendarData(String sessionId) async {
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
  }*/
  Future<CalendarModalClass> getCalendarData(String sessionId) async {
    String _currentMonthc = DateFormat('MM-yyyy').format(DateTime.now());
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.calendarApi;
    print("Current Month - $_currentMonth $_currentMonthc");

    CalendarModalClass calendarModalClass;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "month=$_currentMonth");
    setState(() {
      isLoading = true;
    });
    print("Calendar Data - $urlapi");
    Map<String, dynamic> mapResponse = {};

    final prefs = await SharedPreferences.getInstance();

    // ✅ STEP 1: Try loading from SharedPreferences first
    if(_currentMonthc==_currentMonth){

      final cachedData = prefs.getString('calendarData');
      final cachedMonth = prefs.getString('calendarMonth');


      print("Calendar Month - $cachedMonth");

      if (cachedData != null) {
        print("Cachded Month $cachedMonth");
        try {
          //print("Loaded calendar data from cache ✅");
          mapResponse = json.decode(cachedData);
          _buildCalendarFromMap(mapResponse);
        } catch (e) {
          //print("Error loading cached calendar: $e");
        }
      }
    }

    // ✅ STEP 2: Now call API (refresh data and overwrite cache)
    try {
      final response = await http.post(urlapi);
      if (response.statusCode == 200) {

        mapResponse = json.decode(response.body);

        print("Calendar URL - ${response.request}");

        // Save to SharedPreferences
        if(_currentMonthc==_currentMonth){
          await prefs.setString('calendarData', json.encode(mapResponse));
          await prefs.setString('calendarMonth', _currentMonth);
        }
        //Need to un comment this for deadline requisition restriction
        /*String raiseDate = mapResponse['raisedDeadlineDate'];
        shared.setRaiseRequisition(raiseDate);
        print('object raised $raiseDate');*/
        // ✅ Rebuild UI from fresh API data
        _buildCalendarFromMap(mapResponse);
      } else {
        print("Calendar URL - ${response.request}");
        print('Failed to load calendar data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error calling calendar API: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    calendarModalClass = CalendarModalClass.fromJson(mapResponse);
    return calendarModalClass;
  }

// 🔧 Helper method to rebuild UI from any map data (API or cache)
  void _buildCalendarFromMap(Map<String, dynamic> mapResponse) {
    try {
      data = mapResponse['data'] ?? [];
      List<dynamic> legends = mapResponse['legends'] ?? [];

      // Build legends
      _legends = legends.map((legend) {
        String mobColor = (legend["mobColor"] != null &&
            legend["mobColor"].toString().trim().isNotEmpty)
            ? legend["mobColor"].toString()
            : "0xffaf9f6";
        return {
          "mobColor": mobColor,
          "status": legend["status"].toString(),
          "statusName": legend["statusName"].toString(),
        };
      }).toList();

      // Build marked dates
      _markedDateMap.clear();
      //print("Calendar Mark Date - $_markedDateMap");

      for (var event in data) {
        DateTime eventDate = DateTime.parse(event['logDate']);
        String title = event['status'] ?? "Event";
        String logDate = event['logDate'];
        String mobColor = (event["mobColor"] != null &&
            event["mobColor"].toString().trim().isNotEmpty)
            ? event["mobColor"].toString()
            : "0xffaf9f6";
        //print("Calendar event data - $eventDate");

        _markedDateMap.add(
          eventDate,
          Event(
            date: eventDate,
            title: title,
            icon: _buildEventIcon(mobColor, logDate),
          ),
        );
      }
    } catch (e) {
      print("Error parsing calendar data: $e");
    }

    setState(() {}); // Refresh UI
  }

  // Helper function to build event icon
  Widget _buildEventIcon(String colorHex, String logDate) {
    //print('_buildEventIcon $colorHex');
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
          color: int.parse(colorHex) == 0xFFFFFF00 ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /*Future<EssEventsListModal> getEventData(String sessionId) async {
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
  }*/

  static const String _lastApiCallKey = 'lastApiCallDate';

  /// Call this before executing your daily API
/*  static Future<bool> shouldRunApi() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastCallDate = prefs.getString(_lastApiCallKey);
    //prefs.remove(_lastApiCallKey);
    // Get current date in yyyy-MM-dd format
    final String currentDate = DateTime.now().toIso8601String().split('T')[0];

    if (lastCallDate == currentDate) {
      // ✅ API already called today
      print('API already called today ($currentDate). Skipping call.');
      isLoading =false;
      return false;
    } else {
      // 🆕 Update date and allow API call
      await prefs.setString(_lastApiCallKey, currentDate);
      print('Running API for new date: $currentDate');
      return true;
    }
  }*/

  // ===============================================================
  // ✅ MAIN METHOD - Check and Run API only once per day
  // ===============================================================
  /*void checkAndRunApi() async {
    bool runApi = await shouldRunApi();

    if (runApi) {
      // ✅ Run API only if needed
      print("🔄 Running API for today...");

      Future<EssEventsListModal?> getEmployeeList14 =
      getEventData(sessionId!);

      Future<TodayEventListModal> getTodayEventList =
      getTodayEventData(sessionId!);

      Future<HolidayESSModal?> getHolidayList = getHolidayData(sessionId!);
      Future<CalendarModalClass> getCalendar = getCalendarData(sessionId!);
      Future<EssDashboarrdModel> getEmployeeList11 = getDashboardData(sessionId!);
      getEmployeeList11.then((value) {
        setState(() {
          essDashboardModelGlobal = value;
          isLoading = false;
        });

      });

      getCalendar.then((value) {
        setState(() {
          calendarModalGlobal = value;
          isLoading = false;
        });

      });

      getHolidayList.then((value) {
        setState(() {
          holidayListModalGlobal = value;
          setState(() {
            isLoading = false; // End loading
            isLoadingTodayEvent = false;
          });
        });

      });

      getEmployeeList14.then((value) {
        if (value != null) {
          setState(() {
            eventsListModalGlobal = value;
            isLoading = false;
            isLoadingTodayEvent = false;
          });
        }
      });

      getTodayEventList.then((value) {
        setState(() {
          todayEventModalGlobal = value;
          isLoading = false;
          isLoadingTodayEvent = false;
        });
      });
    } else {
      print("⏸ Skipping API. Loading from cache...");
      await loadSavedData(); // 🔹 Load saved modal data
    }
  }
*/
  void checkAndRunApi() async {
    bool runApi = await shouldRunApi();

    if (!runApi) {
      print("⏸ Skipping API. Loading from cache...");
      await loadSavedData();
      return;
    }

    print("🔄 Running API for today...");

    try {
      // Parallel API calls
      final results = await Future.wait([
        getDashboardData(sessionId!),       // 0
        getCalendarData(sessionId!),        // 1
        getHolidayData(sessionId!),         // 2
        getEventData(sessionId!),           // 3
        getTodayEventData(sessionId!),      // 4
      ]);

      // Assign results
      final dashboardData   = results[0] as EssDashboarrdModel;
      final calendarData    = results[1] as CalendarModalClass;
      final holidayData     = results[2] as HolidayESSModal?;
      final eventList       = results[3] as EssEventsListModal?;
      final todayEventList  = results[4] as TodayEventListModal;

      // Update UI state only once
      setState(() {
        essDashboardModelGlobal = dashboardData;
        calendarModalGlobal = calendarData;
        holidayListModalGlobal = holidayData;
        eventsListModalGlobal = eventList;
        todayEventModalGlobal = todayEventList;

        isLoading = false;
        isLoadingTodayEvent = false;
      });

      print("✅ All APIs loaded successfully.");

    } catch (e, st) {
      print("❌ Error loading APIs: $e");
      print(st);

      setState(() {
        isLoading = false;
        isLoadingTodayEvent = false;
      });
    }
  }

  // ===============================================================
  // ✅ Helper - Check if API should run today
  // ===============================================================
  Future<bool> shouldRunApi() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastCallDate = prefs.getString('lastApiCallDate');
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastCallDate == currentDate) {
      return false; // Same date, skip API
    } else {
      // Update date
      await prefs.setString('lastApiCallDate', currentDate);
      return true;
    }
  }


  /*Future<EssEventsListModal?> getEventData(String sessionId) async {
    */
  /*final prefs = await SharedPreferences.getInstance();
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastApiCallDate = prefs.getString('lastApiCallDate');
    print("Last API Call Date - $lastApiCallDate");
    print("Current Date - $currentDate");
    // ✅ Check if today's date matches last call date
    if (lastApiCallDate == currentDate) {
      print("⏩ Skipping API call. Already fetched today ($currentDate).");
      isLoadingEvent = false;
      return eventsListModalGlobal; // Return previously fetched data if available
    }*/
  /*

    // ✅ If date doesn’t match, make the API call
    setState(() {
      isLoadingEvent = true;
    });

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.eventListModalESSApi;

      print('Fetching event data for session: $sessionId');

      var urlapi = Uri.parse(
        "$conn$apiUrl?sessionId=$sessionId&"
            "branch=$branchId&"
            "shift=$shift&"
            "date=$singleDateString&"
            "userPermission=COMPANY_EMPLOYEE",
      );

      final response = await http.post(urlapi);

      print('API Request: ${response.request}');
      print('Response Body: ${response.body}');

      final mapResponse = json.decode(response.body);
      final eventsListModal = EssEventsListModal.fromJson(mapResponse);

      // ✅ Save global reference
      eventsListModalGlobal = eventsListModal;

      // ✅ Save current date as last API call date
      //await prefs.setString('lastApiCallDate', currentDate);

      return eventsListModal;
    } catch (e) {
      print("❌ Error fetching event data: $e");
      return null;
    } finally {
      setState(() {
        isLoadingEvent = false;
      });
    }
  }*/
  // ✅ Get Event Data and Save to SharedPreferences
  // ===============================================================
  Future<EssEventsListModal?> getEventData(String sessionId) async {
    setState(() {
      isLoadingEvent = true;
    });

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.eventListModalESSApi;

      var urlapi = Uri.parse(
        "$conn$apiUrl?sessionId=$sessionId&"
            "branch=$branchId&shift=$shift&date=$singleDateString&"
            "userPermission=COMPANY_EMPLOYEE",
      );

      final response = await http.post(urlapi);
      final mapResponse = json.decode(response.body);

      print("Event API -${response.request}");
      final eventsListModal = EssEventsListModal.fromJson(mapResponse);
      eventsListModalGlobal = eventsListModal;

      // ✅ Save modal data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('eventsListModalData', jsonEncode(mapResponse));

      return eventsListModal;
    } catch (e) {
      print("❌ Error fetching event data: $e");
      return null;
    } finally {
      setState(() {
        isLoadingEvent = false;
      });
    }
  }

  // ===============================================================
  // ✅ Get Today's Event Data and Save to SharedPreferences
  // ===============================================================
  Future<TodayEventListModal> getTodayEventData(String sessionId) async {
    setState(() {
      isLoadingTodayEvent = true;
    });

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.todayEventApi;

      var urlapi = Uri.parse(
        "$conn$apiUrl?sessionId=$sessionId&"
            "branch=$branchId&shift=$shift&date=$singleDateString&"
            "userPermission=COMPANY_EMPLOYEE",
      );

      final response = await http.post(urlapi);
      final mapResponse = json.decode(response.body);

      print("Today Event - ${response.request}");

      final todayEventListModal = TodayEventListModal.fromJson(mapResponse);
      todayEventModalGlobal = todayEventListModal;

      // ✅ Save modal data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('todayEventModalData', jsonEncode(mapResponse));

      return todayEventListModal;
    } catch (e) {
      print("❌ Error fetching today’s event data: $e");
      rethrow;
    } finally {
      setState(() {
        isLoadingTodayEvent = false;
      });
    }
  }

  // ===============================================================
  // ✅ Load saved data from SharedPreferences
  // ===============================================================
  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString('eventsListModalData');
    final todayEventsJson = prefs.getString('todayEventModalData');
    final holidayJson = prefs.getString('holidayData');
    final calendarJson = prefs.getString('calendarData');
    final calendarMonth = prefs.getString('calendarMonth');
    final dashboardData = prefs.getString('dashboardData');

    if (eventsJson != null) {
      print("Event JSON - $eventsJson");
      final mapResponse = jsonDecode(eventsJson);
      eventsListModalGlobal = EssEventsListModal.fromJson(mapResponse);
      //isLoadingEvent = false;
      //isLoading = false;
      //isLoadingTodayEvent = false;
      print("📦 Loaded eventsJson data from SharedPreferences");
    }else{
      print("📦 Loaded eventsJson data not save from SharedPreferences");
    }

    if (todayEventsJson != null) {
      final mapResponse = jsonDecode(todayEventsJson);
      todayEventModalGlobal = TodayEventListModal.fromJson(mapResponse);
      //isLoadingEvent = false;
      //isLoading = false;
      //isLoadingTodayEvent = false;
      print("📦 Loaded todayEventsJson data from SharedPreferences");
    }else{
      print("📦 Loaded todayEventsJson data not save from SharedPreferences");
    }

    if (holidayJson != null) {
      final mapResponse = jsonDecode(holidayJson);
      final holidayESSModal = HolidayESSModal.fromJson(mapResponse);

      setState(() {
        holidayListModalGlobal = holidayESSModal;
        //isLoadingEvent = false;
        //isLoadingTodayEvent = false;
      });

      print("📦 Loaded Holiday data from SharedPreferences");
    } else {
      print("⚠️ No saved holiday data found in SharedPreferences");
    }

    print("Calendar Data Loaded - $calendarJson");

    /*if (calendarMonth != null) {
      final mapResponse = jsonDecode(calendarMonth);
      calendarModalGlobal = CalendarModalClass.fromJson(mapResponse);
      isLoadingEvent = false;
      isLoading = false;
      isLoadingTodayEvent = false;
    }*/
    if (calendarJson != null && calendarMonth == _currentMonth) {
      final mapResponse = jsonDecode(calendarJson);
      print("Loaded calendar data from cache ✅");
      calendarModalGlobal = CalendarModalClass.fromJson(mapResponse);
      _buildCalendarFromMap(mapResponse);
      isLoadingEvent = false;
      isLoadingEvent = false;
      isLoading = false;
      isLoadingTodayEvent = false;
      print("📦 Loaded calender data from SharedPreferences");
    }else{
      print("📦 Loaded calender data from SharedPreferences");
    }
    if (dashboardData != null) {
      final mapResponse = jsonDecode(dashboardData);
      print("Loaded Dashboard Data data from cache ✅");
      essDashboardModelGlobal = EssDashboarrdModel.fromJson(mapResponse);
      //isLoadingEvent = false;
      //isLoadingEvent = false;
      //isLoading = false;
      //isLoadingTodayEvent = false;
      print("📦 Loaded Dashboard data from SharedPreferences");
    }else{
      print("📦 Loaded Dashboard data Not Saved from SharedPreferences");
    }
    setState(() {
      isLoading = false;
    });
  }

  /*Future<TodayEventListModal> getTodayEventData(String sessionId) async {
    setState(() {
      isLoadingTodayEvent = true; // Show loader before fetching
    });

    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.todayEventApi;

    print('employeeList11: $sessionId');

    TodayEventListModal todayEventListModal;

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

    todayEventListModal = TodayEventListModal.fromJson(mapResponse);

    // assign to global
    todayEventModalGlobal = todayEventListModal;

    setState(() {
      isLoadingTodayEvent = false; // Hide loader AFTER everything is ready
    });

    return todayEventListModal;
  }*/

  Future<TodayPunchesModal> getTodayPunchData(String sessionId) async {
    setState(() {
      isLoadingTodayPunch = true; // Show loader before fetching
    });

    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.todayPunchesApiESS;

    print('employeeList11: $sessionId');

    TodayPunchesModal todayPunchesModal;

    var urlapi = Uri.parse(
        "$conn$apiUrl?sessionId=$sessionId&"
            "date=$todayDateFetch");

    final response = await http.post(urlapi);
    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    print('Body Data $mapResponse');


    todayPunchesModal = TodayPunchesModal.fromJson(mapResponse);

    // assign to global
    todayPunchesModalGlobal = todayPunchesModal;
    // 👇 after parsing response
    setPunchData(todayPunchesModal.data);

    setState(() {
      isLoadingTodayPunch = false; // Hide loader AFTER everything is ready
    });

    return todayPunchesModal;
  }

  List<Map<String, dynamic>> todayPunches = [];

  void setPunchData(List<TodayData>? apiData) {
    if (apiData == null) return; // in case it's null

    todayPunches = apiData.asMap().entries.map((entry) {
      int index = entry.key;
      TodayData punch = entry.value; // now it's strongly typed

      return {
        "time": punch.time, // directly from your model

        "punchType": punch.punchType,

        // Green for the first punch, Red for others
        "color": index == 0 ? Colors.green : Colors.red,

        // Show arrow only for first punch
        "isStart": index == 0
      };
    }).toList();
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



  var getRealTimeAttButtonShow = true;
  var getRealTimeAttShow = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: essDashboardModelGlobal == null
          ? loader()
          : DashboardWidgets(essDashboardModelGlobal!),

    );
  }

  late Future<List<Map<String, dynamic>>> punchesFuture;



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
    if (todayEventModalGlobal?.todayEventList != null) {
      for (int i = 0; i < todayEventModalGlobal!.todayEventList!.length; i++) {
        oldJobEvent = todayEventModalGlobal!.todayEventList![i].dob;
        oldJobLength = todayEventModalGlobal!.todayEventList!.length;
        print("oldJobEvent $oldJobEvent");
      }
    } else {
      print("joblist is null");
    }

    /*if (holidayListModalGlobal?.result == "success") {
      for (int i = 0; i < holidayListModalGlobal!.viewHolidayList!.length; i++) {
        holidayDate = holidayListModalGlobal!.viewHolidayList![i].dateOfHoliday;
        holidayLength = holidayListModalGlobal!.viewHolidayList!.length;
        print("Holiday Length $holidayLength");
      }
    } else {
      print("holiday list is null");
    }*/

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

              Visibility(
                visible: getRealTimeAttButtonShow,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // margin
                  child: SizedBox(
                    width: double.infinity, // 👈 full width
                    child: ElevatedButton.icon(
                      onPressed: () {
                        getRealTimeAttButtonShow = false;
                        getRealTimeAttShow = true;
                        Future<TodayPunchesModal> getTodayPunch = getTodayPunchData(sessionId!);
                        getTodayPunch.then((value) {
                          setState(() {
                            todayPunchesModalGlobal = value;
                            isLoadingTodayPunch = false;
                          });

                        });
                        // 👇 Your action here
                        print("Get Real-Time Attendance clicked");
                      },
                      icon: const Icon(Icons.access_time, color: Colors.white, size: 22,),
                      label: const Text(
                        "Get Real-Time Attendance",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14), // height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: getRealTimeAttShow,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0, left: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Punches",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // 👇 Loader or punches
                      isLoadingTodayPunch
                          ? SizedBox(
                        height: 60, // match approx. punch card height
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                      )
                          : todayPunches.isEmpty
                          ? const Text(
                        "No punches found",
                        style: TextStyle(color: Colors.grey),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Arrow always at the start
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 10,top: 5.0),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            // Punch cards
                            ...todayPunches.map((punch) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 12, bottom: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border: Border.all(color: Mythemes.greyishade),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        punch["punchType"] == "DEVICE"
                                            ? Icons.touch_app
                                            : Icons.smartphone,
                                        color: punch["color"],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        punch["time"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: punch["color"],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // margin
                child: SizedBox(
                  height: 50,
                  width: double.infinity, // 👈 full width
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _currentMonth = DateFormat('MM-yyyy').format(DateTime.now());

                      // 👇 Reset calendar to current month
                      setState(() {
                        _targetDateTime = DateTime.now();
                        _currentDate = DateTime.now();
                        _currentDate2 = DateTime.now();
                        _currentMonth = DateFormat('MM-yyyy').format(_targetDateTime);
                      });
                      Future<EssDashboarrdModel> getEmployeeList11 = getDashboardData(sessionId!);
                      getEmployeeList11.then((value) {
                        setState(() {
                          essDashboardModelGlobal = value;
                          isLoading = false;
                        });

                      });
                      Future<CalendarModalClass> getCalendar = getCalendarData(sessionId!);
                      getCalendar.then((value) {
                        setState(() {
                          calendarModalGlobal = value;
                          isLoading = false;
                        });

                      });
                      // 👇 Your action here
                      print("Update your dashboard clicked");
                    },
                    icon: const Icon(Icons.dashboard_customize, color: Colors.white, size: 22,),
                    label: const Text(
                      "Update Your Dashboard",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Mythemes.successColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12,), // height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
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
                            isLoading: isLoadingTodayEvent,
                            items: todayEventModalGlobal?.todayEventList ?? [],
                            emptyText: "No events today 🎂",
                            titleBuilder: (item) => item.fullName,
                            subtitleBuilder: (item) => item.department,
                            trailingBuilder: (item) => item.dob,
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
  int getCalendarRowCount(DateTime month) {
    // 1st day of month
    DateTime firstDay = DateTime(month.year, month.month, 1);

    // last day of month
    DateTime lastDay = DateTime(month.year, month.month + 1, 0);

    // weekday of first day (Mon=1, Sun=7)
    int firstWeekday = firstDay.weekday;

    // total days in this month
    int totalDays = lastDay.day;

    // (days + offset) / 7 → number of rows
    int rows = ((totalDays + (firstWeekday - 1)) / 7).ceil();

    return rows;
  }
  DateTime? _lastApiCallMonth;
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

    int rowCount = getCalendarRowCount(_targetDateTime);

// Height per row in your calendar UI
    double rowHeight = 52; // perfect for your design

// Header + padding
    double topPadding = 60;

    // Final height
    double dynamicHeight = (rowCount * rowHeight) + topPadding;
    print('object size $dynamicHeight $rowCount $rowHeight $topPadding');

    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Mythemes.lightBluishColor,
      pageScrollPhysics: NeverScrollableScrollPhysics(),
      /*onDayPressed: (date, events) {
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

    },*/
      onDayPressed: (date, events) {
        // Prevent selecting dates older than current month view
        if (date.month < _targetDateTime.month && date.year == _targetDateTime.year) {
          print("⛔ Last month dates are not selectable");
          Fluttertoast.showToast(
            msg: "You cannot select last month's dates.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        if (date.month > _targetDateTime.month && date.year == _targetDateTime.year) {
          Fluttertoast.showToast(
            msg: "You cannot select next month's dates.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        /*if (_targetDateTime.isBefore(DateTime(_today.year, _today.month))) {
          print("⛔ Date tap disabled for past months");
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "Notice",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Requisitions for the last pay-cycle has been closed.",
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          );
          return;
        }
*/

        // PAYCYCLE RANGE
        //DateTime cycleStart = DateTime(2025, 10, 20);
        //DateTime cycleEnd = DateTime(2025, 11, 19);
        DateTime cycleStart;
        DateTime cycleEnd;
        int startDay = int.parse(deadlineStartDate);
        int endDay = int.parse(deadlineEndDate);
        print('date start and End $startDay $endDay');
       /* int startDay = 0;
        int endDay = 0;*/

        // CURRENT DATE
        DateTime today = DateTime.now();
         // e.g. "23-11-2024 11:59 AM"


        //print('raise date New  $lockDateStr');
        //print('raise date  $lockDateTime');
        DateTime monthStart = DateTime(today.year, today.month, 1);
        DateTime monthEnd = DateTime(today.year, today.month + 1, 0);
        // Convert to only "dd"
        int startDayInt = monthStart.day;
        int endDayInt = monthEnd.day;

        //print("Start: $startDayInt");
        //print("End:   $endDayInt");
        //deadlineStartDate - Data get form Login API deadlineEndDate = Data get from Login
        if (startDay == 0 || endDay == 0){
          startDay = startDayInt;
          endDay = endDayInt;
        }
        print('date start and End $startDay $endDay');
        if (today.day < startDay) {
          // Current month cycle is last month → this month
          cycleStart = DateTime(today.year, today.month - 1, startDay);
          cycleEnd = DateTime(today.year, today.month, endDay);
        } else {
          // Current month cycle is this month → next month
          cycleStart = DateTime(today.year, today.month, startDay);
          cycleEnd = DateTime(today.year, today.month + 1, endDay);
        }

        print("Cycle Start: $cycleStart");
        print("Cycle End:   $cycleEnd");
        if (lockDateStr != null && lockDateStr.trim().isNotEmpty) {
          // Convert String → DateTime
          DateTime lockDateTime = DateFormat("dd-MM-yyyy hh:mm").parse(lockDateStr);
          // Step 1 → Execute only if now >= lock date+time
          if (today.isAfter(lockDateTime) || today.isAtSameMomentAs(lockDateTime)) {
            // CHECK: If current date is outside paycycle → BLOCK
            if (date.isBefore(cycleStart) || date.isAfter(cycleEnd)) {
              developer.log('date for all true');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: const Text(
                    "Notice",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    "You are out of the pay-cycle. Attendance requisition not allowed.",
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
              return; // STOP further action
            }
          }
        }else{
          if (date.isBefore(cycleStart) || date.isAfter(cycleEnd)) {
            developer.log('date for all true');
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                title: const Text(
                  "Notice",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  "You are out of the pay-cycle. Attendance requisition not allowed.",
                  style: TextStyle(fontSize: 15),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
            return; // STOP further action
          }
        }

        setState(() => _currentDate = date);
        setState(() => _currentDate2 = date);
        //events.forEach((event) => print('event list ${event.getDescription()}'));
        //print(date);
        setState(() {
          formattedDate = DateFormat('dd-MM-yyyy').format(_currentDate);
          int dayOnly = int.parse(DateFormat('dd').format(_currentDate));
          print("Formatted Date - $formattedDate");
          print(data[dayOnly-1]);
          calendarSendData = data[dayOnly-1];

          //print("Formatted Date - $date");
        });

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AttendanceRequisitionCalendar(
                new AttendanceReportModel(), calendarSendData, 0, "$formattedDate")));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        fontSize: 12,
        color: Colors.red, // weekend date color
      ),

      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey, // previous month date color
      ),

      inactiveDaysTextStyle: TextStyle(
        color: Colors.grey.shade400, // inactive days color
        fontSize: 14,
      ),
      /* weekendTextStyle: TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),*/
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      //firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: dynamicHeight,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      //customGridViewPhysics: NeverScrollableScrollPhysics(),

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
        color: Mythemes.black,
      ),
      //minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      //maxSelectedDate: _currentDate.add(Duration(days: 360)),
      /*prevDaysTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.pinkAccent,
    ),
    inactiveDaysTextStyle: TextStyle(
      color: Colors.tealAccent,
      fontSize: 20,
    ),*/
      /*onCalendarChanged: (DateTime date) {
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
    },*/

        onCalendarChanged: (DateTime date) async {

          // 1. Prevent sliding beyond allowed range
          if (date.isBefore(_minDateAllowed) || date.isAfter(_maxDateAllowed)) {
            print("⛔ Calendar slide limit reached");
            return;
          }

          // 2. Stop duplicate API calls
          // Compare only month & year — day changes should NOT trigger new API
          if (_lastApiCallMonth != null &&
              _lastApiCallMonth!.month == date.month &&
              _lastApiCallMonth!.year == date.year) {
            print("⛔ Duplicate onCalendarChanged — API blocked");
            return;
          }

          // 3. Save month so next duplicate call is blocked
          _lastApiCallMonth = DateTime(date.year, date.month);

          // 4. Update month, UI & selected date
          _targetDateTime = date;
          _currentMonth = DateFormat('MM-yyyy').format(_targetDateTime);

          singleDateString = DateFormat('dd-MM-yyyy').format(date);
          print("Updated Date Change - $singleDateString");

          print("✅ Calling Calendar API for: $_currentMonth");

          // 5. Call API — only ONE time now
          CalendarModalClass result = await getCalendarData(sessionId!);

          setState(() {
            calendarModalGlobal = result;
          });

          print("✔ Calendar API Updated");
        },
      onDayLongPressed: (DateTime date) {
        //print('long pressed date $date');
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
              top: 0.0,
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
                /*TextButton(
                  child: Text('PREV'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month - 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                ),*/
                TextButton(
                  child: Text('PREV'),
                  onPressed: () {
                    final previousMonth = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                    if (previousMonth.isBefore(_minDateAllowed)) {
                      print("⛔ You can’t go beyond last 2 months");
                      Fluttertoast.showToast(
                          msg: "Can't go before this month !!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }
                    setState(() {
                      _targetDateTime = previousMonth;
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                ),
                /*TextButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                )*/
                TextButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    final nextMonth = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                    if (nextMonth.isAfter(_maxDateAllowed)) {
                      print("⛔ You can’t go beyond next month");
                      Fluttertoast.showToast(
                          msg: "Can't go beyond this month !!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }
                    setState(() {
                      _targetDateTime = nextMonth;
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                ),
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

/*class LegendWidget extends StatelessWidget {
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
}*/

class LegendWidget extends StatelessWidget {
  final List<Map<String, String>> legends;

  LegendWidget({required this.legends});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE — current legend wrap
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: legends.map((legend) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(int.parse(legend['mobColor']!)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      legend['status']!,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ).py1();
              }).toList(),
            ),
          ),

          // RIGHT SIDE — ellipsis icon
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Legend Details",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),

                          ...legends.map((legend) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(int.parse(legend['mobColor']!)),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      legend['statusName']!,
                                      style:
                                      TextStyle(fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 4),
              child: Icon(Icons.more_vert, size: 24, color: Colors.black),
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