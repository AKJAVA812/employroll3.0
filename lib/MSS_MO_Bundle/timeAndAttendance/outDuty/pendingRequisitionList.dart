import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../../../MSS_Bundle/common/mss_approval_filter_panel.dart';
import '../../../modules/onDuty/reports/onDutyTypes.dart';
import '../../../modules/onDuty/reports/pendingRequisition/modalClass/pendingOdReqList.dart';
import '../../../modules/onDuty/reports/pendingRequisition/odAttendanceApproval.dart';

class MSS_MO_PendingOdRequisition extends StatefulWidget {
  final PendingOdReqList pendingOdReqList;

  const MSS_MO_PendingOdRequisition(this.pendingOdReqList, {super.key});

  @override
  State<MSS_MO_PendingOdRequisition> createState() =>
      _MSS_MO_PendingOdRequisitionState(pendingOdReqList);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Listdata>? allUsernew = [];
List<Listdata>? foundDataNewMO = [];
bool isLoading = true;
PendingOdReqList? pendingOdReqListLabel;
PendingOdReqList? pendingOdReqListLabeled;
String? userPanel;
dynamic getProfileId;
String? orgId;
dynamic matchedOrg;

class _MSS_MO_PendingOdRequisitionState
    extends State<MSS_MO_PendingOdRequisition>
    with RouteAware {
  final PendingOdReqList pendingOdReqList;

  _MSS_MO_PendingOdRequisitionState(this.pendingOdReqList);

  var titleName = "OD Pending List";

  String? odStatus;
  var startDate;
  var endDate;

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

      // Defer execution until after build frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DateTime now = DateTime.now();
        odStatus = "Pending";
        startDate = "2015-01-01";

        DateFormat currentDateFormat = DateFormat("yyyy-MM-dd");
        String currentDateFormatString = currentDateFormat.format(now);
        endDate = currentDateFormatString;
        getSharedPrfanceList();

        setState(() {
          int listLength = foundDataNewMO?.length ?? 0;
        });
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
        pendingOdReqListLabeled = null;
        isLoading = true;
      });
    }
    try {
      final value = await getPendingOdReqList(sessionId!);
      if (!mounted) return;
      setState(() {
        foundDataNewMO = allUsernew ?? [];
        pendingOdReqListLabel = value;
        pendingOdReqListLabeled = value;
        isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
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
                        }),
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
                            pendingOdReqListLabeled = null;
                            //isLoading = true;
                          });

                          sessionId = await shared.getSessionId();
                          userPanel = await shared.getUserPanel();
                          getProfileId = await shared.getDefaultProfileId();
                          getOrgId = matchedOrg['id']?.toString() ?? '';
                          // await Future.delayed(Duration(seconds: 5));
                          Future<PendingOdReqList> getEmployeeList11 =
                              getPendingOdReqList(sessionId!);
                          final loading = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text(" Login ... Please wait"),
                            ],
                          );

                          getEmployeeList11.then((value) {
                            setState(() {
                              foundDataNewMO = allUsernew;
                              pendingOdReqListLabel = value;
                              pendingOdReqListLabeled = pendingOdReqListLabel;
                              if (foundDataNewMO != null) {
                                foundDataNewMO!.length;
                                isLoading = false;
                              } else {
                                Center(
                                  child:
                                      "There is no data available right now"
                                          .text
                                          .make(),
                                );
                                foundDataNewMO = [];
                              }
                            });

                            //print('employeeList00${pendingOdReqListLabel!.listdata!.length}');
                          });
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

  Future getSharedPrfanceLists() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<PendingOdReqList> getEmployeeList11 = getPendingOdReqList(
      sessionId!,
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
        foundDataNewMO = allUsernew;
        pendingOdReqListLabel = value;
        pendingOdReqListLabeled = pendingOdReqListLabel;
        if (foundDataNewMO != null) {
          foundDataNewMO!.length;
          isLoading = false;
        } else {
          Center(child: "There is no data available right now".text.make());
          foundDataNewMO = [];
        }
      });

      //print('employeeList00${pendingOdReqListLabel!.listdata!.length}');
    });
  }

  Future<PendingOdReqList> getPendingOdReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.odPendingReqListNew;
    PendingOdReqList pendingOdReqList;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "odStatus=$odStatus&"
      "startDate=$startDate&"
      "endDate=$endDate&"
      "profileId=$getProfileId&"
      "userPermission=$userPanel&"
      "orgId=$getOrgId",
    );

    final response = await MobileHttpClient.instance.post(urlapi);

    mapResponse = json.decode(response.body);
    var getData = mapResponse['result'];
    if (getData == "Error") {
      showNodata(context, "Oops", "There is no any requisition.");
    }
    pendingOdReqList = PendingOdReqList.fromJson(mapResponse);
    allUsernew = pendingOdReqList.listdata;

    return pendingOdReqList;
  }

  var statusColor;
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

  void _runFilter(String enteredKeyword) {
    List<Listdata>? results = [];

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
                (element) => element.name!.toLowerCase().contains(
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
    final rows = allUsernew ?? <Listdata>[];
    final hasStageData = rows.any((item) => item.currentLevel != null);
    final results = rows.where((item) {
      final searchable = '${item.name ?? ''} ${item.id ?? ''} ${item.odaddress ?? ''}'.toLowerCase();
      return (query.isEmpty || searchable.contains(query)) &&
          (type == null || '${item.requestType ?? ''} ${item.odtype ?? ''}'.toLowerCase().contains(type) ||
              '${item.requestType ?? ''} ${item.odtype ?? ''}'.toLowerCase().contains(typeCode!)) &&
          (!hasStageData || stage == null || item.currentLevel == stage) &&
          (branch == null || (item.branch ?? '').toLowerCase() == branch);
    }).toList();
    setState(() => foundDataNewMO = results);
  }

  TextEditingController searchType = TextEditingController();
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;
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
              previousScreen: OnDutyTypes(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        child: Icon(Icons.filter_list, color: Mythemes.whitish),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            MssApprovalFilterPanel(
              organisationId: int.tryParse(getOrgId.toString()),
              total: allUsernew?.length ?? 0,
              requestFamilyCode: 'OD',
              onChanged: _applyApprovalFilters,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedToggleSwitch<int>.size(
                  height: 30,
                  current: min(value, 3),
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
                    final text =
                        const ['Pending', 'Approved', 'Disapproved'][local
                            .index];
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
                    });

                    if (value == 0) {
                      isLoading = true;
                      titleName = "OD Pending List";
                      odStatus = "Pending";
                      //Navigator.pushNamed(context, MyRoutings.mssMoPendingOdRequisitionRoute);
                      getSharedPrfanceList();
                      //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                    }
                    if (value == 1) {
                      isLoading = true;
                      titleName = "OD Approved List";
                      odStatus = "Approved";
                      getSharedPrfanceList();
                      //Navigator.pushNamed(context, MyRoutings.levelOnePendingRoute);
                    }
                    if (value == 2) {
                      isLoading = true;
                      titleName = "OD Disapproved List";
                      odStatus = "Disapproved";
                      getSharedPrfanceList();
                      //Navigator.pushNamed(context, MyRoutings.levelTwoPendingRoute);
                    }
                  },
                ),
              ],
            ).py(6),
            isLoading
                ? CircularProgressIndicator().py32()
                : Expanded(
                  child:
                      pendingOdReqListLabeled == null
                          ? "There is no data available.".text.center.make()
                          : getPendingOdRequisitionList(
                            pendingOdReqListLabeled!,
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
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            //Navigator.of(context, rootNavigator: true).pop();
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.onDutyTypes);
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
            );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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
            icon: Icon(Icons.outbond_outlined),
            label: 'OD',
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

  getPendingOdRequisitionList(PendingOdReqList pendingOdReqList) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) => MSS_MO_PendingOdRequisition(PendingOdReqList()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        itemCount: foundDataNewMO!.length,
        itemBuilder: (context, itemCount) {
          var statusCheck = foundDataNewMO![itemCount].approvalstatus;
          if (statusCheck == 'Approved') {
            statusColor = Mythemes.successColor;
          } else if (statusCheck == 'DisApproved') {
            statusColor = Mythemes.dangerColor;
          } else {
            statusColor = Mythemes.alertColor;
          }
          return InkWell(
            onTap: () {
              if (statusCheck == 'Approved') {
                Fluttertoast.showToast(
                  msg: "Your Requisition has already Approved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (statusCheck == 'DisApproved') {
                Fluttertoast.showToast(
                  msg: "Your Requisition has already Disapproved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            OdApproveDisapproveReq(pendingOdReqList, itemCount),
                  ),
                );
              }
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Avatar | Name + address | Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              (foundDataNewMO![itemCount].image != null &&
                                      foundDataNewMO![itemCount].image
                                          .toString()
                                          .isNotEmpty)
                                  ? NetworkImage(
                                        foundDataNewMO![itemCount].image
                                            .toString(),
                                      )
                                      as ImageProvider
                                  : AssetImage('assets/images/avtar7.png'),
                        ),

                        const SizedBox(width: 12),

                        // Name + address (left, expandable)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                foundDataNewMO![itemCount].name.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Address row with icon. The Expanded text prevents overflow and ellipsizes.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      foundDataNewMO![itemCount].odaddress
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 16,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      foundDataNewMO![itemCount].remark
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Status (right aligned, stays vertically at the top)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              foundDataNewMO![itemCount].approvalstatus
                                  .toString(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Remark row
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            foundDataNewMO![itemCount].remark.toString(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),*/
                    const SizedBox(height: 12),
                    const Divider(height: 1),

                    const SizedBox(height: 10),

                    // Bottom icons row (In/Out + Date)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Left block - In/Out and time
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 32,
                                color: Mythemes.lightBluishColor,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    foundDataNewMO![itemCount].odtype
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    foundDataNewMO![itemCount].odtime
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right block - Date
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 32,
                                color: Mythemes.lightBluishColor,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(
                                        foundDataNewMO![itemCount].date
                                            .toString(),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
