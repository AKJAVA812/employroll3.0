import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
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
import '../attendanceRequisition/getAttendanceDetails.dart';
import 'disApprovedRequisitionModel.dart';

class DisApprovedRequisiton extends StatefulWidget {
  final DisapprovedRequisitionModel disapprovedRequisitionModel;
  DisApprovedRequisiton (this.disapprovedRequisitionModel);

  @override
  State<DisApprovedRequisiton> createState() => _DisApprovedRequisitonState(disapprovedRequisitionModel);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

DisapprovedRequisitionModel? disapprovedRequisitionLabel;

class _DisApprovedRequisitonState extends State<DisApprovedRequisiton> with RouteAware{
  final DisapprovedRequisitionModel disapprovedRequisitionModel;
  _DisApprovedRequisitonState(this.disapprovedRequisitionModel);

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
    Future<DisapprovedRequisitionModel> getAppReq11 = getDisapprovedReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        disapprovedRequisitionLabel=value;
      });
      print('employeeList00${disapprovedRequisitionLabel!.data!.length}');
    });
  }

  Future<DisapprovedRequisitionModel> getDisapprovedReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.disApprovedAttReqList;
    print('employeeList11: ${SessionId}');
    DisapprovedRequisitionModel disapprovedRequisitionModel;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    disapprovedRequisitionModel=DisapprovedRequisitionModel.fromJson(mapResponse);

    return disapprovedRequisitionModel;
  }
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Disapproved Requisition List".text.overflow(TextOverflow.ellipsis).maxLines(1).make(),
        /*leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            },
            icon: Icon(Icons.arrow_back_ios)),*/
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

        child:  Column(
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
                      Navigator.pushNamed(context, MyRoutings.pendingReqRoute);
                      //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                    }
                    if(value == 1) {
                      Navigator.pushNamed(context, MyRoutings.approvedReqRoute);
                    }
                    if(value == 2) {
                      Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                    }
                  },
                )
              ],
            ).py(4),
            Expanded(
                child: disapprovedRequisitionLabel == null ?
                Center(
                    child: CircularProgressIndicator()):
                getDisAppList(disapprovedRequisitionLabel!)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAttendanceDet()));
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
            print('My Requests');
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

  getDisAppList(DisapprovedRequisitionModel disapprovedRequisitionModel) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  DisApprovedRequisiton(DisapprovedRequisitionModel()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: disapprovedRequisitionModel!.data!.length,
        itemBuilder: (context, i) {
          return Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        disapprovedRequisitionModel.data![i].empName.toString().text.make().px8().py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                "Disapproved".text.bold.color(Mythemes.dangerColorOne).sm.make().px8(),
                              ],
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        "On Date:".text.sm.make().px8(),
                        disapprovedRequisitionModel.data![i].onDate.toString().text.textStyle(context.captionStyle).make().px8(),
                      ],
                    ),
                    Row(
                      children: [
                        "Update:".text.sm.make().px8(),
                        disapprovedRequisitionModel.data![i].updationDate.toString().text.textStyle(context.captionStyle).make().px8(),
                      ],
                    ),

                    Row(
                      children: [
                        "Remarks:".text.sm.make().px8(),
                        disapprovedRequisitionModel.data![i].remark.toString().text.textStyle(context.captionStyle).make().px8(),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app, size: 35, color: Mythemes.dangerColorOne,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "In Time".text.sm.make(),
                              disapprovedRequisitionModel.data![i].inTime.toString().text.sm.make()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app, size: 35, color: Mythemes.dangerColorOne,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "Out Time".text.sm.make(),
                              disapprovedRequisitionModel.data![i].outtime.toString().text.sm.make()
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
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