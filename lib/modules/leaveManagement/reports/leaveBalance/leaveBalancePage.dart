import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../modalClass/leaveBalModal.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';

class LeaveBalancePage extends StatefulWidget {
  const LeaveBalancePage({Key? key}) : super(key: key);

  @override
  State<LeaveBalancePage> createState() => _LeaveBalancePageState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();

String? sessionId;
var doj;
LeaveBalModal? leaveBalLabel;

class _LeaveBalancePageState extends State<LeaveBalancePage> {
  List<Map<String, dynamic>> _leaveTypes = <Map<String, dynamic>>[];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    doj = await shared.getDoj();
    await _loadLeaveLedger();
  }

  Future<void> _loadLeaveLedger() async {
    final foundation = MobileApiFoundation.instance;
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }
    try {
      final response = await foundation.get(
        ApiDetails.mobileLeaveLedger,
        headers: await foundation.authHeaders(),
        tag: 'LEAVE_LEDGER_REPORT',
      );
      final body = foundation.decodeMap(response.body);
      if (!foundation.isSuccess(response)) {
        throw MobileApiException(
          'LEAVE_LEDGER_FAILED',
          message: _ledgerMessage(body),
          statusCode: response.statusCode,
        );
      }
      final rawTypes = body['leaveTypes'];
      final items = rawTypes is List
          ? rawTypes
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
          : <Map<String, dynamic>>[];
      items.removeWhere(
        (item) => item['leaveTypeCode']?.toString().trim().isEmpty != false,
      );
      if (!mounted) return;
      setState(() {
        mapResponse = body;
        _leaveTypes = items;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _leaveTypes = <Map<String, dynamic>>[];
        _loadError = error is MobileApiException
            ? (error.message ?? 'Unable to load leave ledger.')
            : 'Unable to load leave ledger.';
        _isLoading = false;
      });
    }
  }

  String _ledgerMessage(Map<String, dynamic> body) {
    final message = body['message'] ?? body['reason'] ?? body['detail'];
    return message?.toString() ?? 'Unable to load leave ledger.';
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
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(buildContext);
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

  Future<LeaveBalModal> getLeaveBalance(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBal;
    print('employeeList11: ${SessionId}');
    LeaveBalModal leaveBalModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    //print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];

    var emptyjson = mapResponse['leaveData']['leaveTypeList'];
    //var emptyjson = respons;

    var notEmptyjson = mapResponse.isNotEmpty;
    var containsEmptyjson = mapResponse.length;

    print('responseemployeeList $emptyjson');
    print('responseemployeeList $notEmptyjson');
    print('responseemployeeList $containsEmptyjson');

    /* if (containsEmptyjson==1)  {
      //print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }*/
    print('responseemployeeList $mapResponse');
    leaveBalModal = LeaveBalModal.fromJson(mapResponse);

    //print("typename:-${mapResponse['leaveData']['CO-578']['leavesTaken']}");
    if (emptyjson == null) {
      showNodata(
        context,
        "Oops!!",
        "You are not mapped with any leave policy.",
      );
    }
    return leaveBalModal;
  }

  Widget _buildLedgerList() {
    if (_leaveTypes.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadLeaveLedger,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const <Widget>[
            SizedBox(height: 180),
            Center(child: Text('No leave policy or balance is available.')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadLeaveLedger,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _leaveTypes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = _leaveTypes[index];
          final code = item['shortCode']?.toString().trim().isNotEmpty == true
              ? item['shortCode'].toString()
              : item['leaveTypeCode']?.toString() ?? '';
          final name = item['leaveTypeName']?.toString() ?? code;
          final balance = (item['balance'] as num?)?.toDouble() ?? 0.0;
          final balanceText = balance == balance.roundToDouble()
              ? balance.toInt().toString()
              : balance.toStringAsFixed(1);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Mythemes.lightBluishColor.withOpacity(0.12),
                    child: Text(
                      code,
                      style: TextStyle(
                        color: Mythemes.lightBluishColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                          item['allowHalfDay'] == true
                              ? 'Full day and half day'
                              : 'Full day',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        balanceText,
                        style: TextStyle(
                          color: Mythemes.successColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Balance', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  var titleName = "My Leave Balance";
  int pageIndex = 0;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: titleName.text.make()),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _loadError != null
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_loadError!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadLeaveLedger,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : _buildLedgerList(),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetAttendanceDet(showAppBar: true),
              ),
            );
            print('My Requests');
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAllReportsPage(showAppBar: true),
              ),
            );

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('My Reports');
          }
          if (index == 4) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);

            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Dashboard');
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
}

