import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/attendanceList.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/singleDateAttendance.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../themes/empThemes.dart';
import 'package:http/http.dart' as http;

import '../modalClass/advanceTypeModal.dart';
import '../modalClass/loanAdvanceTypeModal.dart';

class LoanAdvanceRequisition extends StatefulWidget {
  const LoanAdvanceRequisition({Key? key}) : super(key: key);

  @override
  State<LoanAdvanceRequisition> createState() => _LoanAdvanceRequisitionState();
}

class _LoanAdvanceRequisitionState extends State<LoanAdvanceRequisition> {
  var titleName = "Loan & Advance Request";
  var radios = "loan";
  bool loanShow = true;
  bool advanceShow = false;
  SessionManager sessionManager=SessionManager();
  Map<String, dynamic> mapResponse = {};
  SessionManager shared = SessionManager();
  String? sessionId;
  LoanTypeListModal? loanTypeListLabel;
  AdvanceTypeListModal? advanceTypeListLabel;
  late List<String?> loanTypeList = [];
  late List<String?> advanceTypeList = [];
  String valuenew="listText";
  String newValue="listText";
  List<String> loanTypeGlobal=[];
  var dropdownNewvalue;
  var advanceDropValue;
  var ids;
  var advanceId;
  var loanId;
  var radioActive;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LoanTypeListModal?> getLeaveType12 = getLoanTypeList(sessionId!);
    Future<AdvanceTypeListModal?> getLeaveType13 = getAdvanceType(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );
    getLeaveType12.then((value) {
      setState(() {
        loanTypeListLabel=value;
        //var leaveTypeId = value?.leaveData.leaveTypeList;
        //print('object$leaveTypeId');
      });
    });
    getLeaveType13.then((value) {
      setState(() {
        advanceTypeListLabel=value;
        //var leaveTypeId = value?.leaveData.leaveTypeList;
        //print('object$leaveTypeId');
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
  }

  Future<LoanTypeListModal?> getLoanTypeList(String sessionId) async {
    loanTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanRequest;
    print('employeeList11: ${sessionId}');
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseLeaveTypeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseLeaveTypeList $getData');
    loanTypeListLabel=LoanTypeListModal.fromJson(mapResponse);
    int? length = loanTypeListLabel?.loandata?.length;
    print('totalLoanType $length');
    for(int i=0; i<loanTypeListLabel!.loandata!.length;i++){
      String? loanTypeName = loanTypeListLabel!.loandata![i].loanName;
      loanTypeList.add(loanTypeListLabel!.loandata![i].loanName);
      print('dataLeaveTypeName $loanTypeName');
    }
    return loanTypeListLabel;
  }

  Future<AdvanceTypeListModal?> getAdvanceType(String sessionId) async {
    advanceTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.advanceRequest;
    print('employeeList11: ${sessionId}');
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseLeaveTypeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseLeaveTypeList $getData');
    advanceTypeListLabel=AdvanceTypeListModal.fromJson(mapResponse);
    int? length = advanceTypeListLabel?.advancedata?.length;
    print('totalAdvanceType $length');
    for(int i=0; i<advanceTypeListLabel!.advancedata!.length;i++){
      String? advanceTypeName = advanceTypeListLabel!.advancedata![i].advanceName;
      advanceTypeList.add(advanceTypeListLabel!.advancedata![i].advanceName);
      print('dataAdvanceType $advanceTypeName');
    }
    return advanceTypeListLabel;
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: titleName.text.make(),
        ),

        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            value: "loan",
                            groupValue: radios,
                            onChanged: (value) {
                             /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Loan Click"),
                              ));*/
                              setState(() {
                                this.loanShow = true;
                                print(this.loanShow);
                                advanceShow = false;
                                radios = value.toString();
                              });


                            },
                          ),
                          "Loan".text.make(),
                        ],
                      ).px32(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            value: "advance",
                            groupValue: radios,
                            onChanged: (value) {
                              /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Advance Click"),
                              ));*/
                              setState(() {
                                advanceShow = true;
                                loanShow = false;
                                radios = value.toString();
                              });


                            },
                          ),
                          "Advance".text.make(),
                        ],
                      ).px32(),
                    ],
                  ),
                  Visibility(
                    visible: loanShow,
                    child: Row(
                      children: [
                        Expanded(
                            child: ListTile(
                              title:
                              "Select Type".text.maxFontSize(12).make().px4().py2(),
                              subtitle:  DropdownButtonFormField(
                                value:  dropdownNewvalue,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 1, color: Mythemes.blackishade),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Select Type",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,fontSize: 13,
                                        color: Mythemes.blackish),
                                  ),
                                  items: loanTypeList.map<DropdownMenuItem<String>>((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!),
                                    );

                                  }).toList(),
                                onChanged: (newVal) {
                                  valuenew = newVal.toString();
                                  int i =loanTypeList.indexOf(valuenew);
                                  loanId = loanTypeListLabel?.loandata?[i].loanId;
                                  var policyidnew= loanTypeList.elementAt(i);
                                  loanTypeGlobal = newVal.toString().split('-');
                                  String idn=loanTypeGlobal.last;
                                  print('loanId $idn');
                                  setState(() {
                                    print('value1 $i');
                                    print('value $policyidnew');
                                    print('loanId $loanId');
                                    dropdownNewvalue = newVal;
                                  });
                                },

                              ),
                            )),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: advanceShow,
                    child: Row(
                      children: [
                        Expanded(
                            child: ListTile(
                              title:
                              "Select Type".text.maxFontSize(12).make().px4().py2(),
                              subtitle:  DropdownButtonFormField(
                                value: advanceDropValue,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 1, color: Mythemes.blackishade),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Select Type",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,fontSize: 13,
                                        color: Mythemes.blackish),
                                  ),
                                  items: advanceTypeList.map<DropdownMenuItem<String>>((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!),
                                    );

                                  }).toList(),
                                onChanged: (valNew) {
                                  newValue = valNew.toString();
                                  int i =advanceTypeList.indexOf(newValue);
                                 advanceId = advanceTypeListLabel?.advancedata?[i].advanceId;
                                  var policyidnew= advanceTypeList.elementAt(i);
                                  //loanTypeGlobal = valNew.toString().split('-');
                                  //String idn=loanTypeGlobal.last;
                                  //print('loanId $idn');
                                  setState(() {
                                    print('value $policyidnew');
                                    print('advanceId $advanceId');
                                    advanceDropValue = valNew;

                                  });

                                },

                              ),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                            title:
                            "Amount".text.maxFontSize(12).make().px4().py2(),
                            subtitle:  TextFormField(
                              keyboardType: TextInputType.number,
                              controller: amountController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "Amount",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                            title: "Remarks".text.maxFontSize(12).make().px4().py2(),
                            subtitle: TextFormField(
                              enabled: true,
                              controller: remarkController,
                              // initialValue: "Head Office",
                              maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "Add Remarks",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          color: context.cardColor,
          child: ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: Vx.mOnly(right: 16),
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(radios == "loan" || loanShow == true) {
                      ids = loanId;
                      radioActive = "false";
                    }
                    else if (radios == "advance" || loanShow == false){
                      ids = advanceId;
                      radioActive = "true";
                    }
                    loanAdvanceRequest(amountController.text, remarkController.text);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Mythemes.lightBluishColor),
                  ),
                  child: "Send".text.make(),
                ).wh(150, 40).py12()
              ]),
        ),
      ),
    );
  }

  Future<void> loanAdvanceRequest(dynamic loanAmt ,String remarks) async {

    //String idn=leavereqIdGlobel.last;
    String dayRadio = "1";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanAdvReqSend;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "loanAdvId=$ids&"
        "loanAmount=$loanAmt&"
        "selectedAdvanceRadio=$radioActive&"
        "remarks=$remarks"
    );
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      var result = mapResponse['result'].toString();
      var reason = mapResponse['reason'].toString();
      print('result both $result $reason');
      print('result${result}');
      if(result.compareToIgnoringCase("success")==0){
        CommonNotificationPage.showDialgSucess(context,reason.upperCamelCase+" ","Success");
      }else if(result.compareToIgnoringCase("error")==0){
        CommonNotificationPage.showDialgSucess(context,reason.upperCamelCase, " Error ");
      }

    }
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