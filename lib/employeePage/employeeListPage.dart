import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../../adminPage/mssDashboard.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../employeePage/liveMapView.dart';
import '../../employeePage/mapView.dart';
import '../../main.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../themes/empThemes.dart';
import '../adminPage/modelClass/dashboardModel.dart';
import 'myTeamListModal.dart';

class EmpListView extends StatefulWidget {
  const EmpListView({Key? key}) : super(key: key);

  static const String _title = 'Employee List';

  @override
  State<EmpListView> createState() => _EmpListViewState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<ListData>? allUsernew = [];
List<ListData>? foundDataNew = [];
List<DottedEmpList>? allUsernewDotted = [];
List pendingData = [];
List<SharedEmpList>? allUsernewShared = [];
List<DirectEmpList>? allUsernewDirect = [];
List<DesignatedEmpList>? allUsernewDesignated = [];
List<DottedEmpList>? foundDataNewDotted = [];
List<SharedEmpList>? foundDataNewShared = [];
List<DirectEmpList>? foundDataNewDirect = [];
List<DesignatedEmpList>? foundDataNewDesignated = [];
MyTeamsListModal? employeeListModelglobel;
MyTeamsListModal? employeeListModelglobeled;
var empName;
var empId;
String? userPanel;
dynamic getProfileId;
String? orgId;
dynamic matchedOrg;

class _EmpListViewState extends State<EmpListView> with RouteAware {
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
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    userPanel = await shared.getUserPanel();
    getProfileId = await shared.getDefaultProfileId();
    // await Future.delayed(Duration(seconds: 5));

