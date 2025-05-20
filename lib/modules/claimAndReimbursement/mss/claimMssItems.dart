import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../main.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../themes/empThemes.dart';
import '../newModalClasses/claimMssListModal.dart';
import 'claimMssApprovalPage.dart';

class ClaimMSSItemsList extends StatefulWidget {
  const ClaimMSSItemsList({Key? key}) : super(key: key);

  static const String _title = 'Employee List';

  @override
  State<ClaimMSSItemsList> createState() => _ClaimMSSItemsListState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? claimLevelOne;
String? claimLevelTwo;
String? claimLevelThree;
bool isLoading = true;
bool isLoadingCount = true;
dynamic totalDraftAmt;
dynamic totalDisApproved;
dynamic totalApprovedAmt;
dynamic totalPendingAmt;
var permissionId = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
var lOne = false;
var lTwo = false;
var lThree = false;

List<Data>? allUsernew=[];
List<Data>? foundDataNew=[];
ClaimApproverListModalClass? claimApproverListModalGlobal;
ClaimApproverListModalClass? claimApproverListModalGlobaled;
var empName;
var empId;
var empIdSend;
dynamic levelStatusCheck;
var statusUpdate = "LEVEL_ONE_PENDING";
dynamic MyColor;
class _ClaimMSSItemsListState extends State<ClaimMSSItemsList> with RouteAware{
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
      setApprovalLevel();
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }



  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    claimLevelOne = await shared!.getClaimLevelOne();
    claimLevelTwo = await shared!.getClaimLevelTwo();
    claimLevelThree = await shared!.getClaimLevelThree();

    /*if(claimLevelOne == "CLAIM_APPROVAL_LEVEL_ONE_VIEW") {
      permissionId = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
      statusUpdate = "LEVEL_ONE_PENDING";
    }
    if(claimLevelOne == "CLAIM_APPROVAL_LEVEL_TWO_VIEW") {
      permissionId = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
      statusUpdate = "LEVEL_TWO_PENDING";
    }
    if(claimLevelOne == "CLAIM_APPROVAL_LEVEL_THREE_VIEW") {
      permissionId = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
      statusUpdate = "LEVEL_THREE_PENDING";
    }*/
    print("Claim L1 $claimLevelOne");
    print("Claim L2 $claimLevelTwo");
    print("Claim L3 $claimLevelThree");
    print("Status $statusUpdate");


   /* lOne = claimLevelOne == "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
    lTwo = claimLevelTwo == "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
    lThree = claimLevelThree == "CLAIM_APPROVAL_LEVEL_THREE_VIEW";

// Ensure higher levels include lower levels
    if (lThree) {
      lOne = true;
      lTwo = true;
    } else if (lTwo) {
      lOne = true;
    }*/

