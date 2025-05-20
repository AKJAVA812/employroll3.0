import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../adminPage/modelClass/dashboardModel.dart';
import '../../adminPage/mssDashboard.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../employeePage/liveMapView.dart';
import '../../employeePage/mapView.dart';
import '../../main.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../themes/empThemes.dart';
import 'modalClass/onboardingListModal.dart';

class OnboardListView extends StatefulWidget {
  const OnboardListView({Key? key}) : super(key: key);

  static const String _title = 'Employee List';

  @override
  State<OnboardListView> createState() => _OnboardListViewState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNew=[];
OnboardingListModal? onboardingListModalGlobal;
OnboardingListModal? onboardingListModalGlobaled;
var empName;
var empId;
var statusUpdate = "Pending";
dynamic MyColor;
class _OnboardListViewState extends State<OnboardListView> with RouteAware{

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
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    print("Status $statusUpdate");
    // await Future.delayed(Duration(seconds: 5));
    Future<OnboardingListModal> getEmployeeList11 = getEmployeeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        onboardingListModalGlobal=value;
        onboardingListModalGlobaled=onboardingListModalGlobal;
      });
      print('employeeList00${onboardingListModalGlobal!.data!.length}');
    });
  }

  Future<OnboardingListModal> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardingList;
    print('employeeList11: ${SessionId}');
    OnboardingListModal employeeListModel;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "status=$statusUpdate");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel=OnboardingListModal.fromJson(mapResponse);
    allUsernew = employeeListModel.data;

    return employeeListModel;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>?  results = [];

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
          element.firstName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
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
  var titleName = "Onboarding List";
  int value = 1;
  int switcherIndex1 = 0;
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, border: Border(
                  top: BorderSide.none
              ), boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.5,
                    spreadRadius: 0,
                    offset: Offset(0, 0.2))
              ]),
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
                      color: Mythemes.black),
                  searchTextEditingController: searchType),
            ),
          ),
        ),
        bottomNavigationBar:
        BottomNavigationBar (
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {

            if(index==0){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
              //Navigator.pop(context);
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            }
            if(index==2){
              Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Attendance');
            }
            if(index==3){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
              );
              print('Profile');
            }
            /*if(index==3){
                title="Notifications";
              }*/
            setState(() => currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions),
              label: 'Attendance',
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, MyRoutings.addInductionProcessRoute);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Ensures circular shape
          ),
          mini: false,
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(
            Icons.add, color: Mythemes.whitish, size: 28,
          ),
        ),

        body: Container(
          color: context.canvasColor,
          child: Column(
            children: [
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
                      final opacity =
                      ((global.position - local.position).abs() - 0.5)
                          .clamp(0.0, 1.0);
                      return VerticalDivider(
                          indent: 10.0,
                          endIndent: 10.0,
                          color: Colors.white38.withOpacity(opacity));
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['Draft', 'Pending', 'Approved'][local.index];
                      return Center(
                          child: Text(text,
                              style: TextStyle(
                                  color: Color.lerp(Colors.black, Colors.white,
                                      local.animationValue))));
                    },
                    borderWidth: 0.0,
                    onChanged: (i) {
                      setState(() {
                        value = i;
                        print(i);

                      });
                      if(value == 0) {
                        statusUpdate = "DRAFT";

                        getSharedPrfanceList();
                        //Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
                      }
                      if(value == 1) {
                        statusUpdate = "PENDING";
                        getSharedPrfanceList();
                        //Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                      }
                      if(value == 2) {
                        statusUpdate = "APPROVED";
                        getSharedPrfanceList();
                        //Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
                      }

                    },
                  )
                ],
              ).py(8),
              Expanded(child: onboardingListModalGlobaled == null ?
              Center(child: CircularProgressIndicator()): MyStatelessWidget(onboardingListModalGlobaled!)),
            ],
          ),
        )
    );
  }
}


class MyStatelessWidget extends StatefulWidget {
  final OnboardingListModal employeeListModel;

  MyStatelessWidget(this.employeeListModel);
  @override
  State<MyStatelessWidget> createState() => _MyStatelessWidgetState(employeeListModel);
}


