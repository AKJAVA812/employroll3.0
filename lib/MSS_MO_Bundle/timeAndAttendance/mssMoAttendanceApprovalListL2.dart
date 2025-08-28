import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/pendingRequisition/pendingReqAppDiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'moPendingReqAppDIssL2.dart';



class MSS_MO_Att_PendingRequisitionL2 extends StatefulWidget {
  final PendingRequisitionModel pendingRequisitionModel;
  MSS_MO_Att_PendingRequisitionL2 (this.pendingRequisitionModel);

  @override
  State<MSS_MO_Att_PendingRequisitionL2> createState() => _MSS_MO_Att_PendingRequisitionL2State(pendingRequisitionModel);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNewMO=[];
PendingRequisitionModel? pendingRequisitionLabel;
PendingRequisitionModel? pendingRequisitionLabeled;
String? levelOne;
String? levelTwo;
String? userPanel;
dynamic getProfileId;
String? orgId;
dynamic matchedOrg;
class _MSS_MO_Att_PendingRequisitionL2State extends State<MSS_MO_Att_PendingRequisitionL2> with RouteAware{
  final PendingRequisitionModel pendingRequisitionModel;
  _MSS_MO_Att_PendingRequisitionL2State(this.pendingRequisitionModel);
  bool _isFirstBuild = true;
  bool _isBottomSheetOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstBuild) {
      _isFirstBuild = false;
      routeObserver.subscribe(this, ModalRoute.of(context)!);

      // Defer execution until after current build frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getSharedPrfanceList(); // Safe to call here
      });
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when returning to this page
    getSharedPrfanceList(); // Reload and open filter bottom sheet again
    super.didPopNext();
  }

  List<Map<String, dynamic>> storedOrgList = [];
  List<String> organizations = []; // for Dropdown values
  String? selectedOrg;
  dynamic getOrgId;

  Future<void> loadOrgListFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? orgListString = prefs.getString("orgList");

    if (orgListString != null) {
      List<dynamic> decoded = json.decode(orgListString);
      storedOrgList = decoded.map((item) => Map<String, dynamic>.from(item)).toList();

      // Populate dropdown list
      organizations = storedOrgList.map((e) => e['orgName'].toString()).toList();

      // Start with "Select" as default (null value)
      //selectedOrg = null;
      //getOrgId = '';

      setState(() {});
    }
  }
  bool isLoading = false;

  Future getSharedPrfanceList() async {
    if (!_isBottomSheetOpen) {
      await Future.delayed(Duration(milliseconds: 100));
      _showFilterBottomSheet();
    }
    loadOrgListFromPrefs();
  }

  @override
  void initState() {
    super.initState();
    // DO NOT use `context` here
    // Move `getSharedPrfanceList()` to `didChangeDependencies`
  }

/*  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNewMO!.length;
      print('listLength $listLength');
    });

  }*/

  void _showFilterBottomSheet() {
    if (_isBottomSheetOpen) return; // ✅ Prevent multiple opens
    _isBottomSheetOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // <--- Make sure this is true
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      'Filter',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    /// Organization Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Organization',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedOrg,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Select'),
                        ),
                        ...organizations.map((org) {
                          return DropdownMenuItem(
                            value: org,
                            child: Text(org),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedOrg = value;

                          // Match selected org name to get ID
                          matchedOrg = storedOrgList.firstWhere(
                                (org) => org['orgName'] == value,
                            orElse: () => {},
                          );

                          getOrgId = matchedOrg['id']?.toString() ?? '';
                          print('Org Name: $selectedOrg');
                          print('Org ID: $getOrgId');
                        });

                        setModalState(() {});
                      },
                    ),
                    SizedBox(height: 50),

                    /// Filter Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.of(bottomSheetContext).pop();
                          await Future.delayed(Duration(milliseconds: 100));

                          // Now perform async logic
                          setState(() {
                            pendingRequisitionLabeled = null;
                            isLoading = true;
                          });

                          sessionId = await shared!.getSessionId();
                          userPanel = await shared!.getUserPanel();
                          getProfileId = await shared!.getDefaultProfileId();
                          levelOne = await shared!.getLevelOne();
                          levelTwo = await shared!.getLevelTwo();
                          print("Level 1 - $levelOne");
                          print("Level 2 - $levelTwo");
                          getOrgId = matchedOrg['id']?.toString() ?? '';
                          print("ORG ID - $getOrgId");
                          try {
                            final value = await getPendingReqList(sessionId!);

                            setState(() {
                              foundDataNewMO = allUsernew;
                              pendingRequisitionLabel = value;
                              pendingRequisitionLabeled = value;
                              isLoading = false;
                            });

                            print('employeeList00: ${value.data?.length}');
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print('Error while fetching requisitions: $e');
                          }
                        },
                        icon: Icon(Icons.filter_alt),
                        label: Text("Apply Filter"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Mythemes.successColor,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isBottomSheetOpen = false; // ✅ Reset when sheet is dismissed
    });
  }


  /* Future getSharedPrfanceList() async {

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
        foundDataNewMO = allUsernew;
        pendingRequisitionLabel=value;
        pendingRequisitionLabeled=pendingRequisitionLabel;
      });
      print('employeeList00${pendingRequisitionLabel!.data!.length}');
    });
  }*/

  var levelChange = "PENDING";

  Future<PendingRequisitionModel> getPendingReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingReqListRo;
    print('employeeList11: ${SessionId}');
    PendingRequisitionModel pendingRequisitionModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "userPermission=$userPanel&"
        "profileId=$getProfileId&"
        "orgId=$getOrgId&"
        "status=$levelChange");

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
      foundDataNewMO = results;
    });
  }

  int pageIndex = 0;
  int currentIndex = 1;
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

      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        child: Icon(Icons.filter_list, color: Mythemes.whitish,),
      ),
      body:  Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
              visible: levelOne == "1",
              child: Row(
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
                      final text = const ['Level 1', 'Level 2'][local.index];
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
                        levelChange = "LEVEL_ONE_PENDING";
                        Navigator.pushNamed(context, MyRoutings.mssMOPendingAttReqL1);
                        //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                      }
                      if(value == 1) {
                        levelChange = "LEVEL_TWO_PENDING";
                        Navigator.pushNamed(context, MyRoutings.mssMOPendingAttReqL2);
                        //Navigator.pushNamed(context, MyRoutings.mssLevelOnePendingReqRoute);
                      }
                    },
                  )
                ],
              ).py(6),
            ),
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
                MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0,)));
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
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            Navigator.pop(context);
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
                  MSS_MO_Att_PendingRequisitionL2(PendingRequisitionModel()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
          itemCount: foundDataNewMO!.length,
          itemBuilder: (context, itemCount) {
            return  Column(
              children: [
                // if (_isVisible)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      print(foundDataNewMO!.length);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MO_AttendanceApprovalPageL2(pendingRequisitionModel, itemCount)));
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    title: foundDataNewMO![itemCount].empName.toString().text.bold.xl.make(),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        foundDataNewMO![itemCount].onDate
                            .toString()
                            .text
                            .sm
                            .color(Colors.grey.shade700)
                            .make(),
                      ],
                    ),
                    trailing: Icon(
                      CupertinoIcons.chevron_forward,
                      color: Colors.grey.shade600,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                )
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
