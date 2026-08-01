import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/leaveManagement/reports/pendingRequisition/pendingRequisitionList.dart';
import 'package:er_flutter_project/MSS_MO_Bundle/leaveManagement/pendingRequisitionList.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../MSS_Bundle/leaveManagement/pendingRequisitionList.dart';
import '../../../../UIS_Bundle/leaveManagement/pendingRequisitionList.dart';
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
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../modalClass/pendingLeaveRequisitionModal.dart';

class PendingLeaveApproveDisapprove extends StatefulWidget {
  PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  int itemCount;

  PendingLeaveApproveDisapprove(
    this.pendingLeaveRequisitionModal,
    this.itemCount,
  );

  @override
  State<PendingLeaveApproveDisapprove> createState() =>
      _PendingLeaveApproveDisapproveState(
        pendingLeaveRequisitionModal,
        itemCount,
      );
}

var userPanelPermissions;

class _PendingLeaveApproveDisapproveState
    extends State<PendingLeaveApproveDisapprove> {
  PendingLeaveRequisitionModal? pendingLeaveRequisitionModal;
  int itemCount;
  _PendingLeaveApproveDisapproveState(
    this.pendingLeaveRequisitionModal,
    this.itemCount,
  );
  var titleName = "Leave Approval";
  int pageIndex = 0;
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: titleName.text.make(), elevation: 0.5),
        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: PendingLeaveApprovalDisapproval(
              pendingLeaveRequisitionModal!,
              itemCount,
            ),
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
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              print('Leave');
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
              icon: Icon(Icons.group_off),
              label: 'Leave',
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

class PendingLeaveApprovalDisapproval extends StatefulWidget {
  PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  int itemCount;

  PendingLeaveApprovalDisapproval(
    this.pendingLeaveRequisitionModal,
    this.itemCount,
  );

  @override
  State<PendingLeaveApprovalDisapproval> createState() =>
      _PendingLeaveApprovalDisapprovalState(
        pendingLeaveRequisitionModal,
        itemCount,
      );
}

