import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../../../modules/onDuty/reports/onDutyTypes.dart';
import '../../../modules/onDuty/reports/pendingRequisition/modalClass/pendingOdReqList.dart';
import '../../../modules/onDuty/reports/pendingRequisition/odAttendanceApproval.dart';

class UIS_PendingOdRequisition extends StatefulWidget {
  final PendingOdReqList pendingOdReqList;

  UIS_PendingOdRequisition(this.pendingOdReqList);

  @override
  State<UIS_PendingOdRequisition> createState() =>
      _UIS_PendingOdRequisitionState(pendingOdReqList);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Listdata>? allUsernew=[];
List<Listdata>? foundDataNewUIS=[];
bool isLoading = true;
PendingOdReqList? pendingOdReqListLabel;
PendingOdReqList? pendingOdReqListLabeled;

class _UIS_PendingOdRequisitionState extends State<UIS_PendingOdRequisition> with RouteAware{
  final PendingOdReqList pendingOdReqList;

  _UIS_PendingOdRequisitionState(this.pendingOdReqList);

  var titleName = "OD Pending List";


  String? odStatus;
  var startDate;
  var endDate;

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
    DateTime now = DateTime.now();
    odStatus = "Pending";
    startDate = "2015-01-01";
    DateFormat currentDateFormat = DateFormat("yyyy-MM-dd");
    String currentDateFormatString = currentDateFormat.format(now);
    print("current date $currentDateFormatString");
    endDate = currentDateFormatString;
    // TODO: implement initState
    super.initState();
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNewUIS!.length;
      print('listLength $listLength');
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<PendingOdReqList> getEmployeeList11 =
        getPendingOdReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNewUIS = allUsernew;
        pendingOdReqListLabel = value;
        pendingOdReqListLabeled = pendingOdReqListLabel;
        if(foundDataNewUIS != null) {
          foundDataNewUIS!.length;
          print("Fetch data $foundDataNewUIS");
          isLoading = false;
        } else {
          Center(
            child: "There is no data available right now".text.make(),
          );
          foundDataNewUIS = [];
        }
      });

      //print('employeeList00${pendingOdReqListLabel!.listdata!.length}');
    });
  }

  Future<PendingOdReqList> getPendingOdReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.odPendingReqListNew;
    print('employeeList11: ${SessionId}');
    PendingOdReqList pendingOdReqList;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "odStatus=$odStatus&"
        "startDate=$startDate&"
        "endDate=$endDate");

    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['result'];
    if (getData == "Error" )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }
    print('responseemployeeList $getData');
    pendingOdReqList = PendingOdReqList.fromJson(mapResponse);
    allUsernew = pendingOdReqList.listdata;

    return pendingOdReqList;
  }

  var statusColor;
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

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Listdata>?  results = [];

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
          element.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
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
      foundDataNewUIS = results;
    });
  }
  TextEditingController searchType = TextEditingController();
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
                previousScreen:  OnDutyTypes(),
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
                searchTextEditingController: searchType),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
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
                    final text = const ['Pending', 'Approved', 'Disapproved'][local.index];
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
                      isLoading = true;
                      titleName = "OD Pending List";
                      odStatus = "Pending";
                      Navigator.pushNamed(context, MyRoutings.pendingRequisitionListRoute);
                      getSharedPrfanceList();
                      //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                    }
                    if(value == 1) {
                      isLoading = true;
                      titleName = "OD Approved List";
                      odStatus = "Approved";
                      getSharedPrfanceList();
                      //Navigator.pushNamed(context, MyRoutings.levelOnePendingRoute);
                    }
                    if(value == 2) {
                      isLoading = true;
                      titleName = "OD Disapproved List";
                      odStatus = "Disapproved";
                      getSharedPrfanceList();
                      //Navigator.pushNamed(context, MyRoutings.levelTwoPendingRoute);
                    }
                  },
                )
              ],
            ).py(6),
            isLoading
                ? CircularProgressIndicator().py32() :
            Expanded(
                child:

                pendingOdReqListLabeled == null
                    ? "There is no data available.".text.center.make()
                    : getPendingOdRequisitionList(pendingOdReqListLabeled!)),
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
            Navigator.pushNamed(context, MyRoutings.onDutyTypes);
            print('OD');
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
            icon: Icon(Icons.outbond_outlined),
            label: 'OD',
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

  getPendingOdRequisitionList(PendingOdReqList pendingOdReqList) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  UIS_PendingOdRequisition(PendingOdReqList()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        itemCount: foundDataNewUIS!.length,
        itemBuilder: (context, itemCount) {
          var statusCheck = foundDataNewUIS![itemCount].approvalstatus;
          if (statusCheck == 'Approved') {
            statusColor = Mythemes.successColor;
          } else if (statusCheck == 'DisApproved') {
            statusColor = Mythemes.dangerColor;
          } else {
            statusColor = Mythemes.alertColor;
          }
          return InkWell(
            onTap: () {

              if (statusCheck == 'Approved') {

                Fluttertoast.showToast(
                    msg: "Your Requisition has already Approved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              } else if (statusCheck == 'DisApproved') {

                Fluttertoast.showToast(
                    msg: "Your Requisition has already Disapproved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              } else {

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    OdApproveDisapproveReq(pendingOdReqList, itemCount)));
              }
            },
            child: Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          foundDataNewUIS![itemCount].name
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
                              foundDataNewUIS![itemCount].approvalstatus
                                  .toString()
                                  .text.bold
                                  .color(statusColor)
                                  .sm
                                  .make()
                                  .px8(),
                            ],
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: foundDataNewUIS![itemCount].odaddress
                              .toString()
                              .text
                              .textStyle(context.captionStyle)
                              .make()
                              .px8(),)

                        ],
                      ),
                      Row(
                        children: [
                          foundDataNewUIS![itemCount].remark
                              .toString()
                              .text
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
                                foundDataNewUIS![itemCount].odtype
                                    .toString()
                                    .text
                                    .sm
                                    .make(),
                                foundDataNewUIS![itemCount].odtime
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
                                  Icons.date_range,
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
                                "Date".text.sm.make(),
                                DateFormat("dd-MM-yyyy")
                                    .format(DateTime.parse(foundDataNewUIS![itemCount].date
                                        .toString()))
                                    .text
                                    .sm
                                    .make()
                              ],
                            ),
                          ),
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
}
