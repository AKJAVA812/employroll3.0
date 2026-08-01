import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/loanAdvanceReqModal.dart';
import '../modalClass/loanApprovedListModal.dart';

class LoanApprovedReqList extends StatefulWidget {
  final LoanApprovedReqModal loanApprovedReqModal;
  const LoanApprovedReqList(this.loanApprovedReqModal);

  @override
  State<LoanApprovedReqList> createState() =>
      _LoanApprovedReqListState(loanApprovedReqModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
var loanReqId;

LoanApprovedReqModal? loanApprovedReqModalGlobal;

class _LoanApprovedReqListState extends State<LoanApprovedReqList>
    with RouteAware {
  final LoanApprovedReqModal loanApprovedReqModal;
  _LoanApprovedReqListState(this.loanApprovedReqModal);

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
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LoanApprovedReqModal> getAppReq11 = getLoanAppReqList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        loanApprovedReqModalGlobal = value;
      });
      print(
        'employeeList00${loanApprovedReqModalGlobal!.loanAppReqDatalist!.length}',
      );
    });
  }

  Future<LoanApprovedReqModal> getLoanAppReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanApprovedReq;
    print('employeeList11: ${SessionId}');
    LoanApprovedReqModal loanApprovedReqModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['LoanRequiDatalist'];
    print('responseemployeeList $getData');
    loanApprovedReqModal = LoanApprovedReqModal.fromJson(mapResponse);

    return loanApprovedReqModal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Loan Approved List".text.make(),

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
        color: context.canvasColor,
        child:
            loanApprovedReqModalGlobal == null
                ? Center(child: CircularProgressIndicator())
                : getApprovedRequestedList(loanApprovedReqModalGlobal!),
      ),
    );
  }

  getApprovedRequestedList(LoanApprovedReqModal loanApprovedReqModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) => LoanApprovedReqList(LoanApprovedReqModal()),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: loanApprovedReqModal!.loanAppReqDatalist!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {},
            child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        loanApprovedReqModal!
                            .loanAppReqDatalist![i]
                            .empName!
                            .text
                            .make()
                            .px8()
                            .py4(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              loanApprovedReqModal!
                                  .loanAppReqDatalist![i]
                                  .status!
                                  .text
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
                      children: [
                        loanApprovedReqModal!
                            .loanAppReqDatalist![i]
                            .loanType!
                            .text
                            .make()
                            .px8(),
                      ],
                    ).py2(),
                    Row(
                      children: [
                        loanApprovedReqModal!
                            .loanAppReqDatalist![i]
                            .loanRaiseDate!
                            .text
                            .make()
                            .px8(),
                      ],
                    ).py2(),
                    Row(
                      children: [
                        "Remarks -".text.make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              loanApprovedReqModal!
                                  .loanAppReqDatalist![i]
                                  .remark!
                                  .text
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
                              loanApprovedReqModal!
                                  .loanAppReqDatalist![i]
                                  .loanAppAmt!
                                  .text
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
