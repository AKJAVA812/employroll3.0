import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/onDuty/reports/pendingRequisition/modalClass/pendingOdReqList.dart';
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
import 'package:er_flutter_project/MSS_Bundle/timeAndAttendance/outDuty/pendingRequisitionList.dart';
import 'package:er_flutter_project/MSS_MO_Bundle/timeAndAttendance/outDuty/pendingRequisitionList.dart';
import 'package:er_flutter_project/UIS_Bundle/timeAndAttendance/outDuty/pendingRequisitionList.dart';

class OdApproveDisapproveReq extends StatefulWidget {
  PendingOdReqList? pendingOdReqList;
  int indexCont;
  OdApproveDisapproveReq(this.pendingOdReqList, this.indexCont);

  @override
  State<OdApproveDisapproveReq> createState() =>
      _OdApproveDisapproveReqState(pendingOdReqList, indexCont);
}

dynamic userPanel;
dynamic getProfileId;

class _OdApproveDisapproveReqState extends State<OdApproveDisapproveReq> {
  PendingOdReqList? pendingOdReqList;
  int indexCont;
  _OdApproveDisapproveReqState(this.pendingOdReqList, this.indexCont);

  var titleName = "Approved OD Requisition";
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
            child: RadioGroups(pendingOdReqList!, indexCont),
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
}

class RadioGroups extends StatefulWidget {
  PendingOdReqList pendingOdReqList;
  int indexCont;

  RadioGroups(this.pendingOdReqList, this.indexCont);

  @override
  State<RadioGroups> createState() =>
      _RadioGroupsState(pendingOdReqList, indexCont);
}

class _RadioGroupsState extends State<RadioGroups> {
  PendingOdReqList pendingOdReqList;
  int indexCont;

  _RadioGroupsState(this.pendingOdReqList, this.indexCont);
  var empName;
  var image;
  var odDate;
  var odType;
  var odTime;
  var odAddress;
  var odRemark;
  var type;
  var odId;
  SessionManager sessionManager = SessionManager();
  Map<String, dynamic> mapResponse = {};
  SessionManager shared = SessionManager();
  String? sessionId;
  String? commentRo;
  int? attReqId;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    //await Future.delayed(Duration(seconds: 1));
    sessionId = await shared.getSessionId() ?? "N/A";
    userPanel = await shared.getUserPanel() ?? "N/A";
    getProfileId = await shared.getDefaultProfileId() ?? "N/A";

    setState(() {
      if (userPanel == "MSS") {
        empName = foundDataNewMSS![indexCont].name;
        image = foundDataNewMSS![indexCont].image;
        odDate = foundDataNewMSS![indexCont].date;
        odType = foundDataNewMSS![indexCont].odtype;
        odTime = foundDataNewMSS![indexCont].odtime;
        odAddress = foundDataNewMSS![indexCont].odaddress;
        odRemark = foundDataNewMSS![indexCont].remark;
        odId = foundDataNewMSS![indexCont].id;
      }
      if (userPanel == "MSS_MO_ADMIN") {
        empName = foundDataNewMO![indexCont].name;
        image = foundDataNewMO![indexCont].image;
        odDate = foundDataNewMO![indexCont].date;
        odType = foundDataNewMO![indexCont].odtype;
        odTime = foundDataNewMO![indexCont].odtime;
        odAddress = foundDataNewMO![indexCont].odaddress;
        odRemark = foundDataNewMO![indexCont].remark;
        odId = foundDataNewMO![indexCont].id;
      }
      if (userPanel == "USER") {
        empName = foundDataNewUIS![indexCont].name;
        image = foundDataNewUIS![indexCont].image;
        odDate = foundDataNewUIS![indexCont].date;
        odType = foundDataNewUIS![indexCont].odtype;
        odTime = foundDataNewUIS![indexCont].odtime;
        odAddress = foundDataNewUIS![indexCont].odaddress;
        odRemark = foundDataNewUIS![indexCont].remark;
        odId = foundDataNewUIS![indexCont].id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              border: Border.all(color: Mythemes.lightBluishColor, width: 3),
              shape: BoxShape.circle,
              color: Mythemes.whitish,
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: NetworkImage('$image'),
                //FileImage(file!)
              ),
            ),
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
                      labelText: "Name",
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
                    controller: TextEditingController(text: odDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: odDate,
                      labelText: "OD Date",
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
                    controller: TextEditingController(text: odType),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: odType,
                      labelText: "OD Type",
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
                    controller: TextEditingController(text: odTime),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0),
                      enabled: false,
                      hintText: odTime,
                      labelText: "OD Time",
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
                    controller: TextEditingController(text: odAddress),
                    maxLines: 3,
                    style: TextStyle(fontSize: 14),
                    enabled: false,
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
                      hintText: odAddress,
                      labelText: "OD Address",
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
                    controller: TextEditingController(text: odRemark),
                    maxLines: 3,
                    style: TextStyle(fontSize: 14),
                    enabled: false,
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
                      hintText: odRemark,
                      labelText: "OD Remarks",
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
                    controller: _commentController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14),
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
                      hintText: "Add Comments",
                      labelText: "Comments",
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
                        type = "DisApproved";
                        disApproveODReq(_commentController.text);
                        //disapprovedRequisition(_commentController.text, attReqId);
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
                        type = "Approved";
                        print(_commentController.text);
                        approveODReq(_commentController.text);
                        //approvedRequisition(_commentController.text, attReqId);
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
          ).py32(),
        ],
      ),
    );
  }

  Future<void> approveODReq(String getComment) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.odReqApproveDisAp;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "odid=$odId&"
      "type=$type&"
      "remark=$getComment",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = mapResponse['reason'];
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        showDialgSucess1(context, reason.upperCamelCase + " ", "Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        showDialgSucess1(context, reason.upperCamelCase, " Error ");
      }
    }
  }

  Future<void> disApproveODReq(String getComment) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.odReqApproveDisAp;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "odid=$odId&"
      "type=$type&"
      "remark=$getComment",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = mapResponse['reason'];
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
            if (Navigator.of(context).canPop()) {
              // âœ… Using `context` inside the builder
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(); // Close the dialog
              Navigator.of(buildContext).maybePop();
            } else {
              print("âš ï¸ Warning: No route to close.");
            }
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
