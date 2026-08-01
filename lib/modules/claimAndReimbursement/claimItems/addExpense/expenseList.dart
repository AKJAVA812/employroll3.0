import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/expensesListModal.dart';
import 'expenseListDelete.dart';

class ExpenseList extends StatefulWidget {
  final ExpensesListModal expensesListModal;
  ExpenseList(this.expensesListModal);
  @override
  State<ExpenseList> createState() => _ExpenseListState(expensesListModal);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<ClaimRequiDatalist>? allUsernew = [];
List<ClaimRequiDatalist>? foundDataNew = [];
ExpensesListModal? expenseListLabel;
ExpensesListModal? expenseListLabeled;

class _ExpenseListState extends State<ExpenseList> with RouteAware {
  final ExpensesListModal expensesListModal;
  _ExpenseListState(this.expensesListModal);
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
    Future<ExpensesListModal> getAppReq11 = getExpenseList(sessionId!);
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
        expenseListLabel = value;
        expenseListLabeled = expenseListLabel;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });
  }

  Future<ExpensesListModal> getExpenseList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.expensesList;
    print('employeeList11: ${SessionId}');
    ExpensesListModal expensesListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    expensesListModal = ExpensesListModal.fromJson(mapResponse);
    allUsernew = expensesListModal.claimRequiDatalist;

    return expensesListModal;
  }

  var titleName = "Expense List";
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<ClaimRequiDatalist>? results = [];

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
                (element) => element.status!.toLowerCase().contains(
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
        child: Column(
          children: [
            Expanded(
              child:
                  expenseListLabeled == null
                      ? Center(child: CircularProgressIndicator())
                      : getExpList(expenseListLabeled!),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutings.addExpenseRoute);
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(CupertinoIcons.add, color: Mythemes.whitish, size: 25),
      ),
    );
  }

  getExpList(ExpensesListModal expensesListModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => ExpenseList(ExpensesListModal()),
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
              var statusCheck = foundDataNew![i].status.toString();
              print("Status list $statusCheck");

              if (statusCheck == 'CANCEL') {
                Fluttertoast.showToast(
                  msg: "Your Expense has already Cancelled",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (statusCheck == 'APPROVED') {
                Fluttertoast.showToast(
                  msg: "Your Expense has already Approved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (statusCheck == 'DISAPPROVED') {
                Fluttertoast.showToast(
                  msg: "Your Expense has already Disapproved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (statusCheck == 'LEVEL_ONE_PENDING' ||
                  statusCheck == 'LEVEL_TWO_PENDING' ||
                  statusCheck == 'LEVEL_THREE_PENDING' ||
                  statusCheck == 'PENDING') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => DeleteExpenseList(expensesListModal, i),
                  ),
                );
              }
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
                              foundDataNew![i].status
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
                        foundDataNew![i].reimbName
                            .toString()
                            .text
                            .maxFontSize(12)
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
                        foundDataNew![i].claimNo
                            .toString()
                            .text
                            .maxFontSize(12)
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
                        foundDataNew![i].toDate
                            .toString()
                            .text
                            .maxFontSize(12)
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
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 7,
                            right: 0,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Grade".text.make(),
                              foundDataNew![i].empGrade
                                  .toString()
                                  .text
                                  .sm
                                  .make(),
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
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 1,
                            right: 0,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Category".text.make(),
                              foundDataNew![i].catName
                                  .toString()
                                  .text
                                  .sm
                                  .make(),
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
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 1,
                            right: 7,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Amount".text.make(),
                              foundDataNew![i].claimedAmt
                                  .toString()
                                  .text
                                  .sm
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ).py1(),
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
