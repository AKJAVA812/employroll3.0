import 'dart:convert';

import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/pendingRequisition/pendingReqListRo.dart';
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
import 'package:http/http.dart' as http;

import '../../MSS_MO_Bundle/timeAndAttendance/mssMoAttendanceApprovalListL2.dart';


class MO_AttendanceApprovalPageL2 extends StatefulWidget {
  PendingRequisitionModel pendingRequisitionModel;
  int itemCount;

  MO_AttendanceApprovalPageL2(this.pendingRequisitionModel, this.itemCount);

  @override
  State<MO_AttendanceApprovalPageL2> createState() => _MO_AttendanceApprovalPageL2State(pendingRequisitionModel,itemCount);
}

class _MO_AttendanceApprovalPageL2State extends State<MO_AttendanceApprovalPageL2> {
  PendingRequisitionModel pendingRequisitionModel;
  int itemCount;

  _MO_AttendanceApprovalPageL2State(this.pendingRequisitionModel, this.itemCount);

  var titleName = "Attendance Approval";
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: titleName.text.make(),
          elevation: 0.5,
        ),
        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
              child: RadioGroups(pendingRequisitionModel,itemCount)),
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
              //Navigator.of(context, rootNavigator: true).pop();
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );
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
      ),
    );
  }
}

class RadioGroups extends StatefulWidget {
  PendingRequisitionModel pendingRequisitionModel;
  int itemCount;

  RadioGroups(this.pendingRequisitionModel, this.itemCount);

  @override
  State<RadioGroups> createState() => _RadioGroupsState(pendingRequisitionModel,itemCount);
}

class _RadioGroupsState extends State<RadioGroups> {
  PendingRequisitionModel pendingRequisitionModel;
  int itemCount;
  final TextEditingController _inTimeReqController = TextEditingController();
  final TextEditingController _outTimeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  _RadioGroupsState(this.pendingRequisitionModel, this.itemCount);
  var name = "Name";
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  var empName = "Employee Name";
  String? sessionId;
  String? userPanel;
  var _outTimePicker;
  var _inTimePicker;
  String? dateSet;
  String? actualInTimeset;
  String? inTimeReqset;
  String? inRemarkset;
  String? actualOutTimeset;
  String? outTimeReqset;
  String? outRemarkset;
  String? commentRo;
  int? attReqId;

  @override
  void initState() {
    getSharedPrfanceList();

    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    print("User Panel - $userPanel");

    /*if(userPanel == "MSS") {
      _inTimePicker = foundDataNewMSS![itemCount].inTime.toString();
      _outTimePicker = foundDataNewMSS![itemCount].outTime.toString();
      name=foundDataNewMSS![itemCount].empName.toString();

      dateSet= foundDataNewMSS![itemCount].onDate;
      actualInTimeset= foundDataNewMSS![itemCount].actualInTime;
      inTimeReqset= foundDataNewMSS![itemCount].inTime;
      inRemarkset= foundDataNewMSS![itemCount].inRemarks;
      actualOutTimeset= foundDataNewMSS![itemCount].actualOutTime;
      outTimeReqset= foundDataNewMSS![itemCount].outTime;
      outRemarkset= foundDataNewMSS![itemCount].outRemarks;
      attReqId = foundDataNewMSS![itemCount].requestId;
    }*/

    if(userPanel == "MSS_MO_ADMIN") {
      _inTimePicker = foundDataNewMO![itemCount].inTime.toString();
      _outTimePicker = foundDataNewMO![itemCount].outTime.toString();
      name=foundDataNewMO![itemCount].empName.toString();

      dateSet= foundDataNewMO![itemCount].onDate;
      actualInTimeset= foundDataNewMO![itemCount].actualInTime;
      inTimeReqset= foundDataNewMO![itemCount].inTime;
      inRemarkset= foundDataNewMO![itemCount].inRemarks;
      actualOutTimeset= foundDataNewMO![itemCount].actualOutTime;
      outTimeReqset= foundDataNewMO![itemCount].outTime;
      outRemarkset= foundDataNewMO![itemCount].outRemarks;
      attReqId = foundDataNewMO![itemCount].requestId;
    }

    /*if(userPanel == "USER") {
      _inTimePicker = foundDataNewUIS![itemCount].inTime.toString();
      _outTimePicker = foundDataNewUIS![itemCount].outTime.toString();
      name=foundDataNewUIS![itemCount].empName.toString();

      dateSet= foundDataNewUIS![itemCount].onDate;
      actualInTimeset= foundDataNewUIS![itemCount].actualInTime;
      inTimeReqset= foundDataNewUIS![itemCount].inTime;
      inRemarkset= foundDataNewUIS![itemCount].inRemarks;
      actualOutTimeset= foundDataNewUIS![itemCount].actualOutTime;
      outTimeReqset= foundDataNewUIS![itemCount].outTime;
      outRemarkset= foundDataNewUIS![itemCount].outRemarks;
      attReqId = foundDataNewUIS![itemCount].requestId;
    }*/
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {



    Future<void> _openInTimepicker(BuildContext context) async {
      final TimeOfDay? n = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return
              MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
          });
      print('timenew $n');
      _inTimePicker = n.toString();
      setState(() {

      });
    }

