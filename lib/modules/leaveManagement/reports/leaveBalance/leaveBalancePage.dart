import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../modalClass/leaveBalModal.dart';
import '../modalClass/leaveBalanceModel.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';

class LeaveBalancePage extends StatefulWidget {
  const LeaveBalancePage({Key? key}) : super(key: key);

  @override
  State<LeaveBalancePage> createState() => _LeaveBalancePageState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();

String? sessionId;
var doj;
LeaveBalModal? leaveBalLabel;

class _LeaveBalancePageState extends State<LeaveBalancePage> {
  @override
  void initState() {
    //print(leaveBalanceLabel!.leaveTypeListDetails.toString().length);
    // TODO: implement initState
    setState(() {
      getSharedPrfanceList();
    });
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LeaveBalModal> getAppReq11 = getLeaveBalance(sessionId!);
    doj = await shared.getDoj();
    //doj = DateFormat('dd-MM-yyyy').format(DateTime.parse(doj));
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        leaveBalLabel = value;
        /* if( leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length != null) {
          leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length;
          print("Fetch data ${ leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length}");
        } else {
          Center(
            child: "There is no data available right now".text.make(),
          );
          leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist = [];
        }
*/
      });
      /*if(leaveBalLabel!.leaveData!.leaveTypeList == Null){
        showNodata(context, "Oops", "There is no any requisition.");
      }else
        {
          var conditioncheck = leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length;
          if(conditioncheck==0 ){
            showNodata(context, "Oops", "There is no any requisition.");
          }
        }*/
      //print('employeeList00${leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length}');
    });
  }

  showNodata(BuildContext buildContext, result, reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(buildContext);
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

  Future<LeaveBalModal> getLeaveBalance(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBal;
    print('employeeList11: ${SessionId}');
    LeaveBalModal leaveBalModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    //print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];

    var emptyjson = mapResponse['leaveData']['leaveTypeList'];
    //var emptyjson = respons;

    var notEmptyjson = mapResponse.isNotEmpty;
    var containsEmptyjson = mapResponse.length;

    print('responseemployeeList $emptyjson');
    print('responseemployeeList $notEmptyjson');
    print('responseemployeeList $containsEmptyjson');

    /* if (containsEmptyjson==1)  {
      //print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }*/
    print('responseemployeeList $mapResponse');
    leaveBalModal = LeaveBalModal.fromJson(mapResponse);

    //print("typename:-${mapResponse['leaveData']['CO-578']['leavesTaken']}");
    if (emptyjson == null) {
      showNodata(
        context,
        "Oops!!",
        "You are not mapped with any leave policy.",
      );
    }
    return leaveBalModal;
  }

  var titleName = "My Leave Balance";
  int pageIndex = 0;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: titleName.text.make()),

      body:
          leaveBalLabel == null
              ? Center(child: CircularProgressIndicator())
              : GetLeaveBal(leaveBalLabel!),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 0),
              ),
            );
            //Navigator.pop(context);
            print('home tab');
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 1),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetAttendanceDet(showAppBar: true),
              ),
            );
            print('My Requests');
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAllReportsPage(showAppBar: true),
              ),
            );

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('My Reports');
          }
          if (index == 4) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);

            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Dashboard');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.app_badge_fill),
            label: 'My Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'My Reports',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class GetLeaveBal extends StatefulWidget {
  final LeaveBalModal leaveBalModal;
  const GetLeaveBal(this.leaveBalModal);

  @override
  State<GetLeaveBal> createState() => _GetLeaveBalState(leaveBalModal);
}

class _GetLeaveBalState extends State<GetLeaveBal> {
  final LeaveBalModal leaveBalModal;
  var itemCount;
  _GetLeaveBalState(this.leaveBalModal);
  bool isExpanded = false;
  void expandTile() {
    setState(() {
      isExpanded = true;
      // keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      isExpanded = false;
      // keyTile = UniqueKey();
    });
  }

