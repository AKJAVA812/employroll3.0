import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/pendingRequisition/pendingReqAppDiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../../MSS_Bundle/common/mss_approval_filter_panel.dart';

class MSS_MO_PendingRequisitionRo extends StatefulWidget {
  final PendingRequisitionModel pendingRequisitionModel;
  MSS_MO_PendingRequisitionRo(this.pendingRequisitionModel);

  @override
  State<MSS_MO_PendingRequisitionRo> createState() =>
      _MSS_MO_PendingRequisitionRoState(pendingRequisitionModel);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew = [];
List<Data>? foundDataNewMO = [];
PendingRequisitionModel? pendingRequisitionLabel;
PendingRequisitionModel? pendingRequisitionLabeled;
String? userPanel;
dynamic getProfileId;
String? orgId;
var reqType = "";
dynamic matchedOrg;

class _MSS_MO_PendingRequisitionRoState
    extends State<MSS_MO_PendingRequisitionRo>
    with RouteAware {
  final PendingRequisitionModel pendingRequisitionModel;
  _MSS_MO_PendingRequisitionRoState(this.pendingRequisitionModel);
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
    await loadOrgListFromPrefs();
    sessionId = await shared.getSessionId();
    userPanel = await shared.getUserPanel();
    getProfileId = await shared.getDefaultProfileId();
    final activeOrgId = await shared.getActiveOrgId() ?? await shared.getOrgId();
    final activeOrgName = await shared.getActiveOrgName();
    getOrgId = activeOrgId?.toString() ?? '';
    matchedOrg = storedOrgList.firstWhere(
      (org) => org['id']?.toString() == getOrgId,
      orElse: () => {
        'id': getOrgId,
        'orgName': activeOrgName ?? '',
      },
    );
    final resolvedOrgName = matchedOrg['orgName']?.toString();
    selectedOrg = organizations.contains(resolvedOrgName) ? resolvedOrgName : null;
    if ((sessionId ?? '').isEmpty || (getOrgId ?? '').toString().isEmpty) return;

    if (mounted) {
      setState(() {
        pendingRequisitionLabeled = null;
        isLoading = true;
      });
    }
    try {
      final value = await getPendingReqList(sessionId!);
      if (!mounted) return;
      setState(() {
        foundDataNewMO = allUsernew;
        pendingRequisitionLabel = value;
        pendingRequisitionLabeled = value;
        isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  var levelChange = "PENDING";
  Future<PendingRequisitionModel> getPendingReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingReqListRo;
    print('employeeList11: ${SessionId}');
    PendingRequisitionModel pendingRequisitionModel;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "userPermission=$userPanel&"
      "profileId=$getProfileId&"
      "orgId=$getOrgId&"
      "status=$levelChange",
    );

    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    pendingRequisitionModel = PendingRequisitionModel.fromJson(mapResponse);

    allUsernew = pendingRequisitionModel.data;

    return pendingRequisitionModel;
  }

  var titleName = "Pending Requisition List";

  TextEditingController searchType = TextEditingController();

  // This function is called whenever the text field changes
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

  void _applyApprovalFilters(MssApprovalFilterValue filters) {
    final query = filters.search.toLowerCase();
    final type = filters.requestType?.label.toLowerCase();
    final typeCode = filters.requestType?.code.toLowerCase().replaceAll('_', ' ');
    final branch = filters.branch?.label.toLowerCase();
    final stage = int.tryParse(filters.stage?.id?.toString() ?? '');
    final rows = allUsernew ?? <Data>[];
    final hasStageData = rows.any((item) => item.currentLevel != null);
    final results = rows.where((item) {
      final searchable = '${item.empName ?? ''} ${item.empId ?? ''} ${item.department ?? ''}'.toLowerCase();
      final requestType = '${item.requestType ?? ''} ${item.attendanceRequisionType ?? ''} ${item.compOffRequistionType ?? ''} '
          '${item.shortLeaveRequistionType ?? ''} ${item.odRequistionType ?? ''} ${item.nightRequistionType ?? ''}'.toLowerCase();
      return (query.isEmpty || searchable.contains(query)) &&
          (type == null || requestType.contains(type) || requestType.contains(typeCode!)) &&
          (!hasStageData || stage == null || item.currentLevel == stage) &&
          (branch == null || (item.branch ?? '').toString().toLowerCase() == branch);
    }).toList();
    setState(() => foundDataNewMO = results);
  }

  int pageIndex = 0;
  int currentIndex = 2;

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
                      onChanged: (value) async {
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

                        final selectedId = int.tryParse(getOrgId.toString());
                        if (selectedId != null && selectedId > 0) {
                          await shared.setActiveOrgId(selectedId);
                          await shared.setActiveOrgName(value ?? '');
                        }

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

                          sessionId = await shared.getSessionId();
                          userPanel = await shared.getUserPanel();
                          getProfileId = await shared.getDefaultProfileId();
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        child: Icon(Icons.filter_list, color: Mythemes.whitish),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    MssApprovalFilterPanel(
                      organisationId: int.tryParse(getOrgId.toString()),
                      total: allUsernew?.length ?? 0,
                      requestFamilyCode: 'ATTENDANCE',
                      onChanged: _applyApprovalFilters,
                    ),
                    Expanded(
                      child:
                          pendingRequisitionLabeled == null
                              ? Center(
                                child:
                                    "Please select Organisation first!"
                                        .text
                                        .bold
                                        .center
                                        .make(),
                              )
                              : getPendingRequisitionRo(
                                pendingRequisitionLabeled!,
                              ),
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
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            Navigator.pop(context);
            print('Attendance');
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('My Reports');
          }
          if (index == 4) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            /*Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );*/
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Dashboard');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval_sharp),
            label: 'Att. Approval',
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
    );
  }

  getPendingRequisitionRo(PendingRequisitionModel pendingRequisitionModel) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) =>
                    MSS_MO_PendingRequisitionRo(PendingRequisitionModel()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        itemCount: foundDataNewMO!.length,
        itemBuilder: (context, itemCount) {
          if (foundDataNewMO![itemCount].attendanceRequisionType == true) {
            reqType = "Attendance Request";
          }
          if (foundDataNewMO![itemCount].compOffRequistionType == true) {
            reqType = "Compensatory Off Request";
          }
          if (foundDataNewMO![itemCount].nightRequistionType == true) {
            reqType = "Night Shift Request";
          }
          if (foundDataNewMO![itemCount].shortLeaveRequistionType == true) {
            reqType = "Short Leave Request";
          }
          if (foundDataNewMO![itemCount].odRequistionType == true) {
            reqType = "Out Duty Request";
          }
          return Column(
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
                    //Navigator.pushNamed(context, MyRoutings.approveDisapproveReqRoute);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ApproveDisapproveReq(
                              pendingRequisitionModel,
                              itemCount,
                            ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.person, color: Colors.blue.shade700),
                  ),
                  title:
                      foundDataNewMO![itemCount].empName
                          .toString()
                          .text
                          .bold
                          .xl
                          .make(),
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
                      SizedBox(height: 4),
                      "Request Type: $reqType"
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ],
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