class _PendingLeaveApprovalDisapprovalState
    extends State<PendingLeaveApprovalDisapproval> {
  PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  int itemCount;
  _PendingLeaveApprovalDisapprovalState(
    this.pendingLeaveRequisitionModal,
    this.itemCount,
  );
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  String? leaveType = "Sick Leave";
  var lBalance;
  String? branchName;
  String? department;
  String? empName;
  String? applicationDate;
  String? fromDate;
  String? toDate;
  String? reqRemarks;
  String? approvalRemarks;
  int? leaveReqId;
  String? status;
  var approved = "APPROVED";
  var key = "";
  var disapproved = "DISAPPROVED";
  var comment = "Comments";
  late var result;
  final TextEditingController _commentController = TextEditingController();

  var getComment;
  @override
  void initState() {
    getSharedPrfanceList();
    /*if(userPanelPermissions == "MSS") {

    }
    if(userPanelPermissions == "MSS_MO_ADMIN") {
      leaveType = foundDataNewMO![itemCount].leaveType;
      lBalance = foundDataNewMO![itemCount].totalLeave;
      branchName = foundDataNewMO![itemCount].branchName;
      department = foundDataNewMO![itemCount].department;
      empName = foundDataNewMO![itemCount].employeeName;
      applicationDate = foundDataNewMO![itemCount].applicationDate;
      fromDate = foundDataNewMO![itemCount].startDate;
      toDate = foundDataNewMO![itemCount].endDate;
      reqRemarks = foundDataNewMO![itemCount].summary;
      leaveReqId = foundDataNewMO![itemCount].reqId;
      status = foundDataNewMO![itemCount].status;
    }
    if(userPanelPermissions == "USER") {
      leaveType = foundDataNewUIS![itemCount].leaveType;
      lBalance = foundDataNewUIS![itemCount].totalLeave;
      branchName = foundDataNewUIS![itemCount].branchName;
      department = foundDataNewUIS![itemCount].department;
      empName = foundDataNewUIS![itemCount].employeeName;
      applicationDate = foundDataNewUIS![itemCount].applicationDate;
      fromDate = foundDataNewUIS![itemCount].startDate;
      toDate = foundDataNewUIS![itemCount].endDate;
      reqRemarks = foundDataNewUIS![itemCount].summary;
      leaveReqId = foundDataNewUIS![itemCount].reqId;
      status = foundDataNewUIS![itemCount].status;
    }*/

    //getComment = _commentController;
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanelPermissions = await shared!.getUserPanel();
    if (userPanelPermissions == "MSS") {
      leaveType = foundDataNewMSS![itemCount].leaveType;
      lBalance = foundDataNewMSS![itemCount].totalLeave;
      branchName = foundDataNewMSS![itemCount].branchName;
      department = foundDataNewMSS![itemCount].department;
      empName = foundDataNewMSS![itemCount].employeeName;
      applicationDate = foundDataNewMSS![itemCount].applicationDate;
      fromDate = foundDataNewMSS![itemCount].startDate;
      toDate = foundDataNewMSS![itemCount].endDate;
      reqRemarks = foundDataNewMSS![itemCount].summary;
      leaveReqId = foundDataNewMSS![itemCount].reqId;
      status = foundDataNewMSS![itemCount].status;
    }
    if (userPanelPermissions == "MSS_MO_ADMIN") {
      leaveType = foundDataNewMO![itemCount].leaveType;
      lBalance = foundDataNewMO![itemCount].totalLeave;
      branchName = foundDataNewMO![itemCount].branchName;
      department = foundDataNewMO![itemCount].department;
      empName = foundDataNewMO![itemCount].employeeName;
      applicationDate = foundDataNewMO![itemCount].applicationDate;
      fromDate = foundDataNewMO![itemCount].startDate;
      toDate = foundDataNewMO![itemCount].endDate;
      reqRemarks = foundDataNewMO![itemCount].summary;
      leaveReqId = foundDataNewMO![itemCount].reqId;
      status = foundDataNewMO![itemCount].status;
    }
    if (userPanelPermissions == "USER") {
      leaveType = foundDataNewUIS![itemCount].leaveType;
      lBalance = foundDataNewUIS![itemCount].totalLeave;
      branchName = foundDataNewUIS![itemCount].branchName;
      department = foundDataNewUIS![itemCount].department;
      empName = foundDataNewUIS![itemCount].employeeName;
      applicationDate = foundDataNewUIS![itemCount].applicationDate;
      fromDate = foundDataNewUIS![itemCount].startDate;
      toDate = foundDataNewUIS![itemCount].endDate;
      reqRemarks = foundDataNewUIS![itemCount].summary;
      leaveReqId = foundDataNewUIS![itemCount].reqId;
      status = foundDataNewUIS![itemCount].status;
    }

    setState(() {});
    print("Panel - $userPanelPermissions");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: TextEditingController(text: leaveType),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: leaveType,
                      labelText: "Leave Type",
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
                    controller: TextEditingController(text: "$lBalance"),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: "$lBalance",
                      labelText: "Leave Balance",
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
                    controller: TextEditingController(text: branchName),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: branchName,
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
                    controller: TextEditingController(text: department),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: department,
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
                    controller: TextEditingController(text: empName),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: empName,
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
                    controller: TextEditingController(text: applicationDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: applicationDate,
                      labelText: "Application Date",
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
                    controller: TextEditingController(text: fromDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: fromDate,
                      labelText: "From Date",
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
                    controller: TextEditingController(text: toDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: toDate,
                      labelText: "To Date",
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
                    controller: TextEditingController(text: reqRemarks),
                    readOnly: true,
                    maxLines: 3,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: reqRemarks,
                      labelText: "Requisition Remarks",
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
                    controller: _commentController,
                    maxLines: 3,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      hintText: approvalRemarks,
                      labelText: "Approval Remarks",
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
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding: Vx.mOnly(right: 16),
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        key = "DISAPPROVED";
                        disApproveLeaveRequisition(
                          _commentController.text,
                          leaveReqId,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Mythemes.dangerColorOne,
                        ),
                      ),
                      child: "Disapprove".text.make(),
                    ).wh(150, 40).py12(),
                    ElevatedButton(
                      onPressed: () {
                        key = "APPROVED";
                        approveLeaveRequisition(
                          _commentController.text,
                          leaveReqId,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Mythemes.successColor,
                        ),
                      ),
                      child: "Approve".text.make(),
                    ).wh(150, 40).py12(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> approveLeaveRequisition(
    String getComment,
    int? leaveReqId,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveApprovalApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "leavereqid=$leaveReqId&"
      "status=$key&"
      "comment=$getComment",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        showDialgSucess1(context, reason.upperCamelCase + " ", "Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        showDialgSucess1(context, reason.upperCamelCase, " Error ");
      } else if (result.compareToIgnoringCase("warning") == 0) {
        showDialgSucess1(context, reason.upperCamelCase, " Warning ");
      }
    }
  }

  Future<void> disApproveLeaveRequisition(
    String getComment,
    int? leaveReqId,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveApprovalApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "leavereqid=$leaveReqId&"
      "status=$key&"
      "comment=$getComment",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        showDialgSucess1(context, reason.upperCamelCase + " ", "Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        showDialgSucess1(context, reason.upperCamelCase, " Error ");
      }
    }
  }

  showDialgSucess1(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
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
                      PendingLeaveRequisitionList(PendingLeaveRequisitionModal()),
                  transitionDuration: Duration(seconds: 1),
                  maintainState: true,
                ));*/
            Navigator.of(buildContext, rootNavigator: true).pop();
            Navigator.pushNamed(
              buildContext,
              MyRoutings.mssPendingLeaveRequestRoute,
            );
            //Navigator.pop(context);
            //Navigator.of(buildContext, rootNavigator: true).pop();
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
      },
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
