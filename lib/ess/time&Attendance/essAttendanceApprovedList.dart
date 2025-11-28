import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
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
import '../../modules/timeAndAttendance/reports/approvedRequisition/approvedRequisitionModel.dart';
import '../../modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../myAllReports.dart';

class ESSAttApprovedRequisiton extends StatefulWidget {
  final ApprovedRequisitionModel approvedRequisitionModel;
  ESSAttApprovedRequisiton (this.approvedRequisitionModel);

  @override
  State<ESSAttApprovedRequisiton> createState() => _ESSAttApprovedRequisitonState(approvedRequisitionModel);
}
Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
dynamic userPanelPerm;
dynamic getProfileId;

ApprovedRequisitionModel? approvedRequisitionLabel;

class _ESSAttApprovedRequisitonState extends State<ESSAttApprovedRequisiton> with RouteAware{
  final ApprovedRequisitionModel approvedRequisitionModel;
  _ESSAttApprovedRequisitonState(this.approvedRequisitionModel);
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
    userPanelPerm = await shared!.getUserPanel();
    getProfileId = await shared!.getDefaultProfileId();
    // await Future.delayed(Duration(seconds: 5));
    Future<ApprovedRequisitionModel> getAppReq11 = getApprovedReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        approvedRequisitionLabel=value;
      });
      print('employeeList00${approvedRequisitionLabel!.data!.length}');
    });
  }

  Future<ApprovedRequisitionModel> getApprovedReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.essAttendanceApprovedList;
    print('employeeList11: ${SessionId}');
    ApprovedRequisitionModel approvedRequisitionModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId");
    final response = await http.post(urlapi);
    print('ESS Attendance Approved APIs - ${response.request}');

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    approvedRequisitionModel=ApprovedRequisitionModel.fromJson(mapResponse);

    return approvedRequisitionModel;
  }
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 1;
  var reqType = "Attendance Requisition";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Approved Requisition List".text.make(),
         leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context, delegate: SearchItems(),
                );

              }, icon: Icon(Icons.search))
        ],
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
                    /*if(value == 2) {
                      Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                    }*/
                  },
                )
              ],
            ).py(4),
            Expanded(
                child: approvedRequisitionLabel == null ?
                Center(
                    child: CircularProgressIndicator()):
                getAppRovedReqList(approvedRequisitionLabel!)),
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
            //Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));
            print('My Reports');
          }
          if(index==4){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
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

  getAppRovedReqList(ApprovedRequisitionModel approvedRequisitionModel) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  ESSAttApprovedRequisiton(ApprovedRequisitionModel()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: approvedRequisitionModel!.data!.length,
        itemBuilder: (context, i) {
          return
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ================= EMPLOYEE NAME + STATUS =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      approvedRequisitionModel.data![i].empName
                          .toString()
                          .text
                          .xl
                          .semiBold
                          .make(),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Mythemes.lightBluishColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: "Approved"
                            .toString()
                            .text
                            .color(Mythemes.successColor)
                            .bold
                            .make(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ================= DATE =================
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      approvedRequisitionModel.data![i].onDate
                          .toString()
                          .text
                          .textStyle(context.captionStyle)
                          .color(Colors.grey.shade700)
                          .make(),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ================= REQUEST TYPE =================
                  /*Row(
                    children: [
                      Icon(Icons.assignment, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      "Request Type: $reqType"
                          .text
                          .bold
                          .color(Colors.black87)
                          .sm
                          .make(),
                    ],
                  ),*/

                  //const SizedBox(height: 16),
                  const Divider(thickness: .8),
                  // const SizedBox(height: 12),

                  // ================= IN/OUT TIME =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      // ---------------- IN TIME ----------------
                      Column(
                        children: [
                          Icon(Icons.touch_app,
                              size: 32, color: Mythemes.lightBluishColor),
                          const SizedBox(height: 4),
                          "In Time".text.sm.make(),
                          approvedRequisitionModel.data![i].inTime.toString().text.semiBold.make(),
                        ],
                      ),

                      // ---------------- OUT TIME ----------------
                      Column(
                        children: [
                          Icon(Icons.touch_app,
                              size: 32, color: Mythemes.dangerColor),
                          const SizedBox(height: 4),
                          "Out Time".text.sm.make(),
                          approvedRequisitionModel.data![i].outTime.toString().text.semiBold.make(),
                        ],
                      ),

                      // If you want working hours, uncomment easily
                      /*
            Column(
              children: [
                Icon(Icons.timer_outlined,
                    size: 32, color: Mythemes.lightBluishColor),
                const SizedBox(height: 4),
                "Working Hours".text.sm.make(),
                "09:30".text.semiBold.make()
              ],
            ),
            */
                    ],
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}

class SearchItems extends SearchDelegate {

  List<String> searchTerms = [

  ];
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