import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/ess/myAllRequestsPage.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app/modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
import '../attendanceRequisition/getAttendanceDetails.dart';
import '../timeAndAttReports.dart';

class PendingRequisition extends StatefulWidget {
  final SelfRequisitionModel selfRequisitionModel;

  PendingRequisition(this.selfRequisitionModel);

  @override
  State<PendingRequisition> createState() =>
      _PendingRequisitionState(selfRequisitionModel);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNew=[];

SelfRequisitionModel? selfRequisitionLabel;
SelfRequisitionModel? selfRequisitionLabeled;


class _PendingRequisitionState extends State<PendingRequisition> with RouteAware{
  final SelfRequisitionModel selfRequisitionModel;

  _PendingRequisitionState(this.selfRequisitionModel);

  var reqId;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => getSharedPrfanceList());

    //getSharedPrfanceList();
  }

  @override
  void didUpdateWidget(covariant PendingRequisition oldWidget) {
    //getSharedPrfanceList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<SelfRequisitionModel> getEmployeeList11 = getSelfReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        selfRequisitionLabel = value;
        selfRequisitionLabeled = selfRequisitionLabel;

        if(foundDataNew != null) {
          foundDataNew!.length;
          print("Fetch data $foundDataNew");
        } else {
          Center(
            child: "There is no data available right now".text.make(),
          );
          foundDataNew = [];
        }
        print("Attendance Request Data - $selfRequisitionLabeled");
      });

      //print('employeeList00${selfRequisitionLabel!.data!.length}');
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

  var reqType;

  Future<SelfRequisitionModel> getSelfReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.selfAttRequisitionList;
    print('employeeList11: ${SessionId}');
    setState(() {
      _isLoading = true;
    });
    SelfRequisitionModel selfRequisitionModel;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');
    print('URL ${response.request}');
    mapResponse = json.decode(response.body);
    print('responseemployeeList $mapResponse');
    var getData = mapResponse.length;
    if (getData == 0 )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }

    selfRequisitionModel = SelfRequisitionModel.fromJson(mapResponse);
    if (selfRequisitionModel.data != null) {
      allUsernew = selfRequisitionModel.data!;
    } else {
      allUsernew = []; // or handle accordingly
    }
    setState(() {
      _isLoading = false;
    });
    return selfRequisitionModel;
  }

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
  bool _isLoading = true;
  var titleName = "My Attendance Requests";
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;
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
                previousScreen:  MyAllRequestPage(),
                textStyle: TextStyle(fontSize: 14),
                onChanged: (value) {
                  _runFilter(value);
                },
                horizontalPadding: 8,
                searchIconColor: Mythemes.black,
                centerTitle: "$titleName - ${foundDataNew!.length}",
                verticalPadding: 3,
                centerTitleStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Mythemes.black),
                searchTextEditingController: searchType),
          ),
        ),
      ),
      body: Container(
        child: Column(
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
                      Navigator.pushNamed(context, MyRoutings.pendingReqRoute);
                      //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                    }
                    if(value == 1) {
                      Navigator.pushNamed(context, MyRoutings.essAttendanceApprovedReq);
                    }
                   /* if(value == 2) {
                      Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                    }*/
                  },
                )
              ],
            ).py(4),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : selfRequisitionLabeled == null
                  ? Center(child: Text('Click on + icon to raise the attendance request.'))
                  : getEmpReqList(selfRequisitionLabeled!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAttendanceDet(showAppBar: true,)));
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.add, color: Mythemes.whitish,),
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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GetAttendanceDet(showAppBar: true,)));
            print('My Requests');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if(index==4){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
           /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );*/
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

  getEmpReqList(SelfRequisitionModel selfRequisitionModel) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  PendingRequisition(SelfRequisitionModel()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: foundDataNew!.length,
        itemBuilder: (context, i) {
          if(foundDataNew![i].attendanceRequisionType == true) {
            reqType = "Attendance Request";
          }
          if (foundDataNew![i].compOffRequistionType == true) {
            reqType = "Compensatory Off Request";
          }
          if (foundDataNew![i].nightRequistionType == true) {
            reqType = "Night Shift Request";
          }
          if (foundDataNew![i].shortLeaveRequistionType == true) {
            reqType = "Short Leave Request";
          }
          if (foundDataNew![i].odRequistionType == true) {
            reqType = "Out Duty Request";
          }
          return InkWell(
            onTap: () {
              reqId = foundDataNew![i].reqId;

              print("Req ID - $reqId");

              showDialgCancel(context, context, context);
              //CommonNotificationPage.showDeleteMessage(context, context, context);
            },
            child: Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          foundDataNew![i].employeeName
                              .toString()
                              .text
                              .make()
                              .px8()
                              .py4(),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              foundDataNew![i].status.toString()
                                  .text.bold
                                  .color(Mythemes.lightBluishColor)
                                  .sm
                                  .make()
                                  .px8(),
                            ],
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          selfRequisitionModel
                                  .data![i].reqDate
                                  .toString()
                              .text
                              .textStyle(context.captionStyle)
                              .make()
                              .px8(),
                        ],
                      ),
                      Row(
                        children: [
                          "Request Type: $reqType"
                              .text.bold
                              .textStyle(context.captionStyle)
                              .make()
                              .px8(),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 35,
                                  color: Mythemes.lightBluishColor,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "In Time".text.sm.make(),
                                foundDataNew![i].inTime
                                    .toString()
                                    .text
                                    .sm
                                    .make()
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 35,
                                  color: Mythemes.dangerColor,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "Out Time".text.sm.make(),
                                foundDataNew![i].outTime
                                    .toString()
                                    .text
                                    .sm
                                    .make()
                              ],
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.only(top:15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.update, size: 35, color: Mythemes.lightBluishColor,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "Working Hours".text.sm.make(),
                                "09:30".text.sm.make()
                              ],
                            ),
                          ),*/
                        ],
                      )
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  showDialgCancel(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      )),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(
              child: Text(
            "Cancel Requisition",
            style: TextStyle(fontSize: 20),
          )),
        ],
      ),
      content: Text("Sure you want to cancel requisition?",
          style: TextStyle(fontSize: 14)),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              // color: Mythemes.lightBluishColor,
              child: Text(
                "No",
                style: TextStyle(color: Mythemes.dangerColor),
              ),
            )),
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) =>
                        PendingRequisition(SelfRequisitionModel()),
                    transitionDuration: Duration(seconds: 1),
                    maintainState: true,
                  ));
              cancelSelfAttRequisition(reqId.toString());
              Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              child: Text(
                "Yes",
                style: TextStyle(color: Mythemes.warningColor),
              ),
            )),
      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<void> cancelSelfAttRequisition(String reqId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.cancelSelfAttReqList;

    if (!mounted) return;
    CommonNotificationPage.showLoaderDialog(context);
    print("🔄 Loader shown...");

    try {
      var urlapi = Uri.parse("$conn$apiUrl?"
          "sessionId=$sessionId&"
          "reqId=$reqId");

      final response = await http.post(urlapi);
      print('🌍 URL: ${response.request}');
      print('📩 Raw Response: ${response.body}');

      String result = "unknown";

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        result = mapResponse['result']?.toString() ?? "unknown";
        print("📌 API Result: $result");
      } else {
        print("❌ API Error ${response.statusCode}");
      }

      // ✅ Always close loader no matter success/failure
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // ✅ Now show popup depending on result
      if (mounted) {
        if (result.compareToIgnoringCase("success") == 0) {
          CommonNotificationPage.showDialgSucess(
            context,
            "Requisition Deleted Successfully !",
            "Success.",
          );
          // Close current screen after success
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        } else if (result.compareToIgnoringCase("failed") == 0) {
          CommonNotificationPage.showDialgSucess(
            context,
            "Please check the network connection!",
            "Failed",
          );
        } else {
          CommonNotificationPage.showDialgSucess(
            context,
            "Unexpected response: $result",
            "Error",
          );
        }
      }

    } catch (e) {
      print("❌ Exception: $e");
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // ✅ close loader
        CommonNotificationPage.showDialgSucess(context, "Exception: $e", "Error");
      }
    }
  }
}

class SearchItems extends SearchDelegate {
  List<String> searchTerms = [];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
