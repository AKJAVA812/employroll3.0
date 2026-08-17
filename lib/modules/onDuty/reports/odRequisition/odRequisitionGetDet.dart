import 'dart:convert';

import 'package:flutter/material.dart';
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
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';

class ODRequisitionSelection extends StatefulWidget {
  const ODRequisitionSelection({super.key});

  @override
  State<ODRequisitionSelection> createState() => _ODRequisitionSelectionState();
}

SessionManager sessionManager = SessionManager();
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? branchName;
String? deptName;
String? empName;

class _ODRequisitionSelectionState extends State<ODRequisitionSelection> {
  String dayRadio = "1";
  bool singleDayShow = true;
  bool multipleDayShow = false;
  var empNewId;
  var orgNewId;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  @override
  void initState() {
    getSharedPrfanceList();
    getEmpId();
    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     content: Text("Sucessfully Run"),
   ));*/
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    //await Future.delayed(Duration(seconds: 1));

    sessionId = await shared.getSessionId() ?? "N/A";
    branchName = await shared.getBranch() ?? "N/A";
    deptName = await shared.getDept() ?? "N/A";
    empName = await shared.getempName() ?? "N/A";
    setState(() {
    });
  }

  Future getEmpId() async {
    empNewId = await shared.getEmpId();
  }

  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    var titleName = "OD Requisition";
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(title: titleName.text.make()),

        /*floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, MyRoutings.odAttendanceListRoute);
          },
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(
            Icons.list, color: Mythemes.whitish, size: 28,
          ),
        ),*/
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*Padding(
                padding: EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                      borderSide: BorderSide(
                          width: 1, color: Mythemes.blackishade),
                    ),

                    hintText: "For",
                    labelText: "For",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.all(5),

                    // labelText: "Location",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,fontSize: 13,
                        color: Mythemes.blackish),
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Select'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Self'),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text('Reportees'),
                      value: 3,
                    ),
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      value = value!;
                    });
                  }

              ),
              ),*/
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(text: branchName),
                  readOnly: true,
                  //initialValue: "${branchName}",
                  decoration: InputDecoration(
                    hintText: "Branch Name",
                    labelText: "Branch Name",
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(text: deptName),
                  readOnly: true,
                  //initialValue: deptName,
                  decoration: InputDecoration(
                    hintText: "Department Name",
                    labelText: "Department Name",
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(text: empName),
                  readOnly: true,
                  //initialValue: empName,
                  decoration: InputDecoration(
                    hintText: "Employee Name",
                    labelText: "Employee Name",
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: "1",
                              groupValue: dayRadio,
                              onChanged: (value) {
                                setState(() {
                                  singleDayShow = true;
                                  multipleDayShow = false;
                                  /*  _singleDayShow == _singleDayShow;
                                           _multipleDayShow == _multipleDayShow;*/
                                });
                                setState(() {
                                  dayRadio = value.toString();
                                });
                              },
                            ),
                            "Single Day".text.make(),
                          ],
                        ).px8(),
                        Row(
                          /*mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,*/
                          children: [
                            Radio(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: "2",
                              groupValue: dayRadio,
                              onChanged: (value) {
                                setState(() {
                                  singleDayShow = true;
                                  multipleDayShow = true;
                                  /*  _singleDayShow =_singleDayShow;
                                          _multipleDayShow =! _multipleDayShow;*/
                                });
                                setState(() {
                                  dayRadio = value.toString();
                                });
                              },
                            ),
                            "Multiple Day".text.make(),
                          ],
                        ).px8(),
                        Visibility(
                          visible: false,
                          child:
                              Row(
                                /* mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,*/
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: "3",
                                    groupValue: dayRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        singleDayShow = true;
                                        multipleDayShow = false;
                                        /* _singleDayShow == _singleDayShow;
                                            _multipleDayShow = !_multipleDayShow;*/
                                      });
                                      setState(() {
                                        dayRadio = value.toString();
                                      });
                                    },
                                  ),
                                  "Half Day".text.make(),
                                ],
                              ).px1(),
                        ),
                      ],
                    ).pLTRB(0, 0, 5, 5),
                  ),
                ],
              ),

              Row(
                children: [
                  Visibility(
                    visible: singleDayShow,
                    child: Expanded(
                      child:
                          TextFormField(
                            onTap: () async {
                              DateTime? fromDate = DateTime.now();
                              FocusScope.of(
                                context,
                              ).requestFocus(FocusNode());

                              fromDate = await showDatePicker(
                                context: context,
                                initialDate: fromDate,
                                firstDate: DateTime(1947),
                                lastDate: DateTime(2040),
                              );
                              setState(() {
                                //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                _fromDateController.text = DateFormat(
                                  "dd-MM-yyyy",
                                ).format(fromDate!);
                              });

                            },
                            readOnly: true,
                            enabled: true,
                            controller: _fromDateController,
                            // initialValue: "Head Office",
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month, size: 18),
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              labelText: "From Date",
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(5),
                              /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                              // labelText: "Location",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Mythemes.blackish,
                              ),
                            ),
                          ).p8(),
                    ),
                  ),

                  Visibility(
                    visible: multipleDayShow,
                    child: Expanded(
                      child:
                          TextFormField(
                            onTap: () async {
                              DateTime? toDate = DateTime.now();
                              FocusScope.of(
                                context,
                              ).requestFocus(FocusNode());

                              toDate = await showDatePicker(
                                context: context,
                                initialDate: toDate,
                                firstDate: DateTime(1947),
                                lastDate: DateTime(2040),
                              );
                              setState(() {
                                //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                _toDateController.text = DateFormat(
                                  "dd-MM-yyyy",
                                ).format(toDate!);
                              });

                            },
                            readOnly: true,
                            enabled: true,
                            controller: _toDateController,
                            // initialValue: "Head Office",
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month, size: 18),
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              labelText: "To Date",
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(5),
                              /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                              // labelText: "Location",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Mythemes.blackish,
                              ),
                            ),
                          ).p8(),
                    ),
                  ),
                ],
              ).pLTRB(0, 0, 0, 8),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _remarkController,
                  maxLines: 2,
                  enabled: true,
                  //initialValue: deptName,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.textsms),
                    hintText: "Add remarks",
                    labelText: "Remarks",
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (dayRadio == '1') {
                        singleDayRequisition(
                          _remarkController.text,
                          _fromDateController.text,
                          empNewId,
                        );
                      } else if (dayRadio == '2') {
                        multipleDayRequisition(
                          _remarkController.text,
                          _toDateController.text,
                          _fromDateController.text,
                          empNewId,
                        );
                      }

                      //key = "APPROVED";
                      //approveLeaveRequisition(_commentController.text, leaveReqId);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Mythemes.lightBluishColor,
                      ),
                    ),
                    child: "Send".text.make(),
                  ).wh(150, 40).py24(),
                ],
              ),
            ],
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
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
              );
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            }
            if (index == 2) {
              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
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
              //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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

  Future<void> singleDayRequisition(
    String getRemark,
    fromDate,
    empNewId,
  ) async {
    //String idn=leavereqIdGlobel.last;
    String dayRadio = "1";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.tourRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "fromDate=$fromDate&"
      "summary=$getRemark&"
      "radio=$dayRadio&"
      "empid=$empNewId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    if (response.statusCode == 200) {
      var responseResult = response.body;
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      if (result.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          "${reason.upperCamelCase} ",
          "Success",
        );
      } else if (result.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase,
          " Error ",
        );
      }
    }
  }

  Future<void> multipleDayRequisition(
    String getRemark,
    toDate,
    fromDate,
    empNewId,
  ) async {
    //String idn=leavereqIdGlobel.last;
    String dayRadio = "2";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.tourRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "tilldate=$toDate&"
      "sessionId=$sessionId&"
      "fromDate=$fromDate&"
      "summary=$getRemark&"
      "radio=$dayRadio&"
      "empid=$empNewId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    if (response.statusCode == 200) {
      var responseResult = response.body;
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      if (result.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          "${reason.upperCamelCase} ",
          "Success",
        );
      } else if (result.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase,
          " Error ",
        );
      }
    }
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
