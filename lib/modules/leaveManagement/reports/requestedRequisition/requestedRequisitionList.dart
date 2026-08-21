import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../leaveRequisition/leaveRequisitionPage.dart';
import '../modalClass/selfLeaveRequisitionModal.dart';

class RequestedRequisitionList extends StatefulWidget {
  final SelfLeaveRequisitionListModal selfLeaveRequisitionListModal;
  final int initialTab;
  const RequestedRequisitionList(
    this.selfLeaveRequisitionListModal, {
    super.key,
    this.initialTab = 0,
  });

  @override
  State<RequestedRequisitionList> createState() =>
      _RequestedRequisitionListState(selfLeaveRequisitionListModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

class _RequestedRequisitionListState extends State<RequestedRequisitionList>
    with RouteAware {
  final SelfLeaveRequisitionListModal selfLeaveRequisitionListModal;
  _RequestedRequisitionListState(this.selfLeaveRequisitionListModal);

  var status;
  var leaveId;
  SelfLeaveRequisitionListModal? selfLeaveRequisitionLabel;

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
    super.initState();
    value = widget.initialTab == 1 ? 1 : 0;
    getSharedPrfanceList();
  }

  Future<void> getSharedPrfanceList() async {
    if (mounted) setState(() => _isLoading = true);
    sessionId = await shared.getSessionId();
    final result = await getSelfLeaveReqList(sessionId ?? '');
    if (!mounted) return;
    setState(() {
      selfLeaveRequisitionLabel = result;
      _isLoading = false;
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

  bool _isLoading = true;
  int? _loadingReversalId;
  Future<SelfLeaveRequisitionListModal> getSelfLeaveReqList(
    String SessionId,
  ) async {
    final foundation = MobileApiFoundation.instance;
    try {
      final response = await foundation.get(
        ApiDetails.mobileLeaveRequisitionList,
        queryParameters: const <String, Object?>{'page': 0, 'size': 100},
        headers: await foundation.authHeaders(),
        tag: 'LEAVE_REQUISITION_LIST',
      );
      final body = foundation.decodeMap(response.body);
      if (!foundation.isSuccess(response)) {
        throw MobileApiException(
          'LEAVE_REQUISITION_LIST_FAILED',
          message: body['message']?.toString(),
          statusCode: response.statusCode,
        );
      }
      mapResponse = body;
      final model = SelfLeaveRequisitionListModal.fromJson(body);
      return model;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is MobileApiException
                  ? (error.message ?? 'Unable to load leave requests.')
                  : 'Unable to load leave requests.',
            ),
          ),
        );
      }
      return SelfLeaveRequisitionListModal(data: <Data>[]);
    }
  }

  Future<void> _openLeaveReversal(Data leave) async {
    final requisitionId = leave.leavereqId;
    if (requisitionId == null) {
      _showMessage('Unable to identify this approved leave requisition.');
      return;
    }
    if (_loadingReversalId != null) return;
    setState(() => _loadingReversalId = requisitionId);
    final api = MobileApiFoundation.instance;
    try {
      final response = await api.get(
        ApiDetails.mobileLeaveReversalPreview(requisitionId),
        headers: await api.authHeaders(requestId: api.newRequestId()),
        tag: 'LEAVE_REVERSAL_PREVIEW',
      );
      final body = api.decodeMap(response.body);
      if (!api.isSuccess(response)) {
        throw MobileApiException(
          'LEAVE_REVERSAL_PREVIEW_FAILED',
          message: body['message']?.toString(),
          statusCode: response.statusCode,
        );
      }
      final payload =
          body['data'] is Map
              ? Map<String, dynamic>.from(body['data'] as Map)
              : body;
      final dates =
          (payload['dates'] as List? ?? const <dynamic>[])
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
      if (!mounted) return;
      if (dates.isEmpty) {
        _showMessage('No leave dates are available for reversal.');
        return;
      }
      setState(() => _loadingReversalId = null);
      await _showLeaveReversalSheet(requisitionId, leave, dates);
    } catch (error) {
      if (!mounted) return;
      _showMessage(
        error is MobileApiException
            ? (error.message ?? 'Unable to load leave reversal details.')
            : 'Unable to load leave reversal details.',
      );
    } finally {
      if (mounted && _loadingReversalId == requisitionId) {
        setState(() => _loadingReversalId = null);
      }
    }
  }

