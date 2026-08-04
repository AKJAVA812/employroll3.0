import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/workDoneReport/workDoneReportModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../attendanceRequisition/getAttendanceDetails.dart';

class WorkDoneReport extends StatefulWidget {
  final String forDatePickedString;
  final String toDatePickedString;

  const WorkDoneReport({
    Key? key,
    required this.forDatePickedString,
    required this.toDatePickedString,
  }) : super(key: key);

  @override
  State<WorkDoneReport> createState() =>
      _WorkDoneReportState(forDatePickedString, toDatePickedString);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<DataNew>? allUsernew = [];
List<DataNew>? foundDataNew = [];
late WorkdoneReportModel? workDoneReportModelGlobal = WorkdoneReportModel(
  data: [],
);
late WorkdoneReportModel? workDoneReportModelGlobaled = WorkdoneReportModel(
  data: [],
);

class _WorkDoneReportState extends State<WorkDoneReport> {
  final String forDatePickedString;
  final String toDatePickedString;

  _WorkDoneReportState(this.forDatePickedString, this.toDatePickedString);

  @override
  void initState() {
    getSharedPrfanceList();
    var listLength;
    listLength = foundDataNew!.length;
    print('listLength $listLength');
    print(forDatePickedString);
    print(toDatePickedString);
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    print('ResponseAttendance: ${sessionId}');
    print('ResponseAttendance: ${forDatePickedString}');
    print('ResponseAttendance: ${toDatePickedString}');
    //await Future.delayed(Duration(seconds: 3));
    Future<WorkdoneReportModel> getEmployeeList11 = getEmployeeList(
      sessionId!,
      toDatePickedString,
      forDatePickedString,
    );
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );
    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        workDoneReportModelGlobal = value;
        workDoneReportModelGlobaled = workDoneReportModelGlobal;
      });
      print('workDoneReport00${workDoneReportModelGlobal!.data!.length}');
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
            Navigator.of(buildContext, rootNavigator: true).pop();
            Navigator.pop(buildContext);
            setState(() {});
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

  Future<WorkdoneReportModel> getEmployeeList(
    String sessionId,
    String fromdate,
    String toDate,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.workDoneReport;
    print('workDoneReport: ${sessionId}');
    WorkdoneReportModel workdoneReportModel;
    //http://www.employroll.com/restful/service/get/self/mobile/task/list?sessionId=49a180fd3893b71baf3b030f39e0782d51d02cbe51a&fromdate=01-10-2022&todate=31-10-2022
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&todate=$fromdate&fromdate=$toDate",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    if (getData.length == 0) {
      print("getData111 $getData");
      showNodata(context, "Alert", "There is no data available for this date.");
    }
    workdoneReportModel = WorkdoneReportModel.fromJson(mapResponse);

    allUsernew = workdoneReportModel.data;

    return workdoneReportModel;
  }

  //late UniqueKey keyTile;
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

  var titleName = "Workdone Report";
  TextEditingController searchType = TextEditingController();

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<DataNew>? results = [];

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

      results =
          allUsernew
              ?.where(
                (element) => element.cName!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
      results =
          allUsernew
              ?.where(
                (element) => element.cMailId!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
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
  int currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mythemes.whitish,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide.none),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.5,
                  spreadRadius: 0,
                  offset: Offset(0, 0.2),
                ),
              ],
            ),
            child: AnimationSearchBar(
              searchFieldDecoration: BoxDecoration(
                color: Mythemes.greyishade,
                borderRadius: BorderRadius.circular(20),
              ),
              backIcon: Icons.arrow_back_ios,
              backIconColor: Mythemes.black,
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
                color: Mythemes.black,
              ),
              searchTextEditingController: searchType,
            ),
          ),
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child:
                  workDoneReportModelGlobaled!.data!.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : GetWorkDoneReports(workDoneReportModelGlobaled!),
            ),
          ],
        ),
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

class GetWorkDoneReports extends StatefulWidget {
  final WorkdoneReportModel workdoneReportModel;

  GetWorkDoneReports(this.workdoneReportModel);

  @override
  State<GetWorkDoneReports> createState() =>
      _GetWorkDoneReportsState(workdoneReportModel);
}

class _GetWorkDoneReportsState extends State<GetWorkDoneReports> {
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

  final WorkdoneReportModel workdoneReportModel;

  _GetWorkDoneReportsState(this.workdoneReportModel);

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ListView.builder(
      itemCount: foundDataNew!.length,
      itemBuilder: (context, itemCount) {
        return Card(
          child: ExpansionTile(
            //key: keyTile,
            initiallyExpanded: isExpanded,
            childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
            leading: CircleAvatar(
              backgroundColor: Mythemes.greyish,
              backgroundImage: NetworkImage(
                workDoneReportModelGlobal!.data![itemCount].image.toString(),
              ),
            ),
            title: foundDataNew![itemCount].cName.toString().text.make(),
            subtitle: foundDataNew![itemCount].date.toString().text.make(),
            children: [
              Row(
                children: [
                  Container(width: 75, child: "Mobile No :".text.make()),
                  foundDataNew![itemCount].cNumber
                      .toString()
                      .text
                      .make()
                      .px24()
                      .py4(),
                ],
              ),
              Row(
                children: [
                  Container(width: 75, child: "Email Id :".text.make()),
                  Expanded(
                    child:
                        foundDataNew![itemCount].cMailId
                            .toString()
                            .text
                            .make()
                            .px24()
                            .py2(),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(width: 75, child: "Time :".text.make()),
                  foundDataNew![itemCount].time
                      .toString()
                      .text
                      .make()
                      .px24()
                      .py2(),
                ],
              ),
              Row(
                children: [
                  Container(width: 75, child: "Location :".text.make()),
                  Expanded(
                    child:
                        foundDataNew![itemCount].cAddress
                            .toString()
                            .text
                            .make()
                            .px24()
                            .py4(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
