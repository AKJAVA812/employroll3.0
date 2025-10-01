import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../commanScreen/allAPIList.dart';
import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../main.dart';
import '../profiles/profilePageWithHead.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../themes/empThemes.dart';
import 'EssDashboarrddModel.dart';
import 'Model/myManagersModalList.dart';
import 'essDashboardNavigate.dart';
import 'package:velocity_x/velocity_x.dart';
class ReportingOfficersPage extends StatefulWidget {
  @override
  _ReportingOfficersPageState createState() => _ReportingOfficersPageState();
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<ListData>? allUsernew=[];
List<ListData>? foundDataNew=[];
List<DottedEmpList>? allUsernewDotted=[];
List pendingData =[];
List<SharedEmpList>? allUsernewShared=[];
List<DirectEmpList>? allUsernewDirect=[];
List<DesignatedEmpList>? allUsernewDesignated=[];
List<DottedEmpList>? foundDataNewDotted=[];
List<SharedEmpList>? foundDataNewShared=[];
List<DirectEmpList>? foundDataNewDirect=[];
List<DesignatedEmpList>? foundDataNewDesignated=[];

MyManagersModalList? myManagersModalListLabel;
MyManagersModalList? myManagersModalListLabeled;
int valueChange = 0;
class _ReportingOfficersPageState extends State<ReportingOfficersPage> with RouteAware{
  String selectedFilter = "Direct";

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

    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }

  @override
  void didUpdateWidget(covariant ReportingOfficersPage oldWidget) {
    //getSharedPrfanceList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<MyManagersModalList> getEmployeeList11 = getMyReportingOfficersList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        if(selectedFilter == "All") {
          foundDataNew = allUsernew;
        } if(selectedFilter == "Dotted") {
          foundDataNewDotted = allUsernewDotted;
        } if(selectedFilter == "Shared") {
          foundDataNewShared = allUsernewShared;
        } if(selectedFilter == "Direct") {
          foundDataNewDirect = allUsernewDirect;
        }if(selectedFilter == "Designated") {
          foundDataNewDesignated = allUsernewDesignated;
        }

