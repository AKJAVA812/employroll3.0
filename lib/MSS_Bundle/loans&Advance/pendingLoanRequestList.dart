import 'dart:convert';
import 'dart:math';
import 'package:er_flutter_project/MSS_Bundle/loans&Advance/loanApprovalPage.dart';
import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:er_flutter_project/ess/essDashboardNavigate.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/travelExpenseAdd/travelExpenseRequestRaise.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/travelExpenseAdd/updateRaisedClaim.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';

import '../../../adminPage/modelClass/dashboardModel.dart';
import '../../../adminPage/mssDashboard.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../main.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../ess/loan&Advance/myLoanRequestRaisePage.dart';
import '../../ess/loan&Advance/myLoanRequestUpdate.dart';
import 'modalClass/mssLoanListModal.dart';

class PendingLoanRequestList extends StatefulWidget {
  const PendingLoanRequestList({Key? key}) : super(key: key);

  @override
  State<PendingLoanRequestList> createState() => _PendingLoanRequestListState();
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
dynamic userPanel;
dynamic getProfileId;
dynamic loanReqIdSend;

List<LoanRequiDataforOthers>? allUsernew = [];
List<LoanRequiDataforOthers>? foundDataNew = [];

String? empName = "";
String? status = "";
String? reimbName = "";
String? raisedOn = "";
String? catName = "";
dynamic claimedAmt = "";
dynamic approvedAmount = "";
MSSLoanListModal? mssLoanListLabel;
MSSLoanListModal? mssLoanListLabeled;

dynamic totalDraftAmt;
dynamic totalDisapprovedAmt;
dynamic totalApprovedAmt;
dynamic totalPendingAmt;

dynamic deptName;
dynamic branchName;
dynamic loanType;
dynamic loanAmount;
dynamic loanStartDate;
dynamic instalments;
dynamic loanIdSend;

dynamic statusCheck;

var draftShow = true;
var pendingShow = false;
var approveShow = false;
var disApproveShow = false;

bool isLoading = true;
bool isLoadingCount = true;

class _PendingLoanRequestListState extends State<PendingLoanRequestList>
    with RouteAware {
  late ScrollController _controller;

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

    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }

  @override
  void didUpdateWidget(covariant PendingLoanRequestList oldWidget) {
    //getSharedPrfanceList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    getProfileId = await shared!.getDefaultProfileId();
    // await Future.delayed(Duration(seconds: 5));
    Future<MSSLoanListModal> getEmployeeList11 = getMSSLoanList(sessionId!);
    isLoading = true;
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        mssLoanListLabel = value;
        mssLoanListLabeled = mssLoanListLabel;
        isLoading = false;
        print('MSS LOAN LIST - ${foundDataNew!.length}');
      });
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

  Future<MSSLoanListModal> getMSSLoanList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.mssLoanListApi;
    print('employeeList11: ${SessionId}');
    MSSLoanListModal mssLoanListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "status=$statusChange&"
      "permission=$userPanel&"
      "profId=$getProfileId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');
    setState(() {
      isLoadingCount = true;
      isLoading = true;
    });
    print('URL ${response.request}');
    mapResponse = json.decode(response.body);
    print('responseemployeeList $mapResponse');
    var getData = mapResponse.length;
    if (getData == 0) {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }
    mssLoanListModal = MSSLoanListModal.fromJson(mapResponse);
    totalDisapprovedAmt = mssLoanListModal.disApprovedValue;
    totalApprovedAmt = mssLoanListModal.approvedValue;
    totalPendingAmt = mssLoanListModal.pendingAmount;

    allUsernew = mssLoanListModal.loanRequiDataforOthers;

    setState(() {
      isLoadingCount = false;
      isLoading = false;
    });

    return mssLoanListModal;
  }

  Future<void> deleteLoanRequest(BuildContext context) async {
    // âœ… Proceed with the API call if both checks pass
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanRequestDeleteApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['loanReqId'] = loanIdSend.toString();

    try {
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Status Code: ${httpResponse.statusCode}');
      print('Response: ${httpResponse.body}');

      Navigator.of(context, rootNavigator: true).pop();

      if (httpResponse.statusCode == 200) {
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      }
    } catch (e) {
      print('âŒ Exception during API call: $e');
    }
  }

  showDialgSucess(BuildContext buildContext, String result, String alert) {
    if (buildContext == null) {
      print("âš ï¸ Warning: buildContext is null, cannot show dialog.");
      return;
    }

    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(children: [Expanded(child: Text(alert))]),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  // âœ… Using `context` inside the builder
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(); // Close the dialog
                  getSharedPrfanceList();
                  //Navigator.of(buildContext).maybePop();
                } else {
                  print("âš ï¸ Warning: No route to close.");
                }
              },
              child: Text("Ok"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }

  dynamic levelOnePendingStatus = false;
  dynamic levelTwoPendingStatus = false;
  dynamic levelThreePendingStatus = false;
  dynamic levelFourPendingStatus = false;
  dynamic levelFivePendingStatus = false;

  var statusChange = "LEVEL_ONE_PENDING";
  int valueChange = 0;
  var titleName = "Pending Loan Requisitions";
  TextEditingController searchType = TextEditingController();
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
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
                //_runFilter(value);
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

      /*floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoanRequestPage()));
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.add, color: Mythemes.whitish,),
      ),*/
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
            print('home tab');
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EssAdminDashboardHead(EssDashboarrdModel()),
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
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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

      body: Container(
        color: context.canvasColor,
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(6.0),
              crossAxisCount: 3,
              children: <Widget>[
                Hero(
                  tag: 'AP',
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
                            child:
                                isLoadingCount
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "â‚¹$totalPendingAmt".text.bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            child:
                                isLoadingCount
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "â‚¹$totalApprovedAmt".text.bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            child:
                                isLoadingCount
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "â‚¹$totalDisapprovedAmt".text.bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
                          ),
                          Center(
                            child: Container(
                              //margin: EdgeInsets.only(top: 70, left: 10),
                              //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'Disapproved',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Mythemes.whitish,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                AnimatedToggleSwitch<int>.size(
                  height: 30,
                  current: min(valueChange, 5),
                  style: ToggleStyle(
                    backgroundColor: Mythemes.greyishade,
                    indicatorColor: Mythemes.lightBluishColor,
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    indicatorBorderRadius: BorderRadius.zero,
                  ),
                  values: const [0, 1, 2, 3, 4],
                  iconOpacity: 1.0,
                  selectedIconScale: 1.0,
                  indicatorSize: const Size.fromWidth(65),
                  iconAnimationType: AnimationType.onHover,
                  styleAnimationType: AnimationType.onHover,
                  spacing: 4.0,
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
                        const ['L1', 'L2', 'L3', 'Approve', 'Rejected'][local
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
                  onChanged: (i) async {
                    setState(() {
                      isLoading = true;
                      isLoadingCount = true;
                      valueChange = i;
                    });

                    // Set the appropriate status
                    switch (valueChange) {
                      case 0:
                        statusChange = "LEVEL_ONE_PENDING";
                        break;
                      case 1:
                        statusChange = "LEVEL_TWO_PENDING";
                        break;
                      case 2:
                        statusChange = "LEVEL_THREE_PENDING";
                        break;
                      case 3:
                        statusChange = "APPROVED";
                        break;
                      case 4:
                        statusChange = "DISAPPROVED";
                        break;
                    }

                    // Await the data load
                    await getSharedPrfanceList();

                    // Then stop the loader
                    setState(() {
                      isLoading = false;
                      isLoadingCount = false;
                    });
                  },
                ),
              ],
            ).py(4),

            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (mssLoanListLabeled == null ||
                          foundDataNew == null ||
                          foundDataNew!.isEmpty)
                      ? const Center(child: Text("No Data Available"))
                      : getLoanSelfReqList(mssLoanListLabeled!),
            ),
          ],
        ),
      ),
    );
  }

  getLoanSelfReqList(MSSLoanListModal mssLoanListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => PendingLoanRequestList(),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              //controller: _controller,
              itemCount: foundDataNew!.length,
              itemBuilder: (context, i) {
                foundDataNew![i].status;
                print(foundDataNew![i].status);

                return InkWell(
                  onTap: () {
                    loanReqIdSend = foundDataNew![i].loanReqId;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                LoanApprovalPage(loanReqId: loanReqIdSend),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Amount and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "â‚¹ ${foundDataNew![i].loanAmount}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${foundDataNew![i].statusShow}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          //Employee Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Employee Name",
                                style: TextStyle(
                                  color: Mythemes.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${foundDataNew![i].empName}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Requested Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Requested On",
                                style: TextStyle(
                                  color: Mythemes.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${foundDataNew![i].date}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // installments
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Requested Installments",
                                style: TextStyle(
                                  color: Mythemes.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${foundDataNew![i].installment}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // loanType
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Loan Type",
                                style: TextStyle(
                                  color: Mythemes.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${foundDataNew![i].loanType}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  color: Mythemes.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "â‚¹ ${foundDataNew![i].loanAmount}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Note
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Loan not approved yet",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          //const SizedBox(height: 8),

                          // Loan Installments Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                loanIdSend = foundDataNew![i].loanReqId;
                                deleteLoanRequest(context);
                              },
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text("Delete Loan"),
                              style: TextButton.styleFrom(
                                foregroundColor: Mythemes.dangerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).pLTRB(10, 10, 10, 5),
                );
              },
            ),
          ),
        ],
      ),
    );

    /*if(foundDataNew == []) {
      print("FETCH NEW DATA");
      Center(
        child: "There is no data availabel right now".text.make(),
      );
    }*/
  }
}
