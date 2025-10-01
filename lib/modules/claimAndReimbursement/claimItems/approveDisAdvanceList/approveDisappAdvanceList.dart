import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../../commanScreen/allAPIList.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/appDisAdvListModal.dart';

class ApproveDisapAdvanceRequisitionList extends StatefulWidget {
  final AppDisAdvListModal appDisAdvListModal;
  ApproveDisapAdvanceRequisitionList (this.appDisAdvListModal);
  @override
  State<ApproveDisapAdvanceRequisitionList> createState() => _ApproveDisapAdvanceRequisitionListState(appDisAdvListModal);

}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

AppDisAdvListModal? appDisAdvListLabel;

class _ApproveDisapAdvanceRequisitionListState extends State<ApproveDisapAdvanceRequisitionList> {
  final AppDisAdvListModal appDisAdvListModal;
  _ApproveDisapAdvanceRequisitionListState(this.appDisAdvListModal);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<AppDisAdvListModal> getAppReq11 = getAppDisAdvList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        appDisAdvListLabel=value;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });
  }

  Future<AppDisAdvListModal> getAppDisAdvList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.appDisAdvList;
    print('employeeList11: ${SessionId}');
    AppDisAdvListModal appDisAdvListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    appDisAdvListModal=AppDisAdvListModal.fromJson(mapResponse);

    return appDisAdvListModal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Advance Requisition List".text.make(),

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
                child: appDisAdvListLabel == null ?
                Center(
                    child: CircularProgressIndicator()):
                getAppDisAdvanceList(appDisAdvListLabel!)),
          ],
        ),
      ),


    );
  }

  getAppDisAdvanceList(AppDisAdvListModal appDisAdvListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  ApproveDisapAdvanceRequisitionList(AppDisAdvListModal()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: appDisAdvListModal!.claimAdvDatalist!.length,
        itemBuilder: (context, i) {
          return Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        appDisAdvListModal!.claimAdvDatalist![i].empName.toString().text.make().px8().py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                appDisAdvListModal!.claimAdvDatalist![i].approvedStatus.toString()
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
                        "Tour -"
                            .text.maxFontSize(12)
                            .make()
                            .px8(),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                appDisAdvListModal!.claimAdvDatalist![i].placeTour.toString().text.size(10).textStyle(context.captionStyle).make(),
                              ],
                            )


                        )
                      ],
                    ).py2(),
                    Row(
                      children: [
                        "Purpose"
                            .text.maxFontSize(12)
                            .make()
                            .px8(),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                appDisAdvListModal!.claimAdvDatalist![i].purpose.toString().text.size(10).textStyle(context.captionStyle).make()
                              ],
                            )


                        )
                      ],
                    ).py2(),
                    Row(
                      children: [
                        "Day -"
                            .text.maxFontSize(12)
                            .make()
                            .px8(),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                appDisAdvListModal!.claimAdvDatalist![i].ndays.toString().text.size(10).textStyle(context.captionStyle).make(),
                              ],
                            )


                        )
                      ],
                    ).py2(),
                    Row(
                      children: [
                        "Amount -"
                            .text.maxFontSize(12)
                            .make()
                            .px8(),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                appDisAdvListModal!.claimAdvDatalist![i].advanceAmt.toString().text.size(10).textStyle(context.captionStyle).make(),
                              ],
                            )


                        )
                      ],
                    ),
                    Row(
                      children: [
                        "Remarks -"
                            .text.maxFontSize(12)
                            .make()
                            .px8(),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                appDisAdvListModal!.claimAdvDatalist![i].remark.toString().text.size(10).textStyle(context.captionStyle).make(),
                              ],
                            )


                        )
                      ],
                    ),
                  ],
                ),
              ));
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
