import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/attendanceList.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/singleDateAttendance.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../themes/empThemes.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../../../timeAndAttendance/reports/attendanceRequisition/model/onDateReportModel.dart';

class ODRequisitionPage extends StatefulWidget {
  AttendanceReportModel? attendanceModelGlobel;
  OnDateAttModel? onDateAttModel;
  int indexCont;

  ODRequisitionPage(
    this.attendanceModelGlobel,
    this.onDateAttModel,
    this.indexCont,
  );

  @override
  State<ODRequisitionPage> createState() =>
      _ODRequisitionPageState(attendanceModelGlobel, onDateAttModel, indexCont);
}

class _ODRequisitionPageState extends State<ODRequisitionPage> {
  AttendanceReportModel? attendanceModelGlobel;
  OnDateAttModel? onDateAttModel;
  int indexCont;
  String? _group1SelectedValue;
  String radios = "onDate";
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  String? branchNameset;
  String? departmentset;
  String? employeeNameset;
  String? onDateset;
  String? actualTimeset;
  String? actualOutTimeset;
  int? empId;

  _ODRequisitionPageState(
    this.attendanceModelGlobel,
    this.onDateAttModel,
    this.indexCont,
  );

  @override
  void initState() {
    //var onDateNew = attendanceModelGlobel!.data![indexCont].attendanceDate,
    //  _group1SelectedValue = "1";
    //String empid=onDateAttModel!.empId.toString();
    //print('responseemployeeList $empid');

    if (attendanceModelGlobel != null) {
      print('attendanceModelGlobel');
      branchNameset = attendanceModelGlobel!.data![indexCont].branchName;
      departmentset = attendanceModelGlobel!.data![indexCont].departmentName;
      employeeNameset = attendanceModelGlobel!.data![indexCont].employeeName;
      onDateset = attendanceModelGlobel!.data![indexCont].attendanceDate;
      actualTimeset = attendanceModelGlobel!.data![indexCont].inTime;
      actualOutTimeset = attendanceModelGlobel!.data![indexCont].outTime;
      empId = attendanceModelGlobel!.data![indexCont].empId;
    } else {
      print('onModelrun');
      branchNameset = onDateAttModel!.branch;
      departmentset = onDateAttModel!.dept;
      employeeNameset = onDateAttModel!.empName;
      onDateset = onDateAttModel!.date;
      actualTimeset = onDateAttModel!.inTime;
      actualOutTimeset = onDateAttModel!.outTime;
      empId = onDateAttModel!.empId;
    }

    getSharedPrfanceList();
    super.initState();
  }

  void _group1Changes(String? value) {
    setState(() {
      _group1SelectedValue = value;
    });
  }

