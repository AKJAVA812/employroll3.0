import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/modalClass/pendingAdvanceReqListModal.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/pendingAdvanceReq/pendingAdvanceReqList.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';

class AppDispPendingAdvanceReq extends StatefulWidget {
  PendingAdvReqListModal pendingAdvReqListModal;
  int i;

  AppDispPendingAdvanceReq(this.pendingAdvReqListModal, this.i);

  @override
  State<AppDispPendingAdvanceReq> createState() =>
      _AppDispPendingAdvanceReqState(pendingAdvReqListModal, i);
}

class _AppDispPendingAdvanceReqState extends State<AppDispPendingAdvanceReq> {
  PendingAdvReqListModal pendingAdvReqListModal;
  int i;

  _AppDispPendingAdvanceReqState(this.pendingAdvReqListModal, this.i);

  var titleName = "Approve Advance Requisition";
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  String? placeTour;
  String? purposeTour;
  String? nDays;
  String? advAmount;
  String? remarks;
  String? claimId;
  String? remarkApp;
  String? appAmt;
  String? appStatus;
  final TextEditingController _approvedAmt = TextEditingController();
  final TextEditingController _approvedRemarks = TextEditingController();

  @override
  void initState() {
    placeTour = foundDataNew![i].placeTour;
    purposeTour = foundDataNew![i].purpose;
    nDays = foundDataNew![i].ndays;
    advAmount = foundDataNew![i].advanceAmt;
    remarks = foundDataNew![i].remark;
    claimId = foundDataNew![i].claimId;
    remarkApp = foundDataNew![i].approvedRemark;
    appAmt = foundDataNew![i].approvedAmount;
    appStatus = foundDataNew![i].approvedStatus;
    setState(() {
      print('check $placeTour');
    });
    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: titleName.text.make()),
        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "Place of Tour".text
                                  .maxFontSize(12)
                                  .make()
                                  .px4()
                                  .py2(),
                          subtitle: TextFormField(
                            controller: TextEditingController(text: placeTour),
                            enabled: false,
                            // initialValue: "Head Office",
                            //maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "Place of Tour",
                              hintStyle: TextStyle(fontSize: 14),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "Purpose of Tour".text
                                  .maxFontSize(12)
                                  .make()
                                  .px4()
                                  .py2(),
                          subtitle: TextFormField(
                            controller: TextEditingController(
                              text: purposeTour,
                            ),
                            enabled: false,
                            // initialValue: "Head Office",
                            //maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "Purpose of Tour",
                              hintStyle: TextStyle(fontSize: 14),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "No. of Days".text
                                  .maxFontSize(12)
                                  .make()
                                  .px4()
                                  .py2(),
                          subtitle: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: nDays),
                            enabled: false,
                            // initialValue: "Head Office",
                            //maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "2",
                              hintStyle: TextStyle(fontSize: 14),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "Amount".text.maxFontSize(12).make().px4().py2(),
                          subtitle: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: advAmount),
                            enabled: false,
                            // initialValue: "Head Office",
                            //maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "1520",
                              hintStyle: TextStyle(fontSize: 14),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "Remarks".text.maxFontSize(12).make().px4().py2(),
                          subtitle: TextFormField(
                            controller: TextEditingController(text: remarks),
                            enabled: false,
                            // initialValue: "Head Office",
                            maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "Add Remarks",
                              hintStyle: TextStyle(fontSize: 14),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "Amount".text.maxFontSize(12).make().px4().py2(),
                          subtitle: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _approvedAmt,
                            enabled: true,
                            // initialValue: "Head Office",
                            //maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "Approved Amount",
                              hintStyle: TextStyle(fontSize: 14),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title:
                              "Remarks".text.maxFontSize(12).make().px4().py2(),
                          subtitle: TextFormField(
                            controller: _approvedRemarks,
                            enabled: true,
                            // initialValue: "Head Office",
                            maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Mythemes.blackishade,
                                ),
                              ),
                              //labelText: "Select Department",
                              hintText: "Add Remarks",
                              hintStyle: TextStyle(fontSize: 14),
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
                                appStatus = "Approved";
                                //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                                approveLeaveRequisition(
                                  _approvedAmt.text,
                                  _approvedRemarks.text,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Mythemes.successColor,
                                ),
                              ),
                              child: "Approve".text.make(),
                            ).wh(150, 40).py12(),
                            ElevatedButton(
                              onPressed: () {
                                appStatus = "Disapproved";
                                //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                                disApproveLeaveRequisition(
                                  _approvedAmt.text,
                                  _approvedRemarks.text,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Mythemes.dangerColorOne,
                                ),
                              ),
                              child: "Disapprove".text.make(),
                            ).wh(150, 40).py12(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> approveLeaveRequisition(String text, dynamic) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.appDisAdvRequisition;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "claimId=$claimId&"
      "remark=$remarkApp&"
      "amount=$appAmt&"
      "status=$appStatus",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.pop(context);
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

  Future<void> disApproveLeaveRequisition(String text, dynamic) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.appDisAdvRequisition;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "claimId=$claimId&"
      "remark=$remarkApp&"
      "amount=$appAmt&"
      "status=$appStatus",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.pop(context);
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
            Navigator.pop(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (a, b, c) =>
                        PendingAdvanceReqList(PendingAdvReqListModal()),
                transitionDuration: Duration(seconds: 1),
                maintainState: true,
              ),
            );
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
