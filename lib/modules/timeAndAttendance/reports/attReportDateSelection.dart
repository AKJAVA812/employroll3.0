import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceReport.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../profiles/profilePageWithHead.dart';

class AttReport extends StatefulWidget {
  const AttReport({Key? key}) : super(key: key);

  @override
  State<AttReport> createState() => _AttReportState();
}

late String? todateString, fromeDateString;

class _AttReportState extends State<AttReport> {
  var year = "YYYY";
  var date = "DD";
  var month = "MM";

  @override
  void initState() {
    this.year;
    this.date;
    this.month;
    //formattedDate = DateFormat.yMd() as String;
    // TODO: implement initState
    super.initState();
  }

  DateTime _date = DateTime.now();
  String formattedDate = DateFormat.ABBR_MONTH;

  bool changeDates = true;
  bool changeNewDate = true;

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        changeDates = false;
        _date = _datePicker;
        todateString = DateFormat('dd-MM-yyyy').format(_date);
        print('dateTime${formattedDate}');
      });
    }
  }

  DateTime _newdate = (DateTime.now());
  String formatDate = DateFormat.ABBR_MONTH;

  Future<Null> _selectToDate(BuildContext context) async {
    DateTime? _newDatePicker = await showDatePicker(
      context: context,
      initialDate: _newdate,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (_newDatePicker != null && _newDatePicker != _newdate) {
      setState(() {
        changeNewDate = false;
        _newdate = _newDatePicker;
        fromeDateString = DateFormat('dd-MM-yyyy').format(_newdate);
      });
    }
  }
  int pageIndex = 0;
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Attendance Report".text.make(),
      ),

      body: Column(
        children: [
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
                                  changeDates
                                      ? year.text
                                      .color(Mythemes.whitish)
                                      .xl2
                                      .make()
                                      : _date.year
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
                                            child: changeDates
                                                ? date.text.xl.make()
                                                : _date.day
                                                .toString()
                                                .text
                                                .xl
                                                .make()
                                                .py4(),
                                          ),
                                          Center(
                                            child: changeDates
                                                ? month.text.xl.make().py8()
                                                : DateFormat.MMM()
                                                .format(_date)
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
                  Column(children: [
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
                                  changeNewDate
                                      ? year.text
                                      .color(Mythemes.whitish)
                                      .xl2
                                      .make()
                                      : _newdate.year
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
                                            child: changeNewDate
                                                ? date.text.xl.make()
                                                : _newdate.day.text.xl
                                                .make()
                                                .py4(),
                                          ),
                                          Center(
                                            child: changeNewDate
                                                ? month.text.xl.make().py8()
                                                : DateFormat.MMM()
                                                .format(_newdate)
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


            ],
          ).py64(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_date.compareTo(_newdate) > 0) {
                    return setState(() {
                      AlertDialog(
                        content: "Please select valid date range".text.make(),
                      );
                      print("select valid date range");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select Valid Date Range "),
                      ));
                    });
                  }

                  if (changeDates == false && changeNewDate == false) {
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
                          builder: (context) => AttendanceReport(
                            forDateString: fromeDateString!,
                            toDateString: todateString!,
                          )));
                    }

                  } else {
                    print("Please select date");
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select Date Range "),
                      ));
                    });
                  }
                },

                child: "Submit".text.make(),
              ),
            ],
          ),
        ],
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
