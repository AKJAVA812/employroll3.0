import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../modalClass/leaveBalModal.dart';
import '../modalClass/leaveBalanceModel.dart';
import 'package:http/http.dart' as http;

class LeaveRequisitionPage extends StatefulWidget {
  const LeaveRequisitionPage({Key? key}) : super(key: key);

  @override
  State<LeaveRequisitionPage> createState() => _LeaveRequisitionPageState();
}
SessionManager sessionManager=SessionManager();
Map<String, dynamic> mapResponse = {};
Map<String, dynamic> mapResponseLBalance = {};
SessionManager shared = SessionManager();
String? sessionId;
var doj;
LeaveBalModal? leaveBalLabel;
LeaveBalanceModel? leaveBalanceLabel;
String valuenew="listText";
List<String> leavereqIdGlobel=[];
late List<String?> list = [];
late List<String?> leaveTypeList = [];
class _LeaveRequisitionPageState extends State<LeaveRequisitionPage> with RouteAware{
  var titleName = "Leave Requisition";
  String? branchName;
  String? deptName;
  String? empName;
  static const List<String> list = <String>['Casual Leave', 'Leave Monthly'];
  var dropdownNewvalue;
  var empNewId;
  var orgNewId;
  String dayRadio = "1";
  String confirmYes = "";
  bool singleDayShow = true;
  bool multipleDayShow = false;
  bool halfDayRadio = false;
  bool halfDayShow = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController fromTimePickerController = TextEditingController();
  final TextEditingController toTimePickerController = TextEditingController();
  final TextEditingController _nomineeController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  String _fromTimePicker = '00:00';
  String _toTimePicker = '00:00';
  var fromDate;
  var getRemark;
  var leaveTypeId;
  var nominee;
  final _formKey = GlobalKey<FormState>();



  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LeaveBalModal> getAppReq11 = getLeaveBalance(sessionId!);