  //String radios = "onDate";
  String _inTimePicker = '00:00';
  String _outTimePicker = '00:00';
  TextEditingController inRemarkController = TextEditingController();
  TextEditingController outRemarkController = TextEditingController();
  String onDateRadio = "1";
  String nextDayRadio = "0";
  String compOffRadio = "0";
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: "Requisition By RO".text.make(), elevation: 0.5),
        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        /*mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,*/
                        children: [
                          Radio(
                            value: "onDate",
                            groupValue: radios,
                            onChanged: (value) {
                              /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("On Date Click"),
                            ));*/
                              setState(() {
                                onDateRadio = "1";
                                nextDayRadio = "0";
                                compOffRadio = "0";
                                radios = value.toString();
                              });
                            },
                          ),
                          "On Date".text.make(),
                        ],
                      ),
                      Row(
                        /* mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,*/
                        children: [
                          Radio(
                            value: "nextDay",
                            groupValue: radios,
                            onChanged: (value) {
                              /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Next Day Click"),
                            ));*/
                              setState(() {
                                onDateRadio = "0";
                                nextDayRadio = "1";
                                compOffRadio = "0";
                                radios = value.toString();
                              });
                            },
                          ),
                          "Next Day".text.make(),
                        ],
                      ).px16(),
                    ],
                  ).p(5),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: TextEditingController(
                              text: branchNameset,
                            ),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: branchNameset,
                              labelText: "Branch Name",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: TextEditingController(
                              text: departmentset,
                            ),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: departmentset,
                              labelText: "Department",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: TextEditingController(
                              text: employeeNameset,
                            ),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: employeeNameset,
                              labelText: "Employee Name",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: TextEditingController(text: onDateset),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: onDateset,
                              labelText: "On Date",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: TextEditingController(
                              text: actualTimeset,
                            ),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: actualTimeset,
                              labelText: "Actual In Time",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () async {
                              //_openInTimepicker(context);
                              final TimeOfDay? n = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(
                                      context,
                                    ).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              print('timenewOut $n');
                              setState(() {
                                var now = DateTime.now();
                                DateTime newt = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  n!.hour,
                                  n!.minute,
                                );
                                var nT = DateFormat('HH:mm').format(newt);
                                print(DateFormat('HH:mm').format(newt));
                                _inTimePicker = nT;
                              });
                            },
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: TextEditingController(
                                text: _inTimePicker,
                              ),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8.0),
                                enabled: false,
                                hintText: _inTimePicker,
                                labelText: "Changes In Time",
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            maxLines: 3,
                            style: TextStyle(fontSize: 14),
                            controller: inRemarkController,
                            enabled: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.greyishade,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: "Add Remark",
                              labelText: "Remarks",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: TextEditingController(
                              text: actualOutTimeset,
                            ),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              enabled: false,
                              hintText: actualOutTimeset,
                              labelText: "Actual Out Time",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () async {
                              //_openOutTimepicker(context);
                              final TimeOfDay? o = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(
                                      context,
                                    ).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              print('timenewOut $o');
                              setState(() {
                                var newNow = DateTime.now();
                                DateTime newt = DateTime(
                                  newNow.year,
                                  newNow.month,
                                  newNow.day,
                                  o!.hour,
                                  o!.minute,
                                );
                                var oT = DateFormat('HH:mm').format(newt);
                                print(DateFormat('HH:mm').format(newt));
                                _outTimePicker = oT;
                              });
                            },
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: TextEditingController(
                                text: _outTimePicker,
                              ),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8.0),
                                enabled: false,
                                hintText: _outTimePicker,
                                labelText: "Changes Out Time",
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            maxLines: 3,
                            style: TextStyle(fontSize: 14),
                            controller: outRemarkController,
                            enabled: true,
                            //initialValue: "${branchName}",
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.greyishade,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 8.0),
                              hintText: "Add Remark",
                              labelText: "Remarks",
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        buttonPadding: Vx.mOnly(right: 16),
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              String? inTimeReq;
                              String? outTimeReq;
                              String logid = "0";
                              String inRemarkString = inRemarkController.text;
                              String outRemarkString = outRemarkController.text;
                              String onDate = DateFormat(
                                "dd-MM-yyyy",
                              ).format(DateTime.parse(onDateset!));
                              var dateformat = onDate;

                              if (_outTimePicker!.compareToIgnoringCase(
                                    "00:00",
                                  ) ==
                                  0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(" Please Select Out Time "),
                                  ),
                                );
                              } else {
                                //  var intimecompair = attendanceModelGlobel!.data![indexCont].inTime ?? onDateAttModel!.inTime;
                                if (onDateset!.compareToIgnoringCase("--:--") ==
                                    0) {
                                  inTimeReq =
                                      onDateset
                                                  .toString()
                                                  .compareToIgnoringCase(
                                                    "--:--",
                                                  ) ==
                                              0
                                          ? _inTimePicker
                                          : _inTimePicker;
                                } else {
                                  inTimeReq =
                                      onDateset
                                                  .toString()
                                                  .compareToIgnoringCase(
                                                    "N/A",
                                                  ) ==
                                              0
                                          ? _inTimePicker
                                          : _inTimePicker;
                                }
                                outTimeReq = _outTimePicker;
                                if (radios.compareToIgnoringCase("next") == 0) {
                                } else {
                                  if (inTimeReq.compareToIgnoringCase(
                                        "00:00",
                                      ) ==
                                      0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          " Please Select In Time ",
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (onDateRadio.compareToIgnoringCase(
                                          "1",
                                        ) ==
                                        0) {
                                      if (inTimeReq.compareTo(outTimeReq) > 0) {
                                        return setState(() {
                                          CommonNotificationPage.showWorkDoneSuccess(
                                            context,
                                            "Your working hours going to negative, Please select requisition time correctly."
                                                    .upperCamelCase +
                                                " ",
                                            "Alert Message",
                                          );
                                        });
                                      } else {
                                        sendRequsitionToServer(
                                          context,
                                          empId!,
                                          inRemarkString,
                                          outRemarkString,
                                          inTimeReq,
                                          outTimeReq,
                                          logid,
                                          dateformat,
                                        );
                                      }
                                    } else if (nextDayRadio
                                            .compareToIgnoringCase("1") ==
                                        0) {
                                      sendRequsitionToServernextDay(
                                        context,
                                        empId!,
                                        inRemarkString,
                                        outRemarkString,
                                        inTimeReq,
                                        outTimeReq,
                                        logid,
                                        dateformat,
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Mythemes.lightBluishColor,
                              ),
                            ),
                            child: "Send".text.make(),
                          ).wh(150, 40).py12(),
                        ],
                      ),
                    ],
                  ).py32(),
                ],
              ),
            ),

            //RadioGroups(attendanceModelGlobel,indexCont)
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
              //Navigator.of(context, rootNavigator: true).pop();
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
              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
              print('OD');
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MSSDashboard(DashboardModel()),
                ),
              );
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
              icon: Icon(Icons.outbond_outlined),
              label: 'OD',
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
      ),
    );
  }

  String conn = ApiDetails.server;
  String apiUrl = ApiDetails.odAttendanceReq;
  Future<void> sendRequsitionToServer(
    BuildContext context,
    int empId,
    String inRemarkString,
    String outRemarkString,
    String inTimeReq,
    String outTimeReq,
    String logid,
    var onDate,
  ) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "id=$empId&"
      "onDate=$onDate&"
      "inTimeRemarks=$inRemarkString&"
      "outTimeRemarks=$outRemarkString&"
      "inTime=$inTimeReq&"
      "outTime=$outTimeReq",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];
        CommonNotificationPage.showDialgSucess(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          CommonNotificationPage.showDialgSucess(context, reason, "Success");
        } else {
          CommonNotificationPage.showDialgSucess(context, result, "Error");
        }
      }
      print('result ${result} reason ${reason}');
    }
  }

  Future<void> sendRequsitionToServernextDay(
    BuildContext context,
    int empId,
    String inRemarkString,
    String outRemarkString,
    String inTimeReq,
    String outTimeReq,
    String logid,
    var onDate,
  ) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "id=$empId&"
      "onDate=$onDate&"
      "inTimeRemarks=$inRemarkString&"
      "outTimeRemarks=$outRemarkString&"
      "inTime=$inTimeReq&"
      "nextday=true&"
      "outTime=$outTimeReq",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];
        CommonNotificationPage.showDialgSucess(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          CommonNotificationPage.showDialgSucess(context, reason, "Success");
        } else {
          CommonNotificationPage.showDialgSucess(context, result, "Error");
        }
      }
      print('result ${result} reason ${reason}');
    }
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
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
