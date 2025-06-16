import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:intl/intl.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../employeePage/employeeListModel.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;

import '../../modules/leaveManagement/reports/modalClass/leaveBalanceModel.dart';
import '../../modules/leaveManagement/reports/modalClass/otherReqEmpList.dart';

class MSS_OthersLeaveReqPage extends StatefulWidget {
  const MSS_OthersLeaveReqPage({Key? key}) : super(key: key);

  @override
  State<MSS_OthersLeaveReqPage> createState() => _MSS_OthersLeaveReqPageState();
}
List<String> leavereqIdGlobel=[];
var empNewId;
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? userPanel;
dynamic getProfileId;
RequistionEmpListModel? employeeListModelglobel;
LeaveBalanceModel? leaveBalanceLabel;
String valuenew="listText";
late List<String?> list = [];
late List<String?> leaveTypeList = [];
class _MSS_OthersLeaveReqPageState extends State<MSS_OthersLeaveReqPage> {
  var titleName = "Other Employee Requisition";
  //static const List<String> list = <String>['Casual Leave', 'Leave Monthly'];
  //String dropdownValue = list.first;
  String dayRadio = "1";
  bool singleDayShow = true;
  bool multipleDayShow = false;
  bool halfDayRadio = false;
  bool halfDayShow = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController fromTimePickerController = TextEditingController();
  final TextEditingController toTimePickerController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  String _fromTimePicker = '00:00';
  String _toTimePicker = '00:00';
  var dropdownvalue;
  var dropdownNewvalue;
  var fromDate;
  var getRemark;

  var leaveTypeId;
  var nominee;

