import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:er_flutter_project/modules/visitorManagement/raiseVisitorRequisition.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'dart:io';
import '../../commanScreen/allAPIList.dart';
import '../../employeePage/employeeListModel.dart';
import '../../sharedPrefancePage/ShardPre.dart';

class VisitorManageSections extends StatefulWidget {
  const VisitorManageSections({super.key});

  @override
  State<VisitorManageSections> createState() => _VisitorManageSectionsState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<Data>? allUsernew = [];
List<Data>? foundDataNew = [];
EmployeeListModel? employeeListModelglobel;
EmployeeListModel? employeeListModelglobeled;
var empName;
var empId;

class _VisitorManageSectionsState extends State<VisitorManageSections> {
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
    Future<EmployeeListModel> getEmployeeList11 = getEmployeeList(sessionId!);
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
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });
  }

  Future<EmployeeListModel> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.getEmpList;
    print('employeeList11: ${SessionId}');
    EmployeeListModel employeeListModel;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel = EmployeeListModel.fromJson(mapResponse);
    allUsernew = employeeListModel.data;

    return employeeListModel;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>? results = [];

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
  var titleName = "Visitor Management";
  var dropdownvalue;
  int switcherIndex1 = 0;
  int value = 0;

  DateTime selectedDate = DateTime.now();
  int pageIndex = 0;
  int currentIndex = 1;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _setToday() {
    setState(() {
      selectedDate = DateTime.now();
    });
  }

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  File? _workDoneImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: titleName.text.make()),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _setToday,
                child: Text('Today'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(20, 30),
                  backgroundColor: Mythemes.lightBluishColor, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _previousDay,
                child: Icon(Icons.chevron_left),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(20, 30),
                  backgroundColor: Mythemes.lightBluishColor,
                ),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  DateFormat('dd-MMM-yyyy').format(selectedDate),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: _nextDay,
                child: Icon(Icons.chevron_right),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(20, 30),
                  backgroundColor: Mythemes.lightBluishColor,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedToggleSwitch<int>.size(
                current: min(value, 2),
                style: ToggleStyle(
                  backgroundColor: Mythemes.greyishade,
                  indicatorColor: Mythemes.lightBluishColor,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  indicatorBorderRadius: BorderRadius.zero,
                ),
                values: const [0, 1],
                iconOpacity: 1.0,
                selectedIconScale: 1.0,
                indicatorSize: const Size.fromWidth(150),
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
                  final text = const ['Visitors', 'Invites'][local.index];
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
                    print(i);
                  });
                },
              ),
            ],
          ).py16(),
          Padding(
            padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 1.0),
            child: TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
          Expanded(
            child:
                employeeListModelglobeled == null
                    ? Center(child: CircularProgressIndicator())
                    : MyStatelessWidget(employeeListModelglobeled!),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            //ImagePicker picker = ImagePicker();
            var imageValue = await _picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 20,
              preferredCameraDevice: CameraDevice.front,
            );
            //picker.dispose();
            if (imageValue == null) return;
            print(
              "Heloo ji "
              "$imageValue",
            );
            setState(() {
              final imagePath = File(imageValue!.path);
              this._workDoneImage = imagePath;
            });
            imageValue = null;
            //imageCache.clear();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder:
                    (context) => RaiseVisitorRequisition(value: _workDoneImage),
              ),
            );
          } on Exception catch (e) {
            print('failed to upload: $e');
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        //height: 20,
        shape: const CircularNotchedRectangle(),
        notchMargin: 1.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 0,
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            selectedItemColor: Mythemes.lightBluishColor,
            unselectedItemColor: Mythemes.greyish,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_circle_rounded),
                label: 'Visitors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rtl_outlined),
                label: 'Approval',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      /*bottomNavigationBar:
      BottomNavigationBar (
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
          unselectedFontSize: 10,
        onTap: (index) {

          if(index==0){

            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){

            print('Attendance');
          }
          if(index==2){
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Dashboard');
          }
          if(index==3){

            print('out duty');
          }
          */
      /*if(index==3){
                title="Notifications";
              }*/
      /*
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
            icon: Icon(Icons.directions_run),
            label: 'Out Duty',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),*/
    );
  }
}

class MyStatelessWidget extends StatefulWidget {
  final EmployeeListModel employeeListModel;

  MyStatelessWidget(this.employeeListModel);
  @override
  State<MyStatelessWidget> createState() =>
      _MyStatelessWidgetState(employeeListModel);
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final EmployeeListModel employeeListModel;
  _MyStatelessWidgetState(this.employeeListModel);

  var green = Color(0xFF45CC0D);
  int? nullableValue;
  bool positive = false;
  bool loading = false;
  List<bool>? positiveStates;
  @override
  void initState() {
    super.initState();
    positiveStates = List.generate(
      foundDataNew!.length,
      (index) => false,
    ); // Initialize with false or your default state
  }

