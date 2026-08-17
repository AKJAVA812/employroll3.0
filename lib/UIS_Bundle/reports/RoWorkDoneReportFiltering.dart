import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/workDoneReport/roWorkDoneReport.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../employeePage/employeeListModel.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';

class UIS_RoWorkDoneReportFiltering extends StatefulWidget {
  const UIS_RoWorkDoneReportFiltering({super.key});

  @override
  State<UIS_RoWorkDoneReportFiltering> createState() => _WorkDoneReport();
}

late String toDatePickedStringRo, fromDatePickedStringRo;

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<Data>? allUsernew = [];
List<Data>? foundDataNew = [];
EmployeeListModel? employeeListModelglobel;
EmployeeListModel? employeeListModelglobeled;

List<String?> list = [];
String valuenew = "listText";
var empNewIdRo;
var filterType;

class _WorkDoneReport extends State<UIS_RoWorkDoneReportFiltering> {
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
    setState(() {
      getSharedPrfanceList();
      filterType = "0";
      empNewIdRo = "";
    });

    //formattedDate = DateFormat.yMd() as String;
    // TODO: implement initState
    super.initState();
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
        toDatePickedStringRo = DateFormat('dd-MM-yyyy').format(_datePick);
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
        fromDatePickedStringRo = DateFormat('dd-MM-yyyy').format(_newDatePick);
      });
    }
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    // await Future.delayed(Duration(seconds: 5));
    Future<EmployeeListModel> getEmployeeList11 = getEmployeeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        employeeListModelglobel = value;
        employeeListModelglobeled = employeeListModelglobel;
      });
    });

    setState(() {
      if (empRole == 1) {
        showHide = true;
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        setState(() {});
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

  Future<EmployeeListModel> getEmployeeList(String sessionId) async {
    list = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.othersReqEmpList;
    EmployeeListModel requistionEmpListModel;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    requistionEmpListModel = EmployeeListModel.fromJson(mapResponse);
    int length = requistionEmpListModel.data!.length;
    for (int i = 0; i < requistionEmpListModel.data!.length; i++) {
      String? empName = requistionEmpListModel.data![i].empName;
      list.add(requistionEmpListModel.data![i].empName);
    }
    return requistionEmpListModel;
  }

  var dropdownvalue;
  int switcherIndex1 = 0;
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 1;

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.reportSectionHead);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: "Workdone Report".text.make(),
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
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
              );
            }
            if (index == 2) {
              Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MSSDashboard(DashboardModel()),
                ),
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            }
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePageNew()),
              );
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
        body: Column(
          children: [
            Visibility(
              visible: showRo || showAdmin,
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
                        color: Colors.white38.withOpacity(opacity),
                      );
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['Self', 'Team'][local.index];
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Color.lerp(
                              Colors.black,
                              Colors.white,
                              local.animationValue,
                            ),
                          ),
                        ),
                      );
                    },
                    borderWidth: 0.0,
                    onChanged: (i) {
                      setState(() {
                        value = i;
                      });
                      if (value == 1) {
                        Navigator.pushNamed(
                          context,
                          MyRoutings.roWorkDoneFilterRoute,
                        );
                      }
                      if (value == 0) {
                        Navigator.pushNamed(
                          context,
                          MyRoutings.workDoneDateReportRoute,
                        );
                      }
                    },
                  ),
                ],
              ),
            ).py(8),

            Visibility(
              visible: showRo || showAdmin,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedToggleSwitch<int>.size(
                    height: 30,
                    current: min(switcherIndex1, 2),
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
                    indicatorSize: const Size.fromWidth(100),
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
                        color: Colors.white38.withOpacity(opacity),
                      );
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['All', 'Employee'][local.index];
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Color.lerp(
                              Colors.black,
                              Colors.white,
                              local.animationValue,
                            ),
                          ),
                        ),
                      );
                    },
                    borderWidth: 0.0,
                    onChanged: (i) {
                      setState(() {
                        switcherIndex1 = i;
                      });
                      if (switcherIndex1 == 0) {
                        filterType = "0";
                        empNewIdRo = "";
                      } else {
                        filterType = "1";
                      }
                    },
                  ),
                ],
              ),
            ).py(8),
            /*Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideSwitcher(
                  children: [
                    switcherIndex1 == 0 ?
                    Text('All',style: TextStyle(color: Mythemes.blackish)) :
                    Text('All',style: TextStyle(color: Mythemes.whitish)),
                    switcherIndex1 == 1 ?
                    Text('Employee',style: TextStyle(color: Mythemes.blackish)):
                    Text('Employee',style: TextStyle(color: Mythemes.whitish))
                  ],
                  onSelect: (index) {
                    setState(() {
                      switcherIndex1 = index;
                      if(switcherIndex1 == 0) {
                        filterType = "0";
                        empNewIdRo = "";
                      } else {
                        filterType = "1";
                      }
                      print("FilterTYPE - $filterType");
                    });
                  },
                  containerHeight: 30,
                  containerWight: 200,
                  containerColor: Mythemes.lightBluishColor,

                  slidersBorder: Border.all(width: 2,color: Mythemes.greyish),
                ),
              ],
            ),*/
            Visibility(
              visible: switcherIndex1 == 1,
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: DropdownButtonFormField<String>(
                        value:
                            list.contains(dropdownvalue) ? dropdownvalue : null,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Mythemes.blackishade,
                            ),
                          ),
                          hintText: "Employee List",
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Mythemes.blackish,
                          ),
                        ),
                        items:
                            list.toSet().toList().map<DropdownMenuItem<String>>(
                              (String? value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.centerLeft,
                                  value: value,
                                  child: Text(value!),
                                );
                              },
                            ).toList(),
                        onChanged: (newVal) {
                          if (newVal != null) {
                            valuenew = newVal;
                            int i = list.indexOf(valuenew);
                            empNewIdRo =
                                employeeListModelglobel?.data?[i].empId
                                    .toString();
                            setState(() {
                              dropdownvalue = newVal;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 110,
                              width: 110,
                              // color: Mythemes.whitish,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Mythemes.lightBluishColor,
                                ),
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
                                        borderRadius: BorderRadius.circular(5),
                                        color: Mythemes.blueShade,
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 2,
                                      ),
                                      height: 72,
                                      //color: Mythemes.greyish,
                                      child: Column(
                                        children: [
                                          Center(
                                            child:
                                                pickDates
                                                    ? date.text.xl.make()
                                                    : _datePick.day
                                                        .toString()
                                                        .text
                                                        .xl
                                                        .make()
                                                        .py4(),
                                          ),
                                          Center(
                                            child:
                                                pickDates
                                                    ? month.text.xl.make().py8()
                                                    : DateFormat.MMM()
                                                        .format(_datePick)
                                                        .toString()
                                                        .text
                                                        .xl
                                                        .make(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    ),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 110,
                              width: 110,
                              // color: Mythemes.whitish,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Mythemes.lightBluishColor,
                                ),
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
                                        borderRadius: BorderRadius.circular(5),
                                        color: Mythemes.blueShade,
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 2,
                                      ),
                                      height: 72,
                                      //color: Mythemes.greyish,
                                      child: Column(
                                        children: [
                                          Center(
                                            child:
                                                pickNewDate
                                                    ? date.text.xl.make()
                                                    : _newDatePick.day.text.xl
                                                        .make()
                                                        .py4(),
                                          ),
                                          Center(
                                            child:
                                                pickNewDate
                                                    ? month.text.xl.make().py8()
                                                    : DateFormat.MMM()
                                                        .format(_newDatePick)
                                                        .text
                                                        .xl
                                                        .make(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                                content:
                                    "Please select valid date range".text
                                        .make(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please Select Valid Date Range ",
                                  ),
                                ),
                              );
                            });
                          }

                          if (pickDates == false && pickNewDate == false) {
                            bool result =
                                await InternetConnectionChecker().hasConnection;
                            if (result == false) {
                              setState(() {
                                AlertDialog(
                                  content:
                                      "Please check your internet connection"
                                          .text
                                          .make(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please check your Internet connection.",
                                    ),
                                  ),
                                );
                              });
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => RoWorkDoneReport(
                                        toDatePickedStringRo,
                                        fromDatePickedStringRo,
                                        filterType,
                                        empNewIdRo,
                                      ),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please Select Date Range "),
                                ),
                              );
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Mythemes.lightBluishColor,
                          ),
                        ),
                        child: "Submit".text.make(),
                      ).wh(120, 40).py32(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({super.key, required this.child});

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
