import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/appDisReimbListModal.dart';

class ApprovalListReimbursement extends StatefulWidget {
  final AppDisReimbListModal appDisReimbListModal;
  ApprovalListReimbursement (this.appDisReimbListModal);
  @override
  State<ApprovalListReimbursement> createState() => _ApprovalListReimbursementState(appDisReimbListModal);


}
Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

AppDisReimbListModal? appDisReimbListLabel;

class _ApprovalListReimbursementState extends State<ApprovalListReimbursement> with RouteAware{
  final AppDisReimbListModal appDisReimbListModal;
  _ApprovalListReimbursementState(this.appDisReimbListModal);
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
    // ✅ Called when coming back from Form Page
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
    Future<AppDisReimbListModal> getAppReq11 = getAppDisReimbList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        appDisReimbListLabel=value;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });
  }

  Future<AppDisReimbListModal> getAppDisReimbList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.appDisReimbList;
    print('employeeList11: ${SessionId}');
    AppDisReimbListModal appDisReimbListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    appDisReimbListModal=AppDisReimbListModal.fromJson(mapResponse);

    return appDisReimbListModal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Claim Status List".text.make(),

        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context, delegate: SearchItems(),
                );

              }, icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        color: Mythemes.whitish,
        child: Column(
          children: [
            Expanded(
                child: appDisReimbListLabel == null ?
                Center(
                    child: CircularProgressIndicator()):
                getAppDisList(appDisReimbListLabel!)),
          ],
        ),
      ),


    );
  }

  getAppDisList(AppDisReimbListModal appDisReimbListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  ApprovalListReimbursement(AppDisReimbListModal()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: appDisReimbListModal!.data!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              //Navigator.pushNamed(context, MyRoutings.approveDisReimbursementRoute);
            },
            child: Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          appDisReimbListModal!.data![i].empName.toString().text.make().px8().py2(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  appDisReimbListModal!.data![i].status.toString()
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
                          appDisReimbListModal!.data![i].reimbName.toString()
                              .text.maxFontSize(12)
                              .make()
                              .px8(),
                          /* Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  "Tour Name".text.size(10).textStyle(context.captionStyle).make(),
                                ],
                              )


                          )*/
                        ],
                      ).py1(),
                      Row(
                        children: [
                          appDisReimbListModal!.data![i].claimNo.toString()
                              .text.maxFontSize(12)
                              .make()
                              .px8(),
                          /*Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "12-04-2022".text.size(10).textStyle(context.captionStyle).make()
                                ],
                              )


                          )*/
                        ],
                      ).py1(),
                      Row(
                        children: [
                          appDisReimbListModal!.data![i].reqDate.toString()
                              .text.maxFontSize(12)
                              .make()
                              .px8(),
                          /* Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "12-04-2022".text.size(10).textStyle(context.captionStyle).make()
                                ],
                              )


                          )*/
                        ],
                      ).py0(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /*Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "Grade".text.make(),
                                ],
                              ),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 7, right: 0, bottom: 18),
                            child: Column(
                              children: [
                                "Grade".text.make(),
                                appDisReimbListModal!.data![i].empGrade.toString().text.sm.make()
                              ],
                            ),
                          ),

                          /* Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "Category".text.make(),
                                ],
                              ),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 1, right: 0, bottom: 18),
                            child: Column(
                              children: [
                                "Category".text.make(),
                                appDisReimbListModal!.data![i].catName.toString().text.sm.make()
                              ],
                            ),
                          ),

                          /*  Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                              child: Column(
                                children: [
                                  "Amount".text.make(),
                                ],
                              ),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 1, right: 7, bottom: 18),
                            child: Column(
                              children: [
                                "Amount".text.make(),
                                appDisReimbListModal!.data![i].claimedAmt.toString().text.sm.make()
                              ],
                            ),
                          ),
                        ],
                      ).py1(),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}


class SearchItems extends SearchDelegate {

  List<String> searchTerms = [

  ];
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
        return ListTile(
          title: Text(result),
        );
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
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