    /*if(claimLevelOne == "CLAIM_APPROVAL_LEVEL_ONE_VIEW") {
      lOne = true;
      lTwo = false;
      lThree = false;
    }
    if(claimLevelOne == "CLAIM_APPROVAL_LEVEL_ONE_VIEW" || claimLevelTwo == "CLAIM_APPROVAL_LEVEL_TWO_VIEW") {
      lOne = true;
      lTwo = true;
      lThree = false;
    }
    if(claimLevelOne == "CLAIM_APPROVAL_LEVEL_ONE_VIEW" || claimLevelTwo == "CLAIM_APPROVAL_LEVEL_TWO_VIEW" || claimLevelThree == "CLAIM_APPROVAL_LEVEL_THREE_VIEW") {
      lOne = true;
      lTwo = true;
      lThree = true;
    }*/
    // await Future.delayed(Duration(seconds: 5));
    Future<ClaimApproverListModalClass> getEmployeeList11 = getEmployeeList(sessionId!);
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
        claimApproverListModalGlobal=value;
        claimApproverListModalGlobaled=claimApproverListModalGlobal;
        isLoading = false;
      });
      print('employeeList00${claimApproverListModalGlobal!.data!.length}');
    });
  }

  int approvalLevel = 0; // 0: Level 1, 1: Level 2, 2: Level 3

  void setApprovalLevel() {
    if (claimLevelThree == "CLAIM_APPROVAL_LEVEL_THREE_VIEW") {
      approvalLevel = 2;
    } else if (claimLevelTwo == "CLAIM_APPROVAL_LEVEL_TWO_VIEW") {
      approvalLevel = 1;
    } else if (claimLevelOne == "CLAIM_APPROVAL_LEVEL_ONE_VIEW") {
      approvalLevel = 0;
    }
  }

  Future<ClaimApproverListModalClass> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.claimApproveListApi;
    print('employeeList11: ${SessionId}');
    ClaimApproverListModalClass employeeListModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "permissionId=$permissionId&"
        "status=$statusUpdate");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');
    setState(() {
      isLoadingCount = true;
      isLoading = true;
    });
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel=ClaimApproverListModalClass.fromJson(mapResponse);
    totalDraftAmt = employeeListModel.draftList;
    totalDisApproved = employeeListModel.disAppList;
    totalApprovedAmt = employeeListModel.appList;
    totalPendingAmt = employeeListModel.pendingList;
    setState(() {
      isLoadingCount = false;
      isLoading = false;
    });
    allUsernew = employeeListModel.data;

    return employeeListModel;
  }

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
      foundDataNew = results;
    });
  }

  TextEditingController searchType = TextEditingController();
  var titleName = "Claim Approver List";
  int value = 1;
  int switcherIndex1 = 0;
  int pageIndex = 0;
  int currentIndex = 2;
  int valueChange = 0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            }
            if(index==2){
              Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Attendance');
            }
            if(index==3){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
              );
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
        /*floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, MyRoutings.addInductionProcessRoute);
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
          color: context.canvasColor,
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(6.0),
                crossAxisCount: 4,
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
                                  :"$totalDraftAmt".text.bold.color(Mythemes.whitish).size(16).make(),
                            ),
                            Center(
                              child: Container(
                                //margin: EdgeInsets.only(top: 30, left: 10),
                                //padding: EdgeInsets.fromLTRB(2, 5, 10, 5),
                                child: Text(
                                  'Draft',
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
                                  :"$totalPendingAmt".text.bold.color(Mythemes.whitish).size(16).make(),
                            ),
                            Center(
                              child: Container(
                                //margin: EdgeInsets.only(top: 70, left: 10),
                                //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                                child: Text(
                                  'Pending',
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
                                  :"$totalApprovedAmt".text.bold.color(Mythemes.whitish).size(16).make(),
                            ),
                            Center(
                              child: Container(
                                //margin: EdgeInsets.only(top: 70, left: 10),
                                //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                                child: Text(
                                  'Approve',
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
                      color: Mythemes.dangerColor,
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
                                  :"$totalDisApproved".text.bold.color(Mythemes.whitish).size(16).make(),
                            ),
                            Center(
                              child: Container(
                                //margin: EdgeInsets.only(top: 70, left: 10),
                                //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                                child: Text(
                                  'Disapprove',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 /* AnimatedToggleSwitch<int>.size(
                    height: 30,
                    current: min(valueChange, 3),
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
                    indicatorSize: const Size.fromWidth(80),
                    iconAnimationType: AnimationType.onHover,
                    styleAnimationType: AnimationType.onHover,
                    spacing: 4.0,
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
                      final text = const ['Level One', 'Level Two', 'Level Three'][local.index];
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
                        valueChange = i;
                        print(i);

                      });
                      //Draft
                      if(valueChange == 0) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
                        statusUpdate = "LEVEL_ONE_PENDING";
                        getSharedPrfanceList();
                        //globalListParameter = claimRequisitionModal.claimRequisitionDraftlist!;
                        //print("length 0 - ${globalListParameter.length}");
                      }
                      //
                      if(valueChange == 1) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
                        statusUpdate = "LEVEL_TWO_PENDING";
                        getSharedPrfanceList();
                        //globalListParameter = claimRequisitionModal.claimRequisitionDraftlist!;
                        //print("length 1-  ${globalListParameter.length}");
                      }
                      //
                      if(valueChange == 2) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
                        statusUpdate = "LEVEL_THREE_PENDING";
                        getSharedPrfanceList();
                      }
                    },
                  ),*/

                  AnimatedToggleSwitch<int>.size(
                    height: 30,
                    current: approvalLevel,  // Controlled by approvalLevel state
                    values: const [0, 1, 2],
                    style: ToggleStyle(
                      backgroundColor: Mythemes.greyishade,
                      indicatorColor: Mythemes.lightBluishColor,
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      indicatorBorderRadius: BorderRadius.zero,
                    ),
                    iconOpacity: 1.0,
                    selectedIconScale: 1.0,
                    indicatorSize: const Size.fromWidth(80),
                    iconAnimationType: AnimationType.onHover,
                    styleAnimationType: AnimationType.onHover,
                    spacing: 4.0,
                    customSeparatorBuilder: (context, local, global) {
                      final opacity = ((global.position - local.position).abs() - 0.5).clamp(0.0, 1.0);
                      return VerticalDivider(
                        indent: 10.0,
                        endIndent: 10.0,
                        color: Colors.white38.withOpacity(opacity),
                      );
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['Level One', 'Level Two', 'Level Three'][local.index];
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.lerp(Colors.black, Colors.white, local.animationValue),
                          ),
                        ),
                      );
                    },
                    borderWidth: 0.0,
                    onChanged: (i) async {
                      setState(() {
                        isLoading = true; // Show loader
                        isLoadingCount = true;
                        approvalLevel = i;  // Update the selected level
                      });

                      await Future.delayed(Duration(seconds: 1)); // Simulate data fetching

                      if (approvalLevel == 0) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
                        statusUpdate = "LEVEL_ONE_PENDING";
                      } else if (approvalLevel == 1) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
                        statusUpdate = "LEVEL_TWO_PENDING";
                      } else if (approvalLevel == 2) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
                        statusUpdate = "LEVEL_THREE_PENDING";
                      }

                      getSharedPrfanceList();

                      setState(() {
                        isLoading = false; // Hide loader
                        isLoadingCount = false;
                      });
                    },
                  ),
                  /*AnimatedToggleSwitch<int>.size(
                    height: 30,
                    current: min(valueChange, 3),
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
                    indicatorSize: const Size.fromWidth(80),
                    iconAnimationType: AnimationType.onHover,
                    styleAnimationType: AnimationType.onHover,
                    spacing: 4.0,
                    customSeparatorBuilder: (context, local, global) {
                      final opacity =
                      ((global.position - local.position).abs() - 0.5).clamp(0.0, 1.0);
                      return VerticalDivider(
                          indent: 10.0,
                          endIndent: 10.0,
                          color: Colors.white38.withOpacity(opacity));
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['Level One', 'Level Two', 'Level Three'][local.index];
                      return Center(
                          child: Text(text,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.lerp(Colors.black, Colors.white,
                                      local.animationValue))));
                    },
                    borderWidth: 0.0,
                    onChanged: (i) async {
                      setState(() {
                        isLoading = true; // Show loader
                        isLoadingCount = true;
                        valueChange = i;
                      });

                      await Future.delayed(Duration(seconds: 1)); // Simulate data fetching

                      if (valueChange == 0) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
                        statusUpdate = "LEVEL_ONE_PENDING";
                      } else if (valueChange == 1) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
                        statusUpdate = "LEVEL_TWO_PENDING";
                      } else if (valueChange == 2) {
                        permissionId = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
                        statusUpdate = "LEVEL_THREE_PENDING";
                      }

                      getSharedPrfanceList();

                      setState(() {
                        isLoading = false; // Hide loader
                        isLoadingCount = false; // Hide loader
                      });
                    },
                  ),*/
                ],
              ).py(4),

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator()) // Show loader
                    : claimApproverListModalGlobaled == null
                    ? Center(child: Text("No Data Available"))
                    : getClaimSelfReqList(claimApproverListModalGlobaled!),
              ),
            ],
          ),
        )
    );
  }


  getClaimSelfReqList(ClaimApproverListModalClass claimRequisitionModal) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            //controller: _controller,
              itemCount: foundDataNew!.length,
              itemBuilder: (context , i) {
                foundDataNew![i].status;
                print(foundDataNew![i].status);
                return InkWell(
                  onTap: () {
                    levelStatusCheck = foundDataNew![i].status;
                    empIdSend = foundDataNew![i].empId.toString();
                    print("EMP ID --> $empIdSend");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ClaimMssApproval(
                          levelStatus: levelStatusCheck!, empId: empIdSend
                        )));
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClaimMssApproval()));*/
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Prevent infinite width issues
                          children: List.generate(3, (index) {
                            // List of levels
                            List<String> levels = [
                              "LEVEL_ONE_PENDING",
                              "LEVEL_TWO_PENDING",
                              "LEVEL_THREE_PENDING"
                            ];

                            // Check if the current step or any previous steps are reached
                            bool isActive = levels.indexOf(foundDataNew![i].status) >= index;

                            return Row(
                              mainAxisSize: MainAxisSize.min, // Ensure inner Row doesn't expand infinitely
                              children: [
                                // Step Indicator
                                GestureDetector(
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: isActive ? Mythemes.successColor : Mythemes.greyishade,
                                      border: Border.all(
                                        width: 1.5,
                                        color: isActive ? Mythemes.successColor : Mythemes.greyishade,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.circle, size: 12, color: Mythemes.whitish),
                                    ),
                                  ),
                                ),
                                if (index < 2) // Avoid line after the last step
                                  Flexible( // Use Flexible instead of Expanded
                                    fit: FlexFit.loose, // Allow it to take space only if available
                                    child: Container(
                                      height: 2,
                                      width: 80, // Set a fixed width to prevent unbounded error
                                      color: isActive ? Mythemes.successColor : Mythemes.greyishade,
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ).p8(),
                        /*Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //step one
                            GestureDetector(
                              //onTap: stepOne,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: foundDataNew![i].status == "LEVEL_ONE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  border: Border.all(
                                    width: 1.5,
                                    strokeAlign: 1,
                                    color: foundDataNew![i].status == "LEVEL_ONE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.circle, size: 12, color: Mythemes.whitish,),
                                ),

                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 2,
                                //why index+1 we want to turn the ligne orange that precede the active bubble
                                color: foundDataNew![i].status == "LEVEL_ONE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                              ),
                            ),

                            //step two
                            GestureDetector(
                              //onTap: stepSix,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: foundDataNew![i].status == "LEVEL_TWO_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  border: Border.all(
                                    width: 1.5,
                                    strokeAlign: 1,
                                    color: foundDataNew![i].status == "LEVEL_TWO_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.circle, size: 12, color: Mythemes.whitish,),
                                ),

                              ),
                            ),
                            Expanded(
                              child : Container(
                                height: 2,
                                color: foundDataNew![i].status == "LEVEL_TWO_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                              ),
                            ),

                            //step Three
                            GestureDetector(
                              //onTap: stepSix,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: foundDataNew![i].status == "LEVEL_THREE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  border: Border.all(
                                    width: 1.5,
                                    strokeAlign: 1,
                                    color: foundDataNew![i].status == "LEVEL_THREE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.circle, size: 12, color: Mythemes.whitish,),
                                ),
                              ),
                            ),
                            Expanded(
                              child : Container(
                                height: 2,
                                color: foundDataNew![i].status == "LEVEL_THREE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                              ),
                            ),

                            //step Four
                            GestureDetector(
                              //onTap: stepSix,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: foundDataNew![i].status == "LEVEL_FOUR_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  border: Border.all(
                                    width: 1.5,
                                    strokeAlign: 1,
                                    color: foundDataNew![i].status == "LEVEL_FOUR_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.circle, size: 12, color: Mythemes.whitish,),
                                ),

                              ),
                            ),
                            Expanded(
                              child : Container(
                                height: 2,
                                color: foundDataNew![i].status == "LEVEL_FOUR_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                              ),
                            ),

                            //step Five
                            GestureDetector(
                              //onTap: stepSix,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: foundDataNew![i].status == "LEVEL_FIVE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  border: Border.all(
                                    width: 1.5,
                                    strokeAlign: 1,
                                    color: foundDataNew![i].status == "LEVEL_FIVE_PENDING" ? Mythemes.successColor : Mythemes.greyishade,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.circle, size: 12, color: Mythemes.whitish,),
                                ),

                              ),
                            ),



                          ],
                        ).p8(),*/
                        Row(
                            children: [
                              foundDataNew![i].empName.toString().text.size(12).make().pLTRB(5, 3, 0, 4),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      foundDataNew![i].statusShow.toString().text.bold.color(Mythemes.alertColor).size(12).make().px8(),

                                    ],
                                  )

                              )
                            ]
                        ).pLTRB(0, 0, 0, 8.0),
                        Row(
                            children: [
                              foundDataNew![i].reimbName.toString().text.size(12).make().pLTRB(5, 3, 0, 4),
                              /*Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        "Segment Type - $segmentType".text.make().px8(),

                                      ],
                                    )

                                )*/
                            ]
                        ).pLTRB(0, 0, 0, 8.0),
                        Row(
                            children: [
                              "Raised On- ${foundDataNew![i].raisedOn.toString()}".text.size(12).make().pLTRB(5, 3, 0, 4),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      "Category - ${foundDataNew![i].empName.toString()}".text.size(12).make().px8(),

                                    ],
                                  )

                              )
                            ]
                        ).pLTRB(0, 0, 0, 8.0),
                        Row(
                            children: [
                              "Claimed Amount - ${foundDataNew![i].claimAmount.toString()}".text.bold.color(Mythemes.lightBluishColor).size(12).make().pLTRB(5, 3, 0, 4),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      "Approved Amount - ${foundDataNew![i].approvedAmount.toString()}".text.bold.color(Mythemes.successColor).size(12).make().px8(),

                                    ],
                                  )

                              )
                            ]
                        ).pLTRB(0, 0, 0, 8.0),
                      ],
                    ),
                  ).p4(),
                );
              }
          ),
        ),
      ],
    );


    /*if(foundDataNew == []) {
      print("FETCH NEW DATA");
      Center(
        child: "There is no data availabel right now".text.make(),
      );
    }*/

  }
}
