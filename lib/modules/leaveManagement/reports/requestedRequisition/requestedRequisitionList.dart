import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import '../modalClass/selfLeaveRequisitionModal.dart';

class RequestedRequisitionList extends StatefulWidget {
  final SelfLeaveRequisitionListModal selfLeaveRequisitionListModal;
  const RequestedRequisitionList(this.selfLeaveRequisitionListModal);


  @override
  State<RequestedRequisitionList> createState() => _RequestedRequisitionListState(selfLeaveRequisitionListModal);
}
Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

SelfLeaveRequisitionListModal? selfLeaveRequisitionLabel;

class _RequestedRequisitionListState extends State<RequestedRequisitionList> with RouteAware{
  final SelfLeaveRequisitionListModal selfLeaveRequisitionListModal;
  _RequestedRequisitionListState(this.selfLeaveRequisitionListModal);

  var status;
  var leaveId;

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
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<SelfLeaveRequisitionListModal> getAppReq11 = getSelfLeaveReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        selfLeaveRequisitionLabel = value;
      });
      if (selfLeaveRequisitionLabel?.data != null) {
        print('employeeList00: ${selfLeaveRequisitionLabel!.data!.length}');
      } else {
        print('employeeList00: No data found');
      }
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
            Navigator.of(buildContext, rootNavigator: true).pop();
            //Navigator.pop(buildContext);
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
  bool _isLoading = true;
  Future<SelfLeaveRequisitionListModal> getSelfLeaveReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.requestedReqList;
    print('employeeList11: ${SessionId}');
    setState(() {
      _isLoading = true;
    });
    SelfLeaveRequisitionListModal approvedLeaveReqModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');
    print('API ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse.length;
    if (getData == 0 )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }
    print('responseemployeeList $getData');
    approvedLeaveReqModal=SelfLeaveRequisitionListModal.fromJson(mapResponse);

    setState(() {
      _isLoading = false;
    });
    return approvedLeaveReqModal;
  }

  var titleName = "My Leave Requests";
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
        elevation: 0.5,
        /*leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              //Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
            },
            icon: Icon(Icons.arrow_back_ios)),*/
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          bool internetCheck = await InternetConnectionChecker().hasConnection;
          if(internetCheck == false) {
            setState(() {
              AlertDialog(
                content: "Please check your internet connection".text.make(),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please check your Internet connection."),
              ));
            });

          } else {
            Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
          }
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.add, color: Mythemes.whitish,),
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
                        final text = const ['Pending', 'Approved'][local.index];
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
                          Navigator.pushNamed(context, MyRoutings.requestedRequisitionRoute);
                          //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                        }
                        if(value == 1) {
                          Navigator.pushNamed(context, MyRoutings.approvedLeaveReqListRoute);
                        }
                       /* if(value == 2) {
                          Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                        }*/
                      },
                    )
                  ],
                ).py(4),
              /*  Expanded(
                  child: selfLeaveRequisitionLabel == null ?
                Center(
                    child: CircularProgressIndicator()):
                getSelfReqRequisitionList(selfLeaveRequisitionLabel!) ,
                )*/

                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : (selfLeaveRequisitionLabel == null || selfLeaveRequisitionLabel!.data == null)
                      ? Center(child: Text('Click on + icon to raise the leave request.'))
                      : getSelfReqRequisitionList(selfLeaveRequisitionLabel!),
                ),

              ],
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
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My All Requests');
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
            icon: Icon(Icons.account_tree_outlined),
            label: 'My Requests',
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

  getSelfReqRequisitionList(SelfLeaveRequisitionListModal selfLeaveRequisitionListModal){
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  RequestedRequisitionList(SelfLeaveRequisitionListModal()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: selfLeaveRequisitionListModal!.data!.length,
        itemBuilder: (context, itemCount) {
          return InkWell(
              onTap: (){
                leaveId = selfLeaveRequisitionListModal.data![itemCount].leavereqId;
                print("leaveId $leaveId");
                var statusCheck = selfLeaveRequisitionListModal.data![itemCount].status.toString();
                if (statusCheck == 'Level_One_Pending') {
                  showDialgCancel(context, context, context);
                }
                else if (statusCheck == 'Level_Two_Pending') {
                  showDialgCancel(context, context, context);
                }
                else if (statusCheck == 'PENDING') {
                  showDialgCancel(context, context, context);
                }
                else if (statusCheck == 'APPROVED') {
                  Fluttertoast.showToast(
                      msg: "Your Requisition has already Approved",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                else {
                  Fluttertoast.showToast(
                      msg: "Your Requisition has already Disapproved",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }

                //print("hi bharat");
                //CommonNotificationPage.showDeleteMessage(context, context, context);
              },
              child: Card(
                  elevation: 2,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            selfLeaveRequisitionListModal.data![itemCount].empName.toString().text.make().px8().py4(),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    selfLeaveRequisitionListModal.data![itemCount].status.toString().text.make().px8(),
                                  ],
                                )
                            )

                          ],
                        ),
                        Row(
                          children: [
                            selfLeaveRequisitionListModal.data![itemCount].leavetype.toString().text.textStyle(context.captionStyle).make().px8(),
                          ],
                        ),
                        Row(
                          children: [
                            selfLeaveRequisitionListModal.data![itemCount].leaveLength.toString().text.textStyle(context.captionStyle).make().px8(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                "Start Date".text.sm.make(),
                                selfLeaveRequisitionListModal.data![itemCount].startDate.toString().text.sm.make()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "End Date".text.sm.make(),
                                  selfLeaveRequisitionListModal.data![itemCount].endDate.toString().text.sm.make()
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                "In Time".text.sm.make(),
                                selfLeaveRequisitionListModal.data![itemCount].startTime.toString().text.sm.make()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "Out Time".text.sm.make(),
                                  selfLeaveRequisitionListModal.data![itemCount].endTime.toString().text.sm.make()
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              )

            /*  .badge(
                color: Mythemes.lightBluishColor ,
                size: 25 ,
                count: 8,
                position: VxBadgePosition.rightTop,
                textStyle: TextStyle(
                    fontSize: 14,
                    color: Mythemes.whitish)

            ),*/
          );
        },
      ),
    );
  }

  showDialgCancel(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( "Cancel Requisition", style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text("Sure you want to cancel requisition?" , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.of(buildContext).pop();
            },
            child: Container(
              // color: Mythemes.lightBluishColor,
              child: Text("No", style: TextStyle(color: Mythemes.dangerColor),),
            )
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              getSelfLeaveReqList(sessionId!);
              /*Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) =>
                        RequestedRequisitionList(SelfLeaveRequisitionListModal()),
                    transitionDuration: Duration(seconds: 1),
                    maintainState: true,
                  ));*/
              cancelReqRequisitionList(leaveId.toString());
            },
            child: Container(
              child: Text("Yes", style: TextStyle(color: Mythemes.warningColor),),
            )
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

 /* void showDialgCancel(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      title: Row(
        children: [
          "Cancel Requisition".text.make(),
        ],
      ),
      content: Builder(
        builder: (context) {
          *//* var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;*//*
          return Container(
            height:  15,
            width:  20,
            child: "Sure you want to cancel requisition?".text.make(),
          );
        },
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
                child: Container(
                  // color: Mythemes.lightBluishColor,
                  child: "No".text.color(Mythemes.dangerColorOne).make(),
                )
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (a, b, c) =>
                            RequestedRequisitionList(SelfLeaveRequisitionListModal()),
                        transitionDuration: Duration(seconds: 1),
                        maintainState: true,
                      ));
                  cancelReqRequisitionList(leaveId.toString());
                },
                child: Container(
                  // color: Mythemes.lightBluishColor,
                  child: "Yes".text.make(),
                )
            ),
          ],
        )
      ],
    );
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }*/

  Future<void> cancelReqRequisitionList(String leaveId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.cancelReqRequisition;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "leaveId=$leaveId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      //Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = mapResponse['reason'];
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        if (mounted) {
          showDialgSucess1(
              context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          showDialgSucess1(
              context, reason.upperCamelCase, " Error ");
        }
        }

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

            /*Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) =>
                      RequestedRequisitionList(SelfLeaveRequisitionListModal()),
                  transitionDuration: Duration(seconds: 1),
                  maintainState: true,
                ));*/
            if(mounted) {
              Navigator.of(context, rootNavigator: true).pop();
            }



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
        });
  }
}

