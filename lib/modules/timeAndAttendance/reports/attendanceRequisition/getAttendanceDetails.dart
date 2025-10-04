import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/singleDateAttendance.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:intl/date_symbol_data_local.dart';


class GetAttendanceDet extends StatefulWidget {
   GetAttendanceDet({Key? key}) : super(key: key);

  @override
  State<GetAttendanceDet> createState() => _GetAttendanceDetState();
}


SessionManager shared = SessionManager();
String? sessionId;
String? branchName;
String? deptName;
String? empName;

String singleDateString="";

class _GetAttendanceDetState extends State<GetAttendanceDet> {
 @override
  void initState() {
   getSharedPrfanceList();
  /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     content: Text("Sucessfully Run"),
   ));*/
   setState(() {

   });
    // TODO: implement initState
    super.initState();
  }
  Future getSharedPrfanceList() async {
    //await Future.delayed(Duration(seconds: 1));

    sessionId = await shared!.getSessionId()??"N/A";
    branchName = await shared!.getBranch()??"N/A";
    deptName = await shared!.getDept()??"N/A";
    empName = await shared!.getempName()??"N/A";
    setState(() {
      print('ResponseAttendance: ${sessionId}' );
    });

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
 int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mythemes.whitish,
      appBar: AppBar(
        title: "Requisitions".text.make(),
        elevation: 0.5,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, MyRoutings.attendanceListRoute);
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(
          Icons.list, color: Mythemes.whitish, size: 28,
        ),
      ),

     /* bottomNavigationBar: Container(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleDateAttendance(
                          singleDateString: singleDateString!,
                        )));

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
              Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
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

      body: SingleChildScrollView(
        child: Column(
          children: [

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
                    hintText: "Employee Name",
                    labelText: "Employee Name"
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
                        if(_dateController.text.compareToIgnoringCase("")==0){
                          print('responseemployeeList');
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Select Date First "),
                            ));
                          });
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SingleDateAttendance(
                                singleDateString: _dateController.text,
                              )));

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
        ),
      )
    );
  }
}