    fetchLeaveBalance(sessionId!);
    doj= await shared.getDoj();
    Future<LeaveBalanceModel?> getLeaveType12 = getLeaveTypeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );
    getLeaveType12.then((value) {
      setState(() {
        leaveBalanceLabel=value;
        //var leaveTypeId = value?.leaveData.leaveTypeList;
        //print('object$leaveTypeId');
      });
    });
    getAppReq11.then((value) {
      setState(() {
        leaveBalLabel=value;
      });

    });
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
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(buildContext);
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

  Future<LeaveBalModal> getLeaveBalance(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBal;
    print('employeeList11: ${SessionId}');
    LeaveBalModal leaveBalModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    //print('responseemployeeList ${response.body}');

    mapResponseLBalance = json.decode(response.body);
    var getData = mapResponseLBalance['data'];

    var emptyjson = mapResponseLBalance['leaveData']['leaveTypeList'];
    //var emptyjson = respons;

    var notEmptyjson = mapResponseLBalance.isNotEmpty;
    var containsEmptyjson = mapResponseLBalance.length;

    print('responseemployeeList $mapResponseLBalance');
    leaveBalModal=LeaveBalModal.fromJson(mapResponseLBalance);

    //print("typename:-${mapResponse['leaveData']['CO-578']['leavesTaken']}");
    if(emptyjson==null){
      showNodata(context, "Oops!!", "You are not mapped with any leave policy.");
    }
    return leaveBalModal;
  }

  Future<LeaveBalanceModel?> getLeaveTypeList(String sessionId) async {
    leaveTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBalanceApi;
    print('employeeList11: ${sessionId}');
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseLeaveTypeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['leaveTypeList'];
    print("GETDATA $getData");

    print('responseLeaveTypeList $getData');
    leaveBalanceLabel=LeaveBalanceModel.fromJson(mapResponse);
    int? length = leaveBalanceLabel?.leaveData?.leaveTypeList?.leaveTypelist?.length;

    print('totalleaveLength $length ');

    for(int i=0; i<mapResponse['leaveTypeList'].length;i++){
      var halfDayRadioShow =  mapResponse['leaveTypeList'][i]['isHalfday'];
      String? leaveTypeName = mapResponse['leaveTypeList'][i]['leavetype'];
      leaveTypeList.add(mapResponse['leaveTypeList'][i]['leavetype']);


      //print('dataLeaveTypeName $leaveTypeName');
      //print("HalfDayShow $halfDayRadioShow");
    }

    return leaveBalanceLabel;
  }

  Map<String, dynamic>? leaveBalances;
  List<String> leaveTypes = [];
  /*Future<void> fetchLeaveBalance(String sessionId) async {
    try {
      LeaveBalModal leaveBalModal = await getLeaveBalance(sessionId);

      setState(() {
        leaveBalances = {};
        leaveTypes = [];

        // === Convert leaveData to Map<String, dynamic> safely ===
        dynamic rawLeaveData = leaveBalModal.leaveData;

        // If it's already a Map, use it directly; otherwise convert via json encode/decode
        Map<String, dynamic> leaveDataMap;
        if (rawLeaveData is Map<String, dynamic>) {
          leaveDataMap = rawLeaveData;
        } else {
          // Converts typed object -> JSON string -> Map
          leaveDataMap = json.decode(json.encode(rawLeaveData)) as Map<String, dynamic>;
        }

        // === Read leaveTypeList -> leaveTypelist safely ===
        final rawTypeList = (leaveDataMap['leaveTypeList']?['leaveTypelist']) ?? [];

        // Ensure it's a List
        final List<dynamic> typelist =
        (rawTypeList is List) ? rawTypeList : (rawTypeList is String ? [rawTypeList] : []);

        // Extract codes like "Casual Leave-CL-789" -> "CL"
        for (var item in typelist) {
          final parts = item.toString().split('-');
          if (parts.length >= 2) {
            leaveTypes.add(parts[1].trim());
          }
        }

        // Deduplicate if any
        leaveTypes = leaveTypes.toSet().toList();

        // === Map each leave type to its data (find the matching key like "CL-789" or "CL-789" present keys) ===
        // The API keys look like "CL-789" or "EL-790" etc. We search for keys that contain the code (e.g. "-CL")
        for (final type in leaveTypes) {
          //print("value1111 $type");

          final matchedKey = leaveDataMap.keys.firstWhere(
                (k) {
              final lower = k.toString().toLowerCase();
              print("value1111L $k");
              final t = type.toLowerCase();
              //print("value1111T $t");
              return lower.startsWith('$t-');
              // ✅ fixed
            },
            orElse: () => '',
          );
          print("🔍 Matching type=$type with keys=${leaveDataMap.keys}");
          print("✅ matchedKey=$matchedKey -> ${leaveDataMap[matchedKey]}");

          if (matchedKey.isNotEmpty) {
            final val = leaveDataMap[matchedKey];
            if (val is Map<String, dynamic>) {
              leaveBalances![type] = val;
            } else {
              leaveBalances![type] =
              (val != null) ? json.decode(json.encode(val)) : {};
            }
          } else {
            leaveBalances![''] = {
              'lwp': 0,
              'leavesTaken': 0,
              'totalLeavesPending': 0,
              'currentYearLeaves': 0,
              'lastYearLeaves': 0,
            };
          }
        }

        // debug prints
        print("✅ leaveTypes: $leaveTypes");
        print("✅ leaveBalances: $leaveBalances");
      });
    } catch (e, st) {
      print("❌ Error in fetchLeaveBalance: $e");
      print(st);
      // optional: setState to clear loader or show fallback UI
      setState(() {
        leaveBalances = {};
        leaveTypes = [];
      });
    }
  }*/
  Future<void> fetchLeaveBalance(String sessionId) async {
    try {
      LeaveBalModal leaveBalModal = await getLeaveBalance(sessionId);

      setState(() {
        leaveBalances = {};
        leaveTypes = [];

        // ✅ Step 1: Ensure we have valid data
        if (leaveBalModal.leaveData == null) {
          print("❌ No leaveData found in API response");
          return;
        }

        // ✅ Step 2: Extract the parsed balances directly from model
        final parsedBalances = leaveBalModal.leaveData!.getParsedBalances();

        // ✅ Step 3: Set the data for UI
        leaveBalances = parsedBalances;
        leaveTypes = parsedBalances.keys.toList();

        // ✅ Debug info
        print("✅ leaveTypes: $leaveTypes");
        print("✅ leaveBalances: $leaveBalances");

      });
    } catch (e, st) {
      print("❌ Error in fetchLeaveBalance: $e");
      print(st);
      setState(() {
        leaveBalances = {};
        leaveTypes = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    getDept();
    getBranch();
    getEmpId();
    getOrgId();
    getSharedPrfanceList();

  }

  Future getUserName() async {
    empName = await shared!.getempName();
    print('Response snapshot: ${empName}');
  }
  Future getDept() async {
  deptName = await shared!.getDept();
    print('Response snapshot: ${deptName}');
  }
  Future getBranch() async {
    branchName = await shared!.getBranch();
    print('Response snapshot: ${branchName}');
  }
  Future getEmpId() async {
    empNewId = await shared!.getEmpId();
    print('Response snapshot: ${empNewId}');
  }

  Future getOrgId() async {
    orgNewId = await shared!.getOrgId();
    print('ORGID: ${orgNewId}');
  }

  final List<Map<String, String>> leaveData = [
    {"count": "19", "type": "TOTAL", "subtext": "24 Leaves"},
    {"count": "3", "type": "ANNUAL", "subtext": "12 Leaves"},
    {"count": "2", "type": "SICK", "subtext": "6 Leaves"},
    {"count": "1", "type": "CASUAL", "subtext": "8 Leaves"},
    {"count": "0", "type": "MATERNITY", "subtext": "90 Leaves"},
  ];

  File? uploadedFile;
  var sickLeaveMedicalTypeShow = false;
  var sickLeaveMedicalShow = false;
  var sickLeaveMedicalShowValue = 0;
  void openUploadDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
                child: Text("Upload Medical",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Use Camera"),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() => uploadedFile = File(image.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.teal),
              title: const Text("Upload from Files"),
              onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null && result.files.single.path != null) {
                  setState(() => uploadedFile = File(result.files.single.path!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAttachmentBottomSheet(BuildContext context, String attachmentUrl) {
    final isPdf = attachmentUrl.toLowerCase().endsWith('.pdf');
    final isImage = attachmentUrl.toLowerCase().endsWith('.jpg') ||
        attachmentUrl.toLowerCase().endsWith('.jpeg') ||
        attachmentUrl.toLowerCase().endsWith('.png');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(

        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("View Attachment",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            // File content viewer
            Expanded(
              child: isPdf
                  ? SfPdfViewer.network(
                attachmentUrl,
                canShowScrollStatus: true,
                canShowPaginationDialog: true,
              )
                  : isImage
                  ? CachedNetworkImage(
                imageUrl: attachmentUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                const Center(child: Text("❌ Failed to load image")),
              )
                  : const Center(
                child: Text(
                  "⚠️ Unsupported file format",
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  int pageIndex = 0;
  int currentIndex = 2;
  int value = 1;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          title: titleName.text.make(),
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
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              print('Leave');
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
              icon: Icon(Icons.group_off),
              label: 'Leave',
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


        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /*Visibility(
                  visible: orgNewId != 190 && orgNewId != 191 && orgNewId != 198,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 3),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1, 2],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(85),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 3.0,
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
                          final text = const ['Attendance', 'Leave', 'OD'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {
                            value = i;
                            print(i);

                          });
                          if(value == 0){
                            Navigator.pushNamed(context, MyRoutings.attendanceReqCalendar);
                            //Navigator.of(context, rootNavigator: true).pop();

                          }
                          if(value == 1) {
                            Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                          }
                          if(value == 2) {
                            Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                          }
                          *//* if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*//*
                        },
                      )
                    ],
                  ),
                ),

                Visibility(
                  visible: orgNewId == 190 || orgNewId == 191 || orgNewId == 198,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 2),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(85),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 3.0,
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
                          final text = const ['Attendance', 'Leave'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {
                            value = i;
                            print(i);

                          });
                          if(value == 0){
                            Navigator.pushNamed(context, MyRoutings.attendanceReqCalendar);
                            //Navigator.of(context, rootNavigator: true).pop();
                          }
                          if(value == 1) {
                            Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                          }
                          *//* if(value == 2) {
                              Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                            }*//*
                          *//* if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*//*
                        },
                      )
                    ],
                  ),
                ),*/
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedToggleSwitch<int>.size(
                      height: 30,
                      current: min(value, 3),
                      style: ToggleStyle(
                        backgroundColor: Mythemes.greyishade,
                        indicatorColor: Mythemes.lightBluishColor,
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        indicatorBorderRadius: BorderRadius.zero,
                      ),
                      values: const [0, 1, 2],
                      iconOpacity: 1.0,
                      selectedIconScale: 1.0,
                      indicatorSize: const Size.fromWidth(85),
                      iconAnimationType: AnimationType.onHover,
                      styleAnimationType: AnimationType.onHover,
                      spacing: 3.0,
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
                        final text = const ['Attendance', 'Leave', 'OD'][local.index];
                        return Center(
                            child: Text(text,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.lerp(Colors.black, Colors.white,
                                        local.animationValue))));
                      },
                      borderWidth: 0.0,
                      onChanged: (i) {
                        setState(() {
                          value = i;
                          print(i);

                        });
                        if(value == 0){
                          Navigator.pushNamed(context, MyRoutings.attendanceReqCalendar);
                          //Navigator.of(context, rootNavigator: true).pop();

                        }
                        if(value == 1) {
                          Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
                          //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                        }
                        if(value == 2) {
                          Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                        }
                        /* if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*/
                      },
                    )
                  ],
                ),
                /*Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(text: branchName),
                    enabled: false,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        hintText: branchName,
                        labelText: "Branch Name"
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(text: deptName),
                    enabled: false,
                    //initialValue: "${branchName}",
                    decoration:  InputDecoration(
                        hintText: deptName,
                        labelText: "Department Name"
                    ),
                  ),
                ),*/

                leaveBalances == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeaveCardDynamic(
                    "Leave Taken (Current Ledger)",
                    leaveTypes,
                    leaveBalances!, (type) => leaveBalances?[type]?['leavesTaken']?.toString() ?? "0",
                    Colors.red,
                    isBold: true,
                  ),
                  const SizedBox(height: 12),
                  _buildLeaveCardDynamic(
                    "Total Balance",
                    leaveTypes,
                    leaveBalances!,
                        (type) => leaveBalances?[type]?['totalLeavesPending']?.toString() ?? "0",
                    Colors.green,
                    isBold: true,
                  ),
                ],
              ).py8(),
                /*Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("LEAVE BALANCE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: leaveData.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = leaveData[index];
                            return _buildLeaveNewCard(item["count"]!, item["type"]!, item["subtext"]!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),*/


                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: TextEditingController(text: empName),
                    enabled: false,
                    //initialValue: deptName,
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(
                      ),
                        hintText: empName,
                        labelText: "Employee Name"

                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    value:  dropdownNewvalue,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                          borderSide: BorderSide(
                              width: 1, color: Mythemes.blackishade),
                        ),
                        //labelText: "Select Department",
                        hintText: "Leave Type",
                        hintStyle: TextStyle(
                          fontSize: 14,
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
                      items: leaveTypeList.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );

                      }).toList(),
                    onChanged: (newVal) {
                      valuenew = newVal.toString();
                      int i =leaveTypeList.indexOf(valuenew);
                      print("Leave Type Data List - ${mapResponse['leaveTypeList']}");
                      leaveTypeId = mapResponse['leaveTypeList'][i]['leaveId'];
                      var leaveHalfDay = mapResponse['leaveTypeList'][i]['isHalfday'];
                      sickLeaveMedicalTypeShow = mapResponse['leaveTypeList'][i]['medCerti'];
                      sickLeaveMedicalShowValue = mapResponse['leaveTypeList'][i]['medValue'];
                      //print("MED CERTI - $sickLeaveMedicalShow");
                      //print("MED VALUE - $sickLeaveMedicalShowValue");
                      //print('Leave Half Day $leaveHalfDay');
                      var policyidnew= leaveTypeList.elementAt(i);
                      leavereqIdGlobel = newVal.toString().split('-');
                      String idn=leavereqIdGlobel.last;
                      print('leaveTypeId $leaveTypeId');
                      setState(() {
                        //print('value1 $i');
                        //print('value $policyidnew');

                        dropdownNewvalue = newVal;

                      });
                      if(leaveHalfDay == true) {
                        setState(() {
                          this.halfDayRadio = true;
                        });
                      }
                      else {
                        setState(() {
                          this.halfDayRadio = false;
                        });
                      }
                      /*if(i == 0 || i == 1 || i == 2) {
                        setState(() {
                          this.halfDayRadio = true;
                        });
                      }
                      else {
                        setState(() {
                          this.halfDayRadio = false;
                        });
                      }*/
                    },

                  ),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: "1",
                                  groupValue: dayRadio,
                                  onChanged: (value) {
                                    setState(() {
                                      singleDayShow = true;
                                      multipleDayShow = false;
                                      halfDayShow = false;
                                      print("day show $singleDayShow");
                                      print("multi show $multipleDayShow");
                                      /*  _singleDayShow == _singleDayShow;
                                           _multipleDayShow == _multipleDayShow;*/
                                    });
                                    setState(() {
                                      dayRadio = value.toString();
                                    });
                                  },
                                ),
                                "Single Day".text.make(),
                              ],
                            ).px1(),
                            Row(
                              /*mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,*/
                              children: [
                                Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: "2",
                                  groupValue: dayRadio,
                                  onChanged: (value) {
                                    setState(() {
                                      singleDayShow = true;
                                      multipleDayShow = true;
                                      halfDayShow = false;
                                      print("day show $singleDayShow");
                                      print("multi show $multipleDayShow");
                                      /*  _singleDayShow =_singleDayShow;
                                          _multipleDayShow =! _multipleDayShow;*/
                                    });
                                    setState(() {
                                      dayRadio = value.toString();
                                    });
                                  },
                                ),
                                "Multiple Day".text.make(),
                              ],
                            ).px1(),
                            Visibility(
                              visible: halfDayRadio,
                              child: Row(
                                /* mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,*/
                                children: [
                                  Radio(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: "3",
                                    groupValue: dayRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        singleDayShow = true;
                                        multipleDayShow = false;
                                        halfDayShow = true;
                                        print("day show $singleDayShow");
                                        print("multi show $multipleDayShow");
                                        /* _singleDayShow == _singleDayShow;
                                            _multipleDayShow = !_multipleDayShow;*/
                                      });
                                      setState(() {
                                        dayRadio = value.toString();
                                      });
                                    },
                                  ),
                                  "Half Day".text.make(),
                                ],
                              ).px1(),
                            ),
                          ],
                        ).pLTRB(0, 0, 5, 5)

                    ),
                  ],
                ),

                Row(
                  children: [

                    Visibility(
                      visible: singleDayShow,
                      child: Expanded(
                        child:  TextFormField(
                          onTap: () async{
                            DateTime? fromDate = DateTime.now();
                            FocusScope.of(context).requestFocus(new FocusNode());

                            fromDate = await showDatePicker(
                                context: context,
                                initialDate: fromDate,
                                firstDate:DateTime(1947),
                                lastDate: DateTime(2040)
                            );
                            setState(() {
                              //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                              _fromDateController.text = DateFormat("dd-MM-yyyy").format(fromDate!);
                            });

                            print(fromDate);
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
                    ),

                    Visibility(
                      visible: multipleDayShow,
                      child: Expanded(
                        child:  TextFormField(
                          onTap: () async{
                            DateTime? toDate = DateTime.now();
                            FocusScope.of(context).requestFocus(new FocusNode());

                            toDate = await showDatePicker(
                                context: context,
                                initialDate: toDate,
                                firstDate:DateTime(1947),
                                lastDate: DateTime(2040)
                            );
                            /*setState(() {
                              //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                              _toDateController.text = DateFormat("dd-MM-yyyy").format(toDate!);
                            });*/
                            setState(() {
                              _toDateController.text = DateFormat("dd-MM-yyyy").format(toDate!);

                              // 🧩 Calculate day difference between from and to date
                              if (_fromDateController.text.isNotEmpty) {
                                DateTime fromDateParsed =
                                DateFormat("dd-MM-yyyy").parse(_fromDateController.text);
                                int dayDifference = toDate.difference(fromDateParsed).inDays + 1;

                                print("Sick Leave Value - $sickLeaveMedicalShowValue");
                                print("Day Difference - $dayDifference");
                                // 🧠 Show medical section if dayDifference > medValue
                                if (sickLeaveMedicalShowValue != null &&
                                    dayDifference > sickLeaveMedicalShowValue) {
                                  sickLeaveMedicalShow = true;
                                  //print("SICK LEAVE SHOW - $sickLeaveMedicalShow");
                                  //print("SICK LEAVE VALUE - $sickLeaveMedicalShowValue");

                                } else {
                                  sickLeaveMedicalShow = false;
                                  //print("SICK LEAVE SHOW - $sickLeaveMedicalShow");
                                  //print("SICK LEAVE VALUE - $sickLeaveMedicalShowValue");
                                }
                              } else {
                                sickLeaveMedicalShow = false;
                                //print("SICK LEAVE SHOW - $sickLeaveMedicalShow");
                                //print("SICK LEAVE VALUE - $sickLeaveMedicalShowValue");
                              }
                            });

                            print(toDate);
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
                    ),
                  ],
                ).pLTRB(0, 0, 0, 8),
                Visibility(
                  visible: halfDayShow,
                  child: Row(
                    children: [
                      Expanded(
                        child:  TextFormField(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            //_openInTimepicker(context);
                            final TimeOfDay? n = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                });
                            print('timenewOut $n');
                            setState(() {
                              var now = DateTime.now();
                              DateTime newt = DateTime(now.year, now.month,
                                  now.day, n!.hour, n!.minute);
                              var nT = DateFormat('HH:mm').format(newt);
                              print(DateFormat('HH:mm').format(newt));
                              _fromTimePicker = nT;
                              fromTimePickerController.text = _fromTimePicker;
                            });
                          },
                          controller: fromTimePickerController,
                          readOnly: true,
                          enabled: true,
                          // initialValue: "Head Office",
                          // maxLines: 3,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                              borderSide: BorderSide(
                                  width: 1, color: Mythemes.blackishade),
                            ),
                            suffixIcon: Icon(
                              Icons.timer, size: 18,
                            ),
                            contentPadding: EdgeInsets.all(5),
                            labelText: "From Time",
                            //hintText: _fromTimePicker,
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
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
                          onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            //_openInTimepicker(context);
                            final TimeOfDay? o = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                });
                            print('timenewOut $o');
                            setState(() {
                              var now = DateTime.now();
                              DateTime newt = DateTime(now.year, now.month,
                                  now.day, o!.hour, o!.minute);
                              var ot = DateFormat('HH:mm').format(newt);
                              print(DateFormat('HH:mm').format(newt));
                              _toTimePicker = ot;
                              toTimePickerController.text = _toTimePicker;
                            });
                          },
                          controller: toTimePickerController,
                          enabled: true,
                          readOnly: true,
                          // initialValue: "Head Office",
                          // maxLines: 3,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                              borderSide: BorderSide(
                                  width: 1, color: Mythemes.blackishade),
                            ),
                            suffixIcon: Icon(
                              Icons.timer, size: 18,
                            ),
                            contentPadding: EdgeInsets.all(5),
                            labelText: "To Time",
                            //hintText: _fromTimePicker,
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
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
                  ),
                ),

                Visibility(
                  visible: orgNewId == 115 || orgNewId == 145 || orgNewId == 3,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nomineeController,
                      enabled: true,
                      //initialValue: deptName,
                      decoration:  InputDecoration(
                          hintText: "Enter Name",
                          labelText: "Nominee"

                      ),
                    ),
                  ),
                ),

                // Upload
                Visibility(
                  visible: sickLeaveMedicalTypeShow && sickLeaveMedicalShow,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // margin
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Upload Medical",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: openUploadDialog,
                        ),
                      ),
                    ),
                  ),
                ),

                /*if (uploadedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("📎 Selected: ${uploadedFile!.path.split('/').last}",
                        style: const TextStyle(color: Colors.green)),
                  ),*/
                if (uploadedFile != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    "View Attachment".text.bold.color(Mythemes.lightBluishColor).make().px12(),
                    IconButton(
                      onPressed: () {
                        if (uploadedFile != null &&
                            uploadedFile.toString().isNotEmpty) {
                          showAttachmentBottomSheet(context, uploadedFile.toString());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No attachment available")),
                          );
                        }
                      },
                      icon: Icon(Icons.remove_red_eye,
                          color: Mythemes.lightBluishColor, size: 24),
                      tooltip: "View Attachment",
                    ),
                  ],
                ),



                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _remarkController,
                    maxLines: 2,
                    enabled: true,
                    //initialValue: deptName,
                    decoration:  InputDecoration(
                        hintText: "Add remarks",
                        labelText: "Remarks"

                    ),
                  ),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {

                        if(_fromDateController.text == "" ) {
                          Fluttertoast.showToast(
                              msg: "Please Select Date range !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        } else {
                          if(_remarkController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Fill Remarks !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else {
                            if (dayRadio == '1') {
                              singleDayRequisition(_remarkController.text, leaveTypeId, _fromDateController.text, empNewId, _nomineeController.text, confirmYes);
                            }
                            else if(dayRadio == '2') {
                              if(_toDateController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "Please Select Date range !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              } else {
                                multipleDayRequisition(_remarkController.text, leaveTypeId, _toDateController.text, _fromDateController.text, empNewId, _nomineeController.text, confirmYes);
                              }
                            }
                            else if (dayRadio == '3') {
                              halfDayRequisition(fromTimePickerController.text, toTimePickerController.text, _remarkController.text, leaveTypeId, _fromDateController.text, empNewId, _nomineeController.text, confirmYes);
                            }
                          }
                        }


                        //key = "APPROVED";
                        //approveLeaveRequisition(_commentController.text, leaveReqId);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Mythemes.lightBluishColor),
                      ),
                      child: "Send".text.make(),
                    ).wh(150, 40).py12(),
                  ],
                )

              ],
            ),
          ),
        ),

      ),
    );
  }

  showValidatePop(BuildContext buildContext, result,alert) {
    String text = "Stop Service";
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
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
            onPressed: () async {
              Navigator.of(buildContext, rootNavigator: true).pop();
              //Navigator.pop(buildContext);
            },
            child: Container(
              child: Text("No", style: TextStyle(color: Mythemes.dangerColorOne),),
            )
        ),
        TextButton(
            onPressed: () async {
              confirmYes = "YES";
              Navigator.of(buildContext, rootNavigator: true).pop();
              if(_fromDateController.text == "" ) {
                Fluttertoast.showToast(
                    msg: "Please Select Date range !",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              } else {
                CommonNotificationPage.showLoaderDialog(context);
                if(_remarkController.text == "") {
                  Fluttertoast.showToast(
                      msg: "Please Fill Remarks !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                else {
                  if (dayRadio == '1') {
                    singleDayRequisition(_remarkController.text, leaveTypeId, _fromDateController.text, empNewId, _nomineeController.text, confirmYes);
                  }
                  else if(dayRadio == '2') {
                    if(_toDateController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Select Date range !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else {
                      multipleDayRequisition(_remarkController.text, leaveTypeId, _toDateController.text, _fromDateController.text, empNewId, _nomineeController.text, confirmYes);
                    }
                  }
                  else if (dayRadio == '3') {
                    halfDayRequisition(fromTimePickerController.text, toTimePickerController.text, _remarkController.text, leaveTypeId, _fromDateController.text, empNewId, _nomineeController.text, confirmYes);
                  }
                  Navigator.of(buildContext, rootNavigator: true).pop();
                }

              }

              //Navigator.pop(buildContext);
            },
            child: Container(
              child: Text("Yes", style: TextStyle(color: Mythemes.warningColor),),
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

  Widget _buildLeaveNewCard(String count, String type, String subtext) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          Text(type, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue)),
          const SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLeaveCardDynamic(
      String title,
      List<String> types,
      Map<String, dynamic> data,
      String Function(String) valueGetter,
      Color titleColor, {
        bool isBold = false,
      }) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                        color: titleColor)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 35,
                  runSpacing: 20,
                  children: types.map((type) {
                    final value = valueGetter(type);
                    return _buildLeaveType(type, value, _getColorForType(type));
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Color _getColorForType(String type) {
    switch (type.toUpperCase()) {
      case "CL":
        return Colors.orange;
      case "SL":
        return Colors.blue;
      case "EL":
        return Colors.green;
      case "PL":
        return Colors.red;
      case "CO":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLeaveCard(String title, String cl, String sl, String el, String pl, String WO, Color titleColor, {bool isBold = false}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),

            // Replace Row with Wrap
            Wrap(
              spacing: 25, // Horizontal spacing
              runSpacing: 25, // Vertical spacing
              children: [
                _buildLeaveType("CL", cl, Colors.orange),
                _buildLeaveType("SL", sl, Colors.blue),
                _buildLeaveType("EL", el, Colors.green),
                _buildLeaveType("PL", pl, Colors.red),
                _buildLeaveType("WO", WO, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

/*  Widget _buildLeaveType(String type, String count, Color color) {
    return Column(
      children: [
        Text(type, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }*/
  Widget _buildLeaveType(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }


  Future<void> singleDayRequisition(String getRemark, int? idn, fromDate, empNewId, nominee, String confirmYes) async {

    String idn=leavereqIdGlobel.last;
    String dayRadio = "1";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
   /* var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "leaveTypeId=$leaveTypeId&"
        "fromDate=$fromDate&"
        "summary=$getRemark&"
        "radio=$dayRadio&"
        "empid=$empNewId&"
        "nominee=$nominee&"
        "confirmyes=$confirmYes"
    );*/
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['leaveTypeId'] = leaveTypeId.toString();
    request.fields['fromDate'] = fromDate;
    request.fields['summary'] = getRemark;
    request.fields['radio'] = dayRadio;
    request.fields['empid'] = empNewId.toString();
    request.fields['nominee'] = nominee;
    request.fields['confirmyes'] = confirmYes;

    // ✅ Attach file if available
  /*  if (uploadedFile != null && uploadedFile!.existsSync()) {
      String fileName = uploadedFile!.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'document',               // key name for backend
          uploadedFile!.path,       // local file path
          filename: fileName,
        ),
      );
    } else {
      // If no file uploaded, send empty field
      request.fields['document'] = "";
    }*/

    String apiWithParams = urlapi.toString() +
        '?' +
        request.fields.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
    print('API URL with Parameters: $apiWithParams');

    //final response = await http.post(urlapi);
    http.StreamedResponse response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print('URL ${httpResponse.request}');
    if (httpResponse.statusCode == 200) {
      var responseResult = httpResponse.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(httpResponse.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      bool isValidate = true;
      try{
       isValidate = mapResponse['result']['isValidation'];
      } catch (e) {
        //Navigator.of(context, rootNavigator: true).pop();
        isValidate = true;
      }

      print('result both $result $reason');
      print('result${result}');
      print("IsValidate - $isValidate");
      if(isValidate == false) {
        if(result.compareToIgnoringCase("success")==0){
          showDialgSucess(context,reason.upperCamelCase+" ","Success");
        }else if(result.compareToIgnoringCase("error")==0){
          showDialgSucess(context,reason.upperCamelCase, " Error ");
        }else if(result.compareToIgnoringCase("warning")==0){
          showValidatePop(context,reason.upperCamelCase, " Warning ");
        }

      } else {
        if(result.compareToIgnoringCase("success")==0){
          showDialgSucess(context,reason.upperCamelCase+" ","Success");
        }else if(result.compareToIgnoringCase("error")==0){
          showDialgSucess(context,reason.upperCamelCase, " Error ");
        }else if(result.compareToIgnoringCase("warning")==0){
          showDialgSucess(context,reason.upperCamelCase, " Warning ");
        }
      }

    }
  }

  Future<void> multipleDayRequisition(String getRemark, int? idn, toDate, fromDate, empNewId,nominee, String confirmyes) async {
    String idn=leavereqIdGlobel.last;
    String dayRadio = "2";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
   /* var urlapi = Uri.parse("$conn$apiUrl?"
        "tilldate=$toDate&"
        "sessionId=$sessionId&"
        "leaveTypeId=$leaveTypeId&"
        "fromDate=$fromDate&"
        "summary=$getRemark&"
        "radio=$dayRadio&"
        "empid=$empNewId&"
        "nominee=$nominee&"
        "confirmyes=$confirmyes"
    );*/
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);
    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['tilldate'] = toDate;
    request.fields['leaveTypeId'] = leaveTypeId.toString();
    request.fields['fromDate'] = fromDate;
    request.fields['summary'] = getRemark;
    request.fields['radio'] = dayRadio;
    request.fields['empid'] = empNewId.toString();
    request.fields['confirmyes'] = confirmyes;

    // ✅ Attach file if available
    /*if (uploadedFile != null && uploadedFile!.existsSync()) {
      String fileName = uploadedFile!.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'document',               // key name for backend
          uploadedFile!.path,       // local file path
          filename: fileName,
        ),
      );
    } else {
      // If no file uploaded, send empty field
      request.fields['document'] = "";
    }*/
    String apiWithParams = urlapi.toString() +
        '?' +
        request.fields.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
    print('API URL with Parameters: $apiWithParams');

    //final response = await http.post(urlapi);
    http.StreamedResponse response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print('URL ${httpResponse.request}');
    if (httpResponse.statusCode == 200) {
      var responseResult = httpResponse.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(httpResponse.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      bool isValidate = true;
      try{
        isValidate = mapResponse['result']['isValidation'];
      } catch (e) {
        //Navigator.of(context, rootNavigator: true).pop();
        isValidate = true;
      }

      print('result both $result $reason');
      print('result${result}');
      print("IsValidate - $isValidate");
      if(isValidate == false) {
        if(result.compareToIgnoringCase("success")==0){
          showDialgSucess(context,reason.upperCamelCase+" ","Success");
        }else if(result.compareToIgnoringCase("error")==0){
          showDialgSucess(context,reason.upperCamelCase, " Error ");
        }else if(result.compareToIgnoringCase("warning")==0){
          showValidatePop(context,reason.upperCamelCase, " Warning ");
        }

      } else {
        if(result.compareToIgnoringCase("success")==0){
          showDialgSucess(context,reason.upperCamelCase+" ","Success");
        }else if(result.compareToIgnoringCase("error")==0){
          showDialgSucess(context,reason.upperCamelCase, " Error ");
        }else if(result.compareToIgnoringCase("warning")==0){
          showDialgSucess(context,reason.upperCamelCase, " Warning ");
        }
      }

    }
  }
  Future<void> halfDayRequisition(startTime, endTime, String getRemark,  int? idn, fromDate, empNewId,nominee, String confirmyes) async {
    String idn=leavereqIdGlobel.last;
    String dayRadio = "3";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    CommonNotificationPage.showLoaderDialog(context);
    /*var urlapi = Uri.parse("$conn$apiUrl?"
        "starttime=$startTime&"
        "endtime=$endTime&"
        "sessionId=$sessionId&"
        "leaveTypeId=$leaveTypeId&"
        "fromDate=$fromDate&"
        "summary=$getRemark&"
        "radio=$dayRadio&"
        "empid=$empNewId&"
        "nominee=$nominee&"
        "confirmyes=$confirmyes"
    );*/
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);
    // Add static fields
    request.fields['starttime'] = startTime!;
    request.fields['endtime'] = endTime;
    request.fields['sessionId'] = sessionId!;
    request.fields['leaveTypeId'] = leaveTypeId.toString();
    request.fields['fromDate'] = fromDate;
    request.fields['summary'] = getRemark;
    request.fields['radio'] = dayRadio;
    request.fields['empid'] = empNewId;
    request.fields['nominee'] = nominee;
    request.fields['confirmyes'] = confirmyes;

    // ✅ Attach file if available
   /* if (uploadedFile != null && uploadedFile!.existsSync()) {
      String fileName = uploadedFile!.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'document',               // key name for backend
          uploadedFile!.path,       // local file path
          filename: fileName,
        ),
      );
    } else {
      // If no file uploaded, send empty field
      request.fields['document'] = "";
    }*/
    String apiWithParams = urlapi.toString() +
        '?' +
        request.fields.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
    print('API URL with Parameters: $apiWithParams');
    //final response = await http.post(urlapi);
    http.StreamedResponse response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print('URL ${httpResponse.request}');
    if (httpResponse.statusCode == 200) {
      var responseResult = httpResponse.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(httpResponse.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      bool isValidate = true;
      try{
        isValidate = mapResponse['result']['isValidation'];
      } catch (e) {
        //Navigator.of(context, rootNavigator: true).pop();
        isValidate = true;
      }

      print('result both $result $reason');
      print('result${result}');
      print("IsValidate - $isValidate");
      if(isValidate == false) {
        if(result.compareToIgnoringCase("success")==0){
          showDialgSucess(context,reason.upperCamelCase+" ","Success");
        }else if(result.compareToIgnoringCase("error")==0){
          showDialgSucess(context,reason.upperCamelCase, " Error ");
        }else if(result.compareToIgnoringCase("warning")==0){
          showValidatePop(context,reason.upperCamelCase, " Warning ");
        }

      } else {
        if(result.compareToIgnoringCase("success")==0){
          showDialgSucess(context,reason.upperCamelCase+" ","Success");
        }else if(result.compareToIgnoringCase("error")==0){
          showDialgSucess(context,reason.upperCamelCase, " Error ");
        }else if(result.compareToIgnoringCase("warning")==0){
          showDialgSucess(context,reason.upperCamelCase, " Warning ");
        }
      }

    }
  }

  static showDialgSucess(BuildContext buildContext, String result, String alert) {
    if (buildContext == null) {
      print("⚠️ Warning: buildContext is null, cannot show dialog.");
      return;
    }

    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(
            children: [
              Expanded(child: Text(alert)),
            ],
          ),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) { // ✅ Using `context` inside the builder
                  Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
                  Navigator.of(buildContext).maybePop();
                } else {
                  print("⚠️ Warning: No route to close.");
                }
              },
              child: Text("Ok"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