    Future<MyTeamsListModal> getEmployeeList11 = getEmployeeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );
    getEmployeeList11.then((value) {
      setState(() {
        if (selectedFilter == "All") {
          foundDataNew = allUsernew;
        }
        if (selectedFilter == "Direct") {
          foundDataNewDirect = allUsernewDirect;
        }
        if (selectedFilter == "Dotted") {
          foundDataNewDotted = allUsernewDotted;
        }
        if (selectedFilter == "Shared") {
          foundDataNewShared = allUsernewShared;
        }
        if (selectedFilter == "Designated") {
          foundDataNewDesignated = allUsernewDesignated;
        }

        employeeListModelglobel = value;
        employeeListModelglobeled = employeeListModelglobel;
      });
      print('All LIST - ${employeeListModelglobel!.listData!.length}');
      print('Direct LIST - ${employeeListModelglobel!.directEmpList!.length}');
      print('Dotted LIST - ${employeeListModelglobel!.dottedEmpList!.length}');
      print('Shared LIST - ${employeeListModelglobel!.sharedEmpList!.length}');
      print(
        'Designated LIST - ${employeeListModelglobel!.designatedEmpList!.length}',
      );
    });
  }

  Future<MyTeamsListModal> getEmployeeList(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.myTeamListApi;

    setState(() {
      isLoading = true; // Show loader
    });

    try {
      var urlapi = Uri.parse(
        "$conn$apiUrl?"
        "sessionId=$sessionId&"
        "profileId=$getProfileId&"
        "orgId=0&"
        "userPermission=$userPanel",
      );

      final response = await MobileHttpClient.instance.post(urlapi);

      mapResponse = json.decode(response.body);

      /// âœ… Always update the main model
      employeeListModelglobel = MyTeamsListModal.fromJson(mapResponse);

      print("Employee List API - ${response.request}");
      setState(() {
        if (selectedFilter == "All") {
          allUsernew = employeeListModelglobel!.listData!;
        } else if (selectedFilter == "Dotted") {
          allUsernewDotted = employeeListModelglobel!.dottedEmpList!;
        } else if (selectedFilter == "Shared") {
          allUsernewShared = employeeListModelglobel!.sharedEmpList!;
        } else if (selectedFilter == "Direct") {
          allUsernewDirect = employeeListModelglobel!.directEmpList!;
        } else if (selectedFilter == "Designated") {
          allUsernewDesignated = employeeListModelglobel!.designatedEmpList!;
        }
      });
    } catch (e) {
      print("Error fetching employee list: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false; // Hide loader always
      });
    }

    return employeeListModelglobel!;
  }

  bool isLoading = true;
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<ListData>? resultsAll = [];
    List<SharedEmpList>? resultsShared = [];
    List<DirectEmpList>? resultsDirect = [];
    List<DottedEmpList>? resultsDotted = [];
    List<DesignatedEmpList>? resultsDesignated = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
      setState(() {
        //results = allUsernew;
        if (selectedFilter == "All") {
          resultsAll = allUsernew;
        } else if (selectedFilter == "Dotted") {
          resultsDotted = allUsernewDotted;
        } else if (selectedFilter == "Shared") {
          resultsShared = allUsernewShared;
        } else if (selectedFilter == "Direct") {
          resultsDirect = allUsernewDirect;
        } else if (selectedFilter == "Designated") {
          resultsDesignated = allUsernewDesignated;
        }
      });
    } else {
      /*results = allUsernew.where((user) =>
        user!.data!.contains(enteredKeyword.toLowerCase()))
          .toList();*/

      resultsAll =
          allUsernew
              ?.where(
                (element) => element.empName!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();

      resultsShared =
          allUsernewShared
              ?.where(
                (element) => element.empName!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();

      resultsDotted =
          allUsernewDotted
              ?.where(
                (element) => element.empName!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();

      resultsDirect =
          allUsernewDirect
              ?.where(
                (element) => element.empName!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();

      resultsDesignated =
          allUsernewDesignated
              ?.where(
                (element) => element.empName!.toLowerCase().contains(
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
      foundDataNew = resultsAll;
      foundDataNewDirect = resultsDirect;
      foundDataNewDotted = resultsDotted;
      foundDataNewDesignated = resultsDesignated;
      foundDataNewShared = resultsShared;
    });
  }

  TextEditingController searchType = TextEditingController();
  var titleName = "My Team";
  int value = 1;
  int switcherIndex1 = 0;
  int pageIndex = 0;
  int currentIndex = 2;
  var dropdownvalue;

  String selectedFilter = "All";
  Widget filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        checkmarkColor: selectedFilter == label ? Colors.white : Colors.black87,
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedFilter == label ? Colors.white : Colors.black87,
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              centerTitle: "$titleName - ${foundDataNew!.length}",
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
                builder: (context) => HomePage(selectedIndex: 0),
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
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 2),
              ),
            );
            print('Reports');
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MSSDashboard(DashboardModel()),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
            );
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
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'Reports',
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

      //floatingActionButton: getFAB(),
      /*floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, MyRoutings.exitWorkflowRoute);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Ensures circular shape
          ),
          mini: false,
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(
            Icons.add, color: Mythemes.whitish, size: 28,
          ),
        ),*/
      body: Container(
        color: Mythemes.whitish,
        child: Column(
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
                            child:
                                isLoading
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "${employeeListModelglobel!.listData!.length}"
                                        .text
                                        .bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            child:
                                isLoading
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "${employeeListModelglobel!.directEmpList!.length}"
                                        .text
                                        .bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            child:
                                isLoading
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "${employeeListModelglobel!.sharedEmpList!.length}"
                                        .text
                                        .bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            child:
                                isLoading
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "${employeeListModelglobel!.dottedEmpList!.length}"
                                        .text
                                        .bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            child:
                                isLoading
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "${employeeListModelglobel!.designatedEmpList!.length}"
                                        .text
                                        .bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : (employeeListModelglobel == null
                          ? Center(child: Text("No data found"))
                          : getMyReportings(employeeListModelglobel!)),
            ),
          ],
        ),
      ),
    );
  }

  getMyReportings(MyTeamsListModal myTeamsListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => EmpListView(),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: Column(
        children: [
          // List
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
          //Divider(thickness: 1),
          Visibility(
            visible: selectedFilter == "All",
            child: Expanded(
              child:
                  foundDataNew == null || foundDataNew!.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox, // No data icon
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Employees Available !!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: foundDataNew!.length,
                        itemBuilder: (context, index) {
                          var officer = foundDataNew![index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color:
                                        foundDataNew![index].employeeStatus ==
                                                "ACTIVE"
                                            ? Colors.green
                                            : Colors.red,
                                    width: 6, // Left colored curved border
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Employee Photo
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: Mythemes.greyish,
                                          backgroundImage:
                                              (foundDataNew![index].empPhoto !=
                                                          null &&
                                                      foundDataNew![index]
                                                          .empPhoto!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                    foundDataNew![index]
                                                        .empPhoto!,
                                                  )
                                                  : null,
                                          child:
                                              (foundDataNew![index].empPhoto ==
                                                          null ||
                                                      foundDataNew![index]
                                                          .empPhoto!
                                                          .isEmpty)
                                                  ? Icon(
                                                    Icons.person,
                                                    size: 32,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Employee details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                foundDataNew![index].empName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Type: ${foundDataNew![index].reportieeType.toString()}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "ðŸ“ž ${foundDataNew![index].empContact ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ†” ${foundDataNew![index].empCode ?? '-'}",
                                              ),
                                              Text(
                                                "âœ‰ï¸ ${foundDataNew![index].empEmailId ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ¢ ${foundDataNew![index].empDeptName ?? '-'}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trailing status text in TOP-RIGHT corner
                                  Positioned(
                                    top: 8,
                                    right: 12,
                                    child: Text(
                                      foundDataNew![index].employeeStatus ??
                                          '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            foundDataNew![index]
                                                        .employeeStatus ==
                                                    "ACTIVE"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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
              child:
                  foundDataNewDirect == null || foundDataNewDirect!.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox, // No data icon
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Employee Available !",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: foundDataNewDirect!.length,
                        itemBuilder: (context, index) {
                          var officer = foundDataNewDirect![index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color:
                                        foundDataNewDirect![index]
                                                    .employeeStatus ==
                                                "ACTIVE"
                                            ? Colors.green
                                            : Colors.red,
                                    width: 6, // Left colored curved border
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Employee Photo
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: Mythemes.greyish,
                                          backgroundImage:
                                              (foundDataNewDirect![index]
                                                              .empPhoto !=
                                                          null &&
                                                      foundDataNewDirect![index]
                                                          .empPhoto!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                    foundDataNewDirect![index]
                                                        .empPhoto!,
                                                  )
                                                  : null,
                                          child:
                                              (foundDataNewDirect![index]
                                                              .empPhoto ==
                                                          null ||
                                                      foundDataNewDirect![index]
                                                          .empPhoto!
                                                          .isEmpty)
                                                  ? Icon(
                                                    Icons.person,
                                                    size: 32,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Employee details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                foundDataNewDirect![index]
                                                    .empName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Type: ${foundDataNewDirect![index].reportieeType.toString()}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "ðŸ“ž ${foundDataNewDirect![index].empContact ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ†” ${foundDataNewDirect![index].empCode ?? '-'}",
                                              ),
                                              Text(
                                                "âœ‰ï¸ ${foundDataNewDirect![index].empEmailId ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ¢ ${foundDataNewDirect![index].empDeptName ?? '-'}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trailing status text in TOP-RIGHT corner
                                  Positioned(
                                    top: 8,
                                    right: 12,
                                    child: Text(
                                      foundDataNewDirect![index]
                                              .employeeStatus ??
                                          '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            foundDataNewDirect![index]
                                                        .employeeStatus ==
                                                    "ACTIVE"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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
              child:
                  foundDataNewDesignated == null ||
                          foundDataNewDesignated!.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox, // No data icon
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Employee Available !",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: foundDataNewDesignated!.length,
                        itemBuilder: (context, index) {
                          var officer = foundDataNewDesignated![index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color:
                                        foundDataNewDesignated![index]
                                                    .employeeStatus ==
                                                "ACTIVE"
                                            ? Colors.green
                                            : Colors.red,
                                    width: 6, // Left colored curved border
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Employee Photo
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: Mythemes.greyish,
                                          backgroundImage:
                                              (foundDataNewDesignated![index]
                                                              .empPhoto !=
                                                          null &&
                                                      foundDataNewDesignated![index]
                                                          .empPhoto!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                    foundDataNewDesignated![index]
                                                        .empPhoto!,
                                                  )
                                                  : null,
                                          child:
                                              (foundDataNewDesignated![index]
                                                              .empPhoto ==
                                                          null ||
                                                      foundDataNewDesignated![index]
                                                          .empPhoto!
                                                          .isEmpty)
                                                  ? Icon(
                                                    Icons.person,
                                                    size: 32,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Employee details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                foundDataNewDesignated![index]
                                                    .empName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Type: ${foundDataNewDesignated![index].reportieeType.toString()}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "ðŸ“ž ${foundDataNewDesignated![index].empContact ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ†” ${foundDataNewDesignated![index].empCode ?? '-'}",
                                              ),
                                              Text(
                                                "âœ‰ï¸ ${foundDataNewDesignated![index].empEmailId ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ¢ ${foundDataNewDesignated![index].empDeptName ?? '-'}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trailing status text in TOP-RIGHT corner
                                  Positioned(
                                    top: 8,
                                    right: 12,
                                    child: Text(
                                      foundDataNewDesignated![index]
                                              .employeeStatus ??
                                          '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            foundDataNewDesignated![index]
                                                        .employeeStatus ==
                                                    "ACTIVE"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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
              child:
                  foundDataNewShared == null || foundDataNewShared!.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox, // No data icon
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Employee Available !",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: foundDataNewShared!.length,
                        itemBuilder: (context, index) {
                          var officer = foundDataNewShared![index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color:
                                        foundDataNewShared![index]
                                                    .employeeStatus ==
                                                "ACTIVE"
                                            ? Colors.green
                                            : Colors.red,
                                    width: 6, // Left colored curved border
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Employee Photo
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: Mythemes.greyish,
                                          backgroundImage:
                                              (foundDataNewShared![index]
                                                              .empPhoto !=
                                                          null &&
                                                      foundDataNewShared![index]
                                                          .empPhoto!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                    foundDataNewShared![index]
                                                        .empPhoto!,
                                                  )
                                                  : null,
                                          child:
                                              (foundDataNewShared![index]
                                                              .empPhoto ==
                                                          null ||
                                                      foundDataNewShared![index]
                                                          .empPhoto!
                                                          .isEmpty)
                                                  ? Icon(
                                                    Icons.person,
                                                    size: 32,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Employee details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                foundDataNewShared![index]
                                                    .empName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Type: ${foundDataNewShared![index].reportieeType.toString()}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "ðŸ“ž ${foundDataNewShared![index].empContact ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ†” ${foundDataNewShared![index].empCode ?? '-'}",
                                              ),
                                              Text(
                                                "âœ‰ï¸ ${foundDataNewShared![index].empEmailId ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ¢ ${foundDataNewShared![index].empDeptName ?? '-'}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trailing status text in TOP-RIGHT corner
                                  Positioned(
                                    top: 8,
                                    right: 12,
                                    child: Text(
                                      foundDataNewShared![index]
                                              .employeeStatus ??
                                          '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            foundDataNewShared![index]
                                                        .employeeStatus ==
                                                    "ACTIVE"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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
              child:
                  foundDataNewDotted == null || foundDataNewDotted!.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox, // No data icon
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Employee Available !",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: foundDataNewDotted!.length,
                        itemBuilder: (context, index) {
                          var officer = foundDataNewDotted![index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color:
                                        foundDataNewDotted![index]
                                                    .employeeStatus ==
                                                "ACTIVE"
                                            ? Colors.green
                                            : Colors.red,
                                    width: 6, // Left colored curved border
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Employee Photo
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: Mythemes.greyish,
                                          backgroundImage:
                                              (foundDataNewDotted![index]
                                                              .empPhoto !=
                                                          null &&
                                                      foundDataNewDotted![index]
                                                          .empPhoto!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                    foundDataNewDotted![index]
                                                        .empPhoto!,
                                                  )
                                                  : null,
                                          child:
                                              (foundDataNewDotted![index]
                                                              .empPhoto ==
                                                          null ||
                                                      foundDataNewDotted![index]
                                                          .empPhoto!
                                                          .isEmpty)
                                                  ? Icon(
                                                    Icons.person,
                                                    size: 32,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Employee details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                foundDataNewDotted![index]
                                                    .empName
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Type: ${foundDataNewDotted![index].reportieeType.toString()}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "ðŸ“ž ${foundDataNewDotted![index].empContact ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ†” ${foundDataNewDotted![index].empCode ?? '-'}",
                                              ),
                                              Text(
                                                "âœ‰ï¸ ${foundDataNewDotted![index].empEmailId ?? '-'}",
                                              ),
                                              Text(
                                                "ðŸ¢ ${foundDataNewDotted![index].empDeptName ?? '-'}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trailing status text in TOP-RIGHT corner
                                  Positioned(
                                    top: 8,
                                    right: 12,
                                    child: Text(
                                      foundDataNewDotted![index]
                                              .employeeStatus ??
                                          '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            foundDataNewDotted![index]
                                                        .employeeStatus ==
                                                    "ACTIVE"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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

  Widget getFAB() {
    return FloatingActionButton.extended(
      tooltip: "Go to Exit List",
      onPressed: () {
        Navigator.pushNamed(context, MyRoutings.exitEmpListRoute);
      },
      backgroundColor: Mythemes.lightBluishColor,
      icon: Icon(Icons.not_interested, color: Mythemes.whitish),
      label: Text('Go to Exit List', style: TextStyle(color: Mythemes.whitish)),
    ).py0();
  }
}

class MyStatelessWidget extends StatefulWidget {
  final MyTeamsListModal employeeListModel;

  MyStatelessWidget(this.employeeListModel);
  @override
  State<MyStatelessWidget> createState() =>
      _MyStatelessWidgetState(employeeListModel);
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final MyTeamsListModal employeeListModel;
  _MyStatelessWidgetState(this.employeeListModel);

  var status;
  var stepOne;
  var stepTwo;
  var stepThree;
  var stepFour;
  var stepFive;

  @override
  Widget build(BuildContext context) {
    showTrackDialog(BuildContext buildContext, result, alert) {
      var alertDialog = AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        title: Row(
          children: [
            //Icon(Icons.warning),
            Expanded(child: Text(alert, style: TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(result, style: TextStyle(fontSize: 14)),
        titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        actions: [
          TextButton(
            onPressed: () {
              /*for(int i=0; i<employeeListModel!.data!.length;i++){
                  setState(() {
                    empId;
                    empName;

                    print('id $empId');
                    print('name $empName');
                  });

                }*/
              //print('emPI $empId');
              //print('emName $empName');
              print("Emp list clicked");
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HistoryMapView(empName, empId),
                ),
              );

              //Navigator.pop(buildContext);
            },
            child: Container(
              child: Text(
                "History",
                style: TextStyle(color: Mythemes.dangerColor),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LiveMapView(empName, empId),
                ),
              );
            },
            child: Container(
              child: Text(
                "Live",
                style: TextStyle(color: Mythemes.lightBluishColor),
              ),
            ),
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

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: foundDataNew!.length,
      itemBuilder: (context, i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              empId = foundDataNew![i].empDetId;
              empName = foundDataNew![i].empName;
              print('ID $empId');
              print('NameCheck $empName');
              //Navigator.pushNamed(context, MyRoutings.hdRaisedTicketReplyRoute);
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Mythemes.greyish,
                          backgroundImage: NetworkImage(
                            foundDataNew![i].empPhoto ?? "",
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                foundDataNew![i].empName ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "ðŸ“ž ${foundDataNew![i].empContact ?? '-'}",
                              ),
                              Text("ðŸ†”${foundDataNew![i].empDetId ?? '-'}"),
                              Text(
                                "âœ‰ï¸ ${foundDataNew![i].empEmailId ?? '-'}",
                              ),
                              Text(
                                "ðŸ¢ ${foundDataNew![i].empDeptName ?? '-'}",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              "${foundDataNew![i].reportieeType}".text.bold
                                  .color(Mythemes.lightBluishColor)
                                  .make()
                                  .px4(),
                            ],
                          ),
                        ),
                        /* Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    empId = foundDataNew![i].empdetailsId;
                                    empName = foundDataNew![i].empName;
                                    print('emID $empId');
                                    print('name $empName');
                                    print("Emp list clicked");
                                  });

                                  showTrackDialog(
                                      context, "How do you want to see tracking?".toString() + " " , "Tracking Location");
                                },
                                icon: Icon(
                                  Icons.location_on,
                                  size: 28.0, color: Mythemes.lightBluishColor,
                                ),
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    /*ListView.builder(
      padding: EdgeInsets.all(6.0),
      itemCount: employeeListModel!.data!.length,
      itemBuilder: (context,i) {
        return SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  empId = employeeListModel!.data![i].empId;
                  print('emPID $empId');
                },
                child: Card(
                  child: CustomListItemTwo(
                    thumbnail: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 9),
                        child: CircleAvatar(
                          backgroundColor: Mythemes.greyish,
                          maxRadius: 40,
                          minRadius: 40,
                          backgroundImage: NetworkImage(employeeListModel.data![i].empPhoto!),
                        ),
                      ),
                    ),

                    title: employeeListModel.data![i].empName as String,
                    subtitle: employeeListModel.data![i].empContactNo as String,
                    author: employeeListModel.data![i].empEmail as String,
                  ),
                ),
              ),
            ],
          ),
        );
      },

    );*/
  }
}