class GetLeaveBal extends StatefulWidget {
  final LeaveBalModal leaveBalModal;
  const GetLeaveBal(this.leaveBalModal);

  @override
  State<GetLeaveBal> createState() => _GetLeaveBalState(leaveBalModal);
}

class _GetLeaveBalState extends State<GetLeaveBal> {
  final LeaveBalModal leaveBalModal;
  var itemCount;
  _GetLeaveBalState(this.leaveBalModal);
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

  @override
  void initState() {
    setState(() {
      //itemCount = 0;
      // TODO: implement initState
      if (leaveBalLabel!.leaveData!.leaveTypeList != null) {
        itemCount =
            leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length;
      } else {
        itemCount = 0;
      }

      print("itemcount $itemCount");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListView.builder(
        //itemCount: leaveBalLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length,
        itemCount: itemCount,
        itemBuilder: (context, itemCount) {
          var leaveTypeName =
              leaveBalLabel!
                  .leaveData!
                  .leaveTypeList!
                  .leaveTypelist![itemCount];

          var splitLeave = leaveTypeName.split("-")[2];
          var newListLeave = leaveTypeName.split("-")[1];
          var nameOnly = leaveTypeName.split("-")[0];
          var newString = "$newListLeave-" + "$splitLeave";
          //print("$newListLeave-" + "$splitLeave");
          print("Leave Type - $nameOnly");

          var leaveTypeShort =
              mapResponse['leaveData']['$newString']['leavesTaken'];
          //var leaveTypeShort = ;
          print("$leaveTypeShort");

          return Card(
            child: ExpansionTile(
              //key: keyTile,
              initiallyExpanded: isExpanded,
              childrenPadding: EdgeInsets.all(16).copyWith(top: 0),

              title: nameOnly.toString().text.bold.make(),
              subtitle:
                  "Balance - ${mapResponse['leaveData']['$newString']['totalLeavesPending'].toString()}"
                      .text
                      .bold
                      .color(Mythemes.successColor)
                      .make(),
              children: [
                /*Row(
                        children: [
                          "Carry Forward (Last Ledger)".text.bold.color(Mythemes.lightBluishColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //leaveBalLabel!.leaveData!.sL606!.lastYearLeaves!.toString().text.make().px8(),
                                  mapResponse['leaveData']['$newString']['lastYearLeaves'].toString().text.bold.color(Mythemes.lightBluishColor).make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                /*Row(
                        children: [
                          "Leave Credit (Current)".text.bold.color(Mythemes.activeStepColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  mapResponse['leaveData']['$newString']['currentYearLeaves'].toString().text.bold.color(Mythemes.activeStepColor).make().px8(),
                                  */
                /* if (leaveTypeName == 'Sick Leave-SL-606')
                                  leaveBalLabel!.leaveData!.sL606!.currentYearLeaves!.toString().text.make().px8(),
                                if(leaveTypeName == 'Casual Leave-CL-607')
                                  leaveBalLabel!.leaveData!.cL607!.currentYearLeaves!.toString().text.make().px8(),
                                if(leaveTypeName == 'Earn Leave-EL-608')
                                  leaveBalLabel!.leaveData!.eL608!.currentYearLeaves!.toString().text.make().px8(),*/
                /*
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                Row(
                  children: [
                    "Total Leave Enjoyed".text.bold
                        .color(Mythemes.warningColor)
                        .make(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          mapResponse['leaveData']['$newString']['leavesTaken']
                              .toString()
                              .text
                              .bold
                              .color(Mythemes.warningColor)
                              .make()
                              .px8(),
                        ],
                      ),
                    ),
                  ],
                ).pLTRB(0, 0, 0, 8.0),
                /*Row(
                        children: [
                          "Leave Without Pay".text.bold.color(Mythemes.dangerColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  mapResponse['leaveData']['$newString']['lwp'].toString().text.bold.color(Mythemes.dangerColor).make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                /*Row(
                        children: [
                          "Balance Leaves".text.bold.color(Mythemes.alertColor).make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  mapResponse['leaveData']['$newString']['totalLeavesPending'].toString().text.bold.color(Mythemes.alertColor).make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),*/
                Row(
                  children: [
                    "Net Balance".text.bold.color(Mythemes.successColor).make(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          mapResponse['leaveData']['$newString']['totalLeavesPending']
                              .toString()
                              .text
                              .bold
                              .color(Mythemes.successColor)
                              .make()
                              .px8(),
                        ],
                      ),
                    ),
                  ],
                ).pLTRB(0, 0, 0, 8.0),
              ],
            ),
          ).p2();
        },
      ),
    );
  }
}
