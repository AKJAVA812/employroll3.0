import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/modules/leaveManagement/reports/pendingRequisition/pendingLeaveApprovalDis.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../main.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../modules/leaveManagement/reports/leaveManageReport.dart';
import '../../modules/leaveManagement/reports/levelTwoPendingApproval.dart';
import '../../modules/leaveManagement/reports/modalClass/levelTwoPendingLeaveModal.dart';

class UIS_LevelTwoPendingLeave extends StatefulWidget {
  final LevelTwoPendingLeaveModal pendingLeaveRequisitionModal;
  const UIS_LevelTwoPendingLeave(this.pendingLeaveRequisitionModal);


  @override
  State<UIS_LevelTwoPendingLeave> createState() => _UIS_LevelTwoPendingLeaveState(pendingLeaveRequisitionModal);
}
Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNew=[];

LevelTwoPendingLeaveModal? pendingLeaveReqLabel;
LevelTwoPendingLeaveModal? pendingLeaveReqLabeled;

class _UIS_LevelTwoPendingLeaveState extends State<UIS_LevelTwoPendingLeave> with RouteAware {
  final LevelTwoPendingLeaveModal pendingLeaveRequisitionModal;
  _UIS_LevelTwoPendingLeaveState(this.pendingLeaveRequisitionModal);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // ✅ Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;

      print('listLength $listLength');
    });
  }

  showNodata(BuildContext buildContext, result,reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
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
            setState(() {

            });
          },
          child: Text("Ok"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    await Future.delayed(Duration(seconds: 2));
    Future<LevelTwoPendingLeaveModal> getAppReq11 = getPendingLeaveReq(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        pendingLeaveReqLabel=value;
        pendingLeaveReqLabeled=pendingLeaveReqLabel;
        if(foundDataNew != null) {
          foundDataNew!.length;
          print("Fetch data $foundDataNew");
        } else {
          Center(
            child: "There is no data available right now".text.make(),
          );
          foundDataNew = [];
        }
      });
      //print('employeeList00${pendingLeaveReqLabel!.result!.data!.length}');
    });
  }

  Future<LevelTwoPendingLeaveModal> getPendingLeaveReq(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.levelTwoLeaveList;
    print('employeeList11: ${SessionId}');
    LevelTwoPendingLeaveModal pendingLeaveRequisitionModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['result']['data'];
    if (getData == null )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }
    print('responseemployeeList $getData');
    pendingLeaveRequisitionModal=LevelTwoPendingLeaveModal.fromJson(mapResponse);

    allUsernew = pendingLeaveRequisitionModal.result!.data;

    return pendingLeaveRequisitionModal;
  }

  var titleName = "Level Two Pending";
  TextEditingController searchType = TextEditingController();

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>?  results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
      setState(() {
        results = allUsernew;
      });
    } else {
      /*results = allUsernew.where((user) =>
        user!.data!.contains(enteredKeyword.toLowerCase()))
          .toList();*/

      results = allUsernew?.where((element) =>
          element.employeeName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      /*for(int i=0; i<inductionListLabel!.data!.length;i++){
        if(inductionListLabel!.data![i].empName!.toLowerCase().contains(enteredKeyword.toLowerCase())){
          // Refresh the UI
          setState(() {
            inductionListLabeldd=inductionResult;
          });
        }*/
    }
    // we use the toLowerCase() method to make it case-insensitive
    setState(() {
      foundDataNew = results;
    });
  }

  int pageIndex = 0;
  int currentIndex = 2;
  int value = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, border: Border(
                top: BorderSide.none
            ), boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.5,
                  spreadRadius: 0,
                  offset: Offset(0, 0.2))
            ]),
            child: AnimationSearchBar(
                searchFieldDecoration: BoxDecoration(
                  color: Mythemes.greyishade,
                  borderRadius: BorderRadius.circular(20),
                ),
                backIcon: Icons.arrow_back_ios,
                backIconColor: Mythemes.black,
                previousScreen:  LeaveManageReports(),
                textStyle: TextStyle(fontSize: 14),
                onChanged: (value) {
                  _runFilter(value);
                },
                horizontalPadding: 8,
                searchIconColor: Mythemes.black,
                centerTitle: titleName,
                verticalPadding: 3,
                centerTitleStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Mythemes.black),
                searchTextEditingController: searchType,
            ),
          ),
        ),
      ),

      body: Container(
        color: context.canvasColor,
        child:
            Column(
              children: [
                Row(
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
                      spacing: 10.0,
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
                        final text = const ['Pending', 'Level One', 'Level Two'][local.index];
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

                        if(value == 0) {
                          Navigator.pushNamed(context, MyRoutings.pendingLeaveReqListRoute);
                          //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                        }
                        if(value == 1) {
                          Navigator.pushNamed(context, MyRoutings.levelOnePendingRoute);
                        }
                        if(value == 2) {
                          Navigator.pushNamed(context, MyRoutings.levelTwoPendingRoute);
                        }
                      },
                    )
                  ],
                ).py(6),
                Expanded(child:
                pendingLeaveReqLabeled == null ?
                Center(
                    child: CircularProgressIndicator()):
                getPendingLeaveReqList(pendingLeaveReqLabeled!),
                )

              ]

            )

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
    );
  }

  getPendingLeaveReqList(LevelTwoPendingLeaveModal pendingLeaveRequisitionModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  UIS_LevelTwoPendingLeave(LevelTwoPendingLeaveModal()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: foundDataNew!.length,
        itemBuilder: (context, itemCount) {
          return InkWell(
              onTap: (){
                print(foundDataNew!.length);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LevelTwoPendingApproval(
                    pendingLeaveRequisitionModal, itemCount)));
                //Navigator.pushNamed(context, MyRoutings.pendingLeaveAppDisRoute);
                //CommonNotificationPage.showDeleteMessage(context, context, context);
              },
              child: Card(
                  elevation: 2,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            foundDataNew![itemCount].employeeName.toString().text.make().px8().py4(),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    foundDataNew![itemCount].status.toString().text.make().px8(),
                                  ],
                                )
                            )

                          ],
                        ),
                        Row(
                          children: [
                            foundDataNew![itemCount].leaveType.toString().text.textStyle(context.captionStyle).make().px8(),
                          ],
                        ),
                        Row(
                          children: [
                            foundDataNew![itemCount].leaveLength.toString().text.textStyle(context.captionStyle).make().px8(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                "Start Date".text.sm.make(),
                                foundDataNew![itemCount].startDate.toString().text.sm.make()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "End Date".text.sm.make(),
                                  foundDataNew![itemCount].endDate.toString().text.sm.make()
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                "In Time".text.sm.make(),
                                "00:00".toString().text.sm.make()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "Out Time".text.sm.make(),
                                  "00:00".text.sm.make()
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              )
          );
        },
      ),
    );
  }
}



