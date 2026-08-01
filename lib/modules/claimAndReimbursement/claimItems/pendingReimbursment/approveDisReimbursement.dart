import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/pendingReimbursment/pendingList.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/pendingReimbListModal.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';

class ApproveDisappReimbursement extends StatefulWidget {
  PendingReimbListModal pendingReimbListModal;
  int i;
  ApproveDisappReimbursement(this.pendingReimbListModal, this.i);

  @override
  State<ApproveDisappReimbursement> createState() =>
      _ApproveDisappReimbursementState(pendingReimbListModal, i);
}

class _ApproveDisappReimbursementState
    extends State<ApproveDisappReimbursement> {
  PendingReimbListModal pendingReimbListModal;
  int i;

  _ApproveDisappReimbursementState(this.pendingReimbListModal, this.i);
  var titleName = "Approved and Disapproved";
  TextEditingController _approvedAmtController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  String? fromDate;
  String? toDate;
  String? fromPlace;
  String? toPlace;
  String? purpose;
  String? reimpType;
  String? expName;
  String? subExpName;
  String? catName;
  String? distance;
  String? remarks;
  String? raisedAmt;
  String? claimReqId;
  String? status;
  var remark;
  var approveAmt;
  var plus;
  var slash;
  var claimId;

  @override
  void initState() {
    fromDate = foundDataNew![i].fromDate;
    toDate = foundDataNew![i].toDate;
    fromPlace = foundDataNew![i].fromPlace;
    toPlace = foundDataNew![i].toPlace;
    purpose = foundDataNew![i].purpose;
    reimpType = foundDataNew![i].reimbName;
    expName = foundDataNew![i].expName;
    subExpName = foundDataNew![i].subName;
    catName = foundDataNew![i].catName;
    distance = foundDataNew![i].distance;
    remarks = foundDataNew![i].remarks;
    raisedAmt = foundDataNew![i].claimedAmt;
    claimReqId = foundDataNew![i].claimReqId;
    status = foundDataNew![i].status;
    remark = _remarksController;
    approveAmt = _approvedAmtController;
    plus = "+";
    slash = "/";

    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
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
                        child:
                            TextFormField(
                              onTap: () async {
                                DateTime? fromDate = DateTime.now();
                                FocusScope.of(
                                  context,
                                ).requestFocus(new FocusNode());

                                fromDate = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate,
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 0),
                                  ),
                                );
                                setState(() {
                                  //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                  _fromDateController.text = DateFormat(
                                    "dd-MM-yyyy",
                                  ).format(fromDate!);
                                });

                                print(fromDate);
                              },
                              readOnly: true,
                              enabled: false,
                              controller: TextEditingController(text: fromDate),
                              // initialValue: "Head Office",
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
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
                      Expanded(
                        child:
                            TextFormField(
                              onTap: () async {
                                DateTime? toDate = DateTime.now();
                                FocusScope.of(
                                  context,
                                ).requestFocus(new FocusNode());

                                toDate = await showDatePicker(
                                  context: context,
                                  initialDate: toDate,
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 0),
                                  ),
                                );
                                setState(() {
                                  //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                  _toDateController.text = DateFormat(
                                    "dd-MM-yyyy",
                                  ).format(toDate!);
                                });

                                print(toDate);
                              },
                              readOnly: true,
                              enabled: false,
                              controller: TextEditingController(text: toDate),
                              // initialValue: "Head Office",
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
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
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: TextEditingController(
                                text: fromPlace,
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
                                hintText: "From Place",
                                labelText: "From Place",
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
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            TextFormField(
                              controller: TextEditingController(text: toPlace),
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
                                hintText: "To Place",
                                labelText: "To Place",
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
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: TextEditingController(text: purpose),
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
                                hintText: "Add Purpose",
                                labelText: "Purpose",
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
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              disabledHint: Container(
                                width: 150,
                                child:
                                    reimpType
                                        .toString()
                                        .text
                                        .size(13)
                                        .overflow(TextOverflow.ellipsis)
                                        .make(),
                              ),
                              decoration: InputDecoration(
                                enabled: false,
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Reimbursement Type",
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
                              items: [
                                DropdownMenuItem(
                                  child: Text('ER_Conveyence_Policy'),
                                  value: 1,
                                ),

                                /* DropdownMenuItem(
                                      child: Text('Advance'),
                                      value: 2,
                                    ),*/
                              ],
                              /*onChanged: (int? value) {
                              setState(() {
                                value = value!;
                              });
                            }*/
                              onChanged: null,
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              disabledHint: Container(
                                width: 120,
                                child:
                                    expName
                                        .toString()
                                        .text
                                        .size(13)
                                        .overflow(TextOverflow.ellipsis)
                                        .make(),
                              ),
                              decoration: InputDecoration(
                                enabled: false,
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Expense Type",
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
                              items: [
                                DropdownMenuItem(
                                  child: Container(
                                    child:
                                        "Conveyance".text
                                            .size(13)
                                            .overflow(TextOverflow.ellipsis)
                                            .make(),
                                  ),
                                  value: 1,
                                ),

                                /* DropdownMenuItem(
                                      child: Text('Advance'),
                                      value: 2,
                                    ),*/
                              ],
                              /*onChanged: (int? value) {
                              setState(() {
                                value = value!;
                              });
                            }*/
                              onChanged: null,
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              disabledHint: Container(
                                width: 120,
                                child:
                                    subExpName
                                        .toString()
                                        .text
                                        .size(13)
                                        .overflow(TextOverflow.ellipsis)
                                        .make(),
                              ),
                              decoration: InputDecoration(
                                enabled: false,
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Sub Expense Type",
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
                              items: [
                                DropdownMenuItem(
                                  child: Container(
                                    width: 120,
                                    child:
                                        "Bike 2 Wheeler Local".text
                                            .size(13)
                                            .overflow(TextOverflow.ellipsis)
                                            .make(),
                                  ),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Container(
                                    width: 120,
                                    child:
                                        "Cab Taxi".text
                                            .size(13)
                                            .overflow(TextOverflow.ellipsis)
                                            .make(),
                                  ),
                                  value: 2,
                                ),

                                /* DropdownMenuItem(
                                      child: Text('Advance'),
                                      value: 2,
                                    ),*/
                              ],
                              /*onChanged: (int? value) {
                              setState(() {
                                value = value!;
                              });
                            }*/
                              onChanged: null,
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              disabledHint: Container(
                                width: 120,
                                child:
                                    catName
                                        .toString()
                                        .text
                                        .size(13)
                                        .overflow(TextOverflow.ellipsis)
                                        .make(),
                              ),
                              decoration: InputDecoration(
                                enabled: false,
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Category",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                              items: [
                                DropdownMenuItem(
                                  child: Container(
                                    width: 120,
                                    child:
                                        "Employee Owned Bike".text
                                            .size(13)
                                            .overflow(TextOverflow.ellipsis)
                                            .make(),
                                  ),
                                  value: 1,
                                ),

                                /* DropdownMenuItem(
                                      child: Text('Advance'),
                                      value: 2,
                                    ),*/
                              ],
                              /*onChanged: (int? value) {
                              setState(() {
                                value = value!;
                              });
                            }*/
                              onChanged: null,
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: distance),
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
                                hintText: "0",
                                labelText: "Distance",
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
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: TextEditingController(text: remarks),
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
                                hintText: "Add Remarks",
                                labelText: "Remark",
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
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: TextEditingController(
                                text: raisedAmt,
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
                                hintText: "500",
                                labelText: "Raised Amount",
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
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _approvedAmtController,
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
                                hintText: "0",
                                labelText: "Approved Amount",
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
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: _remarksController,
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
                                hintText: "Add Remarks",
                                labelText: "Remark",
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
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        //buttonPadding: Vx.mOnly(right: 16),
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              status = "Approve";
                              approveReimbursementReq(
                                _approvedAmtController.text,
                                _remarksController.text,
                              );
                              //Navigator.pushNamed(context, MyRoutings.expenseListRoute);
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
                              status = "Disapprove";
                              disApproveReimbursementReq(
                                _approvedAmtController.text,
                                _remarksController.text,
                              );
                              //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                              /*CommonNotificationPage.showWorkDoneSuccess(
                                    context,
                                    "Are you sure you want to save this query?"
                                        .upperCamelCase +
                                        " ",
                                    "Claim Cancel");*/
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

  Future<void> approveReimbursementReq(String claimId, remark) async {
    claimId = claimReqId! + '/' + _approvedAmtController.text;
    print("claimId Test $claimId");
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.approveDisapproveReimbReq;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "claimId=$claimId&"
      "status=$status&"
      "remark=$remark",
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

  Future<void> disApproveReimbursementReq(String claimId, remark) async {
    claimId = claimReqId! + '/' + _approvedAmtController.text;
    print("claimId Test $claimId");
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.approveDisapproveReimbReq;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "claimId=$claimId&"
      "status=$status&"
      "remark=$remark",
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
                        PendingListReimbursement(PendingReimbListModal()),
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
