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
          title: "My OD Requests".text.make(),
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
              Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
              print('My All requests');
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
              icon: Icon(Icons.account_tree_outlined),
              label: 'My Requests',
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
  var statusColor;
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
        var statusCheck = selfOdReqListModal.listdata![itemCount].approvalstatus;
        if (statusCheck == 'Approved') {
          statusColor = Mythemes.successColor;
        } else if (statusCheck == 'DisApproved') {
          statusColor = Mythemes.dangerColor;
        } else {
          statusColor = Mythemes.alertColor;
        }
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
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Avatar | Name + address | Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: Image.network(
                            selfOdReqListModal.listdata![itemCount].image ?? "",
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/avtar7.png',
                                fit: BoxFit.cover,
                                width: 56,
                                height: 56,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Name + address (left, expandable)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              selfOdReqListModal.listdata![itemCount].name.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Address row with icon. The Expanded text prevents overflow and ellipsizes.
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    selfOdReqListModal.listdata![itemCount].odaddress.toString(),
                                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.redAccent),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    selfOdReqListModal.listdata![itemCount].remark.toString(),
                                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Status (right aligned, stays vertically at the top)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            selfOdReqListModal.listdata![itemCount].approvalstatus.toString(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Remark row
                  /*Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            foundDataNewMSS![itemCount].remark.toString(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),*/

                  const SizedBox(height: 12),
                  const Divider(height: 1),

                  const SizedBox(height: 10),

                  // Bottom icons row (In/Out + Date)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left block - In/Out and time
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app, size: 32, color: Mythemes.lightBluishColor),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selfOdReqListModal.listdata![itemCount].odtype.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selfOdReqListModal.listdata![itemCount].odtime.toString(),
                                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right block - Date
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.date_range, size: 32, color: Mythemes.lightBluishColor),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat("dd-MM-yyyy")
                                      .format(DateTime.parse(selfOdReqListModal.listdata![itemCount].date.toString())),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
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
