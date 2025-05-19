import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart'
    show AnimationSearchBar;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/advanceRequisitionListModal.dart';

class AdvanceRequisitionList extends StatefulWidget {
  final AdvanceRequestedListModal advanceRequestedListModal;

  AdvanceRequisitionList(this.advanceRequestedListModal);

  @override
  State<AdvanceRequisitionList> createState() =>
      _AdvanceRequisitionListState(advanceRequestedListModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();
List<ClaimAdvDatalist>? allUsernew=[];
List<ClaimAdvDatalist>? foundDataNew=[];
String? sessionId;

AdvanceRequestedListModal? advanceRequestedListLabel;
AdvanceRequestedListModal? advanceRequestedListLabeled;

class _AdvanceRequisitionListState extends State<AdvanceRequisitionList>
    with WidgetsBindingObserver, RouteAware {
  var items = <String>[];
  var claimId;
  final AdvanceRequestedListModal advanceRequestedListModal;

  _AdvanceRequisitionListState(this.advanceRequestedListModal);


  @override
  void initState() {
    print('object change call init');
    // TODO: implement initState
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    setState(() {
      print("update List");
      getSharedPrfanceList();
    });
  }


  @override
  void didPopNext() {
    // ✅ Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    await Future.delayed(Duration(seconds: 2));
    Future<AdvanceRequestedListModal> getAppReq11 =
    getAdvanceReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        advanceRequestedListLabel = value;
        advanceRequestedListLabeled = advanceRequestedListLabel;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });
  }

  @override
  void dispose() {
    getSharedPrfanceList();
    routeObserver.unsubscribe(this);
    // TODO: implement dispose
    super.dispose();
  }

  Future<AdvanceRequestedListModal> getAdvanceReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.advanceRequisitionList;
    print('employeeList11: ${SessionId}');
    AdvanceRequestedListModal advanceRequestedListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);
    print('responseemployeeList ${response.body}');
    mapResponse = json.decode(response.body);
    advanceRequestedListModal = AdvanceRequestedListModal.fromJson(mapResponse);
    allUsernew = advanceRequestedListModal.claimAdvDatalist;

    return advanceRequestedListModal;
  }

  TextEditingController searchType = TextEditingController();
  var titleName = "Advance Requested List";

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<ClaimAdvDatalist>?  results = [];

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

  @override
  Widget build(BuildContext context) {
    print('build method call');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.5,
                  spreadRadius: 0,
                  offset: Offset(0, 0.2))
            ]),
            child: AnimationSearchBar(
                searchFieldDecoration: BoxDecoration(
                  color: Mythemes.greyLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                backIcon: Icons.arrow_back,
                backIconColor: Mythemes.black,
                textStyle: TextStyle(fontSize: 14),
                onChanged: (value) => _runFilter(value),
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
      body: Container(
        color: Mythemes.whitish,
        child: Column(
          children: [
            Expanded(
              child: advanceRequestedListLabeled == null
                  ? Center(child: CircularProgressIndicator())
                  : getAdvList(advanceRequestedListLabeled!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutings.advanceRequisitionPageRoute);
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(
          CupertinoIcons.add,
          color: Mythemes.whitish,
          size: 25,
        ),
      ),
    );
  }

  getAdvList(AdvanceRequestedListModal advanceRequestedListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  AdvanceRequisitionList(AdvanceRequestedListModal()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: foundDataNew!.length,
        itemBuilder: (context, itemCount) {
          return InkWell(
            onTap: () {
              claimId = foundDataNew![itemCount].claimId;
              setState(() {
                print('object in $itemCount');
              });
              print('object out $itemCount');
              var statusCheck = foundDataNew![itemCount].approvedStatus
                  .toString();
              if (statusCheck == 'PENDING') {
                showDialgCancel(context, context, context);
              } else if (statusCheck == 'APPROVED') {
                Fluttertoast.showToast(
                    msg: "Your Requisition has already Approved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Fluttertoast.showToast(
                    msg: "Your Requisition has already Disapproved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          foundDataNew![itemCount].empName
                              .toString()
                              .text
                              .make()
                              .px8()
                              .py4(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  foundDataNew![itemCount].approvedStatus
                                      .toString()
                                      .text
                                      .color(Mythemes.lightBluishColor)
                                      .sm
                                      .make()
                                      .px8(),
                                ],
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          "Tour -".text.maxFontSize(12).make().px8(),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  foundDataNew![itemCount].placeTour
                                      .toString()
                                      .text
                                      .size(10)
                                      .textStyle(context.captionStyle)
                                      .make(),
                                ],
                              ))
                        ],
                      ).py2(),
                      Row(
                        children: [
                          "Purpose".text.maxFontSize(12).make().px8(),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  foundDataNew![itemCount].purpose
                                      .toString()
                                      .text
                                      .size(10)
                                      .textStyle(context.captionStyle)
                                      .make()
                                ],
                              ))
                        ],
                      ).py2(),
                      Row(
                        children: [
                          "Day -".text.maxFontSize(12).make().px8(),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  foundDataNew![itemCount].ndays
                                      .toString()
                                      .text
                                      .size(10)
                                      .textStyle(context.captionStyle)
                                      .make(),
                                ],
                              ))
                        ],
                      ).py2(),
                      Row(
                        children: [
                          "Amount -".text.maxFontSize(12).make().px8(),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  foundDataNew![itemCount].advanceAmt
                                      .toString()
                                      .text
                                      .size(10)
                                      .textStyle(context.captionStyle)
                                      .make(),
                                ],
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          "Remarks -".text.maxFontSize(12).make().px8(),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  foundDataNew![itemCount].remark
                                      .toString()
                                      .text
                                      .size(10)
                                      .textStyle(context.captionStyle)
                                      .make(),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  showDialgCancel(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          )),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(
              child: Text(
                "Cancel Requisition",
                style: TextStyle(fontSize: 20),
              )),
        ],
      ),
      content: Text("Sure you want to cancel requisition?",
          style: TextStyle(fontSize: 14)),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.pop(buildContext);
            },
            child: Container(
              // color: Mythemes.lightBluishColor,
              child: Text(
                "No",
                style: TextStyle(color: Mythemes.dangerColor),
              ),
            )),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) =>
                        AdvanceRequisitionList(AdvanceRequestedListModal()),
                    transitionDuration: Duration(seconds: 0),
                    maintainState: true,
                  ));
              Navigator.of(buildContext, rootNavigator: true).pop();
              cancelAdvanceReq(claimId.toString());
            },
            child: Container(
              child: Text(
                "Yes",
                style: TextStyle(color: Mythemes.warningColor),
              ),
            )),
      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<void> cancelAdvanceReq(String claimId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.cancelAdvRequisition;
    //CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "claimId=$claimId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.pop(context);
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = mapResponse['reason'];
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        showDialgSucess1(context, reason.upperCamelCase + " ", "Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
            context, reason.upperCamelCase, " Error ");
      }
    }
  }

  showDialgSucess1(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          )),
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
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) =>
                      AdvanceRequisitionList(AdvanceRequestedListModal()),
                  transitionDuration: Duration(seconds: 0),
                  maintainState: true,
                ));
            Navigator.pop(context);
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
        });
  }
}