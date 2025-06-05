import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:intl/intl.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../employeePage/employeeListModel.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../modules/leaveManagement/reports/modalClass/leaveBalanceModel.dart';
import '../../modules/leaveManagement/reports/modalClass/otherReqEmpList.dart';
import '../../modules/leaveManagement/reports/othersAttendanceList.dart';
import '../../modules/timeAndAttendance/reports/attendanceRequisition/othersSingleDateAttendance.dart';
import '../../modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';

class UIS_OthersAttendanceRequisitionPage extends StatefulWidget {
  const UIS_OthersAttendanceRequisitionPage({Key? key}) : super(key: key);

  @override
  State<UIS_OthersAttendanceRequisitionPage> createState() => _UIS_OthersAttendanceRequisitionPageState();
}
List<String> leavereqIdGlobel=[];
var empNewIdUSER;
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
RequistionEmpListModel? employeeListModelglobel;
LeaveBalanceModel? leaveBalanceLabel;
String valuenew="listText";
late List<String?> list = [];
late List<String?> leaveTypeList = [];
String? branchName;
String? deptName;
String? empName;
String singleDateString="";
String? userPanel;
dynamic getProfileId;
String? orgId;
class _UIS_OthersAttendanceRequisitionPageState extends State<UIS_OthersAttendanceRequisitionPage> {
  var titleName = "Other Employee's Requisition";
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
    branchName = await shared!.getBranch()??"N/A";
    deptName = await shared!.getDept()??"N/A";
    empName = await shared!.getempName()??"N/A";
    // await Future.delayed(Duration(seconds: 5));
    Future<RequistionEmpListModel> getEmployeeList11 = getEmployeeList(sessionId!);
    //Future<LeaveBalanceModel?> getLeaveType12 = getLeaveTypeList(sessionId!);
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

   /* getLeaveType12.then((value) {
      setState(() {
        leaveBalanceLabel=value;
        //var leaveTypeId = value?.leaveData.leaveTypeList;
        //print('object$leaveTypeId');
      });
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });*/
  }

  Future<RequistionEmpListModel> getEmployeeList(String sessionId) async {
    list = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.othersReqEmpList;
    print('employeeList11: ${sessionId}');
    RequistionEmpListModel requistionEmpListModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "userPermission=$userPanel&"
        "profileId=$getProfileId&"
        "orgId=$orgId");
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

  DateTime _date = (DateTime.now());
  String formattedDate = DateFormat.ABBR_MONTH;
  String dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse("2019-09-30"));
  Future <Null> _selectDate (BuildContext context) async {
    DateTime? _datePicker =await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2040),
    );

    if(_datePicker != null && _datePicker != _date){
      setState(() {
        _date = _datePicker;
      });
    }
  }
  final TextEditingController _dateController = TextEditingController();
  int pageIndex = 0;
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          title: titleName.text.make(),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //Navigator.pushNamed(context, MyRoutings.otherAttendanceListRoute);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OthersAttendanceList(AttendanceReportModel(),0)));
          },
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(
            Icons.list, color: Mythemes.whitish, size: 28,
          ),
        ),

        /*bottomNavigationBar: Container(
          height: 90,
          color: context.cardColor,
          child: ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: Vx.mOnly(right: 16),
              children: [
                ElevatedButton(
                  onPressed: () {

                    if(singleDateString.compareToIgnoringCase("")==0){
                      print('responseemployeeList');
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please Select Date First "),
                        ));
                      });
                    }else{
                      print("EmpIdOther - $empNewId");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OthersSingleDateAttendance(
                            singleDateString: singleDateString!, empId: empNewId,
                          )));
                      *//*Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          OthersSingleDateAttendance(null, onDateAttModelGlobel,1)));*//*

                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Mythemes.lightBluishColor),
                  ),
                  child: "Get Details".text.make(),
                ).wh(150, 40).py12()
              ]),
        ),*/

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
                        labelText: "Select Employee",
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
                        empNewIdUSER = employeeListModelglobel?.data?[i].empId;
                        print("EmpId  $empNewIdUSER");
                        setState(() {

                          dropdownvalue = newVal;

                        });
                      },

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: branchName),
                      enabled: false,
                      //initialValue: "${branchName}",
                      decoration:  InputDecoration(
                          hintText: "Branch Name",
                          labelText: "Branch Name"
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: deptName),
                      enabled: false,
                      //initialValue: deptName,
                      decoration:  InputDecoration(
                          hintText: "Department Name",
                          labelText: "Department Name"

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: empName),
                      enabled: false,
                      //initialValue: empName,
                      decoration:  InputDecoration(
                          hintText: "Reporting Officer Name",
                          labelText: "Reporting Officer Name"
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectDate(context);
                        });
                      },
                      child: TextFormField(

                        onTap: () async{
                          DateTime? date = DateTime.now();
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate:DateTime(1947),
                              lastDate: DateTime.now().add(Duration(days: 0)));
                          setState(() {
                            singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                            _dateController.text = DateFormat("dd-MM-yyyy").format(date!);

                            //  DateFormat.yMd().format(date!).toString();
                          });

                          print(date);
                        },
                        readOnly: true,
                        //initialValue: "dd-mm-yyyy",
                        controller: _dateController,
                        decoration:  InputDecoration(
                          labelText: "Date",
                          suffixIcon: Icon(Icons.calendar_month),
                          hintText: DateFormat("DD-MM-YYYY").format(_date),
                          // hintText: DateFormat.yMd().format(_date).toString(),
                        ),

                      ),
                    ),
                  ),

                  Container(
                    height: 90,
                    color: context.cardColor,
                    child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        buttonPadding: Vx.mOnly(right: 16),
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                              if(singleDateString.compareToIgnoringCase("")==0){
                                print('responseemployeeList');
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Please Select Date First "),
                                  ));
                                });
                              }else{
                                print("EmpIdOther - $empNewIdUSER");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OthersSingleDateAttendance(
                                      singleDateString: singleDateString!, empId: empNewIdUSER,
                                    )));
                                /*Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          OthersSingleDateAttendance(null, onDateAttModelGlobel,1)));*/

                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Mythemes.lightBluishColor),
                            ),
                            child: "Get Details".text.make(),
                          ).wh(150, 40).py12()
                        ]),
                  ).py(80),
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
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
              //Navigator.pop(context);
              print('home tab');
            }
            if(index==1){
              Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Attendance');
            }
            if(index==2){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==3){
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