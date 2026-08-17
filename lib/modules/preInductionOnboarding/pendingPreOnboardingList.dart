import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../main.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../themes/empThemes.dart';
import 'ApprovePreOnboarding.dart';
import 'modalClass/preOnboardListModal.dart';

class PendingPreOnboardingList extends StatefulWidget {
  const PendingPreOnboardingList({super.key});

  static const String _title = 'Employee List';

  @override
  State<PendingPreOnboardingList> createState() =>
      _PendingPreOnboardingListState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<PreOnboardListData>? allUsernew = [];
List<PreOnboardListData>? foundDataNew = [];
PreOnboardListModal? employeeListModelglobel;
PreOnboardListModal? employeeListModelglobeled;
var empNameExited;
var empIdExited;
var statusUpdate = "PENDING";
bool isLoading = true;
String typeOfHiring = "";
String aadharNo = "";
String fullName = "";
String dob = "";
String doj = "";
String contactNo = "";
String inHandSalary = "";
String accomodationCheck = "";
String idCheck = "";
String aadharCardFront = "";
String aadharCardBack = "";
String panCard = "";
String empPhoto = "";
String branchName = "";
String departmentName = "";
String designationName = "";
String bankName = "";
String accountNo = "";
String ifscCode = "";
String nomineeName = "";
String nomineeAadhar = "";
String nomineeRelation = "";
Future<PreOnboardListModal>? futureExitEmpList;

class _PendingPreOnboardingListState extends State<PendingPreOnboardingList>
    with RouteAware {
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
      int listLength;
      listLength = foundDataNew!.length;
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<PreOnboardListModal> getEmployeeList11 = getEmployeeList(sessionId!);
    futureExitEmpList = getEmployeeList(sessionId!);
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
        employeeListModelglobel = value;
        employeeListModelglobeled = employeeListModelglobel;
      });
    });
  }

  Future<PreOnboardListModal> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.preOnboardListApi;
    PreOnboardListModal employeeListModel;
    var urlapi = Uri.parse(
      "$conn$apiUrl?sessionId=$SessionId&"
      "status=$statusUpdate",
    );
    final response = await MobileHttpClient.instance.post(urlapi);


    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    employeeListModel = PreOnboardListModal.fromJson(mapResponse);
    allUsernew = employeeListModel.list;
    setState(() {
      isLoading = false; // âœ… Hide loader after API success
    });

    return employeeListModel;
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
              isLoading = true;
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

  void _runFilter(String enteredKeyword) {
    List<PreOnboardListData>? results = [];

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
                (element) => element.fullName!.toLowerCase().contains(
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
  var titleName = "Pre-Onboarding List";
  int value = 0;
  int switcherIndex1 = 0;
  int pageIndex = 0;
  int currentIndex = 2;
  var dropdownvalue;
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
              centerTitle: "$titleName - ${foundDataNew!.length}",
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
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.preOnboardItemRoute);
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
            );
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
            icon: Icon(Icons.add_task_rounded),
            label: 'Pre-Onboard',
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

      body: Column(
        children: [
          // Your toggle switch
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedToggleSwitch<int>.size(
                height: 25,
                current: min(value, 3),
                style: ToggleStyle(
                  backgroundColor: Mythemes.greyishade,
                  indicatorColor: Mythemes.lightBluishColor,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  indicatorBorderRadius: BorderRadius.zero,
                ),
                values: const [0, 1, 2],
                iconOpacity: 1.0,
                selectedIconScale: 1.0,
                indicatorSize: const Size.fromWidth(90),
                iconAnimationType: AnimationType.onHover,
                styleAnimationType: AnimationType.onHover,
                spacing: 2.0,
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
                      const ['Pending', 'Approved', 'Disapprove'][local.index];
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(
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
                    value = i;
                    if (value == 0) {
                      isLoading = true;
                      statusUpdate = "PENDING";
                      getSharedPrfanceList();
                    }
                    if (value == 1) {
                      isLoading = true;
                      statusUpdate = "APPROVED";
                      getSharedPrfanceList();
                    }
                    if (value == 2) {
                      isLoading = true;
                      statusUpdate = "DISAPPROVED";
                      getSharedPrfanceList();
                    }
                  });
                },
              ),
            ],
          ).py(8),

          // ListView inside Expanded + FutureBuilder
          Expanded(
            child: FutureBuilder<PreOnboardListModal>(
              future: futureExitEmpList,
              builder: (context, snapshot) {
                if (isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("âŒ Error loading data"));
                }
                return RefreshIndicator(
                  onRefresh: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (a, b, c) => PendingPreOnboardingList(),
                        transitionDuration: Duration(seconds: 1),
                        maintainState: true,
                      ),
                    );
                    return Future.value(false);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    itemCount: foundDataNew!.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          String status = foundDataNew![i].reqStatus!;

                          if (status == "APPROVED") {
                            Fluttertoast.showToast(
                              msg: "Already Approved !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (status == "PENDING") {
                            typeOfHiring = foundDataNew![i].typeOfHire!;
                            aadharNo = foundDataNew![i].aadharNumber!;
                            fullName = foundDataNew![i].fullName!;
                            dob = foundDataNew![i].dob!;
                            doj = foundDataNew![i].dateOfJoining!;
                            contactNo = foundDataNew![i].contact!;
                            inHandSalary =
                                foundDataNew![i].inHandSalary!.toString();
                            accomodationCheck =
                                foundDataNew![i].withAccomodation!.toString();
                            aadharCardFront =
                                foundDataNew![i].aadharDocumentFront!;
                            aadharCardBack =
                                foundDataNew![i].aadharDocumentBack!;
                            panCard = foundDataNew![i].panDocument!;
                            empPhoto = foundDataNew![i].empPhoto!;
                            branchName = foundDataNew![i].branchName!;
                            departmentName = foundDataNew![i].departmentName!;
                            designationName = foundDataNew![i].designationName!;
                            nomineeName = foundDataNew![i].nomineeName!;
                            nomineeAadhar = foundDataNew![i].nomineeAadhar!;
                            nomineeRelation = foundDataNew![i].nomineeRelation!;
                            bankName = foundDataNew![i].bankName!;
                            accountNo = foundDataNew![i].accountNo!;
                            ifscCode = foundDataNew![i].ifscCode!;
                            idCheck = foundDataNew![i].id!.toString();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => ApprovePreOnboarding(
                                      typeOfHiring,
                                      aadharNo,
                                      fullName,
                                      dob,
                                      doj,
                                      contactNo,
                                      inHandSalary,
                                      accomodationCheck,
                                      aadharCardFront,
                                      aadharCardBack,
                                      panCard,
                                      empPhoto,
                                      branchName,
                                      departmentName,
                                      designationName,
                                      bankName,
                                      accountNo,
                                      ifscCode,
                                      nomineeName,
                                      nomineeAadhar,
                                      nomineeRelation,
                                      idCheck,
                                    ),
                              ),
                            );
                          } else if (status == "DISAPPROVED") {
                            Fluttertoast.showToast(
                              msg: "Already Disapproved !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color:
                                    foundDataNew![i].reqStatus! == "PENDING" ||
                                            foundDataNew![i].reqStatus! ==
                                                "APPROVED"
                                        ? Mythemes.successColor
                                        : Mythemes.dangerColor,
                                width: 5,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      foundDataNew![i].reqStatus!.text
                                          .size(14)
                                          .align(TextAlign.right)
                                          .bold
                                          .color(
                                            foundDataNew![i].reqStatus! ==
                                                        "PENDING" ||
                                                    foundDataNew![i]
                                                            .reqStatus! ==
                                                        "APPROVED"
                                                ? Mythemes.successColor
                                                : Mythemes.dangerColor,
                                          )
                                          .make()
                                          .px8()
                                          .py4(),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 0,
                                        child:
                                            CircleAvatar(
                                              minRadius: 48,
                                              backgroundColor: Mythemes.greyish,
                                              backgroundImage: NetworkImage(
                                                foundDataNew![i].empPhoto
                                                    .toString(),
                                              ),
                                            ).px(8).py8(),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            foundDataNew![i].fullName
                                                .toString()
                                                .text
                                                .bold
                                                .size(16)
                                                .make()
                                                .px1(),
                                            foundDataNew![i].aadharNumber
                                                .toString()
                                                .text
                                                .size(14)
                                                .color(Colors.grey[700])
                                                .make()
                                                .px1(),
                                            "Type of Hire:".text
                                                .size(13)
                                                .bold
                                                .make()
                                                .px1()
                                                .py2(),
                                            foundDataNew![i].typeOfHire
                                                .toString()
                                                .text
                                                .size(13)
                                                .color(Colors.black87)
                                                .make()
                                                .px1(),
                                            "Date of Joining:".text
                                                .size(13)
                                                .bold
                                                .make()
                                                .px1()
                                                .py2(),
                                            foundDataNew![i].dateOfJoining
                                                .toString()
                                                .text
                                                .size(13)
                                                .color(Colors.black87)
                                                .make()
                                                .px1(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
