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

import '../../../timeAndAttendance/reports/attendanceRequisition/model/onDateReportModel.dart';

class AttendanceRequisition extends StatefulWidget {
  AttendanceReportModel? attendanceModelGlobel;
  OnDateAttModel? onDateAttModel;
  int indexCont;

  AttendanceRequisition(
      this.attendanceModelGlobel, this.onDateAttModel, this.indexCont);

  @override
  State<AttendanceRequisition> createState() => _AttendanceRequisitionState(
      attendanceModelGlobel, onDateAttModel, indexCont);
}

class _AttendanceRequisitionState extends State<AttendanceRequisition> with RouteAware{
  AttendanceReportModel? attendanceModelGlobel;
  OnDateAttModel? onDateAttModel;
  int indexCont;
  String? _group1SelectedValue;
  String radios = "onDate";
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  String? sessionId;
  dynamic orgId;
  String? branchNameset;
  String? updatedWorkHourSet;
  String? relaxationHourSet;
  String? workingHrsSet;
  String? shiftWorkingHourSet;
  String? departmentset;
  String? employeeNameset;
  String? onDateset;
  String? actualTimeset;
  String? actualOutTimeset;
  int? empId;


  _AttendanceRequisitionState(
      this.attendanceModelGlobel, this.onDateAttModel, this.indexCont);

