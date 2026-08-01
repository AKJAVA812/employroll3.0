import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../../adminPage/modelClass/dashboardModel.dart';
import '../../adminPage/mssDashboard.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../employeePage/employeeListModel.dart';
import '../../employeePage/liveMapView.dart';
import '../../employeePage/mapView.dart';
import '../../main.dart';
import '../../modules/exitManagement/exitWorkflow.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../themes/empThemes.dart';

class ExitListViewMO extends StatefulWidget {
  const ExitListViewMO({Key? key}) : super(key: key);

  static const String _title = 'Employee List';

  @override
  State<ExitListViewMO> createState() => _ExitListViewMOState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<Data>? allUsernew = [];
List<Data>? foundDataNewMO = [];
EmployeeListModel? employeeListModelglobel;
EmployeeListModel? employeeListModelglobeled;
var empName;
var empId;
String? userPanel;
dynamic getProfileId;
String? orgId;
dynamic matchedOrg;

class _ExitListViewMOState extends State<ExitListViewMO> with RouteAware {
  /*@override
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
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    getProfileId = await shared!.getDefaultProfileId();
    // await Future.delayed(Duration(seconds: 5));
    Future<EmployeeListModel> getEmployeeList11 = getEmployeeList(sessionId!);
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
        employeeListModelglobel=value;
        employeeListModelglobeled=employeeListModelglobel;
      });
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });
  }*/
  bool _isFirstBuild = true;
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    // DO NOT use `context` here
    // Move `getSharedPrfanceList()` to `didChangeDependencies`
  }

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
      storedOrgList =
          decoded.map((item) => Map<String, dynamic>.from(item)).toList();

      // Populate dropdown list
      organizations =
          storedOrgList.map((e) => e['orgName'].toString()).toList();

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

  void _showFilterBottomSheet() {
    if (_isBottomSheetOpen) return; // âœ… Prevent multiple opens
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                          return DropdownMenuItem(value: org, child: Text(org));
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
                            employeeListModelglobeled = null;
                            isLoading = true;
                          });

                          sessionId = await shared!.getSessionId();
                          userPanel = await shared!.getUserPanel();
                          getProfileId = await shared!.getDefaultProfileId();
                          getOrgId = matchedOrg['id']?.toString() ?? '';
                          print("ORG ID - $getOrgId");
                          try {
                            final value = await getEmployeeList(sessionId!);

                            setState(() {
                              foundDataNewMO = allUsernew;
                              employeeListModelglobel = value;
                              employeeListModelglobeled =
                                  employeeListModelglobel;
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
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isBottomSheetOpen = false; // âœ… Reset when sheet is dismissed
    });
  }

  Future<EmployeeListModel> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.getEmpList;
    print('employeeList11: ${SessionId}');
    EmployeeListModel employeeListModel;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "profileId=$getProfileId&"
      "orgId=$getOrgId&"
      "userPermission=$userPanel",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');
    print('emp list api - ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel = EmployeeListModel.fromJson(mapResponse);
    allUsernew = employeeListModel.data;

    return employeeListModel;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>? results = [];

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
      foundDataNewMO = results;
    });
  }

  TextEditingController searchType = TextEditingController();
  var titleName = "Choose Employee";
  int value = 1;
  int switcherIndex1 = 0;
  int pageIndex = 0;
  int currentIndex = 2;
  var dropdownvalue;
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
              centerTitle: "$titleName - ${foundDataNewMO!.length}",
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
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Exit List');
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
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Exit'),
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
      floatingActionButton: getFAB(),
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

      /*body: Container(
          color: Mythemes.whitish,
          child: Column(
            children: [
              Expanded(child: employeeListModelglobeled == null ?
              Center(child: CircularProgressIndicator()): MyStatelessWidget(employeeListModelglobeled!)),
            ],
          ),
        )*/
      body: Container(
        padding: EdgeInsets.all(8.0),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Expanded(
                      child:
                          employeeListModelglobeled == null
                              ? Center(
                                child:
                                    "Please select Organisation first!"
                                        .text
                                        .bold
                                        .center
                                        .make(),
                              )
                              : MyStatelessWidget(employeeListModelglobeled!),
                    ),
                  ],
                ),
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
  final EmployeeListModel employeeListModel;

  MyStatelessWidget(this.employeeListModel);
  @override
  State<MyStatelessWidget> createState() =>
      _MyStatelessWidgetState(employeeListModel);
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final EmployeeListModel employeeListModel;
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
      itemCount: foundDataNewMO!.length,
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
              empId = foundDataNewMO![i].empdetailsId;
              empName = foundDataNewMO![i].empName;
              print('ID $empId');
              print('NameCheck $empName');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExitWorkflow(empId, empName),
                ),
              );
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
                            foundDataNewMO![i].empPhoto ?? "",
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                foundDataNewMO![i].empName ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "ðŸ“ž ${foundDataNewMO![i].empContactNo ?? '-'}",
                              ),
                              Text("ðŸ†”${foundDataNewMO![i].empId ?? '-'}"),
                              Text(
                                "âœ‰ï¸ ${foundDataNewMO![i].empEmail ?? '-'}",
                              ),
                              Text("ðŸ¢ ${foundDataNewMO![i].empDept ?? '-'}"),
                            ],
                          ),
                        ),
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