  @override
  void initState() {
    int i = 0;
    //empId = employeeListModelglobel?.data![i].empId;
    leaveTypeId = leaveBalanceLabel?.leaveTypeListDetails?[i].leaveId;
    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    getProfileId = await shared!.getDefaultProfileId();
    // await Future.delayed(Duration(seconds: 5));
    Future<RequistionEmpListModel> getEmployeeList11 = getEmployeeList(sessionId!);
    Future<LeaveBalanceModel?> getLeaveType12 = getLeaveTypeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        employeeListModelglobel=value;
      });
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });

    getLeaveType12.then((value) {
      setState(() {
        leaveBalanceLabel=value;
        //var leaveTypeId = value?.leaveData.leaveTypeList;
        //print('object$leaveTypeId');
      });
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });
  }

  Future<RequistionEmpListModel> getEmployeeList(String sessionId) async {
    list = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.othersReqEmpList;
    print('employeeList11: ${sessionId}');
    RequistionEmpListModel requistionEmpListModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "profileId=$getProfileId&"
        "userPermission=$userPanel&"
        "orgId=0");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    requistionEmpListModel=RequistionEmpListModel.fromJson(mapResponse);
    int length = requistionEmpListModel.data!.length;
    print('totallenth $length ');
    for(int i=0; i<requistionEmpListModel.data!.length;i++){
      String? empName = requistionEmpListModel.data![i].empName;
      list.add(requistionEmpListModel.data![i].empName);
      print('dataExpenseType $empName');
    }
    return requistionEmpListModel;
  }
  
  Future<LeaveBalanceModel?> getLeaveTypeList(String sessionId) async {
    leaveTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBalanceApi;
    print('employeeList11: ${sessionId}');
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseLeaveTypeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseLeaveTypeList $getData');
    leaveBalanceLabel=LeaveBalanceModel.fromJson(mapResponse);
    int? length = leaveBalanceLabel?.leaveData?.leaveTypeList?.leaveTypelist?.length;
    print('totalleaveLength $length ');
    for(int i=0; i<leaveBalanceLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length;i++){
      String? leaveTypeName = leaveBalanceLabel!.leaveData!.leaveTypeList!.leaveTypelist![i];
      leaveTypeList.add(leaveBalanceLabel!.leaveData!.leaveTypeList!.leaveTypelist![i]);
      print('dataLeaveTypeName $leaveTypeName');
    }
    return leaveBalanceLabel;
  }

  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          title: titleName.text.make(),
        ),

        body: SingleChildScrollView(
          child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: dropdownvalue,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                            borderSide: BorderSide(
                                width: 1, color: Mythemes.blackishade),
                          ),
                          //labelText: "Select Department",
                          hintText: "Employee Name",
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
                        items: list.map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );

                        }).toList(),
                      onChanged: (newVal) {
                        valuenew = newVal.toString();
                        int i =list.indexOf(valuenew);
                        empNewId = employeeListModelglobel?.data?[i].empId;
                        print("EmpId  $empNewId");
                        setState(() {

                          dropdownvalue = newVal;

                        });
                      },

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: dropdownNewvalue,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                            borderSide: BorderSide(
                                width: 1, color: Mythemes.blackishade),
                          ),
                          //labelText: "Select Department",
                          hintText: "Leave Type",
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
                        items: leaveTypeList.map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );

                        }).toList(),
                      onChanged: (newVal) {
                        valuenew = newVal.toString();
                        int i =leaveTypeList.indexOf(valuenew);
                        var leaveTypeId = leaveBalanceLabel?.leaveTypeListDetails?[i].leaveId;
                        var policyidnew= leaveTypeList.elementAt(i);
                        leavereqIdGlobel = newVal.toString().split('-');
                        String idn=leavereqIdGlobel.last;
                        print('leaveTypeId $idn');
                        setState(() {
                          print('value1 $i');
                          print('value $policyidnew');

                          dropdownNewvalue = newVal;

                        });
                        if(i == 0 || i == 1 || i == 2) {
                          setState(() {
                            this.halfDayRadio = true;
                          });
                        }
                        else {
                          setState(() {
                            this.halfDayRadio = false;
                          });
                        }
                      },

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: "1",
                                    groupValue: dayRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        singleDayShow = true;
                                        multipleDayShow = false;
                                        halfDayShow = false;
                                        print("day show $singleDayShow");
                                        print("multi show $multipleDayShow");
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
                              ).px1(),
                              Row(
                                /*mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,*/
                                children: [
                                  Radio(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: "2",
                                    groupValue: dayRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        singleDayShow = true;
                                        multipleDayShow = true;
                                        halfDayShow = false;
                                        print("day show $singleDayShow");
                                        print("multi show $multipleDayShow");
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
                              ).px1(),
                              Visibility(
                                visible: halfDayRadio,
                                child: Row(
                                  /* mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,*/
                                  children: [
                                    Radio(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      value: "3",
                                      groupValue: dayRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          singleDayShow = true;
                                          multipleDayShow = false;
                                          halfDayShow = true;
                                          print("day show $singleDayShow");
                                          print("multi show $multipleDayShow");
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
                          ).pLTRB(0, 0, 5, 5)

                      ),
                    ],
                  ),
                  Row(
                    children: [

                      Visibility(
                        visible: singleDayShow,
                        child: Expanded(
                          child:  TextFormField(
                            onTap: () async{
                              DateTime? fromDate = DateTime.now();
                              FocusScope.of(context).requestFocus(new FocusNode());

                              fromDate = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate,
                                  firstDate:DateTime(1947),
                                  lastDate: DateTime(2040)
                              );
                              setState(() {
                                //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                _fromDateController.text = DateFormat("dd-MM-yyyy").format(fromDate!);
                              });

                              print(fromDate);
                            },
                            readOnly: true,
                            enabled: true,
                            controller: _fromDateController,
                            // initialValue: "Head Office",
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month, size: 18,),
                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                borderSide: BorderSide(
                                    width: 1, color: Mythemes.blackishade),
                              ),
                              labelText: "From Date",
                              hintStyle: TextStyle(
                                fontSize: 12,
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
                          ).p8(),
                        ),
                      ),

                      Visibility(
                        visible: multipleDayShow,
                        child: Expanded(
                          child:  TextFormField(
                            onTap: () async{
                              DateTime? toDate = DateTime.now();
                              FocusScope.of(context).requestFocus(new FocusNode());

                              toDate = await showDatePicker(
                                  context: context,
                                  initialDate: toDate,
                                  firstDate:DateTime(1947),
                                  lastDate: DateTime(2040)
                              );
                              setState(() {
                                //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                _toDateController.text = DateFormat("dd-MM-yyyy").format(toDate!);
                              });

                              print(toDate);
                            },
                            readOnly: true,
                            enabled: true,
                            controller: _toDateController,
                            // initialValue: "Head Office",
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month, size: 18,),
                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                borderSide: BorderSide(
                                    width: 1, color: Mythemes.blackishade),
                              ),
                              labelText: "To Date",
                              hintStyle: TextStyle(
                                fontSize: 12,
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
                          ).p8(),
                        ),
                      ),
                    ],
                  ).pLTRB(0, 0, 0, 8),
                  Visibility(
                    visible: halfDayShow,
                    child: Row(
                      children: [
                        Expanded(
                          child:  TextFormField(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              //_openInTimepicker(context);
                              final TimeOfDay? n = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  });
                              print('timenewOut $n');
                              setState(() {
                                var now = DateTime.now();
                                DateTime newt = DateTime(now.year, now.month,
                                    now.day, n!.hour, n!.minute);
                                var nT = DateFormat('HH:mm').format(newt);
                                print(DateFormat('HH:mm').format(newt));
                                _fromTimePicker = nT;
                                fromTimePickerController.text = _fromTimePicker;
                              });
                            },
                            controller: fromTimePickerController,
                            readOnly: true,
                            enabled: true,
                            // initialValue: "Head Office",
                            // maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                borderSide: BorderSide(
                                    width: 1, color: Mythemes.blackishade),
                              ),
                              suffixIcon: Icon(
                                Icons.timer, size: 18,
                              ),
                              contentPadding: EdgeInsets.all(5),
                              labelText: "From Time",
                              //hintText: _fromTimePicker,
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              /*border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))),*/
                              // labelText: "Location",
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,fontSize: 13,
                                  color: Mythemes.blackish),
                            ),
                          ).p8(),

                        ),
                        Expanded(
                          child:  TextFormField(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              //_openInTimepicker(context);
                              final TimeOfDay? o = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  });
                              print('timenewOut $o');
                              setState(() {
                                var now = DateTime.now();
                                DateTime newt = DateTime(now.year, now.month,
                                    now.day, o!.hour, o!.minute);
                                var ot = DateFormat('HH:mm').format(newt);
                                print(DateFormat('HH:mm').format(newt));
                                _toTimePicker = ot;
                                toTimePickerController.text = _toTimePicker;
                              });
                            },
                            controller: toTimePickerController,
                            enabled: true,
                            readOnly: true,
                            // initialValue: "Head Office",
                            // maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                borderSide: BorderSide(
                                    width: 1, color: Mythemes.blackishade),
                              ),
                              suffixIcon: Icon(
                                Icons.timer, size: 18,
                              ),
                              contentPadding: EdgeInsets.all(5),
                              labelText: "To Time",
                              //hintText: _fromTimePicker,
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              /*border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))),*/
                              // labelText: "Location",
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,fontSize: 13,
                                  color: Mythemes.blackish),
                            ),
                          ).p8(),

                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _remarkController,
                      /*validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please Add Remarks";
                        } else if (value!.length < 7) {
                          return "Remarks should be atleast of 7 characters";
                        }

                        return null;
                      },*/
                      maxLines: 2,
                      enabled: true,
                      //initialValue: deptName,
                      decoration:  InputDecoration(
                          hintText: "Add remarks",
                          labelText: "Remarks"

                      ),
                    ),
                  ),

                  SizedBox(
                    height: 82,
                  ),
                  Row(
                    children: [
                      Expanded(child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: Vx.mOnly(right: 16),
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (dropdownvalue == null) {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Please Select Employee ! "),
                                    ));
                                  });
                                }
                                if(dropdownNewvalue == null) {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Please Select Leave Type ! "),
                                    ));
                                  });
                                }
                                if(_fromDateController.text == ""){
                                  print('responseemployeeList');
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Please Select Date ! "),
                                    ));
                                  });
                                }
                                if(_remarkController.text == ""){
                                  print('responseemployeeList');
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Please Enter Remarks ! "),
                                    ));
                                  });
                                } else {
                                  if (dayRadio == '1') {
                                    singleDayRequisition(_remarkController.text, leaveTypeId, _fromDateController.text, empNewId);
                                  }
                                  else if(dayRadio == '2') {
                                    multipleDayRequisition(_remarkController.text, leaveTypeId, _toDateController.text, _fromDateController.text, empNewId);
                                  }
                                  else if (dayRadio == '3') {
                                    halfDayRequisition(fromTimePickerController.text, toTimePickerController.text, _remarkController.text, leaveTypeId, _fromDateController.text, empNewId);
                                  }
                                }

                                //key = "APPROVED";
                                //approveLeaveRequisition(_commentController.text, leaveReqId);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Mythemes.lightBluishColor),
                              ),
                              child: "Send".text.make(),
                            ).wh(150, 40).py12(),
                          ]))
                    ],
                  ),
                ],
              )
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
              //Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              Navigator.pop(context);
              print('Leave');
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

  Future<void> singleDayRequisition(String getRemark, int? idn, fromDate, empNewId) async {

    String idn=leavereqIdGlobel.last;
    String dayRadio = "1";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "leaveTypeId=$idn&"
        "fromDate=$fromDate&"
        "summary=$getRemark&"
        "radio=$dayRadio&"
        "empid=$empNewId&"
        "nominee="
    );
    final response = await http.post(urlapi);
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
      if(result.compareToIgnoringCase("success")==0){
        CommonNotificationPage.showDialgSucess(context,reason.upperCamelCase+" ","Success");
      }else if(result.compareToIgnoringCase("error")==0){
        CommonNotificationPage.showDialgSucess(context,reason.upperCamelCase, " Error ");
      }

    }
  }

  Future<void> multipleDayRequisition(String getRemark, int? idn, toDate, fromDate, empNewId) async {
    String idn=leavereqIdGlobel.last;
    String dayRadio = "2";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "tilldate=$toDate&"
        "sessionId=$sessionId&"
        "leaveTypeId=$idn&"
        "fromDate=$fromDate&"
        "summary=$getRemark&"
        "radio=$dayRadio&"
        "empid=$empNewId&"
        "nominee="
    );
    final response = await http.post(urlapi);
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
      if(result.compareToIgnoringCase("success")==0){
        CommonNotificationPage.showDialgSucess(context,reason.upperCamelCase+" ","Success");
      }else if(result.compareToIgnoringCase("error")==0){
        CommonNotificationPage.showDialgSucess(context,reason.upperCamelCase, " Error ");
      }

    }
  }

  Future<void> halfDayRequisition(startTime, endTime, String getRemark,  int? idn, fromDate, empNewId) async {
    String idn=leavereqIdGlobel.last;
    String dayRadio = "3";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "starttime=$startTime&"
        "endtime=$endTime&"
        "sessionId=$sessionId&"
        "leaveTypeId=$idn&"
        "fromDate=$fromDate&"
        "summary=$getRemark&"
        "radio=$dayRadio&"
        "empid=$empNewId&"
        "nominee="
    );
    final response = await http.post(urlapi);
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