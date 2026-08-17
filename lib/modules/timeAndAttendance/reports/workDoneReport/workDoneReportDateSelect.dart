import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/workDoneReport/workDoneReport.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../attendanceRequisition/getAttendanceDetails.dart';

class WorkDoneReportDateSelect extends StatefulWidget {
  const WorkDoneReportDateSelect({super.key});

  @override
  State<WorkDoneReportDateSelect> createState() => _WorkDoneReport();
}

late String? toDatePickedString, fromDatePickedString;
SessionManager shared = SessionManager();
String? sessionId;
class _WorkDoneReport extends State<WorkDoneReportDateSelect> {
  var year = "YYYY";
  var date = "DD";
  var month = "MM";

  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;

  @override
  void initState() {
    year;
    date;
    month;
    //formattedDate = DateFormat.yMd() as String;
    setState(() {
      getSharedPrfanceList();
    });

    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();

    setState(() {
      if(empRole==1){
        showHide=true;
        setState(() {
        });
      }
      if(empRole==0){
        showHide=false;
        setState(() {
        });
      }
      if (adminRole == 0) {
        showAdmin = false;
      }
      if (adminRole == 1) {
        showAdmin = true;
      }
      if (roRole == 0) {
        showRo = false;

      }
      if (roRole == 1) {
        showRo = true;
      }
    });
  }

  bool pickDates = true;
  bool pickNewDate = true;

  DateTime _datePick = (DateTime.now());
  String formattedDate = DateFormat.ABBR_MONTH;

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? datePickPicker = await showDatePicker(
      context: context,
      initialDate: _datePick,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (datePickPicker != null && datePickPicker != _datePick) {
      setState(() {
        pickDates = false;
        _datePick = datePickPicker;
        toDatePickedString = DateFormat('dd-MM-yyyy').format(_datePick);
      });
    }
  }

  DateTime _newDatePick = (DateTime.now());
  String formatDate = DateFormat.ABBR_MONTH;

  Future<Null> _selectToDate(BuildContext context) async {
    DateTime? newDatePickPicker = await showDatePicker(
      context: context,
      initialDate: _newDatePick,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (newDatePickPicker != null && newDatePickPicker != _newDatePick) {
      setState(() {
        pickNewDate = false;
        _newDatePick = newDatePickPicker;
        fromDatePickedString = DateFormat('dd-MM-yyyy').format(_newDatePick);
      });
    }
  }
  int pageIndex = 0;
  int currentIndex = 3;
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
       /* leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.reportSectionHead);
            },
            icon: Icon(Icons.arrow_back_ios)),*/
        title: "Workdone Report".text.make(),
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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.pop(context);
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if(index==2){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GetAttendanceDet(showAppBar: true,)));
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if(index==4){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);

            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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
      ),

      body: Column(
        children: [
          Visibility(
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
                    final text = const ['Self', 'Team'][local.index];
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

                    });
                    if(value == 1) {
                      Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                    }
                    if(value == 0) {
                      Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
                    }
                  },
                )
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Column(
                      children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectDate(context);
                        });
                      },
                      child: Card(
                        borderOnForeground: true,
                        /*shape: RoundedRectangleBorder(
                              side: BorderSide(color: Mythemes.whiteShadeSeventy, width: 1),
                              borderRadius: BorderRadius.circular(10)
                          ),*/
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: 110,
                          width: 110,
                          // color: Mythemes.whitish,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Mythemes.lightBluishColor),
                              child: Column(
                                children: [
                                  pickDates
                                      ? year.text
                                          .color(Mythemes.whitish)
                                          .xl2
                                          .make()
                                      : _datePick.year
                                          .toString()
                                          .text
                                          .color(Mythemes.whitish)
                                          .xl2
                                          .make(),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Mythemes.blueShade),
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, top: 2),
                                      height: 72,
                                      //color: Mythemes.greyish,
                                      child: Column(
                                        children: [
                                          Center(
                                            child: pickDates
                                                ? date.text.xl.make()
                                                : _datePick.day
                                                    .toString()
                                                    .text
                                                    .xl
                                                    .make()
                                                    .py4(),
                                          ),
                                          Center(
                                            child: pickDates
                                                ? month.text.xl.make().py8()
                                                : DateFormat.MMM()
                                                    .format(_datePick)
                                                    .toString()
                                                    .text
                                                    .xl
                                                    .make(),
                                          ),
                                        ],
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5, top: 35),
                    child: Icon(
                      Icons.compare_arrows,
                      size: 50,
                      color: Mythemes.greyish,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Column(
                      children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectToDate(context);
                        });
                      },
                      child: Card(
                        borderOnForeground: true,
                        /*shape: RoundedRectangleBorder(
                              side: BorderSide(color: Mythemes.whiteShadeSeventy, width: 1),
                              borderRadius: BorderRadius.circular(10)
                          ),*/
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: 110,
                          width: 110,
                          // color: Mythemes.whitish,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Mythemes.lightBluishColor),
                              child: Column(
                                children: [
                                  pickNewDate
                                      ? year.text
                                          .color(Mythemes.whitish)
                                          .xl2
                                          .make()
                                      : _newDatePick.year
                                          .toString()
                                          .text
                                          .color(Mythemes.whitish)
                                          .xl2
                                          .make(),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Mythemes.blueShade),
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, top: 2),
                                      height: 72,
                                      //color: Mythemes.greyish,
                                      child: Column(
                                        children: [
                                          Center(
                                            child: pickNewDate
                                                ? date.text.xl.make()
                                                : _newDatePick.day.text.xl
                                                    .make()
                                                    .py4(),
                                          ),
                                          Center(
                                            child: pickNewDate
                                                ? month.text.xl.make().py8()
                                                : DateFormat.MMM()
                                                    .format(_newDatePick)
                                                    .text
                                                    .xl
                                                    .make(),
                                          ),
                                        ],
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ])
                ],
              )
            ],
          ).py32(),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: OverflowBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        /*onPressed: (){
                  Navigator.pushNamed(context, MyRoutings.workDoneReportRoute);
                },*/

                        onPressed: () async {
                          if (_datePick.compareTo(_newDatePick) > 0) {
                            return setState(() {
                              AlertDialog(
                                content: "Please select valid date range".text.make(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please Select Valid Date Range "),
                              ));
                            });
                          }

                          if (pickDates == false && pickNewDate == false) {
                            bool result = await InternetConnectionChecker().hasConnection;
                            if(result == false) {
                              setState(() {
                                AlertDialog(
                                  content: "Please check your internet connection".text.make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please check your Internet connection."),
                                ));
                              });

                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WorkDoneReport(
                                    forDatePickedString: toDatePickedString!,
                                    toDatePickedString: fromDatePickedString!,
                                  )));
                            }



                          } else {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please Select Date Range "),
                              ));
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(Mythemes.lightBluishColor),
                        ),
                        child: "Submit".text.make(),
                      ).wh(120, 40).py32()
                    ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
