import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
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

import '../../MSS_MO_Bundle/timeAndAttendance/mssMoAttendanceApprovalListL2.dart';
import '../../modules/timeAndAttendance/reports/attendanceRequisition/model/onDateReportModel.dart';
import '../../modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';

class ShortLeaveApprovalPageL2MO extends StatefulWidget {
  PendingRequisitionModel pendingRequisitionModel;
  int itemCount;

  ShortLeaveApprovalPageL2MO(this.pendingRequisitionModel, this.itemCount);

  @override
  State<ShortLeaveApprovalPageL2MO> createState() => _ShortLeaveApprovalPageL2MOState(
      pendingRequisitionModel,itemCount);
}

class _ShortLeaveApprovalPageL2MOState extends State<ShortLeaveApprovalPageL2MO> with RouteAware{
  PendingRequisitionModel pendingRequisitionModel;
  int itemCount;
  String? _group1SelectedValue;
  String radios = "onDate";
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  String? userPanel;
  String? branchNameset;
  String? updatedWorkHourSet;
  String? relaxationHourSet;
  String? workingHrsSet;
  String? shiftWorkingHourSet;
  String? departmentset;
  String? employeeNameset;
  String? onDateset;
  String? inTimeReqset;
  String? outTimeReqset;
  String? actualTimeset;
  String? actualOutTimeset;
  int? empId;


  _ShortLeaveApprovalPageL2MOState(this.pendingRequisitionModel, this.itemCount);

