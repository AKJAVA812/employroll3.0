import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/singleDateAttendance.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../ess/Model/calendarModalClass.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../calendarPage/attendanceRequetCalendar.dart';
import '../modelClass/attendanceReportModel.dart';
import 'model/onDateReportModel.dart';


class GetAttendanceDet extends StatefulWidget {
  final bool showAppBar;
  GetAttendanceDet({this.showAppBar = true});
   //GetAttendanceDet({Key? key}) : super(key: key);

  @override
  State<GetAttendanceDet> createState() => _GetAttendanceDetState();
}


SessionManager shared = SessionManager();
String? sessionId;
String? branchName;
String? deptName;
String? empName;
final DateTime _today = DateTime.now();
final DateTime _minDateAllowed = DateTime(_today.year, _today.month - 2); // 2 months before
final DateTime _maxDateAllowed = DateTime(_today.year, _today.month + 1); // 1 month ahead
String singleDateString="";
CalendarModalClass? calendarModalGlobal;
List<dynamic> data=[];
var calendarSendData;
class _GetAttendanceDetState extends State<GetAttendanceDet> {
  dynamic formattedDate;
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat('MM-yyyy').format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  List<Map<String, String>> _legends = [];
  var todayDate = "dd-mm-yyyy";

 @override
  void initState() {
   getSharedPrfanceList();
  /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     content: Text("Sucessfully Run"),
   ));*/
   setState(() {

   });
    // TODO: implement initState
    super.initState();
  }
  Future getSharedPrfanceList() async {
    //await Future.delayed(Duration(seconds: 1));

    sessionId = await shared!.getSessionId()??"N/A";
    branchName = await shared!.getBranch()??"N/A";
    deptName = await shared!.getDept()??"N/A";
    empName = await shared!.getempName()??"N/A";

    checkAndRunApi();
    setState(() {
      print('ResponseAttendance: ${sessionId}' );
    });

  }

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

   Map<String, dynamic> mapResponse = {};

   final prefs = await SharedPreferences.getInstance();

   // ✅ STEP 1: Try loading from SharedPreferences first
   if(_currentMonthc==_currentMonth){

     final cachedData = prefs.getString('calendarData');
     final cachedMonth = prefs.getString('calendarMonth');

     print("Calendar Data - $cachedData");
     print("Calendar Month - $cachedMonth");

     if (cachedData != null) {
       print("Cachded Month $cachedMonth");
       try {
         print("Loaded calendar data from cache ✅");
         mapResponse = json.decode(cachedData);
         _buildCalendarFromMap(mapResponse);
       } catch (e) {
         print("Error loading cached calendar: $e");
       }
     }
   }

   // ✅ STEP 2: Now call API (refresh data and overwrite cache)
   try {
     final response = await http.post(urlapi);
     if (response.statusCode == 200) {
       print('Calendar URL - ${response.request}');
       print('Response body - ${response.body}');
       mapResponse = json.decode(response.body);

       // Save to SharedPreferences
       if(_currentMonthc==_currentMonth){
         await prefs.setString('calendarData', json.encode(mapResponse));
         await prefs.setString('calendarMonth', _currentMonth);
       }
       // ✅ Rebuild UI from fresh API data
       _buildCalendarFromMap(mapResponse);
     } else {
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

// 🔧 Helper method to rebuild UI from any map data (API or cache)
  void _buildCalendarFromMap(Map<String, dynamic> mapResponse) {
    try {
      data = mapResponse['data'] ?? [];
      List<dynamic> legends = mapResponse['legends'] ?? [];

      // Build legends
      _legends = legends.map((legend) {
        return {
          "mobColor": legend["mobColor"].toString(),
          "status": legend["status"].toString(),
        };
      }).toList();

      // Build marked dates
      _markedDateMap.clear();
      //print("Calendar Mark Date - $_markedDateMap");

      for (var event in data) {
        DateTime eventDate = DateTime.parse(event['logDate']);
        String title = event['status'] ?? "Event";
        String logDate = event['logDate'];
        String mobColor = event['mobColor'] ?? "0xff2196F3";
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

  void checkAndRunApi() async {
    bool runApi = await shouldRunApi();

    if (runApi) {
      // ✅ Run API only if needed
      print("🔄 Running API for today...");

      Future<CalendarModalClass> getCalendar = getCalendarData(sessionId!);
      getCalendar.then((value) {
        setState(() {
          calendarModalGlobal = value;
          isLoading = false;
        });

      });
    } else {
      print("⏸ Skipping API. Loading from cache...");
      await loadSavedData(); // 🔹 Load saved modal data
    }
  }

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

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final calendarJson = prefs.getString('calendarData');
    final calendarMonth = prefs.getString('calendarMonth');


    print("Calendar Data Loaded - $calendarJson");

    if (calendarJson != null && calendarMonth == _currentMonth) {
      final mapResponse = jsonDecode(calendarJson);
      print("Loaded calendar data from cache ✅");
      calendarModalGlobal = CalendarModalClass.fromJson(mapResponse);
      _buildCalendarFromMap(mapResponse);

      isLoading = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  DateTime _date = (DateTime.now());
  String dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse("2019-09-30"));
  Future <Null> _selectDate (BuildContext context) async {
    DateTime? _datePicker =await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2040),
    );

    if(_datePicker != null && _datePicker != _date){
      setState(() {
        _date = _datePicker;
      });
    }
  }
  final TextEditingController _dateController = TextEditingController();

 int pageIndex = 0;
 int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mythemes.whitish,
        appBar: widget.showAppBar
            ? AppBar(
          title: "Select Date for Requisition".text.make(),
          elevation: 0.5,
        )
            : null,

     /* floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, MyRoutings.attendanceListRoute);
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(
          Icons.list, color: Mythemes.whitish, size: 28,
        ),
      ),*/

     /* bottomNavigationBar: Container(
        height: 90,
        color: context.cardColor,
        child: ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonPadding: Vx.mOnly(right: 16),
            children: [
              ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                  if(singleDateString.compareToIgnoringCase("")==0){
                    print('responseemployeeList');
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select Date First "),
                      ));
                    });
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleDateAttendance(
                          singleDateString: singleDateString!,
                        )));

                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Mythemes.lightBluishColor),
                ),
                child: "Get Details".text.make(),
              ).wh(150, 40).py12()
            ]),
      ),*/

        bottomNavigationBar: widget.showAppBar
            ?
        BottomNavigationBar (
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {

            if(index==0){

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
              //Navigator.pop(context);
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Workflow');
            }
            if(index==2){
              /*Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Attendance');*/
            }
            if(index==3){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProfilePageNew())
              // );
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
              icon: Icon(CupertinoIcons.app_badge_fill),
              label: 'My Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: 'My Reports',
              //backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
              //backgroundColor: Colors.blue,
            ),
          ],
        ) : null,

      body: SingleChildScrollView(
        child: Column(
          children: [

            /*Padding(
              padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: branchName),
              enabled: false,
              //initialValue: "${branchName}",
              decoration:  InputDecoration(
                  hintText: "Branch Name",
                  labelText: "Branch Name"
              ),
            ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: TextEditingController(text: deptName),
                enabled: false,
                //initialValue: deptName,
                decoration:  InputDecoration(
                    hintText: "Department Name",
                    labelText: "Department Name"

                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: TextEditingController(text: empName),
                enabled: false,
                //initialValue: empName,
                decoration:  InputDecoration(
                    hintText: "Employee Name",
                    labelText: "Employee Name"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectDate(context);
                  });
                },
                child: TextFormField(

                  onTap: () async{
                    DateTime? date = DateTime.now();
                    FocusScope.of(context).requestFocus(new FocusNode());

                    date = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate:DateTime(1947),
                        lastDate: DateTime.now().add(Duration(days: 0)));
                    setState(() {
                      singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                      _dateController.text = DateFormat("dd-MM-yyyy").format(date!);

                        //  DateFormat.yMd().format(date!).toString();
                    });

                    print(date);
                  },
                  readOnly: true,
                  //initialValue: "dd-mm-yyyy",
                  controller: _dateController,
                  decoration:  InputDecoration(
                    labelText: "Date",
                   suffixIcon: Icon(Icons.calendar_month),
                   hintText: DateFormat("DD-MM-YYYY").format(_date),
                   // hintText: DateFormat.yMd().format(_date).toString(),
                  ),

                ),
              ),
            ),

            Container(
              height: 90,
              color: context.cardColor,
              child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding: Vx.mOnly(right: 16),
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                        if(_dateController.text.compareToIgnoringCase("")==0){
                          print('responseemployeeList');
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Select Date First "),
                            ));
                          });
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SingleDateAttendance(
                                singleDateString: _dateController.text,
                              )));

                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Mythemes.lightBluishColor),
                      ),
                      child: "Get Details".text.make(),
                    ).wh(150, 40).py12()
                  ]),
            ).py(80),*/

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
                    "Update Your Calendar",
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

          ],
        ),
      )
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
        if (_targetDateTime.isBefore(DateTime(_today.year, _today.month))) {
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

        this.setState(() => _currentDate = date);
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print('event list ${event.getDescription()}'));
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
      height: 370.0,
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
      onCalendarChanged: (DateTime date) {
        // Prevent sliding beyond allowed range
        if (date.isBefore(_minDateAllowed) || date.isAfter(_maxDateAllowed)) {
          print("⛔ Calendar slide limit reached");
          return;
        }

        _targetDateTime = date;
        _currentMonth = DateFormat('MM-yyyy').format(_targetDateTime);
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
          });
        });
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
