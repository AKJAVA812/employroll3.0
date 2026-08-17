import 'dart:convert';
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
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../leaveRequisition/leaveRequisitionPage.dart';
import '../modalClass/selfLeaveRequisitionModal.dart';

class RequestedRequisitionList extends StatefulWidget {
  final SelfLeaveRequisitionListModal selfLeaveRequisitionListModal;
  const RequestedRequisitionList(this.selfLeaveRequisitionListModal, {super.key});

  @override
  State<RequestedRequisitionList> createState() =>
      _RequestedRequisitionListState(selfLeaveRequisitionListModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

SelfLeaveRequisitionListModal? selfLeaveRequisitionLabel;

class _RequestedRequisitionListState extends State<RequestedRequisitionList>
    with RouteAware {
  final SelfLeaveRequisitionListModal selfLeaveRequisitionListModal;
  _RequestedRequisitionListState(this.selfLeaveRequisitionListModal);

  var status;
  var leaveId;

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
    // await Future.delayed(Duration(seconds: 5));

    Future<SelfLeaveRequisitionListModal> getAppReq11 = getSelfLeaveReqList(
      sessionId!,
    );
    setState(() {});
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        selfLeaveRequisitionLabel = value;
      });
      if (selfLeaveRequisitionLabel?.data != null) {
      } else {
      }
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
  Future<SelfLeaveRequisitionListModal> getSelfLeaveReqList(
    String SessionId,
  ) async {
    setState(() {
      _isLoading = true;
    });
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
      if (mounted) setState(() => _isLoading = false);
      return model;
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
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

  var titleName = "My Leave Requests";
  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;
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
                          selfLeaveRequisitionLabel!.data == null ||
                          selfLeaveRequisitionLabel!.data!.isEmpty)
                      ? Center(
                        child: Text(
                          'No leave requisitions available.',
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
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) =>
                    RequestedRequisitionList(SelfLeaveRequisitionListModal()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: selfLeaveRequisitionListModal.data!.length,
        itemBuilder: (context, index) {
          final leaveData = selfLeaveRequisitionListModal.data![index];
          final statusCheck = leaveData.status.toString();

          return InkWell(
            onTap: () {
              leaveId = leaveData.leavereqId;

              if (statusCheck == 'Level_One_Pending' ||
                  statusCheck == 'Level_Two_Pending' ||
                  statusCheck == 'PENDING') {
                showDialgCancel(context, context, context);
              } else if (statusCheck == 'APPROVED') {
                Fluttertoast.showToast(
                  msg: "Your Requisition has already Approved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
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
                                    statusCheck == 'APPROVED'
                                        ? Colors.green.withOpacity(0.15)
                                        : statusCheck.contains('PENDING')
                                        ? Colors.orange.withOpacity(0.15)
                                        : Colors.red.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusCheck,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      statusCheck == 'APPROVED'
                                          ? Colors.green
                                          : statusCheck.contains('PENDING')
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
                            leaveData.startDate.toString(),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoColumn(
                            "End Date",
                            leaveData.endDate.toString(),
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
            Navigator.of(buildContext).pop();
          },
          child: Container(
            // color: Mythemes.lightBluishColor,
            child: Text("No", style: TextStyle(color: Mythemes.dangerColor)),
          ),
        ),
        TextButton(
          onPressed: () {
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
            cancelReqRequisitionList(leaveId.toString());
            getSharedPrfanceList();
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

  Future<void> cancelReqRequisitionList(String leaveId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.cancelReqRequisition;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "leaveId=$leaveId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    if (response.statusCode == 200) {
      var responseResult = response.body;
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      //Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = mapResponse['reason'];
      if (result.compareToIgnoringCase("success") == 0) {
        if (mounted) {
          showDialgSucess1(context, "${reason.upperCamelCase} ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          showDialgSucess1(context, reason.upperCamelCase, " Error ");
        }
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