  @override
  void initState() {
    getSharedPrfanceList();
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    print("User Panel - $userPanel");

    setState(() {

    });
    if(userPanel == "MSS") {
      _inTimePicker = foundDataNewMO![itemCount].inTime.toString();
      print("Intime - $_inTimePicker");
      _outTimePicker = foundDataNewMO![itemCount].outTime.toString();
      employeeNameset=foundDataNewMO![itemCount].empName.toString();
      departmentset=foundDataNewMO![itemCount].department.toString();
      branchNameset=foundDataNewMO![itemCount].branch.toString();
      onDateset=foundDataNewMO![itemCount].onDate.toString();
      updatedWorkHourSet=foundDataNewMO![itemCount].updatedWorkingHour.toString();
      relaxationHourSet=foundDataNewMO![itemCount].relaxationHour.toString();
      workingHrsSet=foundDataNewMO![itemCount].shiftWorkingHour.toString();
      shortLeave= foundDataNewMO![itemCount].shortLeaveRequistionType;
      print("Short Leave Fields - $shortLeave");
      actualTimeset= foundDataNewMO![itemCount].actualInTime;
      inTimeReqset= foundDataNewMO![itemCount].inTime;
      //inRemarkset= foundDataNewMO![itemCount].inRemarks;
      actualOutTimeset= foundDataNewMO![itemCount].actualOutTime;
      outTimeReqset= foundDataNewMO![itemCount].outTime;
      //outRemarkset= foundDataNewMO![itemCount].outRemarks;
      attReqId = foundDataNewMO![itemCount].requestId;
    } else {
      _inTimePicker = foundDataNewMO![itemCount].inTime.toString();
      _outTimePicker = foundDataNewMO![itemCount].outTime.toString();
      employeeNameset=foundDataNewMO![itemCount].empName.toString();
      departmentset=foundDataNewMO![itemCount].department.toString();
      branchNameset=foundDataNewMO![itemCount].branch.toString();
      onDateset=foundDataNewMO![itemCount].onDate.toString();
      updatedWorkHourSet=foundDataNewMO![itemCount].updatedWorkingHour.toString();
      relaxationHourSet=foundDataNewMO![itemCount].relaxationHour.toString();
      workingHrsSet=foundDataNewMO![itemCount].shiftWorkingHour.toString();
      shortLeave= foundDataNewMO![itemCount].shortLeaveRequistionType;
      print("Short Leave Fields - $shortLeave");
      actualTimeset= foundDataNewMO![itemCount].actualInTime;
      inTimeReqset= foundDataNewMO![itemCount].inTime;
      //inRemarkset= foundDataNewMO![itemCount].inRemarks;
      actualOutTimeset= foundDataNewMO![itemCount].actualOutTime;
      outTimeReqset= foundDataNewMO![itemCount].outTime;
      //outRemarkset= foundDataNewMO![itemCount].outRemarks;
      attReqId = foundDataNewMO![itemCount].requestId;
    }
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
  TextEditingController shortLeaveRemarkController = TextEditingController();
  String onDateRadio = "1";
  String nextDayRadio = "0";
  String compOffRadio = "0";
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;
  List<bool> _isSelected = [false, false, false];
  bool nightShift = false;
  bool compOff = false;
  bool shortLeave = false;
  bool light0 = true;
  bool light1 = true;
  bool isShortLeave = true;
  int? attReqId;
  var name = "Name";

  static const WidgetStateProperty<Icon> thumbIcon = WidgetStateProperty<Icon>.fromMap(
    <WidgetStatesConstraint, Icon>{
      WidgetState.selected: Icon(Icons.check),
      WidgetState.any: Icon(Icons.close),
    },
  );

  Widget buildVerticalToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 1, // smaller switch
          child: Switch(
            thumbIcon: thumbIcon,
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.blueAccent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Mythemes.greyishade,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: "Short Leave Approval".text.make(),
          elevation: 0.5,
        ),
        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:  Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style:TextStyle(fontSize:14),
                            controller: TextEditingController(text: branchNameset),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8.0),
                                hintText: branchNameset,
                                labelText: "Branch Name",
                                labelStyle: TextStyle(fontSize: 15)
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child:
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style:TextStyle(fontSize:14),
                            controller: TextEditingController(text: departmentset),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8.0),
                                hintText: departmentset,
                                labelText: "Department",
                                labelStyle: TextStyle(fontSize: 15)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style:TextStyle(fontSize:14),
                            controller: TextEditingController(text: employeeNameset),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8.0),
                                hintText: employeeNameset,
                                labelText: "Employee Name",
                                labelStyle: TextStyle(fontSize: 15)
                            ),
                          ),
                        ),

                      ),
                      Expanded(
                        child:
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            style:TextStyle(fontSize:14),
                            controller: TextEditingController(text: onDateset),
                            readOnly: true,
                            //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8.0),
                                hintText: onDateset,
                                labelText: "On Date",
                                labelStyle: TextStyle(fontSize: 15)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Yes Short Leave
                  Visibility(
                    visible: shortLeave == true,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              style:TextStyle(fontSize:14, color: Mythemes.successColor, fontWeight: FontWeight.bold),
                              controller: TextEditingController(text: actualTimeset),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: actualTimeset,
                                  labelText: "In Time",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              style:TextStyle(fontSize:14, color: Mythemes.warningColor, fontWeight: FontWeight.bold),
                              controller: TextEditingController(text: actualOutTimeset),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: actualOutTimeset,
                                  labelText: "Out Time",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: shortLeave == true,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              style:TextStyle(fontSize:14, fontWeight: FontWeight.bold),
                              controller: TextEditingController(text: workingHrsSet),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: workingHrsSet,
                                  labelText: "Actual Work Hours",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              style:TextStyle(fontSize:14, fontWeight: FontWeight.bold),
                              controller: TextEditingController(text: relaxationHourSet),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: relaxationHourSet,
                                  labelText: "Short Leave Relaxation Hour",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: shortLeave == true,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              style:TextStyle(fontSize:14, fontWeight: FontWeight.bold),
                              controller: TextEditingController(text: updatedWorkHourSet),
                              readOnly: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: updatedWorkHourSet,
                                  labelText: "Updated Work Hour",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: shortLeave == true,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              maxLines: 3,
                              style:TextStyle(fontSize:14),
                              controller: inRemarkController,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                    borderSide: BorderSide(
                                        width: 1, color: Mythemes.greyishade),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: "Add Remark",
                                  labelText: "Remarks",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: Vx.mOnly(right: 16),
                          children: [


                            ElevatedButton(
                              onPressed: () {
                                disapprovedRequisition(inRemarkController.text, attReqId);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Mythemes.dangerColorOne),
                              ),
                              child: "Disapprove".text.make(),
                            ).wh(150, 40).py12(),
                            ElevatedButton(
                              onPressed: () {
                                print(inRemarkController.text);
                                approvedRequisition(inRemarkController.text, attReqId);
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
            ),

            //RadioGroups(attendanceModelGlobel,indexCont)
          ),
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
            context, "$body" + " ", "Success");
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