  @override
  void initState() {
    //var onDateNew = attendanceModelGlobel!.data![indexCont].attendanceDate,
    //  _group1SelectedValue = "1";
    //String empid=onDateAttModel!.empId.toString();
    //print('responseemployeeList $empid');

    if(attendanceModelGlobel!=null){
      print('attendanceModelGlobel');
      /*branchNameset= attendanceModelGlobel!.data![indexCont].branchName;
      updatedWorkHourSet= attendanceModelGlobel!.data![indexCont].branchName;
      departmentset= attendanceModelGlobel!.data![indexCont].departmentName;
      employeeNameset= attendanceModelGlobel!.data![indexCont].employeeName;
      onDateset= attendanceModelGlobel!.data![indexCont].attendanceDate;
      actualTimeset= attendanceModelGlobel!.data![indexCont].inTime;
      actualOutTimeset= attendanceModelGlobel!.data![indexCont].outTime;
      empId =attendanceModelGlobel!.data![indexCont].empId;*/

      branchNameset= onDateAttModel!.branch;
      updatedWorkHourSet = onDateAttModel!.updatedWorkingHour;
      relaxationHourSet = onDateAttModel!.relaxationHour;
      isShortLeave = onDateAttModel!.isShortLeave ?? false;
      isOutDuty = onDateAttModel!.isOdReq ?? isOutDuty;
      print("Short Leave Check - $isShortLeave");
      workingHrsSet = onDateAttModel!.workingHrs;
      shiftWorkingHourSet = onDateAttModel!.shiftWorkingHour;
      departmentset= onDateAttModel!.dept;
      employeeNameset= onDateAttModel!.empName;
      onDateset= onDateAttModel!.date;
      actualTimeset= onDateAttModel!.inTime;
      actualOutTimeset= onDateAttModel!.outTime;
      empId= onDateAttModel!.empId;

      // Log for debugging
      print('Branch: $branchNameset');
      print('Department: $departmentset');
      print('Employee Name: $employeeNameset');
      print('Date: $onDateset');
      print('In Time: $actualTimeset');
      print('Out Time: $actualOutTimeset');
      print('Employee ID: $empId');

    }else{
      print('onModelrun');
      branchNameset= onDateAttModel!.branch;
      updatedWorkHourSet = onDateAttModel!.updatedWorkingHour;
      isShortLeave = onDateAttModel!.isShortLeave ?? isShortLeave;
      isOutDuty = onDateAttModel!.isOdReq ?? isOutDuty;
      print("Short Leave Check - $isShortLeave");
      relaxationHourSet = onDateAttModel!.relaxationHour;
      workingHrsSet = onDateAttModel!.workingHrs;
      shiftWorkingHourSet = onDateAttModel!.shiftWorkingHour;
      departmentset= onDateAttModel!.dept;
      employeeNameset= onDateAttModel!.empName;
      onDateset= onDateAttModel!.date;
      actualTimeset= onDateAttModel!.inTime;
      actualOutTimeset= onDateAttModel!.outTime;
      empId= onDateAttModel!.empId;

      // Log for debugging
      print('Branch: $branchNameset');
      print('Department: $departmentset');
      print('Employee Name: $employeeNameset');
      print('Date: $onDateset');
      print('In Time: $actualTimeset');
      print('Out Time: $actualOutTimeset');
      print('Employee ID: $empId');
    }

    getSharedPrfanceList();
    super.initState();
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
  bool outDuty = false;
  bool light0 = true;
  bool light1 = true;
  bool isShortLeave = false;
  bool isOutDuty = false;
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
          title: "Attendance Requisition".text.make(),
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
                  Visibility(
                    visible: orgId != 190 && orgId != 191 && orgId != 198,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedToggleSwitch<int>.size(
                          height: 30,
                          current: min(value, 3),
                          style: ToggleStyle(
                            backgroundColor: Mythemes.greyishade,
                            indicatorColor: Mythemes.lightBluishColor,
                            borderColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                            indicatorBorderRadius: BorderRadius.zero,
                          ),
                          values: const [0, 1, 2],
                          iconOpacity: 1.0,
                          selectedIconScale: 1.0,
                          indicatorSize: const Size.fromWidth(90),
                          iconAnimationType: AnimationType.onHover,
                          styleAnimationType: AnimationType.onHover,
                          spacing: 3.0,
                          customSeparatorBuilder: (context, local, global) {
                            final opacity =
                            ((global.position - local.position).abs() - 0.5)
                                .clamp(0.0, 1.0);
                            return VerticalDivider(
                                indent: 10.0,
                                endIndent: 10.0,
                                color: Colors.white38.withOpacity(opacity));
                          },
                          customIconBuilder: (context, local, global) {
                            final text = const ['Attendance', 'Leave', 'OD'][local.index];
                            return Center(
                                child: Text(text,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.lerp(Colors.black, Colors.white,
                                            local.animationValue))));
                          },
                          borderWidth: 0.0,
                          onChanged: (i) {
                            setState(() {
                              value = i;
                              print(i);

                            });
                            if(value == 0){

                            }
                            if(value == 1) {
                              Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                            }
                            if(value == 2) {
                              Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                            }
                            /*if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*/
                          },
                        )
                      ],
                    ).py16(),
                  ),

                  Visibility(
                    visible: orgId == 190 || orgId == 191 || orgId == 198,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedToggleSwitch<int>.size(
                          height: 30,
                          current: min(value, 2),
                          style: ToggleStyle(
                            backgroundColor: Mythemes.greyishade,
                            indicatorColor: Mythemes.lightBluishColor,
                            borderColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                            indicatorBorderRadius: BorderRadius.zero,
                          ),
                          values: const [0, 1],
                          iconOpacity: 1.0,
                          selectedIconScale: 1.0,
                          indicatorSize: const Size.fromWidth(85),
                          iconAnimationType: AnimationType.onHover,
                          styleAnimationType: AnimationType.onHover,
                          spacing: 3.0,
                          customSeparatorBuilder: (context, local, global) {
                            final opacity =
                            ((global.position - local.position).abs() - 0.5)
                                .clamp(0.0, 1.0);
                            return VerticalDivider(
                                indent: 10.0,
                                endIndent: 10.0,
                                color: Colors.white38.withOpacity(opacity));
                          },
                          customIconBuilder: (context, local, global) {
                            final text = const ['Attendance', 'Leave'][local.index];
                            return Center(
                                child: Text(text,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.lerp(Colors.black, Colors.white,
                                            local.animationValue))));
                          },
                          borderWidth: 0.0,
                          onChanged: (i) {
                            setState(() {
                              value = i;
                              print(i);

                            });
                            if(value == 0){
                              //Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                            }
                            if(value == 1) {
                              Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                            }
                            /* if(value == 2) {
                              Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                            }*/
                            /* if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*/
                          },
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildVerticalToggle("Night Shift", nightShift, (val) {
                          setState(() => nightShift = val);
                          compOff=false;
                          shortLeave=false;
                          outDuty=false;
                          print("Night Shift - $nightShift");
                        }),
                        buildVerticalToggle("Comp. Off", compOff, (val) {
                          setState(() => compOff = val);
                          nightShift=false;
                          shortLeave=false;
                          outDuty=false;
                          print("Comp Off - $compOff");
                        }),

                        Visibility(
                          visible: isShortLeave,
                          child: buildVerticalToggle("Short Leave", shortLeave, (val) {
                            setState(() => shortLeave = val);
                            compOff=false;
                            nightShift=false;
                            outDuty=false;
                            print("Short Leave - $shortLeave");
                          }),
                        ),
                        Visibility(
                          visible: isOutDuty,
                          child: buildVerticalToggle("OD", outDuty, (val) {
                            setState(() => outDuty = val);
                            compOff=false;
                            nightShift=false;
                            shortLeave=false;
                            print("Out Duty - $outDuty");
                          }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    /*Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            value: "onDate",
                            groupValue: radios,
                            onChanged: (value) {
                              *//*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("On Date Click"),
                              ));*//*
                              setState(() {
                                onDateRadio = "1";
                                nextDayRadio = "0";
                                compOffRadio = "0";
                                radios = value.toString();
                              });
                            },
                          ),
                          "On Date".text.size(13).make(),
                        ],
                      ),
                    ),*/
                    /*Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            value: "nextDay",
                            groupValue: radios,
                            onChanged: (value) {
                              *//*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Next Day Click"),
                              ));*//*
                              setState(() {
                                onDateRadio = "0";
                                nextDayRadio = "1";
                                compOffRadio = "0";
                                radios = value.toString();
                              });
                            },
                          ),
                          "Night Shift".text.size(13).make(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            value: "compOff",
                            groupValue: radios,
                            onChanged: (value) {
                              *//*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Comp Off Click"),
                              ));*//*
                              setState(() {
                                onDateRadio = "0";
                                nextDayRadio = "0";
                                compOffRadio = "1";
                                radios = value.toString();
                              });
                            },
                          ),
                          "Comp".text.size(13).make(),
                        ],
                      ),
                    ),*/

                  ]).p(5),
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
                  //No Short Leave Case
                  Visibility(
                    visible: shortLeave == false,
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: TextFormField(
                                style:TextStyle(fontSize:14),
                                controller: TextEditingController(text: actualTimeset),
                                readOnly: true,
                                //initialValue: "${branchName}",
                                decoration:  InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 8.0),
                                    hintText: actualTimeset,
                                    labelText: "Actual In Time",
                                    labelStyle: TextStyle(fontSize: 15)
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: compOff != true,
                            child: Expanded(
                              child:
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: TextFormField(
                                  onTap: () async {
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
                                      _inTimePicker = nT;
                                    });
                                  },
                                  style:TextStyle(fontSize:14),
                                  controller: TextEditingController(text: _inTimePicker),
                                  readOnly: true,
                                  //initialValue: "${branchName}",
                                  decoration:  InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 8.0),
                                      hintText: _inTimePicker,
                                      labelText: "Changes In Time",
                                      labelStyle: TextStyle(fontSize: 15)
                                  ),
                                ),
                              ),

                            ),
                          ),
                        ],
                      ),),
                  Visibility(
                    visible: shortLeave == false,
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
                  Visibility(
                    visible: shortLeave == false,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              style:TextStyle(fontSize:14),
                              controller: TextEditingController(text: actualOutTimeset),
                              readOnly: true,
                              //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  hintText: actualOutTimeset,
                                  labelText: "Actual Out Time",
                                  labelStyle: TextStyle(fontSize: 15)
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:  compOff != true,
                          child: Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: TextFormField(
                                onTap: () async {
                                  //_openOutTimepicker(context);
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
                                    var newNow = DateTime.now();
                                    DateTime newt = DateTime(newNow.year, newNow.month,
                                        newNow.day, o!.hour, o!.minute);
                                    var oT = DateFormat('HH:mm').format(newt);
                                    print(DateFormat('HH:mm').format(newt));
                                    _outTimePicker = oT;
                                  });
                                },
                                style:TextStyle(fontSize:14),
                                controller: TextEditingController(text: _outTimePicker),
                                readOnly: true,
                                //initialValue: "${branchName}",
                                decoration:  InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 8.0),
                                    hintText: _outTimePicker,
                                    labelText: "Changes Out Time",
                                    labelStyle: TextStyle(fontSize: 15)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: shortLeave == false,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              maxLines: 3,
                              style:TextStyle(fontSize:14),
                              controller: outRemarkController,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: Vx.mOnly(right: 16),
                          children: [
                            ElevatedButton(
                              onPressed: () {

                                String? inTimeReq;
                                String? outTimeReq;
                                String logid ="0";
                                String inRemarkString = inRemarkController.text;
                                String outRemarkString = outRemarkController.text;
                                String onDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(onDateset!));
                                var dateformat = onDate;

                                if(shortLeave == true){
                                  inTimeReq= actualTimeset;
                                  outTimeReq= actualOutTimeset;
                                  inRemarkString=shortLeaveRemarkController.text;
                                  outRemarkString="";
                                  if(inRemarkString == ""){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(" Please fill remarks !! "),
                                    ));
                                  } else {
                                    sendRequsitionToServerShortLeave(
                                        context,
                                        empId!,
                                        inRemarkString,
                                        outRemarkString,
                                        inTimeReq!,
                                        outTimeReq!,
                                        logid,
                                        dateformat);
                                  }

                                }
                                else
                                {
                                  if(_inTimePicker.compareToIgnoringCase("00:00")==0){
                                    if(actualTimeset!.compareToIgnoringCase("N/A")==0 || actualTimeset!.compareToIgnoringCase("--:--")==0){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please Select In Time "),
                                      ));
                                    }else{
                                      inTimeReq=actualTimeset;
                                    }
                                  }else{
                                    inTimeReq=_inTimePicker;
                                  }
                                  if(actualOutTimeset!.compareToIgnoringCase("N/A")==0 || actualOutTimeset!.compareToIgnoringCase("--:--")==0)
                                  {
                                    if(_outTimePicker!.compareToIgnoringCase("00:00")==0)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please Select Out Time "),
                                      ));
                                    }
                                    else
                                    {
                                      outTimeReq = _outTimePicker;
                                      print("outtime $outTimeReq");
                                    }
                                  }
                                  else
                                  {
                                    if(_outTimePicker!.compareToIgnoringCase("00:00")!=0)
                                    {
                                      outTimeReq=_outTimePicker;
                                    }else{
                                      outTimeReq=actualOutTimeset;
                                    }

                                  }

                                  if(actualTimeset!.compareToIgnoringCase("N/A")==0 || actualTimeset!.compareToIgnoringCase("--:--")==0){
                                    if(_inTimePicker!.compareToIgnoringCase("00:00")==0){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please Select In Time "),
                                      ));
                                    }else{
                                      inTimeReq=_inTimePicker;
                                    }
                                    if(_outTimePicker!.compareToIgnoringCase("00:00")==0){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please Select Out Time "),
                                      ));
                                    }else{
                                      outTimeReq=_outTimePicker;
                                    }
                                  }
                                  if(nightShift==false && compOff == false && outDuty == false)
                                  {
                                    print("intime $inTimeReq");
                                    print("outtime $outTimeReq");
                                    print("night shift  $nightShift");
                                    print("compoff $compOff");

                                    if (inTimeReq!.compareTo(outTimeReq!) > 0) {
                                      return setState(() {
                                        CommonNotificationPage
                                            .showWorkDoneSuccess(
                                            context,
                                            "Your working hours going to negative, Please select requisition time correctly."
                                                .upperCamelCase +
                                                " ",
                                            "Alert Message");
                                      });
                                    }
                                    else{
                                      print("intime $inTimeReq");
                                      print("outtime $outTimeReq");
                                      print("night shift  $nightShift");
                                      print("compoff $compOff");
                                      if(inRemarkController.text.isEmpty || outRemarkController.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(" Please fill remarks !! "),
                                        ));
                                      } else {
                                        sendRequsitionToServer(
                                            context,
                                            empId!,
                                            inRemarkString,
                                            outRemarkString,
                                            inTimeReq,
                                            outTimeReq,
                                            logid,
                                            dateformat);
                                      }

                                    }
                                  }
                                  else if (nightShift == true){
                                    print("intime $inTimeReq");
                                    print("outtime $outTimeReq");
                                    print("night shift  $nightShift");
                                    print("compoff $compOff");
                                    if(inRemarkController.text.isEmpty || outRemarkController.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please fill remarks !! "),
                                      ));
                                    } else {
                                      sendRequsitionToServernextDay(
                                          context,
                                          empId!,
                                          inRemarkString,
                                          outRemarkString,
                                          inTimeReq!,
                                          outTimeReq!,
                                          logid,
                                          dateformat);
                                    }

                                  }
                                  else if (outDuty == true){
                                    print("intime $inTimeReq");
                                    print("outtime $outTimeReq");
                                    print("night shift  $nightShift");
                                    print("compoff $compOff");
                                    print("outDuty $outDuty");
                                    if(inRemarkController.text.isEmpty || outRemarkController.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please fill remarks !! "),
                                      ));
                                    } else {
                                      sendRequsitionToServerOutDuty(
                                          context,
                                          empId!,
                                          inRemarkString,
                                          outRemarkString,
                                          inTimeReq!,
                                          outTimeReq!,
                                          logid,
                                          dateformat);
                                    }

                                  }
                                  else if (compOff==true)
                                  {
                                    print("intime $inTimeReq");
                                    print("outtime $outTimeReq");
                                    print("night shift  $nightShift");
                                    print("compoff $compOff");
                                    if(actualTimeset!.compareToIgnoringCase("N/A")==0||
                                        actualOutTimeset!.compareToIgnoringCase("N/A")==0 || actualTimeset!.compareToIgnoringCase("--:--")==0||
                                        actualOutTimeset!.compareToIgnoringCase("--:--")==0){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Please Handle Attendance Requisition "),
                                      ));
                                    }
                                    else{
                                      if(inRemarkController.text.isEmpty || outRemarkController.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(" Please fill remarks !! "),
                                        ));
                                      } else {
                                        sendRequsitionToServerCompOff(
                                            context,
                                            empId!,
                                            inRemarkString,
                                            outRemarkString,
                                            inTimeReq!,
                                            outTimeReq!,
                                            logid,
                                            dateformat);
                                      }

                                    }
                                  }



                                  /*if (_outTimePicker!.compareToIgnoringCase("00:00") == 0)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(" Please Select Out Time "),
                                    ));
                                  }*/
                                  /*else {
                                    //  var intimecompair = attendanceModelGlobel!.data![indexCont].inTime ?? onDateAttModel!.inTime;
                                    if(onDateset!.compareToIgnoringCase("--:--")==0){
                                      inTimeReq = onDateset.toString().compareToIgnoringCase("--:--") == 0 ? _inTimePicker :_inTimePicker;
                                    }
                                    else{
                                      inTimeReq = onDateset.toString().compareToIgnoringCase("N/A") == 0 ? _inTimePicker :_inTimePicker;
                                    }
                                    outTimeReq = _outTimePicker;
                                    if (nightShift == true) {
                                    } else {
                                      if (inTimeReq.compareToIgnoringCase("00:00") == 0) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(" Please Select In Time "),
                                        ));
                                      }
                                      else {
                                        if (onDateRadio.compareToIgnoringCase("1") == 0) {
                                          if (inTimeReq.compareTo(outTimeReq) > 0) {
                                            return setState(() {
                                              CommonNotificationPage.showWorkDoneSuccess(
                                                  context,
                                                  "Your working hours going to negative, Please select requisition time correctly."
                                                      .upperCamelCase +
                                                      " ",
                                                  "Alert Message");
                                            });
                                          } else {
                                            sendRequsitionToServer(
                                                context,
                                                empId!,
                                                inRemarkString,
                                                outRemarkString,
                                                inTimeReq,
                                                outTimeReq,
                                                logid,
                                                dateformat);
                                          }
                                        }
                                        else if (nightShift == true) {
                                          sendRequsitionToServernextDay(
                                              context,
                                              empId!,
                                              inRemarkString,
                                              outRemarkString,
                                              inTimeReq,
                                              outTimeReq,
                                              logid,
                                              dateformat);
                                        } else if (compOff == true) {
                                          sendRequsitionToServerCompOff(
                                              context,
                                              empId!,
                                              inRemarkString,
                                              outRemarkString,
                                              inTimeReq,
                                              outTimeReq,
                                              logid,
                                              dateformat);
                                        }
                                      }
                                    }
                                  }*/
                                }

                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Mythemes.lightBluishColor),
                              ),
                              child: "Send".text.make(),
                            ).wh(150, 40).py12()
                          ]),
                    ],
                  ).py32()
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

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    orgId = await shared!.getOrgId();
  }



  String conn = ApiDetails.server;
  String apiUrl = ApiDetails.sendAttendanceReq;
  Future<void> sendRequsitionToServer(
      BuildContext context,
      int empId,
      String inRemarkString,
      String outRemarkString,
      String inTimeReq,
      String outTimeReq,
      String logid,
      var onDate) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
            "sessionId=$sessionId&"
            "id=$empId&"
            "onDate=$onDate&"
            "inTimeRemarks=$inRemarkString&"
            "outTimeRemarks=$outRemarkString&"
            "inTime=$inTimeReq&"
            "outTime=$outTimeReq");
    final response = await http.post(urlapi);

    print('URL ${response.request}');

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      //Navigator.pop(context);
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];

        showDialgSucess1(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          showDialgSucess1(context, reason, "Success");
        } else {
          showDialgSucess1(context, result, "⚠️Warning");
        }
      }
      print('result ${result} reason ${reason}');
    }
  }


  Future<void> sendRequsitionToServernextDay(
      BuildContext context,
      int empId,
      String inRemarkString,
      String outRemarkString,
      String inTimeReq,
      String outTimeReq,
      String logid,
      var onDate) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
            "sessionId=$sessionId&"
            "id=$empId&"
            "onDate=$onDate&"
            "inTimeRemarks=$inRemarkString&"
            "outTimeRemarks=$outRemarkString&"
            "inTime=$inTimeReq&"
            "nextday=true&"
            "outTime=$outTimeReq");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];
        showDialgSucess1(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          showDialgSucess1(context, reason, "Success");
        } else {
          showDialgSucess1(context, result, "⚠️Warning");
        }
      }
      print('result ${result} reason ${reason}');
    }
  }

  Future<void> sendRequsitionToServerOutDuty(
      BuildContext context,
      int empId,
      String inRemarkString,
      String outRemarkString,
      String inTimeReq,
      String outTimeReq,
      String logid,
      var onDate) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
            "sessionId=$sessionId&"
            "id=$empId&"
            "onDate=$onDate&"
            "inTimeRemarks=$inRemarkString&"
            "outTimeRemarks=$outRemarkString&"
            "inTime=$inTimeReq&"
            "isOdReq=1&"
            "outTime=$outTimeReq");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];
        showDialgSucess1(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          showDialgSucess1(context, reason, "Success");
        } else {
          showDialgSucess1(context, result, "⚠️Warning");
        }
      }
      print('result ${result} reason ${reason}');
    }
  }

  Future<void> sendRequsitionToServerCompOff(
      BuildContext context,
      int empId,
      String inRemarkString,
      String outRemarkString,
      String inTimeReq,
      String outTimeReq,
      String logid,
      var onDate) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
            "sessionId=$sessionId&"
            "id=$empId&"
            "onDate=$onDate&"
            "inTimeRemarks=$inRemarkString&"
            "outTimeRemarks=$outRemarkString&"
            "inTime=$inTimeReq&"
            "compOff=true&"
            "outTime=$outTimeReq");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];
        CommonNotificationPage.showDialgSucess(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          showDialgSucess1(context, reason, "Success");
        } else {
          showDialgSucess1(context, result, "⚠️Warning");
        }
      }
      print('result ${result} reason ${reason}');
    }
  }

  Future<void> sendRequsitionToServerShortLeave(
      BuildContext context,
      int empId,
      String inRemarkString,
      String outRemarkString,
      String inTimeReq,
      String outTimeReq,
      String logid,
      var onDate) async {
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
            "sessionId=$sessionId&"
            "id=$empId&"
            "onDate=$onDate&"
            "inTimeRemarks=$inRemarkString&"
            "outTimeRemarks=$outRemarkString&"
            "inTime=$inTimeReq&"
            "shortLeave=1&"
            "outTime=$outTimeReq");
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      String result = "";
      String reason = "";
      mapResponse = json.decode(response.body);
      if (mapResponse.containsKey("reason")) {
        result = mapResponse['result'];
        reason = mapResponse['reason'];
        CommonNotificationPage.showDialgSucess(context, reason, result);
      } else {
        result = mapResponse['result'];
        if (result.compareToIgnoringCase("success") == 0) {
          reason = "you have submit Requisition for $onDate";
          showDialgSucess1(context, reason, "Success");
        } else {
          showDialgSucess1(context, result, "⚠️Warning");
        }
      }
      print('result ${result} reason ${reason}');
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
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop();
           /* Navigator.pop(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) =>
                      AttendanceList(AttendanceReportModel()),
                  transitionDuration: Duration(seconds: 1),
                  maintainState: true,
                ));*/
            //Navigator.of(context).pop();

          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    if(mounted) {
      showDialog(
          context: buildContext,
          builder: (BuildContext context) {
            return alertDialog;
          });
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