        myManagersModalListLabel=value;
        myManagersModalListLabeled=myManagersModalListLabel;
      });
      print('All LIST - ${myManagersModalListLabel!.listData!.length}');
      print('Dotted LIST - ${myManagersModalListLabel!.dottedEmpList!.length}');
      print('Shared LIST - ${myManagersModalListLabel!.sharedEmpList!.length}');
      print('Direct LIST - ${myManagersModalListLabel!.directEmpList!.length}');
      print('Designated LIST - ${myManagersModalListLabel!.designatedEmpList!.length}');
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

  bool isLoading = false;
  bool isLoadingCount = true;

  Future<MyManagersModalList> getMyReportingOfficersList(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.myManagersApi;

    print('employeeList11: $sessionId');

    setState(() {
      isLoadingCount = true; // ✅ Start loader before API
    });

    try {
      var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
      final response = await http.post(urlapi);

      print('responseemployeeList ${response.body}');
      print('URL ${response.request}');

      mapResponse = json.decode(response.body);
      print('responseemployeeList $mapResponse');

      var getData = mapResponse.length;
      if (getData == 0) {
        print("getData111 $getData");
        showNodata(context, "Oops", "There is no any requisition.");
      }

      MyManagersModalList myManagersModalList = MyManagersModalList.fromJson(mapResponse);
      print("mymanger ${myManagersModalList.listData}");
      // Assign data based on selected filter
      if (selectedFilter == "All") {
        allUsernew = myManagersModalList.listData!;
      } else if (selectedFilter == "Dotted") {
        allUsernewDotted = myManagersModalList.dottedEmpList!;
      } else if (selectedFilter == "Shared") {
        allUsernewShared = myManagersModalList.sharedEmpList!;
      } else if (selectedFilter == "Direct") {
        allUsernewDirect = myManagersModalList.directEmpList!;
      } else if (selectedFilter == "Designated") {
        allUsernewDesignated = myManagersModalList.designatedEmpList!;
      }

      return myManagersModalList;
    } catch (e) {
      print("Error fetching reporting officers: $e");
      rethrow;
    } finally {
      setState(() {
        isLoadingCount = false; // ✅ Always stop loader
      });
    }
  }


  final List<Map<String, String>> officers = [
    {
      "name": "Rajesh Kumar",
      "type": "Direct",
      "level": "Level 1",
    },
    {
      "name": "Anita Sharma",
      "type": "Dotted",
      "level": "Level 2",
    },
    {
      "name": "Vikram Singh",
      "type": "Designated",
      "level": "Level 1",
    },
    {
      "name": "Priya Mehta",
      "type": "Shared",
      "level": "Level 3",
    },
  ];

  List<Map<String, String>> get filteredOfficers {
    if (selectedFilter == "All") return officers;
    return officers.where((o) => o["type"] == selectedFilter).toList();
  }
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reporting Officers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //backgroundColor: Colors.deepPurple,
        elevation: 3,
      ),
      /*body: Column(
        children: [
          // Filter buttons
          Container(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip("All"),
                  filterChip("Direct"),
                  filterChip("Designated"),
                  filterChip("Shared"),
                  filterChip("Dotted"),
                ],
              ),
            ),
          ),
          Divider(thickness: 1),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: filteredOfficers.length,
              itemBuilder: (context, index) {
                var officer = filteredOfficers[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(
                      officer["name"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type: ${officer["type"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple),
                        ),
                        SizedBox(height: 4),
                        Text(
                          officer["level"]!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Icon(Icons.person, color: Colors.deepPurple),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),*/

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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel()))
            );
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

      body: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(6.0),
            crossAxisCount: 5,
            children: <Widget>[
              Hero(
                tag: 'nrCount',
                child: Card(
                  color: Mythemes.alertColor,
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, MyRoutings.inductionListRoute);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Center(
                          child: isLoadingCount
                              ? CircularProgressIndicator(color: Mythemes.whitish) // Loader when fetching data
                              :"${myManagersModalListLabel!.listData!.length}".text.bold.color(Mythemes.whitish).size(16).make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 30, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 5),
                            child: Text(
                              'Total',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:
                              TextStyle(color: Mythemes.whitish, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'WR',
                child: Card(
                  color: Mythemes.lightBluishColor,
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, MyRoutings.inductionListRoute);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Center(
                          child: isLoadingCount
                              ? CircularProgressIndicator(color: Mythemes.whitish) // Loader when fetching data
                              :"${myManagersModalListLabel!.directEmpList!.length}".text.bold.color(Mythemes.whitish).size(16).make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Direct',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:
                              TextStyle(color: Mythemes.whitish, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'AP',
                child: Card(
                  color: Mythemes.warningColor,
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, MyRoutings.inductionListRoute);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: isLoadingCount
                              ? CircularProgressIndicator(color: Mythemes.whitish) // Loader when fetching data
                              :"${myManagersModalListLabel!.sharedEmpList!.length}".text.bold.color(Mythemes.whitish).size(16).make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Shared',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:
                              TextStyle(color: Mythemes.whitish, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'PR',
                child: Card(
                  color: Mythemes.successColor,
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, MyRoutings.inductionListRoute);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: isLoadingCount
                              ? CircularProgressIndicator(color: Mythemes.whitish) // Loader when fetching data
                              :"${myManagersModalListLabel!.dottedEmpList!.length}".text.bold.color(Mythemes.whitish).size(16).make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Dotted',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:
                              TextStyle(color: Mythemes.whitish, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Hero(
                tag: 'Designated',
                child: Card(
                  color: Mythemes.lightBluishColor,
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, MyRoutings.inductionListRoute);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: isLoadingCount
                              ? CircularProgressIndicator(color: Mythemes.whitish) // Loader when fetching data
                              :"${myManagersModalListLabel!.designatedEmpList!.length}".text.bold.color(Mythemes.whitish).size(16).make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Assigned',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:
                              TextStyle(color: Mythemes.whitish, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),

          Expanded(
            child: isLoadingCount
                ? Center(child: CircularProgressIndicator()) // Show loader
                : myManagersModalListLabeled == null
                ? Center(child: Text("No Data Available"))
                : getMyReportings(myManagersModalListLabeled!),
          ),
        ],
      ),
    );
  }

  getMyReportings(MyManagersModalList myManagersModalList) {
    return RefreshIndicator(
        onRefresh: () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) =>
                ReportingOfficersPage(),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ));
      return Future.value(false);
    },
      child: Column(
        children: [
          // Filter buttons
          Container(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip("All"),
                  filterChip("Direct"),
                  filterChip("Shared"),
                  filterChip("Dotted"),
                  filterChip("Designated"),
                ],
              ),
            ),
          ),
          Divider(thickness: 1),

          // List

          Visibility(
            visible: selectedFilter == "All",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNew!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNew![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        foundDataNew![index].reportingOfficerName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${ foundDataNew![index].reportieeType.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNew![index].profileName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Direct",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewDirect!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewDirect![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        foundDataNewDirect![index].reportingOfficerName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${ foundDataNewDirect![index].reportieeType.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewDirect![index].profileName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Designated",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewDesignated!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewDesignated![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        foundDataNewDesignated![index].reportingOfficerName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${ foundDataNewDesignated![index].reportieeType.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewDesignated![index].profileName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Shared",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewShared!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewShared![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        foundDataNewShared![index].reportingOfficerName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${ foundDataNewShared![index].reportieeType.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewShared![index].profileName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Dotted",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewDotted!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewDotted![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        foundDataNewDotted![index].reportingOfficerName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${ foundDataNewDotted![index].reportieeType.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewDotted![index].profileName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        checkmarkColor: selectedFilter == label ? Colors.white : Colors.black87,
        label: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedFilter == label ? Colors.white : Colors.black87,
            )),
        selected: selectedFilter == label,
        selectedColor: Colors.deepPurple,
        onSelected: (val) {
          setState(() {
            selectedFilter = label;
            getSharedPrfanceList();
            print("Selected Filter - $selectedFilter");
          });
        },
      ),
    );
  }
}