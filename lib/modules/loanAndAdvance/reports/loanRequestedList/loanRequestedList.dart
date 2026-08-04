import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/loanAdvanceReqModal.dart';

class PendingLoanRequestedList extends StatefulWidget {
  final LoanAdvanceReqModal loanAdvanceReqModal;
  const PendingLoanRequestedList(this.loanAdvanceReqModal);

  @override
  State<PendingLoanRequestedList> createState() =>
      _PendingLoanRequestedListState(loanAdvanceReqModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<LoanRequiDatalist>? allUsernew = [];
List<LoanRequiDatalist>? foundDataNew = [];
var loanReqId;

LoanAdvanceReqModal? loanAdvanceReqModalGlobal;
LoanAdvanceReqModal? loanAdvanceReqModalGlobaled;

class _PendingLoanRequestedListState extends State<PendingLoanRequestedList>
    with RouteAware {
  final LoanAdvanceReqModal loanAdvanceReqModal;
  _PendingLoanRequestedListState(this.loanAdvanceReqModal);

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
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LoanAdvanceReqModal> getAppReq11 = getLoanAdvReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        loanAdvanceReqModalGlobal = value;
        loanAdvanceReqModalGlobaled = loanAdvanceReqModalGlobal;
      });
      print(
        'employeeList00${loanAdvanceReqModalGlobal!.loanRequiDatalist!.length}',
      );
    });
  }

  Future<LoanAdvanceReqModal> getLoanAdvReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanAdvanceReqList;
    print('employeeList11: ${SessionId}');
    LoanAdvanceReqModal loanAdvanceReqModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['LoanRequiDatalist'];
    print('responseemployeeList $getData');
    loanAdvanceReqModal = LoanAdvanceReqModal.fromJson(mapResponse);

    allUsernew = loanAdvanceReqModal.loanRequiDatalist;

    return loanAdvanceReqModal;
  }

  TextEditingController searchType = TextEditingController();
  var titleName = "Pending Requisition List";
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<LoanRequiDatalist>? results = [];

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
      foundDataNew = results;
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
      body: Container(
        color: context.canvasColor,
        child:
            loanAdvanceReqModalGlobaled == null
                ? Center(child: CircularProgressIndicator())
                : getLoanAdvanceReqList(loanAdvanceReqModalGlobaled!),
      ),
    );
  }

  getLoanAdvanceReqList(LoanAdvanceReqModal loanAdvanceReqModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) => PendingLoanRequestedList(LoanAdvanceReqModal()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: foundDataNew!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              for (int i = 0; i < foundDataNew!.length; i++) {
                loanReqId = foundDataNew![i].loanReqId;
              }
              showDialgCancel(context, context, context);
            },
            child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        foundDataNew![i].empName!.text.make().px8().py4(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              foundDataNew![i].status!.text
                                  .color(Mythemes.lightBluishColor)
                                  .sm
                                  .make()
                                  .px8(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [foundDataNew![i].loanType!.text.make().px8()],
                    ).py2(),
                    Row(
                      children: [foundDataNew![i].date!.text.make().px8()],
                    ).py2(),
                    Row(
                      children: [
                        "Remarks -".text.make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].remark!.text
                                  .textStyle(context.captionStyle)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ).py2(),
                    Row(
                      children: [
                        "Raised Amount -".text.make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].raisedBy!.text
                                  .textStyle(context.captionStyle)
                                  .make(),
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
            Navigator.of(buildContext).pop();
          },
          child: Container(
            // color: Mythemes.lightBluishColor,
            child: Text("No", style: TextStyle(color: Mythemes.dangerColor)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (a, b, c) =>
                        PendingLoanRequestedList(LoanAdvanceReqModal()),
                transitionDuration: Duration(seconds: 1),
                maintainState: true,
              ),
            );
            cancelLoanAdvReqList(loanReqId.toString());
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

  Future<void> cancelLoanAdvReqList(String loanReqId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.cancelLoanAdvReqList;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "loanReqId=$loanReqId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];
      String reason = mapResponse['reason'].toString();
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase + " ",
          "Success",
        );
      } else if (result.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase,
          " Error ",
        );
      }
    }
  }
}