  Future<void> _showLeaveReversalSheet(
    int requisitionId,
    Data leave,
    List<Map<String, dynamic>> dates,
  ) async {
    final selectedDates = dates.map((item) => item['date'].toString()).toSet();
    final remarksController = TextEditingController();
    var submitting = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (sheetContext) => StatefulBuilder(
            builder:
                (context, setSheetState) => SafeArea(
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
                        Text(
                          'Leave Reversal',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          leave.leavetype?.isNotEmpty == true
                              ? leave.leavetype!
                              : 'Approved Leave',
                        ),
                        const Divider(height: 24),
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: dates.length,
                            separatorBuilder:
                                (_, __) => const Divider(height: 1),
                            itemBuilder: (_, index) {
                              final date = dates[index]['date'].toString();
                              return CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: selectedDates.contains(date),
                                title: Text(_displayDate(date)),
                                subtitle: Text(
                                  '${dates[index]['days'] ?? 1} day',
                                ),
                                onChanged:
                                    submitting
                                        ? null
                                        : (checked) => setSheetState(() {
                                          if (checked == true) {
                                            selectedDates.add(date);
                                          } else {
                                            selectedDates.remove(date);
                                          }
                                        }),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: remarksController,
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
                            onPressed:
                                selectedDates.isEmpty || submitting
                                    ? null
                                    : () async {
                                      setSheetState(() => submitting = true);
                                      try {
                                        final api =
                                            MobileApiFoundation.instance;
                                        final response = await api.postJson(
                                          ApiDetails.mobileLeaveReversal,
                                          body: <String, Object?>{
                                            'sourceRequisitionId':
                                                requisitionId,
                                            'selectedDates':
                                                selectedDates.toList()..sort(),
                                            'reason':
                                                remarksController.text.trim(),
                                          },
                                          headers: await api.authHeaders(
                                            requestId: api.newRequestId(),
                                            json: true,
                                          ),
                                          tag: 'LEAVE_REVERSAL_SUBMIT',
                                        );
                                        final body = api.decodeMap(
                                          response.body,
                                        );
                                        if (!api.isSuccess(response)) {
                                          throw MobileApiException(
                                            'LEAVE_REVERSAL_SUBMIT_FAILED',
                                            message:
                                                body['message']?.toString(),
                                            statusCode: response.statusCode,
                                          );
                                        }
                                        if (!sheetContext.mounted) return;
                                        Navigator.of(sheetContext).pop();
                                        await getSharedPrfanceList();
                                        if (!mounted) return;
                                        _showMessage(
                                          body['message']?.toString() ??
                                              'Leave reversal submitted for approval.',
                                        );
                                      } catch (error) {
                                        if (!sheetContext.mounted) return;
                                        setSheetState(() => submitting = false);
                                        ScaffoldMessenger.of(
                                          sheetContext,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              error is MobileApiException
                                                  ? (error.message ??
                                                      'Unable to submit leave reversal.')
                                                  : 'Unable to submit leave reversal.',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                            icon:
                                submitting
                                    ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
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
    remarksController.dispose();
  }

  String _displayDate(String? value) {
    final rawValue = value?.trim() ?? '';
    final parsed = DateTime.tryParse(rawValue);
    if (parsed == null) return rawValue;
    return '${parsed.day.toString().padLeft(2, '0')}-'
        '${parsed.month.toString().padLeft(2, '0')}-${parsed.year}';
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  var titleName = "My Leave Requests";
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;

  List<Data> get _visibleRequests {
    final rows = selfLeaveRequisitionLabel?.data ?? const <Data>[];
    return rows.where((item) {
      final requestType = (item.requestType ?? '')
          .trim()
          .toUpperCase()
          .replaceAll('-', '_')
          .replaceAll(' ', '_');
      if (requestType == 'LEAVE_REVERSAL') return false;
      final itemStatus = (item.status ?? '').trim().toUpperCase();
      return value == 0
          ? _isPendingStatus(itemStatus)
          : _isApprovedStatus(itemStatus);
    }).toList();
  }

  bool _isPendingStatus(String status) {
    final normalized = status.trim().toUpperCase();
    return normalized.contains('PENDING') ||
        normalized == 'SUBMITTED' ||
        normalized == 'IN_PROGRESS' ||
        normalized == 'AWAITING_APPROVAL';
  }

  bool _isApprovedStatus(String status) {
    final normalized = status.trim().toUpperCase();
    return normalized.contains('APPROVED') &&
        !normalized.contains('DISAPPROVED');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
        elevation: 0.5,
        /*leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              //Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
            },
            icon: Icon(Icons.arrow_back_ios)),*/
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          bool internetCheck = await InternetConnectionChecker().hasConnection;
          if (internetCheck == false) {
            setState(() {
              AlertDialog(
                content: "Please check your internet connection".text.make(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please check your Internet connection."),
                ),
              );
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => LeaveRequisitionPage(showShortcuts: false),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
          }
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.add, color: Mythemes.whitish),
      ),

      body: Container(
        color: context.canvasColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<int>>[
                    ButtonSegment<int>(
                      value: 0,
                      icon: Icon(Icons.pending_actions, size: 18),
                      label: Text('Pending'),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      icon: Icon(Icons.task_alt, size: 18),
                      label: Text('Approved'),
                    ),
                  ],
                  selected: <int>{value},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      setState(() => value = selection.first);
                    }
                  },
                ),
              ),
            ),
            if (_loadingReversalId != null)
              const LinearProgressIndicator(minHeight: 3),
            /*  Row(
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
                        final text = const ['Pending', 'Approved'][local.index];
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
                          Navigator.pushNamed(context, MyRoutings.requestedRequisitionRoute);
                          //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                        }
                        if(value == 1) {
                          Navigator.pushNamed(context, MyRoutings.approvedLeaveReqListRoute);
                        }
                      },
                    )
                  ],
                ).py(4),*/
            /*  Expanded(
                  child: selfLeaveRequisitionLabel == null ?
                Center(
                    child: CircularProgressIndicator()):
                getSelfReqRequisitionList(selfLeaveRequisitionLabel!) ,
                )*/
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : (selfLeaveRequisitionLabel == null ||
                          _visibleRequests.isEmpty)
                      ? Center(
                        child: Text(
                          value == 0
                              ? 'No pending leave requisitions available.'
                              : 'No approved leave requisitions available.',
                        ),
                      )
                      : getSelfReqRequisitionList(selfLeaveRequisitionLabel!),
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
            //Navigator.of(context, rootNavigator: true).pop();
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

  getSelfReqRequisitionList(
    SelfLeaveRequisitionListModal selfLeaveRequisitionListModal,
  ) {
    final visibleRequests = _visibleRequests;
    return RefreshIndicator(
      onRefresh: getSharedPrfanceList,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: visibleRequests.length,
        itemBuilder: (context, index) {
          final leaveData = visibleRequests[index];
          final statusCheck = (leaveData.status ?? '').trim().toUpperCase();
          final isApproved = _isApprovedStatus(statusCheck);
          final reversalStatus =
              (leaveData.reversalStatus ?? '').trim().toUpperCase();
          final reversalPending = reversalStatus == 'PENDING';
          final fullyReversed = reversalStatus == 'REVERSED';
          final partiallyReversed = reversalStatus == 'PARTIALLY_REVERSED';
          final displayStatus =
              fullyReversed
                  ? 'REVERSED'
                  : partiallyReversed
                  ? 'PARTIALLY REVERSED'
                  : statusCheck;
          final canRequestReversal =
              isApproved && !reversalPending && !fullyReversed;
          final loadingReversal = _loadingReversalId == leaveData.leavereqId;

          return InkWell(
            onTap: () {
              leaveId = leaveData.leavereqId;

              if (_isPendingStatus(statusCheck)) {
                showDialgCancel(context, context, context);
              } else if (canRequestReversal) {
                _openLeaveReversal(leaveData);
              } else {
                Fluttertoast.showToast(
                  msg: "Your Requisition has already Disapproved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 4.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== Header Row: Name + Status + Attachment Icon =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child:
                              leaveData.empName.toString().text.bold.lg.make(),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isApproved ||
                                            fullyReversed ||
                                            partiallyReversed
                                        ? Colors.green.withOpacity(0.15)
                                        : _isPendingStatus(statusCheck)
                                        ? Colors.orange.withOpacity(0.15)
                                        : Colors.red.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                displayStatus,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isApproved ||
                                              fullyReversed ||
                                              partiallyReversed
                                          ? Colors.green
                                          : _isPendingStatus(statusCheck)
                                          ? Colors.orange
                                          : Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),

                    /// ===== Leave Type + Leave Length =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 6),
                            leaveData.leavetype.toString().text.semiBold.make(),
                          ],
                        ),
                        leaveData.leaveLength
                            .toString()
                            .text
                            .color(Colors.black87)
                            .bold
                            .make(),
                      ],
                    ).pSymmetric(v: 4),

                    const SizedBox(height: 4),

                    /// ===== Dates and Time Row =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildInfoColumn(
                            "Start Date",
                            _displayDate(leaveData.startDate),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoColumn(
                            "End Date",
                            _displayDate(leaveData.endDate),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoColumn(
                            "Leave Count",
                            leaveData.noOfDay.toString(),
                          ),
                        ),

                        /*Expanded(
                          child: _buildInfoColumn("In Time", leaveData.startTime.toString()),
                        ),
                        Expanded(
                          child: _buildInfoColumn("Out Time", leaveData.endTime.toString()),
                        ),*/
                      ],
                    ),

                    const SizedBox(height: 6),
                    if (_isPendingStatus(statusCheck)) ...[
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            leaveId = leaveData.leavereqId;
                            showDialgCancel(context, context, context);
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Cancel requisition'),
                          style: TextButton.styleFrom(
                            foregroundColor: Mythemes.dangerColor,
                          ),
                        ),
                      ),
                    ] else if (reversalPending) ...[
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hourglass_top,
                              size: 18,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Reversal request already applied',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (fullyReversed) ...[
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.task_alt, size: 18, color: Colors.green),
                            SizedBox(width: 6),
                            Text(
                              'Leave reversed',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (canRequestReversal) ...[
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed:
                              _loadingReversalId != null
                                  ? null
                                  : () => _openLeaveReversal(leaveData),
                          icon:
                              loadingReversal
                                  ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.undo, size: 18),
                          label: Text(
                            loadingReversal
                                ? 'Loading leave dates...'
                                : 'Request reversal',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Helper Widget to build column pairs (Label + Value)
  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.text.color(Colors.grey[600]!).size(12).make(),
        value.text.bold.center.color(Colors.black).make(),
      ],
    ).pSymmetric(h: 6);
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
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            //getSelfLeaveReqList(sessionId!);
            /*Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) =>
                        RequestedRequisitionList(SelfLeaveRequisitionListModal()),
                    transitionDuration: Duration(seconds: 1),
                    maintainState: true,
                  ));*/
            final id = int.tryParse(leaveId.toString());
            if (id != null) await cancelReqRequisitionList(id);
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

  /* void showDialgCancel(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      title: Row(
        children: [
          "Cancel Requisition".text.make(),
        ],
      ),
      content: Builder(
        builder: (context) {
          */ /* var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;*/ /*
          return Container(
            height:  15,
            width:  20,
            child: "Sure you want to cancel requisition?".text.make(),
          );
        },
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
                child: Container(
                  // color: Mythemes.lightBluishColor,
                  child: "No".text.color(Mythemes.dangerColorOne).make(),
                )
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (a, b, c) =>
                            RequestedRequisitionList(SelfLeaveRequisitionListModal()),
                        transitionDuration: Duration(seconds: 1),
                        maintainState: true,
                      ));
                  cancelReqRequisitionList(leaveId.toString());
                },
                child: Container(
                  // color: Mythemes.lightBluishColor,
                  child: "Yes".text.make(),
                )
            ),
          ],
        )
      ],
    );
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }*/

  Future<void> cancelReqRequisitionList(int leaveId) async {
    if (!mounted) return;
    CommonNotificationPage.showLoaderDialog(context);
    var loaderOpen = true;
    try {
      final foundation = MobileApiFoundation.instance;
      final response = await foundation.putJson(
        ApiDetails.mobileLeaveRequisitionCancel(leaveId),
        body: const <String, Object?>{'remarks': 'Cancelled by employee'},
        headers: await foundation.authHeaders(),
        tag: 'LEAVE_REQUISITION_CANCEL',
      );
      final responseBody = foundation.decodeMap(response.body);
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        loaderOpen = false;
      }
      if (!foundation.isSuccess(response)) {
        if (mounted) {
          showDialgSucess1(
            context,
            responseBody['message']?.toString() ??
                'Unable to cancel requisition',
            'Error',
          );
        }
        return;
      }
      if (mounted) {
        Fluttertoast.showToast(msg: 'Leave requisition cancelled');
        await getSharedPrfanceList();
      }
    } catch (error) {
      if (mounted) {
        if (!loaderOpen) {
          showDialgSucess1(
            context,
            error is MobileApiException
                ? (error.message ?? 'Unable to refresh requisitions')
                : 'Unable to refresh requisitions',
            'Error',
          );
          return;
        }
        Navigator.of(context, rootNavigator: true).pop();
        showDialgSucess1(
          context,
          error is MobileApiException
              ? (error.message ?? 'Unable to cancel requisition')
              : 'Unable to cancel requisition',
          'Error',
        );
      }
    }
  }

  showDialgSucess1(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text(alert)),
        ],
      ),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            /*Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) =>
                      RequestedRequisitionList(SelfLeaveRequisitionListModal()),
                  transitionDuration: Duration(seconds: 1),
                  maintainState: true,
                ));*/
            if (mounted) {
              Navigator.of(context, rootNavigator: true).pop();
              getSharedPrfanceList();
            }
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
}