  @override
  Widget build(BuildContext context) {
    showTrackDialog(BuildContext buildContext, result, alert) {
      var alertDialog = AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        title: Row(
          children: [
            //Icon(Icons.warning),
            Expanded(child: Text(alert, style: TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(result, style: TextStyle(fontSize: 14)),
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

              //Navigator.pop(buildContext);
            },
            child: Container(
              child: Text(
                "History",
                style: TextStyle(color: Mythemes.dangerColor),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              child: Text(
                "Live",
                style: TextStyle(color: Mythemes.lightBluishColor),
              ),
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

    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 4, left: 20, right: 20),
      itemCount: foundDataNew!.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            empId = foundDataNew![i].empdetailsId;
            empName = foundDataNew![i].empName;
            print('ID $empId');
            print('NameCheck $empName');
            //Navigator.pushNamed(context, MyRoutings.hdRaisedTicketReplyRoute);
          },
          child: Card(
            elevation: 2,
            child: ListTile(
              isThreeLine: true,
              contentPadding: EdgeInsets.all(12.0),
              leading: CircleAvatar(
                backgroundColor: Mythemes.greyish,
                radius: 35,
                backgroundImage: NetworkImage(foundDataNew![i].empPhoto!),
              ),
              title:
                  foundDataNew![i].empName
                      .toString()
                      .text
                      .overflow(TextOverflow.ellipsis)
                      .maxLines(1)
                      .make()
                      .py8(),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      foundDataNew![i].empContactNo
                          .toString()
                          .text
                          .make()
                          .py4(),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 12,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "In Time".text.size(14).bold.make(),
                              "11:00" == null || "11:00" == 'Casual Leave'
                                  ? ''.text.make()
                                  : "11:00".text.sm.make(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 12,
                            right: 3,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              "Out Time".text.size(14).bold.make(),
                              "-:-" == null || "-:-" == 'Casual Leave'
                                  ? ''.text.make()
                                  : "-:-".text.sm.make(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTheme.merge(
                          data: const IconThemeData(color: Colors.white),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: AnimatedToggleSwitch<bool>.dual(
                              current: positiveStates![i],
                              first: false,
                              second: true,
                              spacing: 80.0,
                              animationDuration: const Duration(milliseconds: 600),
                              style: const ToggleStyle(
                                borderColor: Colors.transparent,
                                indicatorColor: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              customStyleBuilder: (context, local, global) {
                                if (global.position <= 0.0) {
                                  return ToggleStyle(backgroundColor:  Mythemes.greyishade);
                                }
                                return ToggleStyle(
                                    backgroundGradient: LinearGradient(
                                      colors: [Mythemes.successColor, Mythemes.greyishade!],
                                      stops: [
                                        global.position -
                                            (1 - 2 * max(0, global.position - 0.5)) * 0.7,
                                        global.position +
                                            max(0, 2 * (global.position - 0.5)) * 0.7,
                                      ],
                                    ));
                              },
                              borderWidth: 5.0,
                              height: 40.0,
                              loadingIconBuilder: (context, global) =>
                                  CupertinoActivityIndicator(
                                      color: Color.lerp(
                                          Mythemes.greyishade, green, global.position
                                      )
                                  ),
                              onChanged: (bool value) {
                                setState(() {
                                  positiveStates![i] = value; // Update only the specific index
                                });
                              },
                              iconBuilder: (value) => value
                                  ?  Icon(Icons.transit_enterexit,
                                  color: Mythemes.successColor, size: 20.0)
                                  : Icon(Icons.backspace_outlined,
                                  color: Colors.red[800], size: 20.0),
                              textBuilder: (value) => value
                                  ?  Center(child: Text('In', style: TextStyle(color: Mythemes.whitish)))
                                  :  Center(child: Text('Out', style: TextStyle(color: Mythemes.whitish),)),
                            ),
                          ),
                        ),
                      ],
                    ),*/
                ],
              ),
              /*trailing: IconTheme.merge(
                  data: const IconThemeData(color: Colors.white),
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: positive,
                        first: false,
                        second: true,
                        spacing: -3.0,
                        animationDuration: const Duration(milliseconds: 600),
                        style: const ToggleStyle(
                          borderColor: Colors.transparent,
                          indicatorColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        customStyleBuilder: (context, local, global) {
                          if (global.position <= 0.0) {
                            return ToggleStyle(backgroundColor: Colors.red[800]);
                          }
                          return ToggleStyle(
                              backgroundGradient: LinearGradient(
                                colors: [Mythemes.successColor, Colors.red[800]!],
                                stops: [
                                  global.position -
                                      (1 - 2 * max(0, global.position - 0.5)) * 0.7,
                                  global.position +
                                      max(0, 2 * (global.position - 0.5)) * 0.7,
                                ],
                              ));
                        },
                        borderWidth: 5.0,
                        height: 35.0,
                          loadingIconBuilder: (context, global) =>
                              CupertinoActivityIndicator(
                                color: Color.lerp(
                                    Colors.red[800], green, global.position
                                )
                              ),
                        onChanged: (b) => setState(() => positive = b),
                        iconBuilder: (value) => value
                            ?  Icon(Icons.transit_enterexit,
                            color: Mythemes.successColor, size: 20.0)
                            : Icon(Icons.backspace_outlined,
                            color: Colors.red[800], size: 20.0),
                        textBuilder: (value) => value
                            ?  Center(child: Text('In', style: TextStyle(color: Mythemes.whitish)))
                            :  Center(child: Text('Out', style: TextStyle(color: Mythemes.whitish),)),
                      ),
                ),*/
            ),
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

                       */
          /* Expanded(
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
                            ))*/
          /*

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
