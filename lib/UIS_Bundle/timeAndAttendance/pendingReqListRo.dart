import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/pendingRequisition/pendingReqAppDiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';



class UIS_PendingRequisitionRo extends StatefulWidget {
  final PendingRequisitionModel pendingRequisitionModel;
  UIS_PendingRequisitionRo (this.pendingRequisitionModel);

  @override
  State<UIS_PendingRequisitionRo> createState() => _UIS_PendingRequisitionRoState(pendingRequisitionModel);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNewUIS=[];
PendingRequisitionModel? pendingRequisitionLabel;
PendingRequisitionModel? pendingRequisitionLabeled;

String? userPanel;
dynamic getProfileId;
String? orgId;

class _UIS_PendingRequisitionRoState extends State<UIS_PendingRequisitionRo> with RouteAware{
  final PendingRequisitionModel pendingRequisitionModel;
  _UIS_PendingRequisitionRoState(this.pendingRequisitionModel);

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
      listLength = foundDataNewUIS!.length;
      print('listLength $listLength');
    });

  }


  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    getProfileId = await shared!.getDefaultProfileId();
    // await Future.delayed(Duration(seconds: 5));
    Future<PendingRequisitionModel> getEmployeeList11 = getPendingReqList(sessionId!);
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
        pendingRequisitionLabel=value;
        pendingRequisitionLabeled=pendingRequisitionLabel;
      });
      print('employeeList00${pendingRequisitionLabel!.data!.length}');
    });
  }

  Future<PendingRequisitionModel> getPendingReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingReqListRo;
    print('employeeList11: ${SessionId}');
    PendingRequisitionModel pendingRequisitionModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "userPermission=$userPanel&"
        "profileId=$getProfileId&"
        "orgId=0");

    final response = await http.post(urlapi);

    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    pendingRequisitionModel=PendingRequisitionModel.fromJson(mapResponse);

    allUsernew = pendingRequisitionModel!.data;

    return pendingRequisitionModel;
  }
  var titleName = "Pending Requisition List";

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
          element.empName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
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

  int pageIndex = 0;
  int currentIndex = 1;

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
                textStyle: TextStyle(fontSize: 14),
                onChanged: (value) {
                  _runFilter(value);
                },
                horizontalPadding: 8,
                searchIconColor: Mythemes.black,
                centerTitle: "$titleName ${foundDataNewUIS!.length}",
                verticalPadding: 3,
                centerTitleStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Mythemes.black),
                searchTextEditingController: searchType),
          ),
        ),
      ),
      body:  Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: pendingRequisitionLabeled == null ?
                Center(
                    child: CircularProgressIndicator()):
                getPendingRequisitionRo(pendingRequisitionLabeled!)),
          ],
        ),
      ) ,

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
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
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
            icon: Icon(Icons.pending_actions),
            label: 'Attendance',
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

  getPendingRequisitionRo(PendingRequisitionModel pendingRequisitionModel){
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  UIS_PendingRequisitionRo(PendingRequisitionModel()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
          itemCount: foundDataNewUIS!.length,
          itemBuilder: (context, itemCount) {
            return  Column(
              children: [
                // if (_isVisible)
                Card(
                  elevation: 3,
                  child:
                  ListTile(
                    onTap: () {
                      print(foundDataNewUIS!.length);
                      //Navigator.pushNamed(context, MyRoutings.approveDisapproveReqRoute);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          ApproveDisapproveReq(pendingRequisitionModel,itemCount)));
                    },
                    title: foundDataNewUIS![itemCount].empName.toString().text.make(),
                    subtitle: foundDataNewUIS![itemCount].onDate.toString().text.make(),
                    trailing:  Icon(
                        CupertinoIcons.chevron_forward
                    ),
                  ),
                ),
              ],
            );
          }),
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

/*class ApprDisapprovedReq extends StatefulWidget {
  final PendingRequisitionModel pendingRequisitionModel;
  ApprDisapprovedReq (this.pendingRequisitionModel);

  @override
  State<ApprDisapprovedReq> createState() => _ApprDisapprovedReqState(pendingRequisitionModel);
}

class _ApprDisapprovedReqState extends State<ApprDisapprovedReq> {
  final PendingRequisitionModel pendingRequisitionModel;
  _ApprDisapprovedReqState(this.pendingRequisitionModel);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: pendingRequisitionModel!.data!.length,
        itemBuilder: (context, itemCount) {
      return  Column(
        children: [
          // if (_isVisible)
          Card(
            elevation: 3,
            child:
            ListTile(
              onTap: () {
                //Navigator.pushNamed(context, MyRoutings.approveDisapproveReqRoute);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    ApproveDisapproveReq(pendingRequisitionModel,itemCount)));
              },
              title: pendingRequisitionModel.data![itemCount].empName.toString().text.make(),
              subtitle: pendingRequisitionModel.data![itemCount].onDate.toString().text.make(),
              trailing:  Icon(
                  CupertinoIcons.chevron_forward
              ),
            ),
          ),
        ],
      );
    });
  }
}*/
