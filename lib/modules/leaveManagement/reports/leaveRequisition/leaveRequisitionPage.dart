import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:er_flutter_project/ess/Model/LeaveCombinedResponse.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import '../../../timeAndAttendance/calendarPage/workFromHomeRequisitionPage.dart';
import '../../../timeAndAttendance/calendarPage/requisitionTypeTabs.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../modalClass/leaveBalModal.dart';
import '../modalClass/leaveBalanceModel.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';

class LeaveRequisitionPage extends StatefulWidget {
  final bool showShortcuts;
  const LeaveRequisitionPage({super.key, this.showShortcuts = true});

  @override
  State<LeaveRequisitionPage> createState() => _LeaveRequisitionPageState();
}

SessionManager sessionManager = SessionManager();
Map<String, dynamic> mapResponse = {};
Map<String, dynamic> mapResponseLBalance = {};
SessionManager shared = SessionManager();
String? sessionId;
var doj;
LeaveBalModal? leaveBalLabel;
LeaveBalanceModel? leaveBalanceLabel;
String valuenew = "listText";
List<String> leavereqIdGlobel = [];
List<String?> list = [];
List<String?> leaveTypeList = [];

class _LeaveRequisitionPageState extends State<LeaveRequisitionPage>
    with RouteAware {
  var titleName = "Leave Requisition";
  String? branchName;
  String? deptName;
  String? empName;
  static const List<String> list = <String>['Casual Leave', 'Leave Monthly'];
  var dropdownNewvalue;
  var empNewId;
  var orgNewId;
  String dayRadio = "1";
  String halfDayNewRadios = "";
  String confirmYes = "";
  bool singleDayShow = true;
  bool multipleDayShow = false;
  bool halfDayRadio = false;
  bool halfDayShow = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController fromTimePickerController =
      TextEditingController();
  final TextEditingController toTimePickerController = TextEditingController();
  final TextEditingController _nomineeController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final String _fromTimePicker = '00:00';
  final String _toTimePicker = '00:00';
  var fromDate;
  var getRemark;
  var leaveTypeId;
  List<Map<String, dynamic>> _leaveLedgerTypes = <Map<String, dynamic>>[];
  bool _isSubmitting = false;
  var nominee;
  final _formKey = GlobalKey<FormState>();

  /* Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    //Future<LeaveBalModal> getAppReq11 = getLeaveBalance(sessionId!);
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
  }*/

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    doj = await shared.getDoj();

    await getLeaveTypeList(sessionId ?? '');
  }

  showNodata(BuildContext buildContext, result, reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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

  /* Future<LeaveBalModal> getLeaveBalance(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBal;
    print('employeeList11: ${SessionId}');
    LeaveBalModal leaveBalModal = new LeaveBalModal();
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
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
*/

  /*Future<LeaveBalanceModel?> getLeaveTypeList(String sessionId) async {
    leaveTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBalanceApi;
    LeaveBalModal leaveBalModal;
    print('employeeList11: ${sessionId}');
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    print('responseLeaveTypeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['leaveTypeList'];
    var leaveGetData = mapResponse['leaveData'];
    print("GETDATA $getData");

    print('responseLeaveTypeList $getData');
    leaveBalanceLabel=LeaveBalanceModel.fromJson(mapResponse);
    leaveBalModal=LeaveBalModal.fromJson(leaveGetData);
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
  }*/
  Map<String, dynamic>? leaveBalances;
  List<String> leaveTypes = [];

  Future<LeaveCombinedResponse?> _getLegacyLeaveTypeList(
    String sessionId,
  ) async {
    leaveTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveBalanceApi;

    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await MobileHttpClient.instance.post(urlapi);


    mapResponse = json.decode(response.body);

    // Main model
    LeaveBalanceModel? modelFull = LeaveBalanceModel.fromJson(mapResponse);

    // Leave Data -> used for LeaveBalModal
    // Extract only leaveData for LeaveBalModal
    var leaveGetData = mapResponse["leaveData"];
    LeaveBalModal? modelLeaveData =
        leaveGetData != null
            ? LeaveBalModal.fromJson({"leaveData": leaveGetData})
            : null;

    setState(() {
      leaveBalances = {};
      leaveTypes = [];

      // âœ… Step 1: Ensure we have valid data
      if (modelLeaveData!.leaveData == null) {
        return;
      }

      // âœ… Step 2: Extract the parsed balances directly from model
      final parsedBalances = modelLeaveData.leaveData!.getParsedBalances();

      // âœ… Step 3: Set the data for UI
      leaveBalances = parsedBalances;
      leaveTypes = parsedBalances.keys.toList();

      // âœ… Debug info
    });
    // Populate dropdown list
    if (mapResponse['leaveTypeList'] != null) {
      for (var item in mapResponse['leaveTypeList']) {
        leaveTypeList.add(item['leavetype']);
      }
    }

    return LeaveCombinedResponse(
      leaveBalanceModel: modelFull,
      leaveBalModal: modelLeaveData,
    );
  }

  Future<void> getLeaveTypeList(String _) async {
    final foundation = MobileApiFoundation.instance;
    try {
      final response = await foundation.get(
        ApiDetails.mobileLeaveLedger,
        headers: await foundation.authHeaders(),
        tag: 'LEAVE_LEDGER',
      );
      final body = foundation.decodeMap(response.body);
      if (!foundation.isSuccess(response)) {
        throw MobileApiException(
          'LEAVE_LEDGER_FAILED',
          message: _apiMessage(body, 'Unable to load leave ledger.'),
          statusCode: response.statusCode,
        );
      }

      final rawTypes = body['leaveTypes'];
      final parsedTypes = rawTypes is List
          ? rawTypes
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
          : <Map<String, dynamic>>[];
      parsedTypes.removeWhere(
        (item) => item['leaveTypeCode']?.toString().trim().isEmpty != false,
      );
      final balances = <String, dynamic>{};
      final typeCodes = <String>[];
      final dropdownLabels = <String?>[];
      for (final item in parsedTypes) {
        final code = item['leaveTypeCode']?.toString().trim() ?? '';
        if (code.isEmpty) continue;
        final name = item['leaveTypeName']?.toString().trim();
        typeCodes.add(code);
        dropdownLabels.add(name == null || name.isEmpty ? code : name);
        balances[code] = <String, dynamic>{
          'leavesTaken': 0,
          'totalLeavesPending': (item['balance'] as num?)?.toDouble() ?? 0.0,
        };
      }

      if (!mounted) return;
      setState(() {
        mapResponse = body;
        _leaveLedgerTypes = parsedTypes;
        leaveTypeList = dropdownLabels;
        leaveTypes = typeCodes;
        leaveBalances = balances;
        dropdownNewvalue = null;
        leaveTypeId = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _leaveLedgerTypes = <Map<String, dynamic>>[];
        leaveTypeList = <String?>[];
        leaveTypes = <String>[];
        leaveBalances = <String, dynamic>{};
      });
      Fluttertoast.showToast(
        msg: error is MobileApiException
            ? (error.message ?? 'Unable to load leave ledger.')
            : 'Unable to load leave ledger.',
      );
    }
  }

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
              // âœ… fixed
            },
            orElse: () => '',
          );
          print("ðŸ” Matching type=$type with keys=${leaveDataMap.keys}");
          print("âœ… matchedKey=$matchedKey -> ${leaveDataMap[matchedKey]}");

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
        print("âœ… leaveTypes: $leaveTypes");
        print("âœ… leaveBalances: $leaveBalances");
      });
    } catch (e, st) {
      print("âŒ Error in fetchLeaveBalance: $e");
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
      // LeaveBalModal leaveBalModal = await getLeaveBalance(sessionId);

      setState(() {
        leaveBalances = {};
        leaveTypes = [];

        // âœ… Step 1: Ensure we have valid data
        if (leaveBalLabel!.leaveData == null) {
          return;
        }

        // âœ… Step 2: Extract the parsed balances directly from model
        final parsedBalances = leaveBalLabel!.leaveData!.getParsedBalances();

        // âœ… Step 3: Set the data for UI
        leaveBalances = parsedBalances;
        leaveTypes = parsedBalances.keys.toList();

        // âœ… Debug info
      });
    } catch (e, st) {
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
    empName = await shared.getempName();
  }

  Future getDept() async {
    deptName = await shared.getDept();
  }

  Future getBranch() async {
    branchName = await shared.getBranch();
  }

  Future getEmpId() async {
    empNewId = await shared.getEmpId();
  }

  Future getOrgId() async {
    orgNewId = await shared.getOrgId();
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
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Upload Medical",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text("Use Camera"),
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      setState(() => uploadedFile = File(image.path));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.insert_drive_file,
                    color: Colors.teal,
                  ),
                  title: const Text("Upload from Files"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null && result.files.single.path != null) {
                      setState(
                        () => uploadedFile = File(result.files.single.path!),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  void showAttachmentBottomSheet(BuildContext context, String attachmentUrl) {
    // Clean up any "File:" prefix accidentally passed
    attachmentUrl = attachmentUrl.replaceAll("File: '", "").replaceAll("'", "");

    final isPdf = attachmentUrl.toLowerCase().endsWith('.pdf');
    final isImage =
        attachmentUrl.toLowerCase().endsWith('.jpg') ||
        attachmentUrl.toLowerCase().endsWith('.jpeg') ||
        attachmentUrl.toLowerCase().endsWith('.png');

    final isLocalFile =
        attachmentUrl.startsWith('/') || attachmentUrl.startsWith('file://');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "View Attachment",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child:
                      isPdf
                          ? SfPdfViewer.network(attachmentUrl)
                          : isImage
                          ? (isLocalFile
                              ? Image.file(
                                File(attachmentUrl),
                                fit: BoxFit.contain,
                              )
                              : CachedNetworkImage(
                                imageUrl: attachmentUrl,
                                fit: BoxFit.contain,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget:
                                    (context, url, error) => const Center(
                                      child: Text("âŒ Failed to load image"),
                                    ),
                              ))
                          : const Center(
                            child: Text(
                              "âš ï¸ Unsupported file format",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.redAccent,
                              ),
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
        appBar: AppBar(title: titleName.text.make()),
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
                MaterialPageRoute(
                  builder: (context) => PunchInOUtActivity(selectedIndex: 0),
                ),
              );
              //Navigator.of(context, rootNavigator: true).pop();
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PunchInOUtActivity(selectedIndex: 1),
                ),
              );
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetAttendanceDet(showAppBar: true),
                ),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyAllReportsPage(showAppBar: true),
                ),
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            }
            if (index == 4) {
              Navigator.pushNamed(
                context,
                MyRoutings.essDashboardNavigateRoute,
              );
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
              );*/
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
              icon: Icon(CupertinoIcons.app_badge_fill),
              label: 'My Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: 'My Reports',
              //backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
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
                        values: const [0, 1, 2, 3],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(70),
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
                          */
                /* if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*/
                /*
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
                          */
                /* if(value == 2) {
                              Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                            }*/
                /*
                          */
                /* if(value == 3) {
                              Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                            }*/
                /*
                        },
                      )
                    ],
                  ),
                ),*/
                Visibility(
                  visible: widget.showShortcuts,
                  child: RequisitionTypeTabs(
                    currentIndex: min(value, 3),
                    onChanged: (i) {
                      setState(() => value = i);
                      if (value == 0) {
                        Navigator.pushNamed(context, MyRoutings.attendanceReqCalendar);
                      } else if (value == 2) {
                        Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
                      } else if (value == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkFromHomeRequisitionPage(),
                          ),
                        );
                      }
                    },
                  ),
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
                          "Net Balance",
                          leaveTypes,
                          leaveBalances!,
                          (type) =>
                              leaveBalances?[type]?['totalLeavesPending']
                                  ?.toString() ??
                              "0",
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
                    decoration: InputDecoration(
                      labelStyle: TextStyle(),
                      hintText: empName,
                      labelText: "Employee Name",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    value: dropdownNewvalue,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        //<-- SEE HERE
                        borderSide: BorderSide(
                          width: 1,
                          color: Mythemes.blackishade,
                        ),
                      ),
                      //labelText: "Select Department",
                      hintText: "Leave Type",
                      hintStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.all(5),
                      /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                      // labelText: "Location",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Mythemes.blackish,
                      ),
                    ),
                    items:
                        leaveTypeList.map<DropdownMenuItem<String>>((
                          String? value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        }).toList(),
                    onChanged: (newVal) {
                      valuenew = newVal.toString();
                      int i = leaveTypeList.indexOf(valuenew);
                      if (i < 0 || i >= _leaveLedgerTypes.length) return;
                      final selectedType = _leaveLedgerTypes[i];
                      leaveTypeId = selectedType['leaveTypeCode']?.toString();
                      final leaveHalfDay = selectedType['allowHalfDay'] == true;
                      sickLeaveMedicalTypeShow =
                          selectedType['proofRequired'] == true;
                      sickLeaveMedicalShowValue = 0;
                      //print("MED CERTI - $sickLeaveMedicalShow");
                      //print("MED VALUE - $sickLeaveMedicalShowValue");
                      //print('Leave Half Day $leaveHalfDay');
                      var policyidnew = leaveTypeList.elementAt(i);
                      leavereqIdGlobel = <String>[leaveTypeId?.toString() ?? ''];
                      setState(() {
                        //print('value1 $i');
                        //print('value $policyidnew');

                        dropdownNewvalue = newVal;
                      });
                      if (leaveHalfDay == true) {
                        setState(() {
                          halfDayRadio = true;
                        });
                      } else {
                        setState(() {
                          halfDayRadio = false;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: "1",
                                groupValue: dayRadio,
                                onChanged: (value) {
                                  setState(() {
                                    singleDayShow = true;
                                    multipleDayShow = false;
                                    halfDayShow = false;
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
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: "2",
                                groupValue: dayRadio,
                                onChanged: (value) {
                                  setState(() {
                                    singleDayShow = true;
                                    multipleDayShow = true;
                                    halfDayShow = false;
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
                            child:
                                Row(
                                  /* mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,*/
                                  children: [
                                    Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: "3",
                                      groupValue: dayRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          singleDayShow = true;
                                          multipleDayShow = false;
                                          halfDayShow = true;
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
                      ).pLTRB(0, 0, 5, 5),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Visibility(
                      visible: singleDayShow,
                      child: Expanded(
                        child:
                            TextFormField(
                              onTap: () async {
                                DateTime? fromDate = DateTime.now();
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());

                                fromDate = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate,
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime(2040),
                                );
                                setState(() {
                                  //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                  _fromDateController.text = DateFormat(
                                    "dd-MM-yyyy",
                                  ).format(fromDate!);
                                });

                              },
                              readOnly: true,
                              enabled: true,
                              controller: _fromDateController,
                              // initialValue: "Head Office",
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                labelText: "From Date",
                                hintStyle: TextStyle(fontSize: 12),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ),

                    Visibility(
                      visible: multipleDayShow,
                      child: Expanded(
                        child:
                            TextFormField(
                              onTap: () async {
                                DateTime? toDate = DateTime.now();
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());

                                toDate = await showDatePicker(
                                  context: context,
                                  initialDate: toDate,
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime(2040),
                                );
                                /*setState(() {
                              //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                              _toDateController.text = DateFormat("dd-MM-yyyy").format(toDate!);
                            });*/
                                setState(() {
                                  _toDateController.text = DateFormat(
                                    "dd-MM-yyyy",
                                  ).format(toDate!);

                                  // ðŸ§© Calculate day difference between from and to date
                                  if (_fromDateController.text.isNotEmpty) {
                                    DateTime fromDateParsed = DateFormat(
                                      "dd-MM-yyyy",
                                    ).parse(_fromDateController.text);
                                    int dayDifference =
                                        toDate
                                            .difference(fromDateParsed)
                                            .inDays +
                                        1;

                                    // ðŸ§  Show medical section if dayDifference > medValue
                                    if (dayDifference >
                                            sickLeaveMedicalShowValue) {
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

                              },
                              readOnly: true,
                              enabled: true,
                              controller: _toDateController,
                              // initialValue: "Head Office",
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                labelText: "To Date",
                                hintStyle: TextStyle(fontSize: 12),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ),
                  ],
                ).pLTRB(0, 0, 0, 8),

                Visibility(
                  visible: halfDayShow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: "1",
                                  groupValue: halfDayNewRadios,
                                  onChanged: (value) {
                                    setState(() {
                                      /*  _singleDayShow == _singleDayShow;
                                           _multipleDayShow == _multipleDayShow;*/
                                    });
                                    setState(() {
                                      halfDayNewRadios = value.toString();
                                    });
                                  },
                                ),
                                "First Half".text.make(),
                              ],
                            ).px1(),
                            Row(
                              /*mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,*/
                              children: [
                                Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: "2",
                                  groupValue: halfDayNewRadios,
                                  onChanged: (value) {
                                    setState(() {
                                      /*  _singleDayShow =_singleDayShow;
                                          _multipleDayShow =! _multipleDayShow;*/
                                    });
                                    setState(() {
                                      halfDayNewRadios = value.toString();
                                    });
                                  },
                                ),
                                "Second Half".text.make(),
                              ],
                            ).px1(),
                          ],
                        ).pLTRB(0, 0, 5, 5),
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
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        labelText: "Nominee",
                      ),
                    ),
                  ),
                ),

                // Upload
                Visibility(
                  visible: sickLeaveMedicalTypeShow && sickLeaveMedicalShow,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ), // margin
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: const Text(
                            "Upload Medical",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: openUploadDialog,
                        ),
                      ),
                    ),
                  ),
                ),

                /*if (uploadedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("ðŸ“Ž Selected: ${uploadedFile!.path.split('/').last}",
                        style: const TextStyle(color: Colors.green)),
                  ),*/
                if (uploadedFile != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      "View Attachment".text.bold
                          .color(Mythemes.lightBluishColor)
                          .make()
                          .px12(),
                      IconButton(
                        onPressed: () {
                          if (uploadedFile != null &&
                              uploadedFile.toString().isNotEmpty) {
                            showAttachmentBottomSheet(
                              context,
                              uploadedFile!.path,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No attachment available"),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Mythemes.lightBluishColor,
                          size: 24,
                        ),
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
                    decoration: InputDecoration(
                      hintText: "Add remarks",
                      labelText: "Remarks",
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_fromDateController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please Select Date range !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          if (_remarkController.text == "") {
                            Fluttertoast.showToast(
                              msg: "Please Fill Remarks !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            if (dayRadio == '1') {
                              singleDayRequisition(
                                _remarkController.text,
                                leaveTypeId,
                                _fromDateController.text,
                                empNewId,
                                _nomineeController.text,
                                confirmYes,
                              );
                            } else if (dayRadio == '2') {
                              if (_toDateController.text == "") {
                                Fluttertoast.showToast(
                                  msg: "Please Select Date range !",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                multipleDayRequisition(
                                  _remarkController.text,
                                  leaveTypeId,
                                  _toDateController.text,
                                  _fromDateController.text,
                                  empNewId,
                                  _nomineeController.text,
                                  confirmYes,
                                );
                              }
                            } else if (dayRadio == '3') {
                              halfDayRequisition(
                                fromTimePickerController.text,
                                toTimePickerController.text,
                                _remarkController.text,
                                leaveTypeId,
                                _fromDateController.text,
                                empNewId,
                                _nomineeController.text,
                                confirmYes,
                              );
                            }
                          }
                        }
                        //key = "APPROVED";
                        //approveLeaveRequisition(_commentController.text, leaveReqId);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Mythemes.lightBluishColor,
                        ),
                      ),
                      child: "Send".text.make(),
                    ).wh(150, 40).py12(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showValidatePop(BuildContext buildContext, result, alert) {
    String text = "Stop Service";
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text(alert, style: TextStyle(fontSize: 20))),
        ],
      ),
      content: Text(result, style: TextStyle(fontSize: 14)),
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
            child: Text("No", style: TextStyle(color: Mythemes.dangerColorOne)),
          ),
        ),
        TextButton(
          onPressed: () async {
            confirmYes = "YES";
            Navigator.of(buildContext, rootNavigator: true).pop();
            if (_fromDateController.text == "") {
              Fluttertoast.showToast(
                msg: "Please Select Date range !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              CommonNotificationPage.showLoaderDialog(context);
              if (_remarkController.text == "") {
                Fluttertoast.showToast(
                  msg: "Please Fill Remarks !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                if (dayRadio == '1') {
                  singleDayRequisition(
                    _remarkController.text,
                    leaveTypeId,
                    _fromDateController.text,
                    empNewId,
                    _nomineeController.text,
                    confirmYes,
                  );
                } else if (dayRadio == '2') {
                  if (_toDateController.text == "") {
                    Fluttertoast.showToast(
                      msg: "Please Select Date range !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    multipleDayRequisition(
                      _remarkController.text,
                      leaveTypeId,
                      _toDateController.text,
                      _fromDateController.text,
                      empNewId,
                      _nomineeController.text,
                      confirmYes,
                    );
                  }
                } else if (dayRadio == '3') {
                  halfDayRequisition(
                    fromTimePickerController.text,
                    toTimePickerController.text,
                    _remarkController.text,
                    leaveTypeId,
                    _fromDateController.text,
                    empNewId,
                    _nomineeController.text,
                    confirmYes,
                  );
                }
                Navigator.of(buildContext, rootNavigator: true).pop();
              }
            }

            //Navigator.pop(buildContext);
          },
          child: Container(
            child: Text("Yes", style: TextStyle(color: Mythemes.warningColor)),
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

  Widget _buildLeaveNewCard(String count, String type, String subtext) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                Wrap(
                  spacing: 35,
                  runSpacing: 20,
                  children:
                      types.map((type) {
                        final value = valueGetter(type);
                        return _buildLeaveType(
                          type,
                          value,
                          _getColorForType(type),
                        );
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

  Widget _buildLeaveCard(
    String title,
    String cl,
    String sl,
    String el,
    String pl,
    String WO,
    Color titleColor, {
    bool isBold = false,
  }) {
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

  Future<void> singleDayRequisition(
    String getRemark,
    Object? _,
    dynamic fromDate,
    dynamic __,
    dynamic ___,
    String ____,
  ) {
    return _submitLeaveRequest(
      reason: getRemark,
      fromDate: fromDate.toString(),
      toDate: fromDate.toString(),
      leaveLength: 'full',
    );
  }

  Future<void> multipleDayRequisition(
    String getRemark,
    Object? _,
    dynamic toDate,
    dynamic fromDate,
    dynamic __,
    dynamic ___,
    String ____,
  ) {
    return _submitLeaveRequest(
      reason: getRemark,
      fromDate: fromDate.toString(),
      toDate: toDate.toString(),
      leaveLength: 'full',
    );
  }

  Future<void> halfDayRequisition(
    dynamic _,
    dynamic __,
    String getRemark,
    Object? ___,
    dynamic fromDate,
    dynamic ____,
    dynamic _____,
    String ______,
  ) {
    return _submitLeaveRequest(
      reason: getRemark,
      fromDate: fromDate.toString(),
      toDate: fromDate.toString(),
      leaveLength: 'half',
      sessionName: halfDayNewRadios == '1' ? 'first-half' : 'second-half',
    );
  }

  Future<void> _submitLeaveRequest({
    required String reason,
    required String fromDate,
    required String toDate,
    required String leaveLength,
    String? sessionName,
  }) async {
    if (_isSubmitting) return;
    final selectedCode = leaveTypeId?.toString().trim() ?? '';
    if (selectedCode.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select Leave Type.');
      return;
    }
    if (leaveLength == 'half' && halfDayNewRadios.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select First Half or Second Half.');
      return;
    }

    final normalizedFromDate = _toApiDate(fromDate);
    final normalizedToDate = _toApiDate(toDate);
    if (normalizedFromDate == null || normalizedToDate == null) {
      Fluttertoast.showToast(msg: 'Please select a valid leave date.');
      return;
    }

    Map<String, dynamic>? selectedType;
    for (final item in _leaveLedgerTypes) {
      if (item['leaveTypeCode']?.toString() == selectedCode) {
        selectedType = item;
        break;
      }
    }
    final foundation = MobileApiFoundation.instance;
    final requestId = foundation.newRequestId();
    setState(() => _isSubmitting = true);
    CommonNotificationPage.showLoaderDialog(context);
    try {
      final response = await foundation.postJson(
        ApiDetails.mobileLeaveRequisition,
        body: <String, Object?>{
          'leaveTypeCode': selectedCode,
          'leaveTypeName': selectedType?['leaveTypeName']?.toString(),
          'leaveLength': leaveLength,
          'fromDate': normalizedFromDate,
          'toDate': normalizedToDate,
          if (sessionName != null) 'sessionName': sessionName,
          'reason': reason.trim(),
        },
        headers: await foundation.authHeaders(
          requestId: requestId,
          json: true,
        ),
        tag: 'LEAVE_REQUISITION',
      );
      final body = foundation.decodeMap(response.body);
      final success = foundation.isSuccess(response);
      final message = _apiMessage(
        body,
        success
            ? 'Leave requisition submitted successfully.'
            : 'Unable to submit leave requisition.',
      );
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      if (success) {
        _fromDateController.clear();
        _toDateController.clear();
        _remarkController.clear();
        setState(() {
          dayRadio = '1';
          halfDayNewRadios = '';
        });
        await getLeaveTypeList(sessionId ?? '');
      }
      await _showLeaveResult(success ? 'Success' : 'Unable to Submit', message);
    } on MobileApiException catch (error) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await _showLeaveResult(
        'Unable to Submit',
        error.message ?? 'Unable to submit leave requisition.',
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await _showLeaveResult(
        'Unable to Submit',
        'Unable to submit leave requisition.',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _toApiDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    for (final format in <DateFormat>[
      DateFormat('dd-MM-yyyy'),
      DateFormat('yyyy-MM-dd'),
    ]) {
      try {
        return DateFormat('yyyy-MM-dd').format(format.parseStrict(trimmed));
      } catch (_) {}
    }
    return null;
  }

  String _apiMessage(Map<String, dynamic> body, String fallback) {
    for (final key in <String>['message', 'reason', 'detail']) {
      final value = body[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    final error = body['error'];
    if (error is Map) {
      for (final key in <String>['message', 'reason', 'detail']) {
        final value = error[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }
    return fallback;
  }

  Future<void> _showLeaveResult(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _legacySingleDayRequisition(
    String getRemark,
    int? idn,
    fromDate,
    empNewId,
    nominee,
    String confirmYes,
  ) async {
    String idn = leavereqIdGlobel.last;
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
    request.fields['halfDayType'] = "0";
    request.fields['nominee'] = nominee;
    request.fields['confirmyes'] = confirmYes;

    // âœ… Attach file if available
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

    String apiWithParams =
        '$urlapi?${request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&')}';

    //final response = await MobileHttpClient.instance.post(urlapi);
    http.StreamedResponse response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    if (httpResponse.statusCode == 200) {
      var responseResult = httpResponse.body;
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(httpResponse.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      bool isValidate = true;
      try {
        isValidate = mapResponse['result']['isValidation'];
      } catch (e) {
        //Navigator.of(context, rootNavigator: true).pop();
        isValidate = true;
      }

      if (isValidate == false) {
        if (result.compareToIgnoringCase("success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, " Error ");
        } else if (result.compareToIgnoringCase("warning") == 0) {
          showValidatePop(context, reason.upperCamelCase, " Warning ");
        }
      } else {
        if (result.compareToIgnoringCase("success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, " Error ");
        } else if (result.compareToIgnoringCase("warning") == 0) {
          showDialgSucess(context, reason.upperCamelCase, " Warning ");
        }
      }
    }
  }

  Future<void> _legacyMultipleDayRequisition(
    String getRemark,
    int? idn,
    toDate,
    fromDate,
    empNewId,
    nominee,
    String confirmyes,
  ) async {
    String idn = leavereqIdGlobel.last;
    String dayRadio = "2";
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.leaveRequisitionApi;
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);
    if (sickLeaveMedicalShow == true && sickLeaveMedicalTypeShow == true) {
      CommonNotificationPage.showLoaderDialog(context);
      if (uploadedFile != null && uploadedFile!.existsSync()) {
        String fileName = uploadedFile!.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'document', // key name for backend
            uploadedFile!.path, // local file path
            filename: fileName,
          ),
        );
        request.fields['sessionId'] = sessionId!;
        request.fields['tilldate'] = toDate;
        request.fields['leaveTypeId'] = leaveTypeId.toString();
        request.fields['fromDate'] = fromDate;
        request.fields['summary'] = getRemark;
        request.fields['radio'] = dayRadio;
        request.fields['empid'] = empNewId.toString();
        request.fields['halfDayType'] = "0";
        request.fields['confirmyes'] = confirmyes;

        String apiWithParams =
            '$urlapi?${request.fields.entries
                .map(
                  (e) =>
                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                )
                .join('&')}';

        //final response = await MobileHttpClient.instance.post(urlapi);
        http.StreamedResponse response = await request.send();
        http.Response httpResponse = await http.Response.fromStream(response);
        if (httpResponse.statusCode == 200) {
          var responseResult = httpResponse.body;
          Navigator.of(context, rootNavigator: true).pop();
          mapResponse = json.decode(httpResponse.body);
          String result = mapResponse['result']['result'];
          String reason = mapResponse['result']['reason'];
          bool isValidate = true;
          try {
            isValidate = mapResponse['result']['isValidation'];
          } catch (e) {
            //Navigator.of(context, rootNavigator: true).pop();
            isValidate = true;
          }

          if (isValidate == false) {
            if (result.compareToIgnoringCase("success") == 0) {
              showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
            } else if (result.compareToIgnoringCase("error") == 0) {
              showDialgSucess(context, reason.upperCamelCase, " Error ");
            } else if (result.compareToIgnoringCase("warning") == 0) {
              showValidatePop(context, reason.upperCamelCase, " Warning ");
            }
          } else {
            if (result.compareToIgnoringCase("success") == 0) {
              showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
            } else if (result.compareToIgnoringCase("error") == 0) {
              showDialgSucess(context, reason.upperCamelCase, " Error ");
            } else if (result.compareToIgnoringCase("warning") == 0) {
              showDialgSucess(context, reason.upperCamelCase, " Warning ");
            }
          }
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
          msg: "Please Upload Medical Document !!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // If no file uploaded, send empty field
        //request.fields['document'] = "";
      }
    } else {
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

      // Add static fields
      request.fields['sessionId'] = sessionId!;
      request.fields['tilldate'] = toDate;
      request.fields['leaveTypeId'] = leaveTypeId.toString();
      request.fields['fromDate'] = fromDate;
      request.fields['summary'] = getRemark;
      request.fields['radio'] = dayRadio;
      request.fields['empid'] = empNewId.toString();
      request.fields['halfDayType'] = "0";
      request.fields['confirmyes'] = confirmyes;

      String apiWithParams =
          '$urlapi?${request.fields.entries
              .map(
                (e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
              )
              .join('&')}';

      //final response = await MobileHttpClient.instance.post(urlapi);
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);
      if (httpResponse.statusCode == 200) {
        var responseResult = httpResponse.body;
        Navigator.of(context, rootNavigator: true).pop();
        mapResponse = json.decode(httpResponse.body);
        String result = mapResponse['result']['result'];
        String reason = mapResponse['result']['reason'];
        bool isValidate = true;
        try {
          isValidate = mapResponse['result']['isValidation'];
        } catch (e) {
          //Navigator.of(context, rootNavigator: true).pop();
          isValidate = true;
        }

        if (isValidate == false) {
          if (result.compareToIgnoringCase("success") == 0) {
            showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
          } else if (result.compareToIgnoringCase("error") == 0) {
            showDialgSucess(context, reason.upperCamelCase, " Error ");
          } else if (result.compareToIgnoringCase("warning") == 0) {
            showValidatePop(context, reason.upperCamelCase, " Warning ");
          }
        } else {
          if (result.compareToIgnoringCase("success") == 0) {
            showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
          } else if (result.compareToIgnoringCase("error") == 0) {
            showDialgSucess(context, reason.upperCamelCase, " Error ");
          } else if (result.compareToIgnoringCase("warning") == 0) {
            showDialgSucess(context, reason.upperCamelCase, " Warning ");
          }
        }
      }
    }
  }

  Future<void> _legacyHalfDayRequisition(
    startTime,
    endTime,
    String getRemark,
    int? idn,
    fromDate,
    empNewId,
    nominee,
    String confirmyes,
  ) async {
    String idn = leavereqIdGlobel.last;
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
    //request.fields['starttime'] = startTime!;
    //request.fields['endtime'] = endTime;
    request.fields['sessionId'] = sessionId!;
    request.fields['leaveTypeId'] = leaveTypeId.toString();
    request.fields['fromDate'] = fromDate;
    request.fields['summary'] = getRemark;
    request.fields['radio'] = dayRadio;
    request.fields['empid'] = empNewId.toString();
    request.fields['halfDayType'] = halfDayNewRadios.toString();
    request.fields['nominee'] = nominee;
    request.fields['confirmyes'] = confirmyes;

    // âœ… Attach file if available
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
    String apiWithParams =
        '$urlapi?${request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&')}';
    //final response = await MobileHttpClient.instance.post(urlapi);
    http.StreamedResponse response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    if (httpResponse.statusCode == 200) {
      var responseResult = httpResponse.body;
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(httpResponse.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      bool isValidate = true;
      try {
        isValidate = mapResponse['result']['isValidation'];
      } catch (e) {
        //Navigator.of(context, rootNavigator: true).pop();
        isValidate = true;
      }

      if (isValidate == false) {
        if (result.compareToIgnoringCase("success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, " Error ");
        } else if (result.compareToIgnoringCase("warning") == 0) {
          showValidatePop(context, reason.upperCamelCase, " Warning ");
        }
      } else {
        if (result.compareToIgnoringCase("success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, " Error ");
        } else if (result.compareToIgnoringCase("warning") == 0) {
          showDialgSucess(context, reason.upperCamelCase, " Warning ");
        }
      }
    }
  }

  static showDialgSucess(
    BuildContext buildContext,
    String result,
    String alert,
  ) {
    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(children: [Expanded(child: Text(alert))]),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  // âœ… Using `context` inside the builder
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(); // Close the dialog
                  Navigator.of(buildContext).maybePop();
                } else {
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
  const DismissKeyboard({super.key, required this.child});

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
