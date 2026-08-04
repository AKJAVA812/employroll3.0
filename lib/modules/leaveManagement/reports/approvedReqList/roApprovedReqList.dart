import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'approvedLeaveReqModal.dart';

class ApprovedLeaveRequisitionList extends StatefulWidget {
  final ApprovedLeaveReqModal approvedLeaveReqModal;
  ApprovedLeaveRequisitionList(this.approvedLeaveReqModal);

  @override
  State<ApprovedLeaveRequisitionList> createState() =>
      _ApprovedLeaveRequisitionListState(approvedLeaveReqModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
dynamic getProfileId;
dynamic getOrgId;
dynamic userPanelPerm;

ApprovedLeaveReqModal? approvedLeaveReqLabel;

class _ApprovedLeaveRequisitionListState
    extends State<ApprovedLeaveRequisitionList>
    with RouteAware {
  final ApprovedLeaveReqModal approvedLeaveReqModal;
  _ApprovedLeaveRequisitionListState(this.approvedLeaveReqModal);

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
    // âœ… Called when coming back from Form Page
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
    sessionId = await shared.getSessionId();
    getProfileId = await shared.getDefaultProfileId();
    getOrgId = await shared.getOrgId();
    userPanelPerm = await shared.getUserPanel();
    // await Future.delayed(Duration(seconds: 5));
    Future<ApprovedLeaveReqModal> getAppReq11 = getApprovedLeaveReqList(
      sessionId!,
    );
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        approvedLeaveReqLabel = value;
      });
      print('employeeList00${approvedLeaveReqLabel!.result!.data!.length}');
    });
  }

  Future<ApprovedLeaveReqModal> getApprovedLeaveReqList(
    String SessionId,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.roApprovedReqList;
    print('employeeList11: ${SessionId}');
    ApprovedLeaveReqModal approvedLeaveReqModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?sessionId=$SessionId&"
      "profileId=$getProfileId&"
      "userPermission=$userPanelPerm&"
      "orgId=0",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');
    print('API ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    approvedLeaveReqModal = ApprovedLeaveReqModal.fromJson(mapResponse);

    return approvedLeaveReqModal;
  }

  int pageIndex = 0;
  int currentIndex = 2;
  int value = 1;
  var titleName = "Approved List";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
            },
            icon: Icon(Icons.arrow_back_ios)),*/
        title: titleName.text.make(),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchItems());
            },
            icon: Icon(Icons.search),
          ),
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
                    final opacity = ((global.position - local.position).abs() -
                            0.5)
                        .clamp(0.0, 1.0);
                    return VerticalDivider(
                      indent: 10.0,
                      endIndent: 10.0,
                      color: Colors.white38.withOpacity(opacity),
                    );
                  },
                  customIconBuilder: (context, local, global) {
                    final text = const ['Pending', 'Approved'][local.index];
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.lerp(
                            Colors.black,
                            Colors.white,
                            local.animationValue,
                          ),
                        ),
                      ),
                    );
                  },
                  borderWidth: 0.0,
                  onChanged: (i) {
                    setState(() {
                      value = i;
                      print(i);
                    });

                    if (value == 0) {
                      Navigator.pushNamed(
                        context,
                        MyRoutings.requestedRequisitionRoute,
                      );
                      //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                    }
                    if (value == 1) {
                      Navigator.pushNamed(
                        context,
                        MyRoutings.approvedLeaveReqListRoute,
                      );
                    }
                    /* if(value == 2) {
                          Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                        }*/
                  },
                ),
              ],
            ).py(4),
            Expanded(
              child:
                  approvedLeaveReqLabel == null
                      ? Center(child: CircularProgressIndicator())
                      : getAppRequisitionList(approvedLeaveReqLabel!),
            ),
          ],
        ),
      ),

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
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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

  getAppRequisitionList(ApprovedLeaveReqModal approvedLeaveReqModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) =>
                    ApprovedLeaveRequisitionList(ApprovedLeaveReqModal()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: approvedLeaveReqModal.result!.data!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              //Navigator.pushNamed(context, MyRoutings.approveDisapproveLeaveReqRoute);
            },
            child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        approvedLeaveReqModal.result!.data![i].employeeName
                            .toString()
                            .text
                            .make()
                            .px8()
                            .py4(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: ["Leave Length".text.make().px4()],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        approvedLeaveReqModal.result!.data![i].applicationDate
                            .toString()
                            .text
                            .textStyle(context.captionStyle)
                            .make()
                            .px8(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              approvedLeaveReqModal.result!.data![i].leaveLength
                                  .toString()
                                  .text
                                  .make()
                                  .px8(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        approvedLeaveReqModal.result!.data![i].leaveType
                            .toString()
                            .text
                            .textStyle(context.captionStyle)
                            .make()
                            .px8(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            "Start Date".text.sm.make(),
                            approvedLeaveReqModal.result!.data![i].startDate
                                .toString()
                                .text
                                .sm
                                .make(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "End Date".text.sm.make(),
                              approvedLeaveReqModal.result!.data![i].endDate
                                  .toString()
                                  .text
                                  .sm
                                  .make(),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            "Approved By".text.sm.make(),
                            approvedLeaveReqModal.result!.data![i].approvedBy
                                .toString()
                                .text
                                .sm
                                .make(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

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
        return ListTile(title: Text(result));
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
        return ListTile(title: Text(result));
      },
    );
  }
}