  @override
  void initState() {
    setState(() {
      //itemCount = 0;
      // TODO: implement initState
      if (leaveBalLabel!.leaveData!.leaveTypeList != null) {
        itemCount =
            leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length;
      } else {
        itemCount = 0;
      }

      print("itemcount $itemCount");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListView.builder(
        //itemCount: leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length,
        itemCount: itemCount,
        itemBuilder: (context, itemCount) {
          var leaveTypeName =
              leaveBalLabel!
                  .leaveData!
                  .leaveTypeList!
                  .leaveTypelist![itemCount];

          var splitLeave = leaveTypeName.split("-")[2];
          var newListLeave = leaveTypeName.split("-")[1];
          var nameOnly = leaveTypeName.split("-")[0];
          var newString = "$newListLeave-" + "$splitLeave";
          //print("$newListLeave-" + "$splitLeave");
          print("Leave Type - $nameOnly");

          var leaveTypeShort =
              mapResponse['leaveData']['$newString']['leavesTaken'];
          //var leaveTypeShort = ;
          print("$leaveTypeShort");

          return Card(
            child: ExpansionTile(
              //key: keyTile,
              initiallyExpanded: isExpanded,
              childrenPadding: EdgeInsets.all(16).copyWith(top: 0),

              title: nameOnly.toString().text.bold.make(),
              subtitle:
                  "Balance - ${mapResponse['leaveData']['$newString']['totalLeavesPending'].toString()}"
                      .text
                      .bold
                      .color(Mythemes.successColor)
                      .make(),
              children: [
                /*Row(
                        children: [
                          "Carry Forward (Last Ledger)".text.bold.color(Mythemes.lightBluishColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //leaveBalLabel!.leaveData!.sL606!.lastYearLeaves!.toString().text.make().px8(),
                                  mapResponse['leaveData']['$newString']['lastYearLeaves'].toString().text.bold.color(Mythemes.lightBluishColor).make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                /*Row(
                        children: [
                          "Leave Credit (Current)".text.bold.color(Mythemes.activeStepColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  mapResponse['leaveData']['$newString']['currentYearLeaves'].toString().text.bold.color(Mythemes.activeStepColor).make().px8(),
                                  */
                /* if (leaveTypeName == 'Sick Leave-SL-606')
                                  leaveBalLabel!.leaveData!.sL606!.currentYearLeaves!.toString().text.make().px8(),
                                if(leaveTypeName == 'Casual Leave-CL-607')
                                  leaveBalLabel!.leaveData!.cL607!.currentYearLeaves!.toString().text.make().px8(),
                                if(leaveTypeName == 'Earn Leave-EL-608')
                                  leaveBalLabel!.leaveData!.eL608!.currentYearLeaves!.toString().text.make().px8(),*/
                /*
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                Row(
                  children: [
                    "Total Leave Enjoyed".text.bold
                        .color(Mythemes.warningColor)
                        .make(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          mapResponse['leaveData']['$newString']['leavesTaken']
                              .toString()
                              .text
                              .bold
                              .color(Mythemes.warningColor)
                              .make()
                              .px8(),
                        ],
                      ),
                    ),
                  ],
                ).pLTRB(0, 0, 0, 8.0),
                /*Row(
                        children: [
                          "Leave Without Pay".text.bold.color(Mythemes.dangerColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  mapResponse['leaveData']['$newString']['lwp'].toString().text.bold.color(Mythemes.dangerColor).make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                /*Row(
                        children: [
                          "Balance Leaves".text.bold.color(Mythemes.alertColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  mapResponse['leaveData']['$newString']['totalLeavesPending'].toString().text.bold.color(Mythemes.alertColor).make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                Row(
                  children: [
                    "Net Balance".text.bold.color(Mythemes.successColor).make(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          mapResponse['leaveData']['$newString']['totalLeavesPending']
                              .toString()
                              .text
                              .bold
                              .color(Mythemes.successColor)
                              .make()
                              .px8(),
                        ],
                      ),
                    ),
                  ],
                ).pLTRB(0, 0, 0, 8.0),
              ],
            ),
          ).p2();
        },
      ),
    );
  }
}
