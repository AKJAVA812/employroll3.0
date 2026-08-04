import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../modalClass/advanceRequisitionListModal.dart';
import 'advanceRequisitionList.dart';

class AdvanceRequisitionPage extends StatefulWidget {
  const AdvanceRequisitionPage({Key? key}) : super(key: key);

  @override
  State<AdvanceRequisitionPage> createState() => _AdvanceRequisitionPageState();
}

class _AdvanceRequisitionPageState extends State<AdvanceRequisitionPage> {
  var titleName = "Advance Requisition";
  final TextEditingController _placeTourController = TextEditingController();
  final TextEditingController _purposeTourController = TextEditingController();
  final TextEditingController _nDaysController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  var remark;
  var advAmt;
  var purpose;
  var place;
  var ndays;

  @override
  void initState() {
    remark = _remarksController;
    advAmt = _amountController;
    purpose = _purposeTourController;
    place = _placeTourController;
    ndays = _nDaysController;
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
                            controller: _placeTourController,
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
                            controller: _purposeTourController,
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
                            controller: _nDaysController,
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
                              hintText: "No. of Days",
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
                            controller: _amountController,
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
                              hintText: "Amount",
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
                            controller: _remarksController,
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
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          color: context.cardColor,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonPadding: Vx.mOnly(right: 16),
            children: [
              ElevatedButton(
                onPressed: () {
                  saveAdvanceRequisition(
                    _remarksController.text,
                    _amountController.text,
                    _purposeTourController.text,
                    _placeTourController.text,
                    _nDaysController.text,
                  );
                  //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Mythemes.lightBluishColor,
                  ),
                ),
                child: "Save".text.make(),
              ).wh(150, 40).py12(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAdvanceRequisition(
    dynamic remark,
    dynamic advAmt,
    dynamic purpose,
    dynamic place,
    dynamic ndays,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.saveAdvRequisition;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "remark=$remark&"
      "advAmt=$advAmt&"
      "purpose=$purpose&"
      "place=$place&"
      "ndays=$ndays",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body.toString());
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
                        AdvanceRequisitionList(AdvanceRequestedListModal()),
                transitionDuration: Duration(seconds: 0),
                maintainState: true,
              ),
            );
            Navigator.of(context, rootNavigator: true).pop();
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
