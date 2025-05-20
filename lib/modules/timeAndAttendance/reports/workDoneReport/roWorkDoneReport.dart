import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/workDoneReport/roWorkDoneReportModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'RoWorkDoneReportFiltering.dart';

class RoWorkDoneReport extends StatefulWidget {
   String toDatePickedStringRo;
   String fromDatePickedStringRo;
   String filterType;
   String empNewId;

   RoWorkDoneReport(

       this.toDatePickedStringRo,
       this.fromDatePickedStringRo,
       this.filterType,
       this.empNewId,
       );


  @override
  State<RoWorkDoneReport> createState() => _RoWorkDoneReportState(toDatePickedStringRo, fromDatePickedStringRo, filterType, empNewId,
      );
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNew=[];
late ROWorkdoneReportModel? roWorkDoneReportModelGlobal =
ROWorkdoneReportModel(data: []);
late ROWorkdoneReportModel? roWorkDoneReportModelGlobaled =
ROWorkdoneReportModel(data: []);

class _RoWorkDoneReportState extends State<RoWorkDoneReport> {
   String toDatePickedStringRo;
   String fromDatePickedString;
   String filterType;
   String empNewId;

  _RoWorkDoneReportState(this.fromDatePickedString, this.toDatePickedStringRo, this.filterType,this.empNewId);

  @override
  void initState() {
    getSharedPrfanceList();
    var listLength;
    listLength = foundDataNew!.length;
    print('listLength $listLength');
    print(fromDatePickedString);
    print(toDatePickedStringRo);
    print(filterType);
    print(empNewId);
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    print('ResponseAttendance: ${sessionId}');
    print('ResponseAttendance: ${fromDatePickedString}');
    print('ResponseAttendance: ${toDatePickedStringRo}');
    //await Future.delayed(Duration(seconds: 3));
    Future<ROWorkdoneReportModel> getEmployeeList11 =
        getEmployeeList(sessionId!, toDatePickedStringRo, fromDatePickedString, filterType, empNewId);
    if (getEmployeeList11 == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
        roWorkDoneReportModelGlobal = value;
        roWorkDoneReportModelGlobaled = roWorkDoneReportModelGlobal;


      });
      print('workDoneReport00${roWorkDoneReportModelGlobal!.data!.length}');

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

  Future<ROWorkdoneReportModel> getEmployeeList(
      String sessionId, String fromdate, String toDate, String filterType, String empNewId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.roWorkDoneReport;
    print('workDoneReport: ${sessionId}');
    ROWorkdoneReportModel roWorkdoneReportModel;
    //http://www.employroll.com/restful/service/get/self/mobile/task/list?sessionId=49a180fd3893b71baf3b030f39e0782d51d02cbe51a&fromdate=01-10-2022&todate=31-10-2022
    var urlapi = Uri.parse(
        "$conn$apiUrl?"
        "sessionId=$sessionId&"
            "todate=$fromdate&"
            "fromdate=$toDate&"
            "filterType=$filterType&"
            "empId=$empNewId"
    );
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    if (getData.length == 0 )  {
      print("getData111 $getData");
      showNodata(context, "Alert", "There is no data available for this date.");
    }

    roWorkdoneReportModel = ROWorkdoneReportModel.fromJson(mapResponse);

    allUsernew = roWorkdoneReportModel!.data;

    return roWorkdoneReportModel;
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

  var titleName = "Employee Work Done Report";
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
          element.cName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      results = allUsernew?.where((element) =>
          element.cMailId!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mythemes.whitish,
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
        child: Column(
          children: [
            Expanded(
                child: roWorkDoneReportModelGlobaled!.data!.isEmpty
                    ? Center(
                            child:

                            CircularProgressIndicator(),
                )
                        :
                GetWorkDoneReports(roWorkDoneReportModelGlobaled!)

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

class GetWorkDoneReports extends StatefulWidget {
  final ROWorkdoneReportModel roWorkdoneReportModel;

  GetWorkDoneReports(this.roWorkdoneReportModel);

  @override
  State<GetWorkDoneReports> createState() =>
      _GetWorkDoneReportsState(roWorkdoneReportModel);
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

  final ROWorkdoneReportModel roWorkdoneReportModel;

  _GetWorkDoneReportsState(this.roWorkdoneReportModel);

  @override
  Widget build(BuildContext context) => Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) =>
                    RoWorkDoneReport(toDatePickedStringRo,fromDatePickedStringRo, filterType, empNewIdRo),
                transitionDuration: Duration(seconds: 1),
                maintainState: true,
              ));
          return Future.value(false);
        },
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
                    backgroundImage: NetworkImage(roWorkDoneReportModelGlobal!
                        .data![itemCount].image
                        .toString()),
                  ),
                  title: foundDataNew![itemCount].empName
                      .toString()
                      .text
                      .make(),
                  subtitle: foundDataNew![itemCount].date
                      .toString()
                      .text
                      .make().px2(),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 75,
                          child: "Mobile No :".text.make(),
                        ),
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
                        Container(
                          width: 75,
                          child: "Email Id :".text.make(),
                        ),
                        Expanded(child: foundDataNew![itemCount].cMailId
                            .toString()
                            .text
                            .make()
                            .px24()
                            .py2()
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 75,
                          child: "Time :".text.make(),
                        ),
                        foundDataNew![itemCount].time
                            .toString()
                            .text
                            .make()
                            .px24()
                            .py2()
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 75,
                          child: "Location :".text.make(),
                        ),
                        Expanded(
                          child: foundDataNew![itemCount].cAddress
                              .toString()
                              .text
                              .make()
                              .px24()
                              .py4(),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
      ));
}
