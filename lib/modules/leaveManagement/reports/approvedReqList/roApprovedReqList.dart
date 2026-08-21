import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'approvedLeaveReqModal.dart';

class ApprovedLeaveRequisitionList extends StatefulWidget {
  final ApprovedLeaveReqModal approvedLeaveReqModal;
  const ApprovedLeaveRequisitionList(this.approvedLeaveReqModal, {super.key});

  @override
  State<ApprovedLeaveRequisitionList> createState() =>
      _ApprovedLeaveRequisitionListState(approvedLeaveReqModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
dynamic getProfileId;
dynamic getOrgId;
dynamic userPanelPerm;

ApprovedLeaveReqModal? approvedLeaveReqLabel;

class _ApprovedLeaveRequisitionListState
    extends State<ApprovedLeaveRequisitionList>
    with RouteAware {
  final ApprovedLeaveReqModal approvedLeaveReqModal;
  _ApprovedLeaveRequisitionListState(this.approvedLeaveReqModal);

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
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    getProfileId = await shared.getDefaultProfileId();
    getOrgId = await shared.getOrgId();
    userPanelPerm = await shared.getUserPanel();
    // await Future.delayed(Duration(seconds: 5));
    Future<ApprovedLeaveReqModal> getAppReq11 = getApprovedLeaveReqList(
      sessionId!,
    );
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        approvedLeaveReqLabel = value;
      });
    });
  }

  Future<ApprovedLeaveReqModal> getApprovedLeaveReqList(
    String SessionId,
  ) async {
    final api = MobileApiFoundation.instance;
    final response = await api.get(
      ApiDetails.mobileLeaveRequisitionList,
      queryParameters: const <String, Object?>{'page': 0, 'size': 100},
      headers: await api.authHeaders(requestId: api.newRequestId()),
      tag: 'LEAVE_APPROVED_LIST',
    );
    mapResponse = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    final modal = ApprovedLeaveReqModal.fromJson(mapResponse);
    modal.result?.data?.removeWhere(
      (item) => item.status?.toUpperCase() != 'APPROVED' ||
          !_isLeaveRequestType(item.requestType),
    );
    return modal;
  }

  bool _isLeaveRequestType(String? value) {
    final normalized = (value ?? 'leave')
        .trim()
        .toLowerCase()
        .replaceAll('-', '_');
    return normalized == 'leave' || normalized == 'leave_application';
  }

  Future<void> _openLeaveReversal(Data leave) async {
    final id = leave.requisitionId;
    if (id == null) return;
    final api = MobileApiFoundation.instance;
    try {
      final response = await api.get(
        ApiDetails.mobileLeaveReversalPreview(id),
        headers: await api.authHeaders(requestId: api.newRequestId()),
        tag: 'LEAVE_REVERSAL_PREVIEW',
      );
      final payload = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
      final dates = (payload['dates'] as List? ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (!mounted) return;
      if (dates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No leave dates are available for reversal.')),
        );
        return;
      }
      await _showReversalSheet(id, leave, dates);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(error))),
      );
    }
  }

  Future<void> _showReversalSheet(
    int sourceId,
    Data leave,
    List<Map<String, dynamic>> dates,
  ) async {
    final selected = dates.map((item) => item['date'].toString()).toSet();
    final remarks = TextEditingController();
    var submitting = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leave Reversal', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(leave.leaveType ?? 'Approved Leave'),
                const Divider(height: 24),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: dates.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final date = dates[index]['date'].toString();
                      final days = dates[index]['days'];
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: selected.contains(date),
                        title: Text(_displayDate(date)),
                        subtitle: Text('${days ?? 1} day'),
                        onChanged: submitting
                            ? null
                            : (checked) => setSheetState(() {
                                  checked == true ? selected.add(date) : selected.remove(date);
                                }),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: remarks,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: selected.isEmpty || submitting
                        ? null
                        : () async {
                            setSheetState(() => submitting = true);
                            try {
                              final api = MobileApiFoundation.instance;
                              final response = await api.postJson(
                                ApiDetails.mobileLeaveReversal,
                                body: <String, Object?>{
                                  'sourceRequisitionId': sourceId,
                                  'selectedDates': selected.toList()..sort(),
                                  'reason': remarks.text.trim(),
                                },
                                headers: await api.authHeaders(
                                  requestId: api.newRequestId(),
                                  json: true,
                                ),
                                tag: 'LEAVE_REVERSAL_SUBMIT',
                              );
                              if (response.statusCode < 200 || response.statusCode >= 300) {
                                throw Exception('Unable to submit leave reversal.');
                              }
                              if (!sheetContext.mounted) return;
                              Navigator.of(sheetContext).pop();
                              await getSharedPrfanceList();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Leave reversal submitted for approval.')),
                              );
                            } catch (error) {
                              setSheetState(() => submitting = false);
                              if (!sheetContext.mounted) return;
                              ScaffoldMessenger.of(sheetContext).showSnackBar(
                                SnackBar(content: Text(_errorMessage(error))),
                              );
                            }
                          },
                    icon: submitting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.undo),
                    label: const Text('Submit Reversal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    remarks.dispose();
  }

  String _displayDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _errorMessage(Object error) {
    if (error is MobileApiException && error.message?.trim().isNotEmpty == true) {
      return error.message!.trim();
    }
    return 'Unable to process the leave reversal right now.';
  }

  int pageIndex = 0;
  int currentIndex = 2;
  int value = 1;
  var titleName = "Approved List";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
            },
            icon: Icon(Icons.arrow_back_ios)),*/
        title: titleName.text.make(),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchItems());
            },
            icon: Icon(Icons.search),
          ),
        ],
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
                    });

                    if (value == 0) {
                      Navigator.pushNamed(
                        context,
                        MyRoutings.requestedRequisitionRoute,
                      );
                      //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                    }
                    if (value == 1) {
                      Navigator.pushNamed(
                        context,
                        MyRoutings.approvedLeaveReqListRoute,
                      );
                    }
                    /* if(value == 2) {
                          Navigator.pushNamed(context, MyRoutings.disApprovedReqRoute);
                        }*/
                  },
                ),
              ],
            ).py(4),
            Expanded(
              child:
                  approvedLeaveReqLabel == null
                      ? Center(child: CircularProgressIndicator())
                      : getAppRequisitionList(approvedLeaveReqLabel!),
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
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
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
    );
  }

  getAppRequisitionList(ApprovedLeaveReqModal approvedLeaveReqModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) =>
                    ApprovedLeaveRequisitionList(ApprovedLeaveReqModal()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: approvedLeaveReqModal.result!.data!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              _openLeaveReversal(approvedLeaveReqModal.result!.data![i]);
            },
            child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        approvedLeaveReqModal.result!.data![i].employeeName
                            .toString()
                            .text
                            .make()
                            .px8()
                            .py4(),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              "Leave Length".text.make().px4(),
                              const Tooltip(
                                message: 'Request leave reversal',
                                child: Icon(Icons.undo, size: 18, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _displayDate(approvedLeaveReqModal.result!.data![i].applicationDate.toString())
                            .text
                            .textStyle(context.captionStyle)
                            .make()
                            .px8(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              approvedLeaveReqModal.result!.data![i].leaveLength
                                  .toString()
                                  .text
                                  .make()
                                  .px8(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        approvedLeaveReqModal.result!.data![i].leaveType
                            .toString()
                            .text
                            .textStyle(context.captionStyle)
                            .make()
                            .px8(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            "Start Date".text.sm.make(),
                            _displayDate(approvedLeaveReqModal.result!.data![i].startDate.toString())
                                .text
                                .sm
                                .make(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "End Date".text.sm.make(),
                              _displayDate(approvedLeaveReqModal.result!.data![i].endDate.toString())
                                  .text
                                  .sm
                                  .make(),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            "Approved By".text.sm.make(),
                            approvedLeaveReqModal.result!.data![i].approvedBy
                                .toString()
                                .text
                                .sm
                                .make(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /*  .badge(
                color: Mythemes.lightBluishColor ,
                size: 25 ,
                count: 8,
                position: VxBadgePosition.rightTop,
                textStyle: TextStyle(
                    fontSize: 14,
                    color: Mythemes.whitish)

            ),*/
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
