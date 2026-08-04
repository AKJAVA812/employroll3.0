
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../themes/empThemes.dart';

class ApproveDisapproveLeaveReq extends StatefulWidget {


  ApproveDisapproveLeaveReq();

  @override
  State<ApproveDisapproveLeaveReq> createState() => _ApproveDisapproveLeaveReqState();
}

class _ApproveDisapproveLeaveReqState extends State<ApproveDisapproveLeaveReq> {

  _ApproveDisapproveLeaveReqState();

  var titleName = "Leave Approval";
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: titleName.text.make(),
          elevation: 0.5,
        ),
        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
              child: RadioGroups()),
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
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
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
}

class RadioGroups extends StatefulWidget {

  RadioGroups();

  @override
  State<RadioGroups> createState() => _RadioGroupsState();
}

class _RadioGroupsState extends State<RadioGroups> {
  var leaveType = "Sick Leave";
  var lBalance = "3";
  var branchName = "Okhla Head Office";
  var department = "IT";
  var empName = "Employee Name";
  var applicationDate = "12-01-2022";
  var fromDate = "12-05-2022";
  var toDate = "20-05-2022";
  var reqRemarks = "Remarks";
  var nominee = "Nominee";
  var approvalRemarks = "Approval Remarks";

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child:  Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style:TextStyle(fontSize:14),
                    controller: TextEditingController(text: leaveType),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: leaveType,
                        labelText: "Leave Type",
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
                    controller: TextEditingController(text: lBalance),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: lBalance,
                        labelText: "Leave Balance",
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
                child:  Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style:TextStyle(fontSize:14),
                    controller: TextEditingController(text: branchName),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: branchName,
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
                    controller: TextEditingController(text: department),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: department,
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
                child:  Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style:TextStyle(fontSize:14),
                    controller: TextEditingController(text: empName),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: empName,
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
                    controller: TextEditingController(text: applicationDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: applicationDate,
                        labelText: "Application Date",
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
                child:  Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style:TextStyle(fontSize:14),
                    controller: TextEditingController(text: fromDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: fromDate,
                        labelText: "From Date",
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
                    controller: TextEditingController(text: toDate),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: toDate,
                        labelText: "To Date",
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
                    controller: TextEditingController(text: reqRemarks),
                    readOnly: true,
                    maxLines: 3,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: reqRemarks,
                        labelText: "Requisition Remarks",
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
                    controller: TextEditingController(text: nominee),
                    readOnly: true,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        enabled: false,
                        hintText: nominee,
                        labelText: "Nominee",
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
                    //controller: TextEditingController(text: approvalRemarks),
                    maxLines: 3,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8.0),
                        hintText: approvalRemarks,
                        labelText: "Approval Remarks",
                        labelStyle: TextStyle(fontSize: 15)
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding: Vx.mOnly(right: 16),
                  children: [
                    ElevatedButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Mythemes.successColor),
                      ),
                      child: "Approve".text.make(),
                    ).wh(150, 40).py12(),

                    ElevatedButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Mythemes.dangerColorOne),
                      ),
                      child: "Disapprove".text.make(),
                    ).wh(150, 40).py12()
                  ]))
            ],
          ),
        ],
      ),
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