class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final OnboardingListModal employeeListModel;
  _MyStatelessWidgetState(this.employeeListModel);

  var status;
  var stepOne;
  var stepTwo;
  var stepThree;
  var stepFour;
  var stepFive;


  @override
  Widget build(BuildContext context) {
    showTrackDialog(BuildContext buildContext, result,alert) {
      var alertDialog = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0),
            )
        ),
        title: Row(
          children: [
            //Icon(Icons.warning),
            Expanded(child: Text( alert, style: TextStyle(
                fontSize: 18
            ),)),
          ],
        ),
        content: Text(result , style: TextStyle(
            fontSize: 14
        )),
        titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        actions: [
          TextButton(
              onPressed: () {
                /*for(int i=0; i<employeeListModel!.data!.length;i++){
                  setState(() {
                    empId;
                    empName;

                    print('id $empId');
                    print('name $empName');
                  });

                }*/
                //print('emPI $empId');
                //print('emName $empName');
                print("Emp list clicked");
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    HistoryMapView(empName,empId)));

                //Navigator.pop(buildContext);
              },
              child: Container(
                child: Text("History"
                  ,style: TextStyle(color: Mythemes.dangerColor),
                ),
              )
          ),
          TextButton(
              onPressed: () {
                Navigator.of(buildContext, rootNavigator: true).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    LiveMapView(empName,empId)));
              },
              child: Container(
                child: Text("Live",
                    style: TextStyle(color: Mythemes.lightBluishColor)
                ),
              )
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
    return ListView.builder(

      padding: EdgeInsets.only(top: 4, bottom: 4,left: 4, right: 4),
      itemCount: foundDataNew!.length,
      itemBuilder: (context, i) {
        int activeStep = 0;
        int selectedStep = 2;
        int nbSteps = 5;
        return InkWell(
            onTap: () {
              empId = foundDataNew![i].emailId;
              empName = foundDataNew![i].firstName;
              print('ID $empId');
              print('NameCheck $empName');
              Navigator.pushNamed(context, MyRoutings.addInductionProcessRoute);
              //Navigator.pushNamed(context, MyRoutings.hdRaisedTicketReplyRoute);
            },
            child: Card(
                elevation: 2,
                child: Column(
                  children: [
                    /*LinearProgressBar(
                      maxSteps: 5,
                      minHeight: 5.0,
                      progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                      currentStep: i,
                      progressColor: Mythemes.lightBluishColor,
                      backgroundColor: Mythemes.greyishade,
                      borderRadius: BorderRadius.circular(10), //  NEW
                    ).p8().pLTRB(10, 2, 0, 0),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 0,
                            child: CircleAvatar(
                              minRadius: 48,
                              backgroundColor: Mythemes.greyish,
                              backgroundImage: foundDataNew![i].empPhoto.toString() == "" ?  NetworkImage("https://s3.ap-south-1.amazonaws.com/employroll.com/images/1705814809103.jpg") :
                              NetworkImage(foundDataNew![i].empPhoto.toString()),
                            ).px(8).py8()
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                foundDataNew![i].firstName.toString().text.make().px1(),
                                foundDataNew![i].mobileNo.toString().text.make().px1(),
                                foundDataNew![i].emailId.toString().text.make().px1(),
                                foundDataNew![i].departmentName.toString().text.make().px1(),
                              ],
                            )
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                "$statusUpdate".text.color( statusUpdate == "DRAFT" ? Mythemes.alertColor : statusUpdate == "PENDING" ? Mythemes.lightBluishColor : Mythemes.successColor).bold.make(),
                              ],
                            ),

                        )

                      ],
                    ).p(12),
                    /*  Row(
                    children: [

                    ],
                  ),*/


                  ],
                )
            ),

          /* Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Mythemes.greyish,
                          maxRadius: 40,
                          minRadius: 40,
                          backgroundImage: NetworkImage(employeeListModel.data![i].empPhoto!),
                        ),
                        employeeListModel.data![i].empName.toString()
                            .text
                            .make()
                            .px8()
                            .py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {

                                    print("Emp list clicked");
                                    showTrackDialog(
                                        context, "How do you want to see tracking?".toString() + " " , "Tracking Location");
                                  },
                                  icon: Icon(
                                    Icons.map_sharp,
                                    size: 28.0, color: Mythemes.lightBluishColor,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        employeeListModel.data![i].empContactNo.toString()
                            .text
                            .make()
                            .px8(),

                       *//* Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                "1 Year Ago"
                                    .text
                                    .textStyle(
                                    context.captionStyle)
                                    .make().px8(),
                              ],
                            ))*//*

                      ],
                    ).py2(),
                    Row(
                      children: [
                        employeeListModel.data![i].empEmail.toString().text.make().px8(),

                      ],
                    ).py2(),
                  ],
                ),
              )),*/
        );
      },
    );

    /*ListView.builder(
      padding: EdgeInsets.all(6.0),
      itemCount: employeeListModel!.data!.length,
      itemBuilder: (context,i) {
        return SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  empId = employeeListModel!.data![i].empId;
                  print('emPID $empId');
                },
                child: Card(
                  child: CustomListItemTwo(
                    thumbnail: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 9),
                        child: CircleAvatar(
                          backgroundColor: Mythemes.greyish,
                          maxRadius: 40,
                          minRadius: 40,
                          backgroundImage: NetworkImage(employeeListModel.data![i].empPhoto!),
                        ),
                      ),
                    ),

                    title: employeeListModel.data![i].empName as String,
                    subtitle: employeeListModel.data![i].empContactNo as String,
                    author: employeeListModel.data![i].empEmail as String,
                  ),
                ),
              ),
            ],
          ),
        );
      },

    );*/
  }
}
