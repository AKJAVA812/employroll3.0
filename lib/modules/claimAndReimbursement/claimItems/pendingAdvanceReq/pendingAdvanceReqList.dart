import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/pendingAdvanceReq/pendingAdvReqAppDis.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/pendingAdvanceReqListModal.dart';

class PendingAdvanceReqList extends StatefulWidget {
  final PendingAdvReqListModal pendingAdvReqListModal;
  PendingAdvanceReqList(this.pendingAdvReqListModal);
  @override
  State<PendingAdvanceReqList> createState() =>
      _PendingAdvanceReqListState(pendingAdvReqListModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<ClaimAdvDatalist>? allUsernew = [];
List<ClaimAdvDatalist>? foundDataNew = [];

PendingAdvReqListModal? pendingAdvReqListLabel;
PendingAdvReqListModal? pendingAdvReqListLabeled;

class _PendingAdvanceReqListState extends State<PendingAdvanceReqList>
    with RouteAware {
  final PendingAdvReqListModal pendingAdvReqListModal;
  _PendingAdvanceReqListState(this.pendingAdvReqListModal);
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
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<PendingAdvReqListModal> getAppReq11 = getPendingAdvReqList(
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
        foundDataNew = allUsernew;
        pendingAdvReqListLabel = value;
        pendingAdvReqListLabeled = pendingAdvReqListLabel;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });
  }

  Future<PendingAdvReqListModal> getPendingAdvReqList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingAdvReqList;
    print('employeeList11: ${SessionId}');
    PendingAdvReqListModal pendingAdvReqListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    pendingAdvReqListModal = PendingAdvReqListModal.fromJson(mapResponse);
    allUsernew = pendingAdvReqListModal.claimAdvDatalist;

    return pendingAdvReqListModal;
  }

  var titleName = "Pending Advance List";
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<ClaimAdvDatalist>? results = [];

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

  TextEditingController searchType = TextEditingController();

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
        color: Mythemes.whitish,
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            setState(() {
              //getSharedPrfanceList();
            });
          },
          child: Column(
            children: [
              Expanded(
                child:
                    pendingAdvReqListLabeled == null
                        ? Center(child: CircularProgressIndicator())
                        : getPendingAdvanceReqList(pendingAdvReqListLabeled!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getPendingAdvanceReqList(PendingAdvReqListModal pendingAdvReqListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (a, b, c) => PendingAdvanceReqList(PendingAdvReqListModal()),
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
              print(foundDataNew!.length);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AppDispPendingAdvanceReq(pendingAdvReqListModal, i),
                ),
              );
            },
            child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        foundDataNew![i].empName
                            .toString()
                            .text
                            .make()
                            .px8()
                            .py2(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              foundDataNew![i].approvedStatus
                                  .toString()
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
                        "Tour -".text.maxFontSize(12).make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].placeTour
                                  .toString()
                                  .text
                                  .size(10)
                                  .textStyle(context.captionStyle)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ).py1(),
                    Row(
                      children: [
                        "Purpose".text.maxFontSize(12).make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].purpose
                                  .toString()
                                  .text
                                  .size(10)
                                  .textStyle(context.captionStyle)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ).py2(),
                    Row(
                      children: [
                        "Days -".text.maxFontSize(12).make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].ndays
                                  .toString()
                                  .text
                                  .size(10)
                                  .textStyle(context.captionStyle)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ).py1(),
                    Row(
                      children: [
                        "Amount -".text.maxFontSize(12).make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].advanceAmt
                                  .toString()
                                  .text
                                  .size(10)
                                  .textStyle(context.captionStyle)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ).py1(),
                    Row(
                      children: [
                        "Remarks -".text.maxFontSize(12).make().px8(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              foundDataNew![i].advanceAmt
                                  .toString()
                                  .text
                                  .size(10)
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