    Future<void> _openOutTimepicker(BuildContext context) async {
      final TimeOfDay? o = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return
              MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
          });
      print('timeOutnew $o');
      _outTimePicker = o.toString();
      setState(() {

      });
      /*if (selectedTimeRTL != null) {
        setState(() {
          _outTimePicker = selectedTimeRTL.format(context);
          print(_outTimePicker);
        });
      }*/

    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: ListTile(
                    title: "Name".text.maxFontSize(12).make().px4().py2(),
                    subtitle: TextFormField(
                      //controller: _locationController,
                      enabled: false,
                      // initialValue: "Head Office",
                      //maxLines: 3,
                      decoration: InputDecoration(
                        hintText: name,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
              Expanded(
                  child: ListTile(
                    title: "Date".text.maxFontSize(12).sm.make().px4().py2(),
                    subtitle: TextFormField(
                      //controller: _locationController,
                      enabled: false,
                      // initialValue: "Head Office",
                      // maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        hintText: dateSet,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ListTile(
                    title: "Actual In Time".text.maxFontSize(12).make().px4().py2(),
                    subtitle: TextFormField(
                      //controller: _locationController,
                      enabled: false,
                      // initialValue: "Head Office",
                      //maxLines: 3,
                      decoration: InputDecoration(
                        hintText: actualInTimeset,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
              Expanded(
                  child: ListTile(
                    title: "Requisition In Time".text.maxFontSize(12).sm.make().px4().py2(),
                    subtitle: InkWell(
                      onTap: () async{
                        //_openInTimepicker(context);
                        final TimeOfDay? n = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return
                                MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                            });
                        print('timenew $n');
                        setState(() {
                          var now = DateTime.now();
                          DateTime t = DateTime(now.year, now.month, now.day, n!.hour, n!.minute);
                          var nT= DateFormat('HH:mm').format(t);
                          print(DateFormat('HH:mm').format(t));
                          _inTimePicker = nT;
                        });
                      },
                      child: TextFormField(
                        onTap: () async {
                        },
                        controller: _inTimeReqController,
                        enabled: false,
                        //initialValue: _inTimePicker,
                        // maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: _inTimePicker,
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          // labelText: "Location",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500, color: Mythemes.blackish),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ListTile(
                    title: "In Remarks".text.maxFontSize(12).make().px4().py2(),
                    subtitle: TextFormField(
                      //controller: _locationController,
                      enabled: false,
                      // initialValue: "Head Office",
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: inRemarkset,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Mythemes.greyishade)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Mythemes.greyishade),
                            borderRadius: BorderRadius.all(Radius.circular(12)
                            )
                        ),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ListTile(
                    title:
                    "Actual Out Time".text.maxFontSize(12).make().px4().py2(),
                    subtitle: TextFormField(
                      //controller: _locationController,
                      enabled: false,
                      // initialValue: "Head Office",
                      //maxLines: 3,
                      decoration: InputDecoration(
                        hintText: actualOutTimeset,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
              Expanded(
                  child: ListTile(
                    title: "Requisition Out Time*"
                        .text
                        .maxFontSize(12)
                        .sm
                        .make()
                        .px4()
                        .py2(),
                    subtitle: InkWell(
                      onTap: () async{
                        //_openOutTimepicker(context);
                        final TimeOfDay? o = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return
                                MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                            });
                        print('timenewOut $o');
                        setState(() {
                          var newNow = DateTime.now();
                          DateTime newt = DateTime(newNow.year, newNow.month, newNow.day, o!.hour, o!.minute);
                          var oT= DateFormat('HH:mm').format(newt);
                          print(DateFormat('HH:mm').format(newt));
                          _outTimePicker = oT;
                        });
                      },
                      child: TextFormField(
                        onTap: () async {


                        },
                        controller: _outTimeController,
                        enabled: false,
                        //initialValue: _outTimePicker,
                        // maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: _outTimePicker,
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          // labelText: "Location",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Mythemes.blackish),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ListTile(
                    title: "Out Remarks".text.maxFontSize(12).make().px4().py2(),
                    subtitle: TextFormField(
                      //controller: _locationController,
                      enabled: false,
                      // initialValue: "Head Office",
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: outRemarkset,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Mythemes.greyishade)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Mythemes.greyishade),
                            borderRadius: BorderRadius.all(Radius.circular(12))),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ListTile(
                    title: "Comments".text.maxFontSize(12).make().px4().py2(),
                    subtitle: TextFormField(
                      controller: _commentController,
                      // initialValue: "Head Office",
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Add Comments",
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Mythemes.greyishade),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Mythemes.greyishade),
                            borderRadius: BorderRadius.all(Radius.circular(12))),
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Mythemes.blackish),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding: Vx.mOnly(right: 16),
                  children: [


                    ElevatedButton(
                      onPressed: () {
                        disapprovedRequisition(_commentController.text, attReqId);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Mythemes.dangerColorOne),
                      ),
                      child: "Disapprove".text.make(),
                    ).wh(150, 40).py12(),
                    ElevatedButton(
                      onPressed: () {
                        print(_commentController.text);
                        approvedRequisition(_commentController.text, attReqId);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Mythemes.successColor),
                      ),
                      child: "Approve".text.make(),
                    ).wh(150, 40).py12(),
                  ]))
            ],
          )
        ],
      ),
    );
  }

  Future<void> approvedRequisition(String text, int? attReqId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingReqListApprove;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "attReqId=$attReqId&"
        "comment=$text&"
        "status=PENDING");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'].toString();
      String title = mapResponse['title'].toString();
      String body = mapResponse['body'].toString();
      String reason = mapResponse['reason'].toString();
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        showDialgSucess1(
            context, "$body" + " ", "$title");
      } else if (result.compareToIgnoringCase("error") == 0) {
        showDialgSucess1(
            context, reason.upperCamelCase, " Error ");
      }
    }
  }
  Future<void> disapprovedRequisition(String text, int? attReqId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingReqListDisapprove;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "attReqId=$attReqId&"
        "comment=$text");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = "";
      String body ="";
      if(result.compareToIgnoringCase("success")==0){
        showDialgSucess1(context, "Attendance Requisition has been Disapproved.", "Success");
      }else{
        showDialgSucess1(context, "Attendance Requisition has Not been Disapproved.", "Error");
      }
    }
  }


  showDialgSucess1(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          )),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text(alert)),
        ],
      ),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            /*Navigator.pop(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) =>
                      PendingRequisitionRo(PendingRequisitionModel()),
                  transitionDuration: Duration(seconds: 1),
                  maintainState: true,
                ));*/
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
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