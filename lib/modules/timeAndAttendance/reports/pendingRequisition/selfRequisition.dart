import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/ess/myAllRequestsPage.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app/modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../attendanceRequisition/getAttendanceDetails.dart';

class PendingRequisition extends StatefulWidget {
  final SelfRequisitionModel selfRequisitionModel;

  const PendingRequisition(this.selfRequisitionModel, {super.key});

  @override
  State<PendingRequisition> createState() =>
      _PendingRequisitionState(selfRequisitionModel);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew = [];
List<Data>? foundDataNew = [];

SelfRequisitionModel? selfRequisitionLabel;
SelfRequisitionModel? selfRequisitionLabeled;

class _PendingRequisitionState extends State<PendingRequisition>
    with RouteAware {
  final SelfRequisitionModel selfRequisitionModel;

  _PendingRequisitionState(this.selfRequisitionModel);

  var reqId;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => getSharedPrfanceList());

    //getSharedPrfanceList();
  }

  @override
  void didUpdateWidget(covariant PendingRequisition oldWidget) {
    //getSharedPrfanceList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<SelfRequisitionModel> getEmployeeList11 = getSelfReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        selfRequisitionLabel = value;
        selfRequisitionLabeled = selfRequisitionLabel;
        foundDataNew = _filteredRequests(allUsernew ?? <Data>[]);

        if (foundDataNew != null) {
          foundDataNew!.length;
        } else {
          Center(child: "There is no data available right now".text.make());
          foundDataNew = [];
        }
      });

      //print('employeeList00${selfRequisitionLabel!.data!.length}');
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
            //Navigator.pop(buildContext);
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

  var reqType;

  Future<SelfRequisitionModel> getSelfReqList(String SessionId) async {
    setState(() {
      _isLoading = true;
    });
    final foundation = MobileApiFoundation.instance;
    try {
      final response = await foundation.get(
        ApiDetails.mobileAttendanceRequisitionList,
        queryParameters: const <String, Object?>{'page': 0, 'size': 100},
        headers: await foundation.authHeaders(),
        tag: 'ATTENDANCE_REQUISITION_LIST',
      );
      final body = foundation.decodeMap(response.body);
      if (!foundation.isSuccess(response)) {
        throw MobileApiException(
          'ATTENDANCE_REQUISITION_LIST_FAILED',
          message: body['message']?.toString(),
          statusCode: response.statusCode,
        );
      }
      mapResponse = body;
      final model = SelfRequisitionModel.fromJson(body);
      allUsernew = model.data ?? <Data>[];
      if (mounted) setState(() => _isLoading = false);
      return model;
    } catch (error) {
      allUsernew = <Data>[];
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is MobileApiException
                  ? (error.message ?? 'Unable to load attendance requests.')
                  : 'Unable to load attendance requests.',
            ),
          ),
        );
      }
      return SelfRequisitionModel(data: <Data>[]);
    }
  }

  TextEditingController searchType = TextEditingController();
  String _searchQuery = '';

  bool _isApproved(Data request) =>
      (request.status ?? '').trim().toUpperCase().startsWith('APPROVED');

  bool _isPending(Data request) {
    final status = (request.status ?? '').trim().toUpperCase();
    return status.contains('PENDING') ||
        status == 'PENDING_APPROVAL' ||
        status == 'SUBMITTED' ||
        status == 'APPLIED' ||
        status == 'IN_PROGRESS' ||
        status == 'UNDER_REVIEW';
  }

  List<Data> _filteredRequests(List<Data> requests) {
    final query = _searchQuery.trim().toLowerCase();
    return requests.where((request) {
      final matchesStatus =
          value == 1 ? _isApproved(request) : _isPending(request);
      if (!matchesStatus) return false;
      if (query.isEmpty) return true;
      return (request.employeeName ?? '').toLowerCase().contains(query) ||
          (request.empId ?? '').toLowerCase().contains(query) ||
          (request.reqDate ?? '').toLowerCase().contains(query) ||
          (request.status ?? '').toLowerCase().contains(query);
    }).toList();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      _searchQuery = enteredKeyword;
      foundDataNew = _filteredRequests(allUsernew ?? <Data>[]);
    });
  }

  bool _isLoading = true;
  var titleName = "My Attendance Requests";
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
              previousScreen: MyAllRequestPage(),
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
      body: Container(
        child: Column(
          children: [
            Row(
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
                    final text = const ['Pending', 'Approved'][local.index];
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
                      foundDataNew = _filteredRequests(allUsernew ?? <Data>[]);
                    });
                  },
                ),
              ],
            ).py(4),
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : foundDataNew == null || foundDataNew!.isEmpty
                      ? Center(
                        child: Text(
                          value == 1
                              ? 'No approved attendance requisitions available.'
                              : 'No pending attendance requisitions available.',
                        ),
                      )
                      : getEmpReqList(selfRequisitionLabeled!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GetAttendanceDet(showAppBar: true),
            ),
          );
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.add, color: Mythemes.whitish),
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
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 1),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetAttendanceDet(showAppBar: true),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAllReportsPage(showAppBar: true),
              ),
            );

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if (index == 4) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );*/
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
    );
  }

  getEmpReqList(SelfRequisitionModel selfRequisitionModel) {
    return RefreshIndicator(
      onRefresh: () async => getSharedPrfanceList(),
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: foundDataNew!.length,
        itemBuilder: (context, i) {
          if (foundDataNew![i].attendanceRequisionType == true) {
            reqType = "Attendance Request";
          }
          if (foundDataNew![i].compOffRequistionType == true) {
            reqType = "Compensatory Off Request";
          }
          if (foundDataNew![i].nightRequistionType == true) {
            reqType = "Night Shift Request";
          }
          if (foundDataNew![i].shortLeaveRequistionType == true) {
            reqType = "Short Leave Request";
          }
          if (foundDataNew![i].odRequistionType == true) {
            reqType = "Out Duty Request";
          }
          return InkWell(
            onTap: _isPending(foundDataNew![i]) ? () {
              reqId = foundDataNew![i].reqId;


              showDialgCancel(context, context, context);
              //CommonNotificationPage.showDeleteMessage(context, context, context);
            } : null,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= EMPLOYEE NAME + STATUS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        foundDataNew![i].employeeName
                            .toString()
                            .text
                            .xl
                            .semiBold
                            .make(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Mythemes.lightBluishColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:
                              foundDataNew![i].status
                                  .toString()
                                  .text
                                  .color(Mythemes.lightBluishColor)
                                  .bold
                                  .sm
                                  .make(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ================= DATE =================
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        foundDataNew![i].reqDate
                            .toString()
                            .text
                            .textStyle(context.captionStyle)
                            .color(Colors.grey.shade700)
                            .make(),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ================= REQUEST TYPE =================
                    Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        "Request Type: $reqType".text.bold
                            .color(Colors.black87)
                            .sm
                            .make(),
                      ],
                    ),

                    //const SizedBox(height: 16),
                    const Divider(thickness: .8),
                    // const SizedBox(height: 12),

                    // ================= IN/OUT TIME =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ---------------- IN TIME ----------------
                        Column(
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 32,
                              color: Mythemes.lightBluishColor,
                            ),
                            const SizedBox(height: 4),
                            "In Time".text.sm.make(),
                            foundDataNew![i].inTime
                                .toString()
                                .text
                                .semiBold
                                .make(),
                          ],
                        ),

                        // ---------------- OUT TIME ----------------
                        Column(
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 32,
                              color: Mythemes.dangerColor,
                            ),
                            const SizedBox(height: 4),
                            "Out Time".text.sm.make(),
                            foundDataNew![i].outTime
                                .toString()
                                .text
                                .semiBold
                                .make(),
                          ],
                        ),

                        // If you want working hours, uncomment easily
                        /*
            Column(
              children: [
                Icon(Icons.timer_outlined,
                    size: 32, color: Mythemes.lightBluishColor),
                const SizedBox(height: 4),
                "Working Hours".text.sm.make(),
                "09:30".text.semiBold.make()
              ],
            ),
            */
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

  showDialgCancel(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(
            child: Text("Cancel Requisition", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
      content: Text(
        "Sure you want to cancel requisition?",
        style: TextStyle(fontSize: 14),
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: Container(
            // color: Mythemes.lightBluishColor,
            child: Text("No", style: TextStyle(color: Mythemes.dangerColor)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (a, b, c) => PendingRequisition(SelfRequisitionModel()),
                transitionDuration: Duration(seconds: 1),
                maintainState: true,
              ),
            );
            cancelSelfAttRequisition(reqId.toString());
            Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: Container(
            child: Text("Yes", style: TextStyle(color: Mythemes.warningColor)),
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

  Future<void> cancelSelfAttRequisition(String reqId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.cancelSelfAttReqList;

    if (!mounted) return;
    CommonNotificationPage.showLoaderDialog(context);

    try {
      var urlapi = Uri.parse(
        "$conn$apiUrl?"
        "sessionId=$sessionId&"
        "reqId=$reqId",
      );

      final response = await MobileHttpClient.instance.post(urlapi);

      String result = "unknown";

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        result = mapResponse['result']?.toString() ?? "unknown";
      } else {
      }

      // âœ… Always close loader no matter success/failure
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // âœ… Now show popup depending on result
      if (mounted) {
        if (result.compareToIgnoringCase("success") == 0) {
          CommonNotificationPage.showDialgSucess(
            context,
            "Requisition Deleted Successfully !",
            "Success.",
          );
          // Close current screen after success
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        } else if (result.compareToIgnoringCase("failed") == 0) {
          CommonNotificationPage.showDialgSucess(
            context,
            "Please check the network connection!",
            "Failed",
          );
        } else {
          CommonNotificationPage.showDialgSucess(
            context,
            "Unexpected response: $result",
            "Error",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // âœ… close loader
        CommonNotificationPage.showDialgSucess(
          context,
          "Exception: $e",
          "Error",
        );
      }
    }
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
