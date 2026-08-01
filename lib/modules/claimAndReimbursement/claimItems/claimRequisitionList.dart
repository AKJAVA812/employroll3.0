import 'dart:convert';
import 'dart:math';
import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:er_flutter_project/ess/essDashboardNavigate.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/travelExpenseAdd/travelExpenseRequestRaise.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/travelExpenseAdd/updateRaisedClaim.dart';
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
import '../newModalClasses/selfClaimRequisitionListModal.dart';

class ClaimRequisitionList extends StatefulWidget {
  const ClaimRequisitionList({Key? key}) : super(key: key);

  @override
  State<ClaimRequisitionList> createState() => _ClaimRequisitionListState();
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<DataNew>? allUsernew = [];
List<DataNew>? foundDataNew = [];
List<ClaimRequisitionDraftlist>? allUsernewDraft = [];
List pendingData = [];
List<ClaimRequisitionPendinglist>? allUsernewPending = [];
List<ClaimRequisitionApprovedlist>? allUsernewApproved = [];
List<ClaimRequisitionDisapprovelist>? allUsernewDisapproved = [];
List<ClaimRequisitionDraftlist>? foundDataNewDraft = [];
List<ClaimRequisitionPendinglist>? foundDataNewPending = [];
List<ClaimRequisitionApprovedlist>? foundDataNewApproved = [];
List<ClaimRequisitionDisapprovelist>? foundDataNewDisapproved = [];
String? empName = "";
String? status = "";
String? reimbName = "";
String? raisedOn = "";
String? catName = "";
dynamic claimedAmt = "";
dynamic approvedAmount = "";
ClaimRequisitionModal? claimRequisitionLabel;
ClaimRequisitionModal? claimRequisitionLabeled;
String reimbursementType = "";
String reimbursementTypeId = "";
String expCategory = "";
String expCategoryIdNew = "";
String subExpCategory = "";
String subExpCategoryIdNew = "";
String travelFrom = "";
String travelTo = "";
String odometerStart = "";
String odometerEnd = "";
String merchant = "";
String kilometers = "";
String month = "";
String claimDate = "";
String claimedAmount = "";
String remarks = "";
String documents = "";
String claimIdChecking = "";
dynamic totalDraftAmt;
dynamic totalSubmitAmt;
dynamic totalApprovedAmt;
dynamic totalPendingAmt;

var draftShow = true;
var pendingShow = false;
var approveShow = false;
var disApproveShow = false;

bool isLoading = false;
bool isLoadingCount = true;

late ClaimRequisitionModal globalListParameter;

class _ClaimRequisitionListState extends State<ClaimRequisitionList>
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
  void didUpdateWidget(covariant ClaimRequisitionList oldWidget) {
    //getSharedPrfanceList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<ClaimRequisitionModal> getEmployeeList11 = getSelfReqList(
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
        if (valueChange == 0) {
          foundDataNewDraft = allUsernewDraft;
        }
        if (valueChange == 1) {
          foundDataNewPending = allUsernewPending;
        }
        if (valueChange == 2) {
          foundDataNewApproved = allUsernewApproved;
        }
        if (valueChange == 3) {
          foundDataNewDisapproved = allUsernewDisapproved;
        }

        claimRequisitionLabel = value;
        claimRequisitionLabeled = claimRequisitionLabel;
      });
      print(
        'Draft LIST - ${claimRequisitionLabel!.claimRequisitionDraftlist!.length}',
      );
      print(
        'Pending LIST - ${claimRequisitionLabel!.claimRequisitionPendinglist!.length}',
      );
      print(
        'Approved LIST - ${claimRequisitionLabel!.claimRequisitionApprovedlist!.length}',
      );
      print(
        'Disapproved LIST - ${claimRequisitionLabel!.claimRequisitionDisapprovelist!.length}',
      );
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

  Future<ClaimRequisitionModal> getSelfReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.selfClaimRequestListApi;
    print('employeeList11: ${SessionId}');
    ClaimRequisitionModal claimRequisitionModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');
    setState(() {
      isLoadingCount = true;
    });
    print('URL ${response.request}');
    mapResponse = json.decode(response.body);
    print('responseemployeeList $mapResponse');
    var getData = mapResponse.length;
    if (getData == 0) {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }

    claimRequisitionModal = ClaimRequisitionModal.fromJson(mapResponse);
    /* for (int i = 0; i < claimRequisitionModal.claimRequisitionPendinglist!.length; i++) {
      empName = mapResponse['claimRequisitionPendinglist'][i]['empName'];
      print("EMP NAME - $empName");
    }*/
    // globalListParameter = claimRequisitionModal.claimRequisitionApprovedlist;
    totalDraftAmt = claimRequisitionModal.totaDraftAmount;
    totalSubmitAmt = claimRequisitionModal.submittedValue;
    totalApprovedAmt = claimRequisitionModal.approvedValue;
    totalPendingAmt = claimRequisitionModal.pendingAmount;
    if (valueChange == 0) {
      allUsernewDraft = claimRequisitionModal.claimRequisitionDraftlist!;
    }

    if (valueChange == 1) {
      allUsernewPending = claimRequisitionModal.claimRequisitionPendinglist!;
    }
    if (valueChange == 2) {
      allUsernewApproved = claimRequisitionModal.claimRequisitionApprovedlist!;
    }
    if (valueChange == 3) {
      allUsernewDisapproved =
          claimRequisitionModal.claimRequisitionDisapprovelist!;
    }
    setState(() {
      isLoadingCount = false;
    });

    print("Pending List -  ${pendingData.length.toString()}");

    return claimRequisitionModal;
  }

  dynamic levelOnePendingStatus = false;
  dynamic levelTwoPendingStatus = false;
  dynamic levelThreePendingStatus = false;
  dynamic levelFourPendingStatus = false;
  dynamic levelFivePendingStatus = false;

  int valueChange = 0;
  var titleName = "My Claim Requisitions";
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

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TravelExpenseRequestRaise(),
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
                            child:
                                isLoadingCount
                                    ? CircularProgressIndicator(
                                      color: Mythemes.whitish,
                                    ) // Loader when fetching data
                                    : "â‚¹$totalDraftAmt".text.bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
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
                    color: Mythemes.lightBluishColor,
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
                                    : "â‚¹$totalSubmitAmt".text.bold
                                        .color(Mythemes.whitish)
                                        .size(16)
                                        .make(),
                          ),
                          Center(
                            child: Container(
                              //margin: EdgeInsets.only(top: 70, left: 10),
                              //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'Submit',
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
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedToggleSwitch<int>.size(
                  height: 30,
                  current: min(valueChange, 4),
                  style: ToggleStyle(
                    backgroundColor: Mythemes.greyishade,
                    indicatorColor: Mythemes.lightBluishColor,
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    indicatorBorderRadius: BorderRadius.zero,
                  ),
                  values: const [0, 1, 2, 3],
                  iconOpacity: 1.0,
                  selectedIconScale: 1.0,
                  indicatorSize: const Size.fromWidth(80),
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
                        const [
                          'Draft',
                          'Pending',
                          'Approved',
                          'Disapprove',
                        ][local.index];
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
                      isLoading = true; // Show loader
                      isLoadingCount = true;
                      valueChange = i;
                      print(i);
                    });
                    //Draft
                    if (valueChange == 0) {
                      allUsernewDraft;
                      getSharedPrfanceList();
                      setState(() {
                        isLoading = false; // Hide loader
                        isLoadingCount = false;
                      });
                      //globalListParameter = claimRequisitionModal.claimRequisitionDraftlist!;
                      //print("length 0 - ${globalListParameter.length}");
                    }
                    //
                    if (valueChange == 1) {
                      allUsernewPending;
                      getSharedPrfanceList();
                      setState(() {
                        isLoading = false; // Hide loader
                        isLoadingCount = false;
                      });
                      //globalListParameter = claimRequisitionModal.claimRequisitionDraftlist!;
                      //print("length 1-  ${globalListParameter.length}");
                    }
                    //
                    if (valueChange == 2) {
                      allUsernewApproved;
                      getSharedPrfanceList();
                      setState(() {
                        isLoading = false; // Hide loader
                        isLoadingCount = false;
                      });
                    }
                    //
                    if (valueChange == 3) {
                      allUsernewDisapproved;
                      getSharedPrfanceList();
                      setState(() {
                        isLoading = false; // Hide loader
                        isLoadingCount = false;
                      });
                    }
                  },
                ),
              ],
            ).py(4),

            Expanded(
              child:
                  isLoading
                      ? Center(
                        child: CircularProgressIndicator(),
                      ) // Show loader
                      : claimRequisitionLabeled == null
                      ? Center(child: Text("No Data Available"))
                      : getClaimSelfReqList(claimRequisitionLabeled!),
            ),
          ],
        ),
      ),
    );
  }

  getClaimSelfReqList(ClaimRequisitionModal claimRequisitionModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => ClaimRequisitionList(),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: Column(
        children: [
          Visibility(
            visible: valueChange == 0,
            child: Expanded(
              child: ListView.builder(
                //controller: _controller,
                itemCount: foundDataNewDraft!.length,
                itemBuilder: (context, i) {
                  foundDataNewDraft![i].status;
                  print(foundDataNewDraft![i].status);
                  return InkWell(
                    onTap: () {
                      foundDataNewDraft![i].claimRaiseId;
                      reimbursementType =
                          foundDataNewDraft![i].reimbName!.toString();
                      reimbursementTypeId =
                          foundDataNewDraft![i].reimbId!.toString();
                      expCategory = foundDataNewDraft![i].expName!.toString();
                      expCategoryIdNew =
                          foundDataNewDraft![i].expId!.toString();
                      subExpCategory =
                          foundDataNewDraft![i].subExpName!.toString();
                      subExpCategoryIdNew =
                          foundDataNewDraft![i].subExpId!.toString();
                      travelFrom = foundDataNewDraft![i].travelFrom!.toString();
                      travelTo = foundDataNewDraft![i].travelTo!.toString();
                      odometerStart =
                          foundDataNewDraft![i].odometerStart!.toString();
                      odometerEnd =
                          foundDataNewDraft![i].odometerEnd!.toString();
                      merchant = foundDataNewDraft![i].merchant!.toString();
                      kilometers = foundDataNewDraft![i].kilometers!.toString();
                      month = foundDataNewDraft![i].month!.toString();
                      claimDate = foundDataNewDraft![i].reqDate!.toString();
                      claimedAmount =
                          foundDataNewDraft![i].claimedAmt!.toString();
                      remarks = foundDataNewDraft![i].remarks!.toString();
                      documents = foundDataNewDraft![i].document!.toString();
                      claimIdChecking =
                          foundDataNewDraft![i].claimRaiseId!.toString();
                      print("Claim id - ${foundDataNewDraft![i].claimRaiseId}");

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => TravelExpenseRequestUpdate(
                                reimbursementType,
                                reimbursementTypeId,
                                expCategory,
                                expCategoryIdNew,
                                subExpCategory,
                                subExpCategoryIdNew,
                                travelFrom,
                                travelTo,
                                odometerStart,
                                odometerEnd,
                                merchant,
                                kilometers,
                                month,
                                claimDate,
                                claimedAmount,
                                remarks,
                                documents,
                                claimIdChecking,
                              ),
                        ),
                      );
                      /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TravelExpenseRequestRaise()));*/
                    },
                    child:
                        Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Row(
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
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            foundDataNewDraft![i].status ==
                                                    "DRAFT"
                                                ? Mythemes.greyishade
                                                : Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              foundDataNewDraft![i].status ==
                                                      "DRAFT"
                                                  ? Mythemes.greyishade
                                                  : Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      //why index+1 we want to turn the ligne orange that precede the active bubble
                                      color:
                                          foundDataNewDraft![i].status ==
                                                  "DRAFT"
                                              ? Mythemes.greyishade
                                              : Mythemes.successColor,
                                    ),
                                  ),

                                  //step two
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            foundDataNewDraft![i].status ==
                                                    "DRAFT"
                                                ? Mythemes.greyishade
                                                : Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              foundDataNewDraft![i].status ==
                                                      "DRAFT"
                                                  ? Mythemes.greyishade
                                                  : Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          foundDataNewDraft![i].status ==
                                                  "DRAFT"
                                              ? Mythemes.greyishade
                                              : Mythemes.successColor,
                                    ),
                                  ),

                                  //step Three
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            foundDataNewDraft![i].status ==
                                                    "DRAFT"
                                                ? Mythemes.greyishade
                                                : Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              foundDataNewDraft![i].status ==
                                                      "DRAFT"
                                                  ? Mythemes.greyishade
                                                  : Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          foundDataNewDraft![i].status ==
                                                  "DRAFT"
                                              ? Mythemes.greyishade
                                              : Mythemes.successColor,
                                    ),
                                  ),

                                  //step Four
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            foundDataNewDraft![i].status ==
                                                    "DRAFT"
                                                ? Mythemes.greyishade
                                                : Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              foundDataNewDraft![i].status ==
                                                      "DRAFT"
                                                  ? Mythemes.greyishade
                                                  : Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          foundDataNewDraft![i].status ==
                                                  "DRAFT"
                                              ? Mythemes.greyishade
                                              : Mythemes.successColor,
                                    ),
                                  ),

                                  //step Five
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            foundDataNewDraft![i].status ==
                                                    "DRAFT"
                                                ? Mythemes.greyishade
                                                : Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              foundDataNewDraft![i].status ==
                                                      "DRAFT"
                                                  ? Mythemes.greyishade
                                                  : Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).p8(),
                              Row(
                                children: [
                                  foundDataNewDraft![i].empName
                                      .toString()
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        foundDataNewDraft![i].statusShow
                                            .toString()
                                            .text
                                            .bold
                                            .color(Mythemes.alertColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                              Row(
                                children: [
                                  foundDataNewDraft![i].reimbName
                                      .toString()
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  /*Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            "Segment Type - $segmentType".text.make().px8(),

                                          ],
                                        )

                                    )*/
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                              Row(
                                children: [
                                  "Raised On- ${foundDataNewDraft![i].raisedOn.toString()}"
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Category - ${foundDataNewDraft![i].catName.toString()}"
                                            .text
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                              Row(
                                children: [
                                  "Claimed Amount - ${foundDataNewDraft![i].claimedAmt.toString()}"
                                      .text
                                      .bold
                                      .color(Mythemes.lightBluishColor)
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Approved Amount - ${foundDataNewDraft![i].approvedAmount.toString()}"
                                            .text
                                            .bold
                                            .color(Mythemes.successColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                            ],
                          ),
                        ).p4(),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: valueChange == 1,
            child: Expanded(
              child: ListView.builder(
                //controller: _controller,
                itemCount: foundDataNewPending!.length,
                itemBuilder: (context, i) {
                  print(foundDataNewPending![i].status);
                  bool levelOnePendingStatus = false;
                  bool levelTwoPendingStatus = false;
                  bool levelThreePendingStatus = false;
                  bool levelFourPendingStatus = false;
                  bool levelFivePendingStatus = false;

                  // Update level statuses based on API response
                  if (foundDataNewPending![i].status == "LEVEL_ONE_PENDING") {
                    levelOnePendingStatus = true;
                  }
                  if (foundDataNewPending![i].status == "LEVEL_TWO_PENDING") {
                    levelOnePendingStatus = true;
                    levelTwoPendingStatus = true;
                  }
                  if (foundDataNewPending![i].status == "LEVEL_THREE_PENDING") {
                    levelOnePendingStatus = true;
                    levelTwoPendingStatus = true;
                    levelThreePendingStatus = true;
                  }
                  if (foundDataNewPending![i].status == "LEVEL_FOUR_PENDING") {
                    levelOnePendingStatus = true;
                    levelTwoPendingStatus = true;
                    levelThreePendingStatus = true;
                    levelFourPendingStatus = true;
                  }
                  if (foundDataNewPending![i].status == "LEVEL_FIVE_PENDING") {
                    levelOnePendingStatus = true;
                    levelTwoPendingStatus = true;
                    levelThreePendingStatus = true;
                    levelFourPendingStatus = true;
                    levelFivePendingStatus = true;
                  }

                  // Print the statuses for debugging
                  print("Level 1 Pending: $levelOnePendingStatus");
                  print("Level 2 Pending: $levelTwoPendingStatus");
                  print("Level 3 Pending: $levelThreePendingStatus");
                  print("Level 4 Pending: $levelFourPendingStatus");
                  print("Level 5 Pending: $levelFivePendingStatus");
                  return InkWell(
                    onTap: () {
                      foundDataNewDraft![i].claimRaiseId;
                      reimbursementType =
                          foundDataNewPending![i].reimbName!.toString();
                      reimbursementTypeId =
                          foundDataNewPending![i].reimbId!.toString();
                      expCategory = foundDataNewPending![i].expName!.toString();
                      expCategoryIdNew =
                          foundDataNewPending![i].expId!.toString();
                      subExpCategory =
                          foundDataNewPending![i].subExpName!.toString();
                      subExpCategoryIdNew =
                          foundDataNewPending![i].subExpId!.toString();
                      travelFrom =
                          foundDataNewPending![i].travelFrom!.toString();
                      travelTo = foundDataNewPending![i].travelTo!.toString();
                      odometerStart =
                          foundDataNewPending![i].odometerStart!.toString();
                      odometerEnd =
                          foundDataNewPending![i].odometerEnd!.toString();
                      merchant = foundDataNewPending![i].merchant!.toString();
                      kilometers =
                          foundDataNewPending![i].kilometers!.toString();
                      month = foundDataNewPending![i].month!.toString();
                      claimDate = foundDataNewPending![i].reqDate!.toString();
                      claimedAmount =
                          foundDataNewPending![i].claimedAmt!.toString();
                      remarks = foundDataNewPending![i].remarks!.toString();
                      documents = foundDataNewPending![i].document!.toString();
                      claimIdChecking =
                          foundDataNewPending![i].claimRaiseId!.toString();
                      print(
                        "Claim id - ${foundDataNewPending![i].claimRaiseId}",
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => TravelExpenseRequestUpdate(
                                reimbursementType,
                                reimbursementTypeId,
                                expCategory,
                                expCategoryIdNew,
                                subExpCategory,
                                subExpCategoryIdNew,
                                travelFrom,
                                travelTo,
                                odometerStart,
                                odometerEnd,
                                merchant,
                                kilometers,
                                month,
                                claimDate,
                                claimedAmount,
                                remarks,
                                documents,
                                claimIdChecking,
                              ),
                        ),
                      );
                      /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TravelExpenseRequestRaise()));*/
                    },
                    child:
                        Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Row(
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
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            levelOnePendingStatus == true
                                                ? Mythemes.alertColor
                                                : Mythemes.greyishade,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              levelOnePendingStatus == true
                                                  ? Mythemes.alertColor
                                                  : Mythemes.greyishade,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      //why index+1 we want to turn the ligne orange that precede the active bubble
                                      color:
                                          levelOnePendingStatus == true
                                              ? Mythemes.alertColor
                                              : Mythemes.greyishade,
                                    ),
                                  ),

                                  //step two
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            levelTwoPendingStatus == true
                                                ? Mythemes.alertColor
                                                : Mythemes.greyishade,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              levelTwoPendingStatus == true
                                                  ? Mythemes.alertColor
                                                  : Mythemes.greyishade,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          levelTwoPendingStatus == true
                                              ? Mythemes.alertColor
                                              : Mythemes.greyishade,
                                    ),
                                  ),

                                  //step Three
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            levelThreePendingStatus == true
                                                ? Mythemes.alertColor
                                                : Mythemes.greyishade,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              levelThreePendingStatus == true
                                                  ? Mythemes.alertColor
                                                  : Mythemes.greyishade,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          levelThreePendingStatus == true
                                              ? Mythemes.alertColor
                                              : Mythemes.greyishade,
                                    ),
                                  ),

                                  //step Four
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            levelFourPendingStatus == true
                                                ? Mythemes.alertColor
                                                : Mythemes.greyishade,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              levelFourPendingStatus == true
                                                  ? Mythemes.alertColor
                                                  : Mythemes.greyishade,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          levelFourPendingStatus == true
                                              ? Mythemes.alertColor
                                              : Mythemes.greyishade,
                                    ),
                                  ),

                                  //step Five
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            levelFivePendingStatus == true
                                                ? Mythemes.alertColor
                                                : Mythemes.greyishade,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color:
                                              levelFivePendingStatus == true
                                                  ? Mythemes.alertColor
                                                  : Mythemes.greyishade,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).p8(),
                              Row(
                                children: [
                                  foundDataNewPending![i].empName
                                      .toString()
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        foundDataNewPending![i].statusShow
                                            .toString()
                                            .text
                                            .bold
                                            .color(Mythemes.alertColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),

                              Row(
                                children: [
                                  "Raised On- ${foundDataNewPending![i].raisedOn.toString()}"
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Category - ${foundDataNewPending![i].catName.toString()}"
                                            .text
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                              Row(
                                children: [
                                  "Claimed Amount - ${foundDataNewPending![i].claimedAmt.toString()}"
                                      .text
                                      .bold
                                      .color(Mythemes.lightBluishColor)
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Approved Amount - ${foundDataNewPending![i].approvedAmount.toString()}"
                                            .text
                                            .bold
                                            .color(Mythemes.successColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                            ],
                          ),
                        ).p4(),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: valueChange == 2,
            child: Expanded(
              child: ListView.builder(
                //controller: _controller,
                itemCount: foundDataNewApproved!.length,
                itemBuilder: (context, i) {
                  /* foundDataNew![i].empName == null ? empName = "" :  empName = foundDataNew![i].empName;
                    foundDataNew![i].status == null ? status = "" : status = foundDataNew![i].status;
                    foundDataNew![i].reimbName == null ? reimbName = "" : reimbName = foundDataNew![i].reimbName;
                    foundDataNew![i].raisedOn == null ? raisedOn = "" : raisedOn = foundDataNew![i].raisedOn;
                    foundDataNew![i].catName == null ? catName = "" : catName = foundDataNew![i].catName;
                    foundDataNew![i].claimedAmt == null ? claimedAmt = "" : claimedAmt = foundDataNew![i].claimedAmt;
                    foundDataNew![i].approvedAmount == null ? approvedAmount = "" : approvedAmount = foundDataNew![i].approvedAmount;*/

                  return InkWell(
                    onTap: () {
                      foundDataNewApproved![i].claimRaiseId;
                      reimbursementType =
                          foundDataNewApproved![i].reimbName!.toString();
                      reimbursementTypeId =
                          foundDataNewApproved![i].reimbId!.toString();
                      expCategory =
                          foundDataNewApproved![i].expName!.toString();
                      expCategoryIdNew =
                          foundDataNewApproved![i].expId!.toString();
                      subExpCategory =
                          foundDataNewApproved![i].subExpName!.toString();
                      subExpCategoryIdNew =
                          foundDataNewApproved![i].subExpId!.toString();
                      travelFrom =
                          foundDataNewApproved![i].travelFrom!.toString();
                      travelTo = foundDataNewApproved![i].travelTo!.toString();
                      odometerStart =
                          foundDataNewApproved![i].odometerStart!.toString();
                      odometerEnd =
                          foundDataNewApproved![i].odometerEnd!.toString();
                      merchant = foundDataNewApproved![i].merchant!.toString();
                      kilometers =
                          foundDataNewApproved![i].kilometers!.toString();
                      month = foundDataNewApproved![i].month!.toString();
                      claimDate = foundDataNewApproved![i].reqDate!.toString();
                      claimedAmount =
                          foundDataNewApproved![i].claimedAmt!.toString();
                      remarks = foundDataNewApproved![i].remarks!.toString();
                      documents = foundDataNewApproved![i].document!.toString();
                      claimIdChecking =
                          foundDataNewApproved![i].claimRaiseId!.toString();
                      print(
                        "Claim id - ${foundDataNewApproved![i].claimRaiseId}",
                      );

                      /*Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            TravelExpenseRequestUpdate(
                              reimbursementType,
                              reimbursementTypeId,
                              expCategory,
                              expCategoryIdNew,
                              subExpCategory,
                              subExpCategoryIdNew,
                              travelFrom,
                              travelTo,
                              odometerStart,
                              odometerEnd,
                              merchant,
                              kilometers,
                              month,
                              claimDate,
                              claimedAmount,
                              remarks,
                              documents,
                              claimIdCheck,
                            )));*/
                      /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TravelExpenseRequestRaise()));*/
                    },
                    child:
                        Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Row(
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
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      //why index+1 we want to turn the ligne orange that precede the active bubble
                                      color: Mythemes.successColor,
                                    ),
                                  ),

                                  //step two
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Mythemes.successColor,
                                    ),
                                  ),

                                  //step Three
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Mythemes.successColor,
                                    ),
                                  ),

                                  //step Four
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Mythemes.successColor,
                                    ),
                                  ),

                                  //step Five
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.successColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.successColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).p8(),
                              Row(
                                children: [
                                  foundDataNewApproved![i].empName
                                      .toString()
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        foundDataNewApproved![i].statusShow
                                            .toString()
                                            .text
                                            .bold
                                            .color(Mythemes.alertColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),

                              Row(
                                children: [
                                  "Raised On- ${foundDataNewApproved![i].raisedOn.toString()}"
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Category - ${foundDataNewApproved![i].catName.toString()}"
                                            .text
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                              Row(
                                children: [
                                  "Claimed Amount - ${foundDataNewApproved![i].claimedAmt.toString()}"
                                      .text
                                      .bold
                                      .color(Mythemes.lightBluishColor)
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Approved Amount - ${foundDataNewApproved![i].approvedAmount.toString()}"
                                            .text
                                            .bold
                                            .color(Mythemes.successColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                            ],
                          ),
                        ).p4(),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: valueChange == 3,
            child: Expanded(
              child: ListView.builder(
                //controller: _controller,
                itemCount: foundDataNewDisapproved!.length,
                itemBuilder: (context, i) {
                  /*foundDataNew![i].empName == null ? empName = "" :  empName = foundDataNew![i].empName;
                    foundDataNew![i].status == null ? status = "" : status = foundDataNew![i].status;
                    foundDataNew![i].reimbName == null ? reimbName = "" : reimbName = foundDataNew![i].reimbName;
                    foundDataNew![i].raisedOn == null ? raisedOn = "" : raisedOn = foundDataNew![i].raisedOn;
                    foundDataNew![i].catName == null ? catName = "" : catName = foundDataNew![i].catName;
                    foundDataNew![i].claimedAmt == null ? claimedAmt = "" : claimedAmt = foundDataNew![i].claimedAmt;
                    foundDataNew![i].approvedAmount == null ? approvedAmount = "" : approvedAmount = foundDataNew![i].approvedAmount;*/

                  return InkWell(
                    onTap: () {
                      foundDataNewDisapproved![i].claimRaiseId;
                      reimbursementType =
                          foundDataNewDisapproved![i].reimbName!.toString();
                      reimbursementTypeId =
                          foundDataNewDisapproved![i].reimbId!.toString();
                      expCategory =
                          foundDataNewDisapproved![i].expName!.toString();
                      expCategoryIdNew =
                          foundDataNewDisapproved![i].expId!.toString();
                      subExpCategory =
                          foundDataNewDisapproved![i].subExpName!.toString();
                      subExpCategoryIdNew =
                          foundDataNewDisapproved![i].subExpId!.toString();
                      travelFrom =
                          foundDataNewDisapproved![i].travelFrom!.toString();
                      travelTo =
                          foundDataNewDisapproved![i].travelTo!.toString();
                      odometerStart =
                          foundDataNewDisapproved![i].odometerStart!.toString();
                      odometerEnd =
                          foundDataNewDisapproved![i].odometerEnd!.toString();
                      merchant =
                          foundDataNewDisapproved![i].merchant!.toString();
                      kilometers =
                          foundDataNewDisapproved![i].kilometers!.toString();
                      month = foundDataNewDisapproved![i].month!.toString();
                      claimDate =
                          foundDataNewDisapproved![i].reqDate!.toString();
                      claimedAmount =
                          foundDataNewDisapproved![i].claimedAmt!.toString();
                      remarks = foundDataNewDisapproved![i].remarks!.toString();
                      documents =
                          foundDataNewDisapproved![i].document!.toString();
                      claimIdChecking =
                          foundDataNewDisapproved![i].claimRaiseId!.toString();
                      print(
                        "Claim id - ${foundDataNewDisapproved![i].claimRaiseId}",
                      );

                      /*Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            TravelExpenseRequestUpdate(
                              reimbursementType,
                              reimbursementTypeId,
                              expCategory,
                              expCategoryIdNew,
                              subExpCategory,
                              subExpCategoryIdNew,
                              travelFrom,
                              travelTo,
                              odometerStart,
                              odometerEnd,
                              merchant,
                              kilometers,
                              month,
                              claimDate,
                              claimedAmount,
                              remarks,
                              documents,
                              claimIdCheck,
                            )));*/
                      /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TravelExpenseRequestRaise()));*/
                    },
                    child:
                        Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Row(
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
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.dangerColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      //why index+1 we want to turn the ligne orange that precede the active bubble
                                      color: Mythemes.dangerColor,
                                    ),
                                  ),

                                  //step two
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.dangerColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Mythemes.dangerColor,
                                    ),
                                  ),

                                  //step Three
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.dangerColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Mythemes.dangerColor,
                                    ),
                                  ),

                                  //step Four
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.dangerColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Mythemes.dangerColor,
                                    ),
                                  ),

                                  //step Five
                                  GestureDetector(
                                    //onTap: stepSix,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Mythemes.dangerColor,
                                        border: Border.all(
                                          width: 1.5,
                                          strokeAlign: 1,
                                          color: Mythemes.dangerColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Mythemes.whitish,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).p8(),
                              Row(
                                children: [
                                  foundDataNewDisapproved![i].empName
                                      .toString()
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        foundDataNewDisapproved![i].statusShow
                                            .toString()
                                            .text
                                            .bold
                                            .color(Mythemes.alertColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),

                              Row(
                                children: [
                                  "Raised On- ${foundDataNewDisapproved![i].raisedOn.toString()}"
                                      .text
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Category - ${foundDataNewDisapproved![i].catName.toString()}"
                                            .text
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                              Row(
                                children: [
                                  "Claimed Amount - ${foundDataNewDisapproved![i].claimedAmt.toString()}"
                                      .text
                                      .bold
                                      .color(Mythemes.lightBluishColor)
                                      .size(12)
                                      .make()
                                      .pLTRB(5, 3, 0, 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        "Approved Amount - ${foundDataNewDisapproved![i].approvedAmount.toString()}"
                                            .text
                                            .bold
                                            .color(Mythemes.successColor)
                                            .size(12)
                                            .make()
                                            .px8(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).pLTRB(0, 0, 0, 8.0),
                            ],
                          ),
                        ).p4(),
                  );
                },
              ),
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
