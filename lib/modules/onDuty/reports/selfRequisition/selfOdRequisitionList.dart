import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/onDuty/reports/selfRequisition/selfOdReqDateSelect.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:http/http.dart' as http;
import 'modalClass/selfOdReqListModal.dart';

class SelfODRequisitionList extends StatefulWidget {
  final String startDate;
  final String endDate;

  const SelfODRequisitionList(
      {Key? key, required this.startDate, required this.endDate})
      : super(key: key);

  @override
  State<SelfODRequisitionList> createState() =>
      _SelfODRequisitionListState(startDate, endDate);
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();
String? sessionId;
bool isLoading = false;
SelfOdReqListModal? selfOdReqListLabel;

class _SelfODRequisitionListState extends State<SelfODRequisitionList> with RouteAware {
  String startDate;
  String endDate;
  var empNewId;
  var length;

  _SelfODRequisitionListState(this.startDate, this.endDate);

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
    empNewId = "0";
    //getSharedPrfanceList();
    //getEmpId();
    // TODO: implement initState
    super.initState();
  }

/*  Future getEmpId() async {
    empNewId = await shared!.getEmpId();
    print('Response snapshot: ${empNewId}');
  }*/

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    print('ResponseAttendance: ${sessionId}');
    print('ResponseAttendance: ${startDate}');
    print('ResponseAttendance: ${endDate}');
    //await Future.delayed(Duration(seconds: 3));
    Future<SelfOdReqListModal> getEmployeeList11 =
        getSelfOdReqList(sessionId!, startDate, endDate);
    if (getEmployeeList11 == null) {
      return Center(child: "HIi".text.make()
          //CircularProgressIndicator()
          );
    }
    getEmployeeList11.then((value) {
      setState(() {
        selfOdReqListLabel = value;
        isLoading = false;
      });
      //print('employeeList00${selfOdReqListModal!.listdata!.length}');
    });
  }

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime _date = DateTime.now();
  String formattedDate = DateFormat.ABBR_MONTH;

  bool changeDates = true;
  bool changeNewDate = true;

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        changeDates = false;
        _date = _datePicker;
        endDate = DateFormat('yyyy-MM-dd').format(_date);
        print('dateTime${formattedDate}');
        setState(() {
          //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
          _fromDateController.text = DateFormat("dd-MM-yyyy").format(_date!);
        });
      });
    }
  }

  DateTime _newdate = (DateTime.now());
  String formatDate = DateFormat.ABBR_MONTH;

  Future<Null> _selectToDate(BuildContext context) async {
    DateTime? _newDatePicker = await showDatePicker(
      context: context,
      initialDate: _newdate,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (_newDatePicker != null && _newDatePicker != _newdate) {
      setState(() {
        changeNewDate = false;
        _newdate = _newDatePicker;
        startDate = DateFormat('yyyy-MM-dd').format(_newdate);
        setState(() {
          //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
          _toDateController.text = DateFormat("dd-MM-yyyy").format(_newdate!);
        });
      });
    }
  }


  Future<SelfOdReqListModal> getSelfOdReqList(String sessionId, String startDate, String endDate) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.selfOdReqList;
    print('employeeList11: ${sessionId}');
    SelfOdReqListModal selfOdReqListModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "empid=$empNewId&"
        "startdate=$endDate&"
        "enddate=$startDate");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'];

      if (mapResponse.containsKey("error")) {
        //Navigator.of(context, rootNavigator: true).pop();
        String reason = mapResponse['reason'];
        showNullDialog(context, reason.upperCamelCase + " ", result);
        //CommonNotificationPage.showDialgSucess(context, reason, result);
      } else {
        //String reason = mapResponse['reason'];
        if (result.compareToIgnoringCase("error") == 0) {
          //Navigator.of(context, rootNavigator: true).pop();
          showNullDialog(context, "There is no any requisition.".upperCamelCase + " ", "Error");
          // showDialgSucess(context, reason, "Success");
        }
      }
      //print('result ${result} reason ${reason}');
    }
    /*var getData = mapResponse['result'];
    if (getData == "Error" )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    } */
    /*mapResponse = json.decode(response.body);*/
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    selfOdReqListModal = SelfOdReqListModal.fromJson(mapResponse);

    return selfOdReqListModal;
  }

  showNodata(BuildContext buildContext, result,reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
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
            //Navigator.pop(buildContext);

          },
          child: Text("Ok"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: "My Request".text.make(),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:  TextFormField(
                      onTap: () async{
                        _selectDate(context);
                      },
                      readOnly: true,
                      enabled: true,
                      controller: _fromDateController,
                      // initialValue: "Head Office",
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month, size: 18,),
                        enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                          borderSide: BorderSide(
                              width: 1, color: Mythemes.blackishade),
                        ),
                        labelText: "From Date",
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        /*border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8))),*/
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,fontSize: 13,
                            color: Mythemes.blackish),
                      ),
                    ).p8(),
                  ),

                  Expanded(
                    child:  TextFormField(
                      onTap: () async{
                        _selectToDate(context);
                      },
                      readOnly: true,
                      enabled: true,
                      controller: _toDateController,
                      // initialValue: "Head Office",
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month, size: 18,),
                        enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                          borderSide: BorderSide(
                              width: 1, color: Mythemes.blackishade),
                        ),
                        labelText: "To Date",
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        /*border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8))),*/
                        // labelText: "Location",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,fontSize: 13,
                            color: Mythemes.blackish),
                      ),
                    ).p8(),
                  ),
                ],
              ).pLTRB(0, 0, 0, 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_date.compareTo(_newdate) > 0) {
                        return setState(() {
                          AlertDialog(
                            content: "Please select valid date range".text.make(),
                          );
                          print("select valid date range");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Select Valid Date Range "),
                          ));
                        });
                      }

                      if (changeDates == false && changeNewDate == false) {
                        bool result = await InternetConnectionChecker().hasConnection;
                        if(result == false) {
                          setState(() {
                            AlertDialog(
                              content: "Please check your internet connection".text.make(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please check your Internet connection."),
                            ));
                          });

                        } else {
                          isLoading = true;
                          sessionId = await shared!.getSessionId();
                          print('ResponseAttendance: ${sessionId}');
                          print('ResponseAttendance: ${startDate}');
                          print('ResponseAttendance: ${endDate}');
                          //await Future.delayed(Duration(seconds: 3));
                          Future<SelfOdReqListModal> getEmployeeList11 =
                          getSelfOdReqList(sessionId!, startDate, endDate);
                          getEmployeeList11.then((value) {
                            setState(() {
                              selfOdReqListLabel = value;
                              isLoading = false;
                            });
                            //print('employeeList00${selfOdReqListModal!.listdata!.length}');
                          });
                        }

                      } else {
                        print("Please select date");
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Select Date Range "),
                          ));
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Mythemes.lightBluishColor),
                    ),
                    child: "Submit".text.make(),
                  ).wh(120, 45).py(12),
                ],
              ),
              Expanded(
                  child: isLoading
                      ? CircularProgressIndicator():
                  selfOdReqListLabel == null
                      ? Center(child: "Please select date range.".text.make())
                      : getSelfOdRequisitionList(selfOdReqListLabel!)),
            ],
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
              //Navigator.of(context, rootNavigator: true).pop();
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Workflow');
            }
            if(index==2){
              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
              print('OD');
            }
            if(index==3){
              Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.outbond_outlined),
              label: 'OD',
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
      ),
    );
  }

  showNullDialog(BuildContext buildContext, result, alert) {
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
            alert,
            style: TextStyle(fontSize: 18),
          )),
        ],
      ),
      content: Text(result, style: TextStyle(fontSize: 14)),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              //Navigator.pop(buildContext);
            },
            child: Container(
              child: Text("Ok"),
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

  getSelfOdRequisitionList(SelfOdReqListModal selfOdReqListModal) {
    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      itemCount: selfOdReqListModal.listdata != null ? selfOdReqListModal.listdata!.length : 0,
      shrinkWrap: true,
      itemBuilder: (context, itemCount) {
        length = selfOdReqListModal.listdata!.length;
        print("length of data $length");
        if (length == null) {
          return showNullDialog(
              context,
              "There is no data avialable.".upperCamelCase + " ",
              "Alert Message");
        }

        return InkWell(
          onTap: () {
            length = selfOdReqListModal.listdata!.length;
            print("length of data $length");
            if (length == null) {
              return showNullDialog(
                  context,
                  "There is no data avialable.".upperCamelCase + " ",
                  "Alert Message");
            }
            /* Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  OdApproveDisapproveReq(pendingOdReqList, itemCount)));*/
          },
          child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        selfOdReqListModal.listdata![itemCount].name
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
                            selfOdReqListModal
                                .listdata![itemCount].approvalstatus
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
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: selfOdReqListModal
                              .listdata![itemCount].odaddress
                              .toString()
                              .text
                              .overflow(TextOverflow.ellipsis)
                              .maxLines(1)
                              .textStyle(context.captionStyle)
                              .make(),
                        ),
                      ],
                    ).px8(),
                    Row(
                      children: [
                        selfOdReqListModal.listdata![itemCount].remark
                            .toString()
                            .text
                            .textStyle(context.captionStyle)
                            .make()
                            .px8(),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 35,
                                color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              selfOdReqListModal.listdata![itemCount].odtype
                                  .toString()
                                  .text
                                  .sm
                                  .make(),
                              selfOdReqListModal.listdata![itemCount].odtime
                                  .toString()
                                  .text
                                  .sm
                                  .make()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 35,
                                color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "Date".text.sm.make(),
                              DateFormat("dd-MM-yyyy")
                                  .format(DateTime.parse(selfOdReqListModal
                                      .listdata![itemCount].date
                                      .toString()))
                                  .text
                                  .sm
                                  .make()
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        );
      },
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
