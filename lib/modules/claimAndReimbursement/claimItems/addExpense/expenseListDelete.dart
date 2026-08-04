import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/expensesListModal.dart';
import 'expenseList.dart';

class DeleteExpenseList extends StatefulWidget {
  ExpensesListModal expensesListModal;
  int i;

  DeleteExpenseList(this.expensesListModal, this.i);

  @override
  State<DeleteExpenseList> createState() =>
      _DeleteExpenseListState(expensesListModal, i);
}

class _DeleteExpenseListState extends State<DeleteExpenseList> {
  ExpensesListModal expensesListModal;
  int i;

  _DeleteExpenseListState(this.expensesListModal, this.i);

  var titleName = "Claim Requisition List";
  final TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  String? fromDate;
  String? toDate;
  String? fromPlace;
  String? toPlace;
  String? purpose;
  String? reimbType;
  String? expenseType;
  String? subExpenseType;
  String? catName;
  String? distance;
  String? remarks;
  String? claimedAmt;
  String? billAvail;
  var roId;
  String? claimReqId;
  var reason;

  @override
  void initState() {
    fromDate = foundDataNew![i].fromDate;
    toDate = foundDataNew![i].toDate;
    fromPlace = foundDataNew![i].fromPlace;
    toPlace = foundDataNew![i].toPlace;
    purpose = foundDataNew![i].purpose;
    reimbType = foundDataNew![i].reimbName;
    expenseType = foundDataNew![i].expName;
    subExpenseType = foundDataNew![i].subName;
    catName = foundDataNew![i].catName;
    distance = foundDataNew![i].distance;
    remarks = foundDataNew![i].remarks;
    claimedAmt = foundDataNew![i].claimedAmt;
    billAvail = foundDataNew![i].billAvail;
    roId = 0;
    claimReqId = foundDataNew![i].claimReqId;
    reason = _reasonController;
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
                                ).requestFocus(FocusNode());

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
                                    reimbType
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
                              /* onChanged: (int? value) {
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
                                    expenseType
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
                                  child: Text('Conveyance'),
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
                                    subExpenseType
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
                                  child: Text(
                                    'Bike 2 Wheeler Local',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 13,
                                    ),
                                  ),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'Cab Taxi',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 13,
                                    ),
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
                                  child: Text(
                                    'Employee Owned Bike',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 13,
                                    ),
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
                              }
                              );
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
                                hintText: "Approved Remarks",
                                labelText: "Remarks",
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
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                text: claimedAmt,
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
                                hintText: "1200",
                                labelText: "Amount",
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
                            DropdownButtonFormField(
                              disabledHint: Container(
                                width: 120,
                                child:
                                    billAvail
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
                                labelText: "Bill Available",
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
                                DropdownMenuItem(child: Text('Yes'), value: 1),
                                DropdownMenuItem(child: Text('No'), value: 2),

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
                            TextFormField(
                              controller: _reasonController,
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
                                hintText: "Add Reason",
                                labelText: "Reason",
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
                              Navigator.pushNamed(
                                context,
                                MyRoutings.expenseListRoute,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Mythemes.lightBluishColor,
                              ),
                            ),
                            child: "Back".text.make(),
                          ).wh(150, 40).py12(),
                          ElevatedButton(
                            onPressed: () {
                              //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                              /*CommonNotificationPage.showDialgSucess(
                                    context,
                                    "Are you sure you want to save this query?"
                                        .upperCamelCase +
                                        " ",
                                    "Claim Cancel");*/
                              deleteClaimReq(_reasonController.text);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Mythemes.dangerColorOne,
                              ),
                            ),
                            child: "Delete".text.make(),
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

  Future<void> deleteClaimReq(String reason) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.deleteClaimRequisition;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "roId=$roId&"
      "reason=$reason&"
      "claimId=$claimReqId",
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
                pageBuilder: (a, b, c) => ExpenseList(ExpensesListModal()),
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
