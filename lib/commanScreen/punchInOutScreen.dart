import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:er_flutter_project/commanScreen/modalClass/attendance_punch.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/punchInUploadPage.dart';
import 'package:er_flutter_project/commanScreen/recognization_page.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/skyDecorWorkDone.dart';
import 'package:er_flutter_project/commanScreen/workDonePage.dart';
import 'package:er_flutter_project/commanScreen/ujalaCreditWorkdone.dart';
import 'package:er_flutter_project/modules/helpDesk/helpdeskItem/helpdeskItem.dart';
import 'package:er_flutter_project/profiles/profilePage.dart';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:safe_device/safe_device.dart';
//import 'package:trust_location/trust_location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:er_flutter_project/widgets/drawer_file.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
//import 'package:er_flutter_project/adminPage/adminDashboard/adminDashboard.dart';
//import '../adminPage/adminDashboard/adminDashboard.dart';
import '../UIS_Bundle/dashboard/adminDashboard.dart' as mss;
import '../adminPage/modelClass/dashboardModel.dart';
import '../ess/EssDashboarrddModel.dart';
//import '../ess/essDashboard.dart';
import '../ess/essDashboard.dart' as ess;
import '../main.dart';
import '../mss_profiles/global_profile.dart';
import '../mss_profiles/organisationListModal.dart';
import '../mss_profiles/profileListModal.dart';
import '../reports/reportPage.dart';
import '../settings/checkForUpdates.dart';
import '../settings/companyPolicyList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';

import '../singUP/resetPassword/resetPasswordPage.dart';
import '../tracking/LocationPermissionRequest.dart';
import 'allAPIList.dart';
import 'commanNotificationPage.dart';
import 'digiWeighWorkDone.dart';
import 'package:location/location.dart' as loc;

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/tracking/DB/SaveLatlng.dart';
import 'package:er_flutter_project/tracking/LocationClient.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math' show asin, cos, sqrt;

import 'geofenceSelectionPopup.dart';
import 'modalClass/geofenceListModal.dart';

class PunchInOUtActivity extends StatefulWidget {
  final int selectedIndex;
  const PunchInOUtActivity({super.key, this.selectedIndex = 0});

  @override
  State<PunchInOUtActivity> createState() => _PunchInOUtActivityState();
}
int pageIndex = 0;
int currentIndex = 0;
var orgId;
var setGeofenceActive;
var myTeamShow = "0";
Position? position = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: ess.date,
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

LatLng? currentPostion = const LatLng(0.0, 0.0);
late GoogleMapController googleMapController;
var currentAddress = "Address Not Found";
var todayDate = "dd/mm/yyyy";
var todayDateShow = "dd/mm/yyyy";
late LoginModel _loginModel;
String timeString = "";
String? sessionId;
dynamic empIdGet;
String? userType;
String? getMobActions;
dynamic getMobTrackTime;
int? orgnizationID = 0;
late String UserName = "Employee Name";
late String employeeCode = "101";
String? imageString;
String? defaultProfileName;
dynamic defaultProfileId;
dynamic profileIdGetter;
dynamic profileNameGetter;
String? userPanelPermissions;
//MSS MO Permission Variable
dynamic pendingAttendanceReqMOPermission = "0";
dynamic othersAttendanceReqMOPermission = "0";
dynamic pendingLeaveReqMOPermission = "0";
dynamic pendingLeaveReqL1MOPermission = "0";
dynamic pendingLeaveReqL2MOPermission = "0";
dynamic othersLeaveReqMOPermission = "0";
dynamic odPendingReqMOPermission = "0";
dynamic claimPendingReqMOPermission = "0";
dynamic preOnboardPendingReqMOPermission = "0";
dynamic exitFormalityMOPermission = "0";

//MSS Permission Variable
dynamic pendingAttendanceReqPermission = "0";
dynamic othersAttendanceReqPermission = "0";
dynamic pendingLeaveReqPermission = "0";
dynamic pendingLeaveReqL1Permission = "0";
dynamic pendingLeaveReqL2Permission = "0";
dynamic othersLeaveReqPermission = "0";
dynamic odPendingReqPermission = "0";
dynamic claimPendingReqPermission = "0";
dynamic preOnboardPendingReqPermission = "0";
dynamic exitFormalityPermission = "0";

//UIS Permission Variable
dynamic pendingAttendanceReqUISPermission = "0";
dynamic othersAttendanceReqUISPermission = "0";
dynamic pendingLeaveReqUISPermission = "0";
dynamic pendingLeaveReqL1UISPermission = "0";
dynamic pendingLeaveReqL2UISPermission = "0";
dynamic othersLeaveReqUISPermission = "0";
dynamic odPendingReqUISPermission = "0";
dynamic claimPendingReqUISPermission = "0";
dynamic preOnboardPendingReqUISPermission = "0";
dynamic exitFormalityUISPermission = "0";

SessionManager shared = SessionManager();
String? clockingType = " ";

String profileImage = "";
String emailid = "abc@gmail.com";
String name = "Employee Name ";
final screensNew = [
  const DefaultPage(),
  const Workflow(),
  const Report(),
  Dashboard(),
  ProfileCheck(),
];

late List<String?> organisationList = [];

class _PunchInOUtActivityState extends State<PunchInOUtActivity> {
  OrganisationListModal? organisationListModal;
  //Tracking start variables
  final _locationClient = LocationClient();
  final _points = <LatLng>[];
  LatLng? _currPosition;
  bool _isServiceRunning = false;
  final databaseLatlngSave = SaveLatlng();
  SaveLatlng databaseLatlngDelete = SaveLatlng();


  void setupDatabaseAndDelete(int id) async {
    await databaseLatlngDelete.init(); // ✅ Initialize before use
    await databaseLatlngDelete.deleteLatlng(id);
    print("🗑️ Deleted uniqueID: $id from local database");
    //getLatlngAll();
  }
  //Tracking end variables

  DateTime ntpTime = DateTime.now();

  void _loadNTPTime() async {
    setState(() async {
      ntpTime = await NTP.now();
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    _loginModel = new LoginModel();
    getSharedPrfanceList();
    currentIndex = widget.selectedIndex;
    loadProfileFromPrefs();
    loadRequisitionCountsFromPrefs();
    var now = new DateTime.now();
    //var now =  ntpTime.toUtc();

    print("NTP TIME -  $todayDate");
    var newFormat = new DateFormat('dd-MM-yyyy');
    todayDateShow = newFormat.format(now);
    print("todaydate  $todayDateShow");
    getUserNameImage();
    super.initState();
  }

  void loadProfileFromPrefs() async {
    String? name = await shared.getDefaultProfileName();
    int? id = await shared.getDefaultProfileId();

    selectedProfileNameNotifier.value = name ?? '';
    selectedProfileIdNotifier.value = id ?? 0;
  }

  void loadRequisitionCountsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    attReqCountNotifier.value = prefs.getInt("attReqCount") ?? 0;
    leaveReqCountNotifier.value = prefs.getInt("leaveReqCount") ?? 0;
    odReqCountNotifier.value = prefs.getInt("mobOdCount") ?? 0;
  }


  var type = "0";

  showLogoutPopup(BuildContext buildContext, result, alert) {
    String text = "Stop Service";
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
            style: TextStyle(fontSize: 20),
          )),
        ],
      ),
      content: Text(result, style: TextStyle(fontSize: 14)),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () async {
              shared.setSessionId("");
              shared.setAdminRole(0);
              shared.setEmpRoll(0);
              shared.setRoRoll(0);
              shared.setMobAction(0);
              getLogout(this.context);
              final service = FlutterBackgroundService();
              var isRunning = await service.isRunning();
              print(isRunning);
              if (isRunning) {
                service.invoke("stopService");
                print("Background Stop");
              } else {
                service.startService();
                print("New service Started");
              }
              if (!isRunning) {
                text = 'Stop Service';
              } else {
                text = 'Start Service';
              }
              setState(() {});
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.pushAndRemoveUntil(
                buildContext,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );

              //Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              child: Text(
                "Yes",
                style: TextStyle(color: Mythemes.warningColor),
              ),
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

  Future getLogout(BuildContext buildContext) async {
    //var cameraStatus = await Permission.camera.status;
    //if(cameraStatus.isGranted) {
    //String? qrData = await scanner.scan();
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.logoutAPi;
    /*var stream = http.ByteStream(value!.openRead());
    stream.cast();*/
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "type=$type");
    var request = new http.MultipartRequest("Post", urlapi);
    http.Response response =
        await http.Response.fromStream(await request.send());
    mapResponse = json.decode(response.body);
    String reason = mapResponse['reason'];
    //String status = mapResponse['status'];
    String result = mapResponse['result'];
    print('reason $reason');
    print('reason${reason}');

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      //Navigator.pop(this.context);
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      //String status = mapResponse['status'];
      print('reason both $reason');
      //print('reason${reason}');
      if (result.compareToIgnoringCase("success") == 0) {
        print("Logout Successfully !!");
        Fluttertoast.showToast(
            msg: "Logout Successfully !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        //CommonNotificationPage.showDialgSucess(this.context,reason.upperCamelCase+" ","Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        print("Logout Error !!");
        Fluttertoast.showToast(
            msg: "Logout Error !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        //CommonNotificationPage.showDialgSucess(this.context,reason.upperCamelCase, " Error ");
      }
    }
  }

  var title = "Home";

  logoutApp(context) {
    showLogoutPopup(
        context, "Do You Want To Logout?".toString() + " ", "Alert");
  }

  Future getUserNameImage() async {
    profileImage = await shared.getProfileImage();
    name = await shared.getempName();
    emailid = await shared.getEmailId();
  }



  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    orgId = await shared!.getOrgId();
    setGeofenceActive = await shared!.getGeofenceActive();
    print("Geofence Permission - $setGeofenceActive");
    userType = await shared!.getUserType();
    defaultProfileName = await shared!.getDefaultProfileName();
    defaultProfileId = await shared!.getDefaultProfileId();
    print("Default Profile Name - $defaultProfileName");
    print("Default Profile Id - $defaultProfileId");
    userPanelPermissions = await shared!.getUserPanel();
    print("User Type - $userType");

    Future<OrganisationListModal> getOrgList = getOrganisationList(sessionId!);
    getOrgList.then((value) {
      setState(() {
        organisationListModal=value;
      });

    });

    setState(() {

    });
    imageString = await shared.getProfileImage();
    UserName = await shared.getempName();
    employeeCode = await shared.getEmpCode();
    lat= await shared.getLatitude();
    lng = await shared.getLongitude();
    getMobActions = await shared.getMobAttAction();
    getMobTrackTime = await shared.getMobTrackTime();
    print("GetMobAction - $getMobActions");
    print("GetMobTrackTime - $getMobTrackTime");
    //startTracking();
    //currentPostion = LatLng(lat, lng);
    //print('Response snapshot: ${sessionId}');
  }

  Future<OrganisationListModal> getOrganisationList(String sessionId) async {
    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.orgListApi;

      var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId&userPermission=$userPanelPermissions");
      final response = await http.post(urlapi);

      var mapResponse = json.decode(response.body);
      organisationListModal = OrganisationListModal.fromJson(mapResponse);

      print("Organisation List -  ${mapResponse}");

      /// Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String orgListString = json.encode(organisationListModal?.list ?? []);
      await prefs.setString("orgList", orgListString);

      return organisationListModal!;
    } catch (e) {
      print("Error loading profiles: $e");
      rethrow;
    }
  }

  //Tracking Code Start
  startTracking() {
    if(getMobActions == "BOTH" || getMobActions == "ATT") {
      //initDBLatlng();
      _requestLocationPermission();
      _locationClient.init();
      _listenLocation();
      initDBLatlng();
    }
  }

  initDBLatlng() async {
    await databaseLatlngSave.init();
    //getLatlngAll();
    //startTrackingTimer(context);
    String deviceIdString = await getUniqueDeviceId();
    //print('deviceIdString $deviceIdString');
  }

  void _listenLocation() async {
    double totalDistance = 0;
    if (!_isServiceRunning && await _locationClient.isServiceEnabled()) {
      _isServiceRunning = true;
      _locationClient.locationStream.listen((event) {
        try{
          setState(() {
            _currPosition = LatLng(event.latitude, event.longitude);
            print(_currPosition);

          });
        }catch(e){

        }

        String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
        print('time $formattedDate');
        //print("laglng $_currPosition");
        if(_points.length>2){
          for(int i=0 ;i<=_points.length-1;i++){
            double latlng = _points[i].longitude;
            print("latlnd $i  $latlng");
            //saveTrackingData(context);
          }
          totalDistance = calculateDistance(_points[_points.length-2].latitude, _points[_points.length-2].longitude, _points[_points.length-1].latitude, _points[_points.length-1].longitude);
          print("Total distance :- $totalDistance");
          String latLngString = '${_currPosition?.latitude},${_currPosition?.longitude}';
          print('latlong String  $latLngString');
          //100 miter travel than lat distance 100 meter
         /* if(totalDistance>=100){
            insertLatlngData(latLngString,  formattedDate);
          }*/

          insertLatlngData(latLngString,  formattedDate);

          _points.add(_currPosition!);

        }else{
          _points.add(_currPosition!);
        }
      });
    } else {
      _isServiceRunning = false;
    }
  }

  Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';

    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.device}:${androidDeviceInfo.id},${androidDeviceInfo.id}${androidDeviceInfo.id}' ; // unique ID on Android
    }

    return uniqueDeviceId;

  }

  void insertLatlngData(String latlng, String time)
  {
    //print('insertLatlng $latlng');
    //print('insertLatlng $time');
    Map<String, dynamic> rowData = {
      SaveLatlng.latlng : latlng,
      SaveLatlng.timestamp : time,
    };
    final latlngIdSave = databaseLatlngSave.insertlatlng(rowData);

  }


  dynamic allLatlng;
  void getLatlngAll() async {
    //final allLatlng = await databaseLatlngSave.queryAllRowCount();
    allLatlng = await databaseLatlngSave.getAllData();
    //print('total number Data $allLatlng');
    log('data $allLatlng');
    //print("My latlongs  $allLatlng");
    //saveTrackingData(context);
     //startTrackingTimer(context);
    for (final row in allLatlng) {
      print("latlng id ${row[SaveLatlng.id]}");
      print("latlng ${row[SaveLatlng.latlng]}");
      print("latlng ${row[SaveLatlng.timestamp]}");
    }
    print('total number Data ${allLatlng.length}');
  }

  Timer? trackingTimer; // 🔹 Timer Variable

  void startTrackingTimer(BuildContext context) {
    trackingTimer?.cancel();

    trackingTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      //initDBLatlng();
      //getLatlngAll();
      print("Running Too");
      if (allLatlng.length != 0) {
        print("Running ALSO");
        //sendInBatches(context, allLatlng);
      }
    });
    //saveTrackingData(context, allLatlng);
    print("SENDING LATLNG - ${allLatlng.length}");

    print("🚀 Tracking started: API will hit when 50 data points are reached");
  }

  void sendInBatches(BuildContext context,dynamic latlngData) {
    int batchSize = 50;
    print("Running");

    // ✅ Create a mutable copy of allLatlng before modifying
    List mutableList = List.from(latlngData);
    print("mutable data ${mutableList.length}");

    /*for(final mutablelog in mutableList)
      {
        print("mutable latlng $mutablelog");
      }*/

    if (mutableList.length >= batchSize)
    {
      List batch = mutableList.sublist(0, batchSize); // First 50 items
      //saveTrackingData(context, batch); // ✅ Send data
      mutableList.removeRange(0, batchSize); // ✅ Remove sent items
      print("📤 Sent a batch of 50 data points");
    }else if(mutableList.length < 50){
      //saveTrackingData(context, mutableList);
      print("📤 Sent a batch of ${mutableList.length} data points");// ✅ Send remaining data if < 50
    }else if (mutableList.length == 0) {
      //saveTrackingData(context, mutableList); // ✅ Send remaining data if < 50
      mutableList.clear();
      print("📤 you have ${mutableList.length} data points to send to server");
    }

    // ✅ Update the original list after processing
    //allLatlng = List.from(mutableList);
  }

  void stopTrackingTimer() {
    trackingTimer?.cancel();

    print("🛑 Tracking stopped");
  }

  Future<void> saveTrackingData(BuildContext context, List batch) async {
    print('Total number of Data: ${batch.length}');
    print("✅ API Called with ${batch.length} records");

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.saveTrackingData;
      var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
      print("API Data $urlapi");

      // ✅ JSON Encode `batch`
      String jsonData = jsonEncode(batch);

      // ✅ Request Headers
      var headers = {
        'Content-Type': 'application/json',
      };

      // ✅ API Call
      var response = await http.post(
        urlapi,
        headers: headers,
        body: jsonData,
      );

      // ✅ Response Handling
      if (response.statusCode == 200) {
        print("✅ JSON Upload successful: ${response.body}");

        // ✅ Parse the response JSON
        var responseData = jsonDecode(response.body);

        if (responseData['result'] == 'success' && responseData.containsKey('Data')) {
          List<dynamic> dataList = responseData['Data'];

          for (var entry in dataList) {
            if (entry.containsKey('uniqueID')) {
              int uniqueID = int.tryParse(entry['uniqueID']) ?? 0; // ✅ Convert safely
              if (uniqueID > 0) { // Ensure valid ID before deleting
                setupDatabaseAndDelete(uniqueID);
               // databaseLatlngDelete.deleteLatlng(uniqueID); // ✅ Delete from DB
                //print("🗑️ Deleted uniqueID: $uniqueID from local database");
              } else {
                //print("⚠️ Skipping invalid uniqueID: ${entry['uniqueID']}");
              }
            }
          }
        }
      } else {
        print("❌ JSON Upload Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("❌ Error uploading file: $e");
    }
  }

  Future<void> requestLocationPermissions() async {
    final loc.Location location = loc.Location();

    loc.PermissionStatus permission = await location.requestPermission();
    loc.PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted != loc.PermissionStatus.granted) {
      return Future.value(false);
    }

    if (permissionGranted == loc.PermissionStatus.deniedForever) {
      print("Location permission not granted");
      openAppSettingsDialog();
      return;
    }
  }
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _requestLocationPermission() async {
    await LocationPermissionRequest.requestLocationPermission(context);
  }


  void openAppSettingsDialog() {
    showDialog(
      context: MyApp.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text(
              "Background location permission is permanently denied. Please enable it from app settings."),
          actions: [
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                //openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  showDialgSucess(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      )),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(" Info "),
        ],
      ),
      content: Container(
        //width: MediaQuery.of(buildContext).size.width,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Center()],
        ),
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(this.context);
          },
          child: "Cancel".text.color(Mythemes.dangerColorOne).make(),
        ),
        TextButton(
          onPressed: () {
            shared.setSessionId("");
            Navigator.pushAndRemoveUntil(
              this.context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
          },
          child: "Logout".text.color(Mythemes.warningColor).make(),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
           Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5D9CDF), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title  ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: selectedProfileNameNotifier,
                        builder: (context, value, _) {
                          final displayText = (userPanelPermissions == "COMPANY_EMPLOYEE")
                              ? "ESS"
                              : value;

                          return Text(
                            displayText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            // 🧭 User Manual Icon
            /*IconButton(
              tooltip: "User Manual / Help",
              icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
              onPressed: () {
                // 👉 Navigate to your User Manual Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserManualPage()),
                );
              },
            ),*/
            // 🔌 Logout Icon
            IconButton(
              tooltip: "Logout",
              icon: const Icon(Icons.power_settings_new_rounded, color: Colors.white),
              onPressed: () => logoutApp(context),
            ),
          ],
        ),
        body: screensNew[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {
            String newTitle = "";

            // Adjust index mapping if Profile is hidden
            int adjustedIndex = index;
            if (userType == 'COMPANY_ADMIN' && index >= 4) {
              adjustedIndex += 1;
            }

            switch (adjustedIndex) {
              case 0:
                newTitle = "Home";
                break;
              case 1:
                newTitle = "Workflow";
                break;
              case 2:
                newTitle = "Reports";
                break;
              case 3:
                newTitle = "Dashboard";
                break;
              case 4:
                newTitle = "Profile";
                break;
            }

            setState(() {
              currentIndex = index;
              title = newTitle;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: 'Reports',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            if (userType != 'COMPANY_ADMIN')
              const BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
          ],
        ),
        drawer: DrawerFile(),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: const Text(
            'Do you really want to close this app?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                 // SystemNavigator.pop();
                  //Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pop(context);
                  //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void showAppCloseDialog(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      )),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(" Info "),
        ],
      ),
      content: Text("Do you really want to close this app?"),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(this.context);
          },
          child: "No".text.color(Mythemes.dangerColorOne).make(),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              SystemNavigator.pop();
            });
          },
          child: "Yes".text.color(Mythemes.warningColor).make(),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void showDialgErro(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning),
          Text("   Alert Dialog"),
        ],
      ),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(this.context);
            print('response11 ${result}');
          },
          child: Text("Ok"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

class DefaultPage extends StatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}


Map<String, dynamic> mapResponse = {};

class _DefaultPageState extends State<DefaultPage> {

  String? _platformVersion = 'Unknown', _autoTimezone, _autoTime, _daftar = "";
  Map<String, dynamic>? _list;
  SessionManager sessionManager = SessionManager();
  final ImagePicker _picker = ImagePicker();
  late var result;
  late final File? value;
  File? _image;
  File? _workDoneImage;

  int? orgnizationID = 0;
  int? mobAction;
  String? mockLat;
  String? mockLong;
  bool? isMock = false;


  @override
  void initState() {
    //print('initState');
    // TODO: implement initState
    _determinePosition();
    _getUserLocation();
    timeString = _formatDateTime(DateTime.now());
    getSharedPrfanceList();
    _getTime();
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //TrustLocation.stop();
    super.dispose();
  }




// ✅ Main method to get Geofence list
  Future<GeofenceListModal> getGeofenceList(String sessionId) async {
    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.geofenceListApi;
      var urlapi = Uri.parse(
          "$conn$apiUrl?sessionId=$sessionId&empId=$empIdGet&orgId=$orgId");

      print("🔗 Fetching geofence list from: $urlapi");

      final response = await http.post(urlapi);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ✅ Parse into GeofenceListModal directly
        return GeofenceListModal.fromJson(data);
      } else {
        throw Exception("Failed to fetch geofence list: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error fetching geofence list: $e");
      // ✅ Return empty model in case of failure
      return GeofenceListModal(userdata: []);
    }
  }


  static const String _kSavedGeofenceKey = 'savedGeofenceId';
  // Helper to get saved geofence id (nullable)
  Future<int?> _getSavedGeofenceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kSavedGeofenceKey);
  }

// Helper to save geofence id
  Future<void> _saveGeofenceId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSavedGeofenceKey, id);
  }



// ✅ Widget Method to show Geofence Dialog
/*  Future<void> showGeofenceDialog(
      BuildContext context, {
        required dynamic sessionId,
        required dynamic empId,
        required dynamic orgId,
      }) async {
    GeofenceListModal? geofenceList;
    int? selectedGeofenceId; // ✅ Store ID instead of name
    bool isLoading = true;

    // ✅ Fetch geofences
    geofenceList = await getGeofenceList(sessionId);
    isLoading = false;

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Select Your Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (geofenceList?.userdata == null ||
                    geofenceList!.userdata!.isEmpty)
                    ? const Center(
                  child: Text(
                    "No geofence data available",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedGeofenceId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select Geofence",
                      ),
                      items: geofenceList!.userdata!
                          .map(
                            (geo) => DropdownMenuItem<int>(
                          value: geo.id, // ✅ ID as value
                          child: Text(
                            "${geo.name ?? "Unnamed"}",
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGeofenceId = value;
                          print("🆔 Selected Geofence ID: $selectedGeofenceId");
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    print("✅ SELECTED GEOFENCE ID - $selectedGeofenceId");
                    if (selectedGeofenceId != null) {
                      Navigator.pop(context, selectedGeofenceId);
                      getPunchInWithGeofence(context, selectedGeofenceId); // ✅ Pass selected ID to your method
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a geofence"),
                        ),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          );
        },
      );
    }
  }*/

  // Show dialog (updated)
  Future<void> showGeofenceDialog(
      BuildContext context, {
        required dynamic sessionId,
        required dynamic empId,
        required dynamic orgId,
      }) async {

    // Load saved id first
    int? savedGeofenceId = await _getSavedGeofenceId();

    // Fetch geofences
    GeofenceListModal geofenceList = await getGeofenceList(sessionId);

    // If no geofences, show dialog with message
    if (geofenceList.userdata == null || geofenceList.userdata!.isEmpty) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Select Your Location"),
          content: const Text("No geofence data available"),
          actions: [
            TextButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop(), child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    // Ensure saved id exists in fetched list; otherwise ignore it
    bool savedExists = savedGeofenceId != null &&
        geofenceList.userdata!.any((g) => g.id == savedGeofenceId);

    int? selectedGeofenceId = savedExists ? savedGeofenceId : null;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                "Select Your Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedGeofenceId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select Geofence",
                      ),
                      items: geofenceList.userdata!
                          .map(
                            (geo) => DropdownMenuItem<int>(
                          value: geo.id,
                          child: Text("${geo.name ?? 'Unnamed'}"),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGeofenceId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // Optional: show currently saved selection info
                    if (savedGeofenceId != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          savedExists
                              ? "Saved location will be pre-selected"
                              : "Previously saved location not available in list",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (selectedGeofenceId != null) {
                      // Save selected id to shared preferences
                      await _saveGeofenceId(selectedGeofenceId!);

                      // Close dialog and trigger punch-in (as you had)
                      Navigator.pop(context, selectedGeofenceId);

                      // Call your punch-in method with selected id
                      if (context.mounted) {
                        getPunchInWithGeofence(context, selectedGeofenceId);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a geofence")),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showGeofenceDialogPunchOut(
      BuildContext context, {
        required dynamic sessionId,
        required dynamic empId,
        required dynamic orgId,
      }) async {

    // Load saved id first
    int? savedGeofenceId = await _getSavedGeofenceId();

    // Fetch geofences
    GeofenceListModal geofenceList = await getGeofenceList(sessionId);

    // If no geofences, show dialog with message
    if (geofenceList.userdata == null || geofenceList.userdata!.isEmpty) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Select Your Location"),
          content: const Text("No geofence data available"),
          actions: [
            TextButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop(), child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    // Ensure saved id exists in fetched list; otherwise ignore it
    bool savedExists = savedGeofenceId != null &&
        geofenceList.userdata!.any((g) => g.id == savedGeofenceId);

    int? selectedGeofenceId = savedExists ? savedGeofenceId : null;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                "Select Your Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedGeofenceId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select Geofence",
                      ),
                      items: geofenceList.userdata!
                          .map(
                            (geo) => DropdownMenuItem<int>(
                          value: geo.id,
                          child: Text("${geo.name ?? 'Unnamed'}"),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGeofenceId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // Optional: show currently saved selection info
                    if (savedGeofenceId != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          savedExists
                              ? "Saved location will be pre-selected"
                              : "Previously saved location not available in list",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (selectedGeofenceId != null) {
                      // Save selected id to shared preferences
                      await _saveGeofenceId(selectedGeofenceId!);

                      // Close dialog and trigger punch-in (as you had)
                      Navigator.pop(context, selectedGeofenceId);

                      // Call your punch-in method with selected id
                      if (context.mounted) {
                        getPunchOutWithGeofence(context, selectedGeofenceId); // ✅ Pass selected ID to your method
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a geofence")),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ✅ Widget Method to show Geofence Dialog
/*  Future<void> showGeofenceDialogPunchOut(
      BuildContext context, {
        required dynamic sessionId,
        required dynamic empId,
        required dynamic orgId,
      }) async {
    GeofenceListModal? geofenceList;
    int? selectedGeofenceId; // ✅ Store ID instead of name
    bool isLoading = true;

    // ✅ Fetch geofences
    geofenceList = await getGeofenceList(sessionId);
    isLoading = false;

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Select Your Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (geofenceList?.userdata == null ||
                    geofenceList!.userdata!.isEmpty)
                    ? const Center(
                  child: Text(
                    "No geofence data available",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedGeofenceId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select Geofence",
                      ),
                      items: geofenceList.userdata!
                          .map(
                            (geo) => DropdownMenuItem<int>(
                          value: geo.id, // ✅ ID as value
                          child: Text(
                            "${geo.name ?? "Unnamed"}",
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGeofenceId = value;
                          print("🆔 Selected Geofence ID: $selectedGeofenceId");
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    print("✅ SELECTED GEOFENCE ID - $selectedGeofenceId");
                    if (selectedGeofenceId != null) {
                      Navigator.pop(context, selectedGeofenceId);
                      getPunchOutWithGeofence(context, selectedGeofenceId); // ✅ Pass selected ID to your method
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a geofence"),
                        ),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          );
        },
      );
    }
  }*/


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getUserLocation() async {
    print('Setcurrent ');
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    //position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 5));
    //print('SetcurrentCL  $position');
    var lastPosition = await Geolocator.getLastKnownPosition();
    //print('SetcurrentLast  $lastPosition');
    // bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (position != null) {
      setState(() {
        currentPostion = LatLng(position!.latitude, position!.longitude);
        shared.setLatitude(position!.latitude);
        shared.setLongitude(position!.longitude);
        getAddress(position!);
      });
    } else {
      showAboutDialog(context: this.context);
    }
  }

  Future<void> getAddress(Position position) async {
    List<Placemark> pleaceMark =
        await placemarkFromCoordinates(position!.latitude, position.longitude);
    Placemark placemarkee = pleaceMark[0];
    print('currentPosition $currentAddress');
    var contryName = placemarkee.country;
    var locality = placemarkee.locality;
    var sublocality = placemarkee.subLocality;
    var administrativeArea = placemarkee.administrativeArea;
    var street = placemarkee.street;
    var postalCode = placemarkee.postalCode;
    var nameAdd = placemarkee.name;
    setState(() {
      currentAddress = '$street ' +
          '$nameAdd ' +
          '$sublocality ' +
          '$locality ' +
          '$administrativeArea ' +
          '$contryName ' +
          '$postalCode ';
    });
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (!mounted) return;
    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;

  var attAction;
  var appVersion;
  var oldAppVersion;

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empIdGet = await shared.getEmpId();
    appVersion = await shared.getAppVersion();
    print("App Version - $appVersion");
    userPanelPermissions = await shared.getUserPanel();
    //getGeofenceList(sessionId!);
    print("$userPanelPermissions");
    lat = await shared.getLatitude();
    //position= Position(longitude: shared.getLongitude(), latitude: shared.getLatitude(), timestamp: date, accuracy: 1, altitude: 1, altitudeAccuracy: 1, heading: 1, headingAccuracy: 1, speed: 1, speedAccuracy: 1);
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    lng = await shared.getLongitude();
    orgnizationID = await shared.getOrgId();
    attAction = await shared.getAttAction();
    print("LatLong - ${LatLng(position!.latitude, position!.longitude)}");
    //print("Long - $lng");
    currentPostion = LatLng(position!.latitude, position!.longitude);


    mobAction = await shared.getMobAction();
    print('mobActions $mobAction');

    print('ATTACTION- $attAction');

    setState(() {
      if (empRole == 1) {
        showHide = true;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion = "", autoTimezone = "", autoTime = "";
    Map<String, dynamic> list;

    /*try {
      autoTimezone = (await GlobalSettingsList.autoTimeZone)!;
      list = await GlobalSettingsList.list;
      //autoTime = await GlobalSettingsList.autoTime;
    } on PlatformException {
      autoTimezone = 'Gagal';
      autoTime = 'Gagal';
    }*/

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _autoTimezone = autoTimezone;
      print('timeZone $_autoTimezone');
      print('PlatoformVersion $_platformVersion');
      _autoTime = autoTime;
      //_list = list;
      _daftar = "";

      /*list.forEach((k, v) {
        _daftar += "$k : $v \n";
      });*/
    });
  }

  @override
  Widget build(BuildContext context) {

    /*getImageForWorkdone() async {
      try {
        final imageValue = await ImagePicker()
            .pickImage(source: ImageSource.camera,imageQuality: 20)
            .then((value) {
          if (value != null) _workDoneImage = File(value.path);

          if (value == null) {
            Navigator.pushNamed(context, MyRoutings.punchInRoute);
            //Navigator.pushNamed(context, MyRoutings.addInductionProcessRoute);
          } else {
            setState(() {
             *//*File image = File(value.path);
             final bytearray = image.readAsBytesSync().lengthInBytes;
             print("workdone image:- $bytearray");*//*
              if (orgnizationID == 108) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UjalaCreditWorkdone(
                        value: _workDoneImage,
                        address: currentAddress,
                        time: timeString)));
              } else if (orgnizationID == 110) {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SkyDecorWorkDone(value: _workDoneImage, address: currentAddress, time: timeString )));
              } else if (orgnizationID == 119) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DigiWeighWorkDone(
                        value: _workDoneImage,
                        address: currentAddress,
                        time: timeString)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WorkDonePage(
                        value: _workDoneImage,
                        address: currentAddress,
                        time: timeString)));
              }
            });
          }
        });

        *//*final File image = File(imageValue!.path);
        final bytearray = image.readAsBytesSync().lengthInBytes;
        print("workdone image$bytearray");*//*
       *//* if(imageValue==null) return;
        final imagePath= File(imageValue.path);
        print("workdone image$imagePath");*//*
      } on PlatformException catch (e) {
        //print('failed to upload: $e');
      }
    }
*/
    Future<void> getImageForWorkdone(BuildContext context) async {
      try {
        final picker = ImagePicker();
        final XFile? value = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 20,
        );

        if (value == null) {
          // User cancelled → navigate if widget still exists
          if (context.mounted) {
            Navigator.pushNamed(context, MyRoutings.punchInRoute);
          }
          return;
        }

        // Convert XFile → File
        _workDoneImage = File(value.path);

        if (!context.mounted) return;

        // Update UI safely
        setState(() {
          if (orgnizationID == 108) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UjalaCreditWorkdone(
                value: _workDoneImage,
                address: currentAddress,
                time: timeString,
              ),
            ));
          } else if (orgnizationID == 110) {
            // Example:
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => SkyDecorWorkDone(
            //     value: _workDoneImage,
            //     address: currentAddress,
            //     time: timeString,
            //   ),
            // ));
          } else if (orgnizationID == 119) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DigiWeighWorkDone(
                value: _workDoneImage,
                address: currentAddress,
                time: timeString,
              ),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WorkDonePage(
                value: _workDoneImage,
                address: currentAddress,
                time: timeString,
              ),
            ));
          }
        });
      } on PlatformException catch (e) {
        debugPrint("Failed to pick image: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Camera error: $e")),
          );
        }
      }
    }
    getImagePunchOut() async {
      try {
        //Navigator.pushNamed(context, MyRoutings.cameraPageRoute);

        final imageValue = await ImagePicker()
            .pickImage(source: ImageSource.camera,imageQuality: 20)
            .then((value) {
          this._workDoneImage = File(value!.path);
        });
        /* if(imageValue==null) return;

        final imagePath= File(imageValue.path);
        setState(() {
          this._workDoneImage=imagePath;
          print('object$imagePath');
        });*/

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageUploaded(
                value: _workDoneImage,
                address: currentAddress,
                time: timeString,
                punchType: clockingType)));
      } catch (e) {
        print('failed to upload: $e');
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Card(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentPostion!.latitude, currentPostion!.longitude),
                  zoom: 14,
                ),
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
              ),
            ),
          ),
          //Container(height: 10),
          // User info card
          Card(
            child: ListTile(
              //title: Text({_loginModel.data?.userLoginned?.name}==null ?' ': " Name "),
              title: "${UserName + "($employeeCode)"}".text.make(),
              subtitle: Text('$currentAddress'),
              leading: Container(
                width: 45,
                height: 45,
                child: imageString == null
                    ? Center(child: CircularProgressIndicator())
                    : CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(imageString!),
                        backgroundColor: Colors.grey,
                        // child: Image.network(imageString!),
                      ),
              ),
            ),
          ),

          /* Container(
              height: 10),*/
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("Today Date"),
                      ),
                      //Container(height: 10),
                      //Padding(padding: EdgeInsets.all(0)),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          '$todayDateShow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("Today Time"),
                      ),
                      //Container(height: 12, color: Mythemes.whiteShadeSeventy),
                      //Padding(padding: EdgeInsets.all(0)),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          timeString,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          mobAction == 0
              ? SizedBox(
                  height: 0,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //punch in
                          Expanded(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () async {
                                  bool internetCheck =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (internetCheck == false) {
                                    setState(() {
                                      AlertDialog(
                                        content:
                                            "Please check your internet connection"
                                                .text
                                                .make(),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Please check your Internet connection."),
                                      ));
                                    });
                                  } else if (Platform.isAndroid) {
                                    bool isFakeLocation =
                                    await DetectFakeLocation().detectFakeLocation();
                                    print("Fake Location - $isFakeLocation");
                                    if(isFakeLocation == true) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Mock Location Detected'),
                                            content: Text(
                                                'You have enabled a mock or fake location. Please disable it to proceed with marking your attendance.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      bool timeAuto =
                                      await DatetimeSetting.timeIsAuto();
                                      bool timezoneAuto =
                                      await DatetimeSetting.timeZoneIsAuto();
                                      print("AUTO TIME $timeAuto");
                                      print("AUTO TIME ZONE $timezoneAuto");
                                      if (!timeAuto) {
                                        //DatetimeSetting.openSetting();
                                        showAutoTimeZone(
                                            context,
                                            "Your mobile timing not updated, please change time setting to auto.",
                                            "Info ");
                                      } else {
                                        clockingType = "In";
                                        //print("ATTACTIONCHECK - $attAction");
                                        if (attAction == '0') {
                                          print("ORGID - $orgId");
                                          if ((orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202 || orgId == 145)
                                              && setGeofenceActive == true) {

                                            showGeofenceDialog(
                                              context,
                                              sessionId: sessionId!,
                                              empId: empIdGet,
                                              orgId: orgId,
                                            );

                                          } else {
                                            getPunchIn(context);
                                          }
                                        } else if (attAction == '1') {
                                          //getImagePunchIn();
                                          try {
                                            //ImagePicker picker = ImagePicker();
                                            var imageValue =
                                            await _picker.pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: 20,

                                            );
                                            // Navigator.pushNamed(context, MyRoutings.cameraPageRoute);
                                            /*final imageValue = await _picker.pickImage(source: ImageSource.camera).then((value) {
                                    if(value!=null){
                                      this._workDoneImage=File(value!.path);
                                    }else{
                                      return;
                                    }

                                  });*/
                                            //picker.dispose();
                                            if (imageValue == null) return;
                                            //print("Heloo ji " "$imageValue");
                                           /* setState(() {
                                              final imagePath =
                                              File(imageValue!.path);
                                              this._workDoneImage = imagePath;
                                            });*/
                                            if (mounted) {
                                              setState(() {
                                                final imagePath = File(imageValue!.path);
                                                this._workDoneImage = imagePath;
                                              });
                                            }
                                            imageValue = null;
                                            //imageCache.clear();
                                            /*Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageUploaded(
                                                            value: _workDoneImage,
                                                            address:
                                                            currentAddress,
                                                            time: timeString,
                                                            punchType:
                                                            clockingType)));*/
                                            if (context.mounted) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => ImageUploaded(
                                                    value: _workDoneImage,
                                                    address: currentAddress,
                                                    time: timeString,
                                                    punchType: clockingType,
                                                  ),
                                                ),
                                              );
                                            }
                                          } on Exception catch (e) {
                                            print('failed to upload: $e');
                                          }
                                        }
                                      }
                                    }

                                  } else {
                                    clockingType = "In";
                                    if (attAction == '0') {
                                      print("ORGID - $orgId");
                                      if ((orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202 || orgId == 145)
                                          && setGeofenceActive == true) {

                                        showGeofenceDialog(
                                          context,
                                          sessionId: sessionId!,
                                          empId: empIdGet,
                                          orgId: orgId,
                                        );

                                      } else {
                                        getPunchIn(context);
                                      }


                                    } else if (attAction == '1') {
                                      //getImagePunchIn();
                                      try {
                                        //ImagePicker picker = ImagePicker();
                                        var imageValue =
                                            await _picker.pickImage(
                                                source: ImageSource.camera,imageQuality: 20);
                                        // Navigator.pushNamed(context, MyRoutings.cameraPageRoute);
                                        /*final imageValue = await _picker.pickImage(source: ImageSource.camera).then((value) {
                                    if(value!=null){
                                      this._workDoneImage=File(value!.path);
                                    }else{
                                      return;
                                    }

                                  });*/
                                        //picker.dispose();
                                        if (imageValue == null) return;
                                        print("Heloo ji " "$imageValue");
                                        /*setState(() {
                                          final imagePath =
                                              File(imageValue!.path);
                                          this._workDoneImage = imagePath;
                                        });*/
                                        if (mounted) {
                                          setState(() {
                                            final imagePath = File(imageValue!.path);
                                            this._workDoneImage = imagePath;
                                          });
                                        }
                                        imageValue = null;
                                        //imageCache.clear();
                                        /*Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageUploaded(
                                                        value: _workDoneImage,
                                                        address: currentAddress,
                                                        time: timeString,
                                                        punchType: clockingType)));*/
                                        if (context.mounted) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ImageUploaded(
                                                value: _workDoneImage,
                                                address: currentAddress,
                                                time: timeString,
                                                punchType: clockingType,
                                              ),
                                            ),
                                          );
                                        }
                                      } on Exception catch (e) {
                                        print('failed to upload: $e');
                                      }
                                    }

                                    /*   if(_autoTimezone == "1") {

                              }
                              else if(_autoTimezone == "0") {
                                CommonNotificationPage.showWorkDoneSuccess(
                                    context, "Your mobile timing is not updated, please change time settings", "Info ");
                              }*/

                                    // getUploadImage();
                                  }
                                  /*    getUploadImage();
                              clockingType = "In";
                              print("click in");
                              _getId();
                              */ /*await AndroidMultipleIdentifier
                                              .requestPermission();*/ /*
                              punchInnew(sessionId);*/
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.touch_app,
                                          size: 30,
                                          color: Mythemes.creamColor,
                                        ),
                                        backgroundColor: Mythemes.successColor,
                                        radius: 30,
                                      ),
                                    ),
                                    Container(height: 5),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      //margin: EdgeInsets.all(5),
                                      child: Text(
                                        "Punch In",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //work done
                          Expanded(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () async {
                                  bool internetCheck =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (internetCheck == false) {
                                    setState(() {
                                      AlertDialog(
                                        content:
                                            "Please check your internet connection"
                                                .text
                                                .make(),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Please check your Internet connection."),
                                      ));
                                    });
                                  } else if (Platform.isAndroid) {
                                    bool isFakeLocation =
                                    await DetectFakeLocation().detectFakeLocation();
                                    print("Fake Location - $isFakeLocation");
                                    if(isFakeLocation == true) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Mock Location Detected'),
                                            content: Text(
                                                'You have enabled a mock or fake location. Please disable it to proceed with marking your work done.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      bool timeAuto =
                                      await DatetimeSetting.timeIsAuto();
                                      bool timezoneAuto =
                                      await DatetimeSetting.timeZoneIsAuto();
                                      /* print("AUTO TIME $timeAuto");
                                    print("AUTO TIME ZONE $timezoneAuto");*/
                                      if (!timeAuto) {
                                        //DatetimeSetting.openSetting();
                                        showAutoTimeZone(
                                            context,
                                            "Your mobile timing not updated, please change time setting to auto.",
                                            "Info ");
                                      } else {
                                        getImageForWorkdone(context);
                                      }
                                    }

                                  } else {
                                    getImageForWorkdone(context);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.work_history,
                                          size: 30,
                                          color: Mythemes.creamColor,
                                        ),
                                        backgroundColor:
                                            Mythemes.lightBluishColor,
                                        radius: 30,
                                      ),
                                    ),
                                    Container(height: 5),
                                    Padding(padding: EdgeInsets.all(0)),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Work Done",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //punch out
                          Expanded(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () async {
                                  bool internetCheck =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (internetCheck == false) {
                                    setState(() {
                                      AlertDialog(
                                        content:
                                            "Please check your internet connection"
                                                .text
                                                .make(),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Please check your Internet connection."),
                                      ));
                                    });
                                  } else if (Platform.isAndroid) {
                                    bool isFakeLocation =
                                    await DetectFakeLocation().detectFakeLocation();
                                    print("Fake Location - $isFakeLocation");
                                    if(isFakeLocation == true) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Mock Location Detected'),
                                            content: Text(
                                                'You have enabled a mock or fake location. Please disable it to proceed with marking your attendance.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      bool timeAuto =
                                      await DatetimeSetting.timeIsAuto();
                                      bool timezoneAuto =
                                      await DatetimeSetting.timeZoneIsAuto();
                                      /*  print("AUTO TIME $timeAuto");
                                    print("AUTO TIME ZONE $timezoneAuto");*/
                                      if (!timeAuto) {
                                        //DatetimeSetting.openSetting();
                                        showAutoTimeZone(
                                            context,
                                            "Your mobile timing not updated, please change time setting to auto.",
                                            "Info ");
                                      } else {
                                        print("ATTACTIONCHECK - $attAction");
                                        clockingType = "Out";
                                        if (attAction == '0') {
                                          print("ORGID - $orgId");
                                          if ((orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202 || orgId == 145)
                                              && setGeofenceActive == true) {

                                            showGeofenceDialogPunchOut(
                                              context,
                                              sessionId: sessionId!,
                                              empId: empIdGet,
                                              orgId: orgId,
                                            );

                                          } else {
                                            getPunchOut(context);
                                          }

                                        } else if (attAction == '1') {
                                          getImagePunchOut();
                                        }
                                      }
                                    }

                                  } else {
                                    print("ATTACTIONCHECK - $attAction");
                                    clockingType = "Out";
                                    if (attAction == '0') {
                                      print("ORGID - $orgId");
                                      if ((orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202 || orgId == 145)
                                          && setGeofenceActive == true) {

                                        showGeofenceDialogPunchOut(
                                          context,
                                          sessionId: sessionId!,
                                          empId: empIdGet,
                                          orgId: orgId,
                                        );

                                      } else {
                                        getPunchOut(context);
                                      }
                                    } else if (attAction == '1') {
                                      getImagePunchOut();
                                    }
                                  }
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.touch_app,
                                          size: 30,
                                          color: Mythemes.creamColor,
                                        ),
                                        backgroundColor:
                                            Mythemes.dangerColorOne,
                                        radius: 30,
                                      ),
                                    ),
                                    Container(height: 5),
                                    Padding(padding: EdgeInsets.all(0)),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Punch Out",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  showDialgError(BuildContext buildContext, result, reason) {
    var alertDialog = AlertDialog(
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
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            getPunchIn(buildContext);
          },
          child: Text("Retry"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  showAutoTimeZone(BuildContext buildContext, result, alert) {
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
              DatetimeSetting.openSetting();
              Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              child: Text("Ok"),
            )),
      ],
      elevation: 24.0,
    );
    showDialog(
        barrierDismissible: false,
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void showUpdateDialog(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    final storeUrl = isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.employroll.employroll' // ✅ Replace with your Play Store URL
        : 'https://apps.apple.com/in/app/employroll-2-0/id1664350846'; // ✅ Replace with your App Store ID

    final message = isAndroid
        ? 'A new version of the app is available on the Play Store. Please update your app to continue.'
        : 'A new version of the app is available on the App Store. Please update your app to continue.';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Available'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(storeUrl))) {
                launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open store.')));
              }
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  getTimeUpdate() {
    setState(() {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      todayDate = formatter.format(now);
    });
  }

  String formattedDate = "";

  // void _openGeofencePopup(BuildContext context) async {
  //   final result = await showDialog(
  //     context: context,
  //     builder: (context) => const GeofenceSelectionPopup(),
  //   );
  //
  //   if (result != null) {
  //     print("Selected Geofence: $result");
  //   }
  // }

  final List<String> geofenceList = [
    'Head Office',
    'Warehouse',
    'Plant 1',
    'Plant 2',
    'Client Site',
    'Remote Office',
  ];

  String? selectedGeofence;
  List<String> filteredList = [];

  /*Future<void> getPunchIn(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithoutSelfie;
    CommonNotificationPage.showLoaderDialog(context);
    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;
    setState(() {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      formattedDate = dateFormat.format(now);
    });

    getTimeUpdate();
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "address=$currentAddress&"
        "clocking=$sessionId&"
        "clockingType=$clockingType&"
        "lat=$lat&"
        "lng=$lng&"
        "currentDate=$todayDate&"
        "firstImei=$sessionId&"
        "secondImei=$sessionId&"
        "macAddress=$sessionId&"
        "deviceId=$sessionId&"
        "battery=$sessionId");
    var request = http.MultipartRequest("Post", urlapi);
    http.Response response =
        await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];
    //print('result${result}');

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      print("I m Punch in");
      Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
            context,
            reasonSuccess.upperCamelCase + " " + formattedDate,
            "Successfully Punch In");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
            context, reasonSuccess.upperCamelCase, " Failed ");
      }
    } else {
       Navigator.of(context, rootNavigator: true).pop();
      showDialgError(
          context, result, "Your Punch Not Submitted, Please Try Again");
    }
  }*/

  Future<void> getPunchIn(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithoutSelfie;

    // ✅ Use root context to show dialogs safely
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    CommonNotificationPage.showLoaderDialog(rootContext);

    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;

    setState(() {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      formattedDate = dateFormat.format(now);
    });

    getTimeUpdate();

    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "address=$currentAddress&"
        "clocking=$sessionId&"
        "clockingType=$clockingType&"
        "lat=$lat&"
        "lng=$lng&"
        "currentDate=$todayDate&"
        "firstImei=$sessionId&"
        "secondImei=$sessionId&"
        "macAddress=$sessionId&"
        "deviceId=$sessionId&"
        "battery=$sessionId");

    var request = http.MultipartRequest("POST", urlapi);
    http.Response response =
    await http.Response.fromStream(await request.send());

    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];

    print('URL ${response.request}');
    print("I m Punch in");

    // ✅ Always pop loader safely
    if (rootContext.mounted) {
      Navigator.of(rootContext, rootNavigator: true).pop();
    }

    // ✅ Use rootContext to show success popup (not the old one)
    if (response.statusCode == 200) {
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
          rootContext,
          "${reasonSuccess.upperCamelCase} $formattedDate",
          "Successfully Punch In",
        );
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
          rootContext,
          reasonSuccess.upperCamelCase,
          "Failed",
        );
      }
    } else {
      showDialgError(
        rootContext,
        result,
        "Your Punch Not Submitted, Please Try Again",
      );
    }
  }

  Future<void> getPunchInWithGeofence(BuildContext context, dynamic selectedGeofenceId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithGeofence;

    // ✅ Use root context to show dialogs safely
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    CommonNotificationPage.showLoaderDialog(rootContext);

    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;

    setState(() {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      formattedDate = dateFormat.format(now);
    });

    getTimeUpdate();

    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "address=$currentAddress&"
        "clocking=$sessionId&"
        "clockingType=$clockingType&"
        "lat=$lat&"
        "lng=$lng&"
        "currentDate=$todayDate&"
        "firstImei=$sessionId&"
        "secondImei=$sessionId&"
        "macAddress=$sessionId&"
        "deviceId=$sessionId&"
        "battery=$sessionId&"
        "geofenceId=$selectedGeofenceId");

    var request = http.MultipartRequest("POST", urlapi);
    http.Response response =
    await http.Response.fromStream(await request.send());

    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];

    print('URL ${response.request}');
    print("I m Punch in");

    // ✅ Always pop loader safely
    if (rootContext.mounted) {
      Navigator.of(rootContext, rootNavigator: true).pop();
    }

    // ✅ Use rootContext to show success popup (not the old one)
    if (response.statusCode == 200) {
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
          rootContext,
          "${reasonSuccess.upperCamelCase} $formattedDate",
          "Successfully Punch In",
        );
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
          rootContext,
          reasonSuccess.upperCamelCase,
          "Failed",
        );
      }
    } else {
      showDialgError(
        rootContext,
        result,
        "Your Punch Not Submitted, Please Try Again",
      );
    }
  }

  Future<void> getPunchOut(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithoutSelfie;
    CommonNotificationPage.showLoaderDialog(context);
    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;
    setState(() {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      formattedDate = dateFormat.format(now);
    });
    getTimeUpdate();
    /*var stream = http.ByteStream(value!.openRead());
    stream.cast();*/
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "address=$currentAddress&"
        "clocking=$sessionId&"
        "clockingType=$clockingType&"
        "lat=$lat&"
        "lng=$lng&"
        "currentDate=$todayDate&"
        "firstImei=$sessionId&"
        "secondImei=$sessionId&"
        "macAddress=$sessionId&"
        "deviceId=$sessionId&"
        "battery=$sessionId");
    var request = new http.MultipartRequest("Post", urlapi);
    http.Response response =
        await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];
    print('result${result}');

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      print("I m Punch Out");
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
            context,
            reasonSuccess.upperCamelCase + " " + formattedDate,
            "Successfully Punch Out");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
            context, reasonSuccess.upperCamelCase, " Failed ");
      }
    } else {
       Navigator.of(context, rootNavigator: true).pop();
      showDialgError(
          context, result, "Your Punch Not Submitted, Please Try Again");
    }
  }

  Future<void> getPunchOutWithGeofence(BuildContext context, dynamic selectedGeofenceId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithGeofence;

    // ✅ Use root context to show dialogs safely
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    CommonNotificationPage.showLoaderDialog(rootContext);
    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;
    setState(() {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      formattedDate = dateFormat.format(now);
    });
    getTimeUpdate();
    /*var stream = http.ByteStream(value!.openRead());
    stream.cast();*/
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "address=$currentAddress&"
        "clocking=$sessionId&"
        "clockingType=$clockingType&"
        "lat=$lat&"
        "lng=$lng&"
        "currentDate=$todayDate&"
        "firstImei=$sessionId&"
        "secondImei=$sessionId&"
        "macAddress=$sessionId&"
        "deviceId=$sessionId&"
        "battery=$sessionId&"
        "geofenceId=$selectedGeofenceId");
    var request = new http.MultipartRequest("Post", urlapi);
    http.Response response =
        await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];
    print('result${result}');

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      print("I m Punch Out");
      // ✅ Always pop loader safely
      if (rootContext.mounted) {
        Navigator.of(rootContext, rootNavigator: true).pop();
      }
      // Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
            rootContext,
            reasonSuccess.upperCamelCase + " " + formattedDate,
            "Successfully Punch Out");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
            rootContext, reasonSuccess.upperCamelCase, " Failed ");
      }
    } else {
       Navigator.of(rootContext, rootNavigator: true).pop();
      showDialgError(
          rootContext, result, "Your Punch Not Submitted, Please Try Again");
    }
  }

  Future punchInnew(String? sessionId) async {
    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;
    print('click $lat');
    print('click $lng');
    var urlapi = Uri.parse(
        "http://www.employroll.com/restful/service/attendance/via/mobile/without/image?"
        "sessionId=$sessionId&"
        "address=$currentAddress&"
        "clocking=$sessionId&"
        "clockingType=$clockingType&"
        "lat=$lat&"
        "lng=$lng&"
        "currentDate=$todayDate&"
        "firstImei=$sessionId&"
        "secondImei=$sessionId&"
        "macAddress=$sessionId&"
        "deviceId=$sessionId&"
        "battery=$sessionId&");
    final response = await http.get(urlapi);
    print({response.request});
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    /*  print('Running on ${androidInfo.model}');
    print('Running on ${androidInfo.androidId}');
    print('Running on ${androidInfo.device}');
    print('Running on ${androidInfo.id}');
    print('Running on ${androidInfo.isPhysicalDevice}');
    print('Running on ${androidInfo.fingerprint}');
    print('Running on ${androidInfo.hardware}');
    print('Running on ${androidInfo.display}');
    return androidInfo.androidId;*/
  }

  moveToImageUpload(BuildContext context) {
    Navigator.pushNamed(context, MyRoutings.imageUploadRoute);
  }

  moveToWorkDone(BuildContext context) async {
    await Navigator.pushNamed(context, MyRoutings.workDoneRoute);
  }
}

class Workflow extends StatelessWidget {
  const Workflow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProjectList();
  }
}

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReportPage();
  }
}

class ProfileCheck extends StatefulWidget {
  const ProfileCheck({super.key});

  @override
  State<ProfileCheck> createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var title = "My Dashboard";

  @override
  Widget build(BuildContext context) {
    return userPanelPermissions == "USER" ?
    mss.Admin_UIS_Dashboard(DashboardModel()) :
    ess.EssAdminDashboard(EssDashboarrdModel());
  }
}

class DrawerFile extends StatefulWidget {
  @override
  State<DrawerFile> createState() => _DrawerFileState();
}

//SessionManager shared= SessionManager();
class _DrawerFileState extends State<DrawerFile> {
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  dynamic selectedProfileId;
  dynamic selectedProfileName;
  dynamic mobOdCount;
  dynamic odReqCount;
  dynamic tourReqCount;
  dynamic attReqCount;
  dynamic leaveReqCount;
  @override
  void initState() {
    getUserRoles();
    getSharedPreferences();
    loadSelectedProfile();
    //getUserNameImage();
    super.initState();
  }


  Future<void> getSharedPreferences() async {

    final prefs = await SharedPreferences.getInstance();
    selectedProfileId = prefs.getInt('defaultProfileId');
    selectedProfileName = prefs.getString('defaultProfileName');
    userPanelPermissions = await shared!.getUserPanel();
    print("Loaded ID: $selectedProfileId, Name: $selectedProfileName");

    getProfileList(sessionId!).then((value) {
      setState(() {
        profileListModal = value;
      });
    });
    orgId = await shared!.getOrgId();
    print("Org Id Check - $orgId");
    setState(() {

    });
  }

  ProfileListModal? profileListModal;
  List<ProfileData> profileListGetter = [];

  void loadSelectedProfile() async {
    selectedProfileId = await shared.getDefaultProfileId();
    selectedProfileName = await shared.getDefaultProfileName();

    // Optional: update the ValueNotifiers if needed globally
    selectedProfileIdNotifier.value = selectedProfileId!;
    selectedProfileNameNotifier.value = selectedProfileName!;

    setState(() {});
  }

  Future<ProfileListModal> getProfileList(String sessionId) async {
    setState(() {
      isLoadingProfiles = true;
    });

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.profileListApi;

      var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId&userPermission=$userPanelPermissions");
      final response = await http.post(urlapi);

      var mapResponse = json.decode(response.body);
      profileListModal = ProfileListModal.fromJson(mapResponse);

      profileListGetter.clear();
      profileListGetter.addAll(profileListModal?.data ?? []);

      print("Profile List API - ${response.request}");
      for (int i = 0; i < profileListGetter.length; i++) {
        List<String>? userPermission = profileListGetter[i].profilePermission;

        print("User Permission for profile ${i + 1} - $userPermission");
        /*//MSS MO
        //Attendance Pending Request & Other Attendance Request
        if (userPermission != null &&
            userPermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD")) {
          pendingAttendanceReqMOPermission = "1";
        }
        //Leave Pending Request
        if (userPermission != null &&
            userPermission.contains("LEAVE_REQ_APPROVAL_MO_ADD")) {
          pendingLeaveReqMOPermission = "1";
        }
        //Leave Pending Request L1
        if (userPermission != null &&
            userPermission.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD")) {
          pendingLeaveReqL1MOPermission = "1";
        }
        //Leave Pending Request L2
        if (userPermission != null &&
            userPermission.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD")) {
          pendingLeaveReqL2MOPermission = "1";
        }
        //Other Leave Request
        if (userPermission != null &&
            userPermission.contains("OTHERS_LEAVE_REQUEST_MO_ADD")) {
          othersLeaveReqMOPermission = "1";
        }

        //MSS
        //Attendance Pending Request & Other Attendance Request
        if (userPermission != null &&
            userPermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD")) {
          pendingAttendanceReqMOPermission = "1";
        }
        //Leave Pending Request
        if (userPermission != null &&
            userPermission.contains("LEAVE_REQ_APPROVAL_ADD")) {
          pendingLeaveReqMOPermission = "1";
        }
        //Leave Pending Request L1
        if (userPermission != null &&
            userPermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD")) {
          pendingLeaveReqL1MOPermission = "1";
        }
        //Leave Pending Request L2
        if (userPermission != null &&
            userPermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD")) {
          pendingLeaveReqL2MOPermission = "1";
        }
        //Other Leave Request
        if (userPermission != null &&
            userPermission.contains("OTHERS_LEAVE_REQUEST_ADD")) {
          othersLeaveReqMOPermission = "1";
        }*/


        print("Attendance Permission - $pendingAttendanceReqMOPermission");
      }

      if (profileListGetter.isNotEmpty) {
        var defaultProfile = profileListGetter.firstWhere(
              (p) => p.isDefaultProfile == true,
          orElse: () => profileListGetter.first,
        );
        selectedProfileId = defaultProfile.profileId;
      } else {
        selectedProfileId = 0;
        print("⚠️ profileListGetter is empty.");
      }

      return profileListModal!;
    } catch (e) {
      print("Error loading profiles: $e");
      rethrow;
    } finally {
      setState(() {
        isLoadingProfiles = false;
      });
    }
  }

  Future<void> loadRequisitionCounts() async {
    final prefs = await SharedPreferences.getInstance();

    mobOdCount = prefs.getInt("mobOdCount") ?? 0;
    leaveReqCount = prefs.getInt("leaveReqCount") ?? 0;
    odReqCount = prefs.getInt("odReqCount") ?? 0;
    tourReqCount = prefs.getInt("tourReqCount") ?? 0;
    attReqCount = prefs.getInt("attReqCount") ?? 0;

    print("Loaded counts → attReqCount: $attReqCount, leaveReqCount: $leaveReqCount");
  }


  Future<void> getRequisitionCounts(String sessionId) async {
    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.reqCountApi;

      var urlapi = Uri.parse("$conn$apiUrl?"
          "sessionId=$sessionId&"
          "profileId=$selectedProfileId&"
          "userPermission=$userPanelPermissions");

      final response = await http.post(urlapi);

      print("Requisition Count API - ${response.request}");
      print("Response Body - ${response.body}");

      Map<String, dynamic> mapResponse = json.decode(response.body);

      // After decoding response
      int attReqCount = mapResponse['attReqCount'] ?? 0;
      int leaveReqCount = mapResponse['leaveReqCount'] ?? 0;
      int mobOdCount = mapResponse['mobOdCount'] ?? 0;

// ✅ Update global notifiers
      attReqCountNotifier.value = attReqCount;
      leaveReqCountNotifier.value = leaveReqCount;
      odReqCountNotifier.value = mobOdCount;

// ✅ Also persist in SharedPreferences for app relaunch
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("attReqCount", attReqCount);
      await prefs.setInt("leaveReqCount", leaveReqCount);
      await prefs.setInt("mobOdCount", mobOdCount);

      // ✅ Assign values to variables
      mobOdCount = mapResponse['mobOdCount'] ?? 0;
      leaveReqCount = mapResponse['leaveReqCount'] ?? 0;
      odReqCount = mapResponse['odReqCount'] ?? 0;
      tourReqCount = mapResponse['tourReqCount'] ?? 0;
      attReqCount = mapResponse['attReqCount'] ?? 0;


      // ✅ Save all data into SharedPreferences
      //final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("mobOdCount", mobOdCount);
      await prefs.setInt("leaveReqCount", leaveReqCount);
      await prefs.setInt("odReqCount", odReqCount);
      await prefs.setInt("tourReqCount", tourReqCount);
      await prefs.setInt("attReqCount", attReqCount);

      print("Saved Requisition Counts to SharedPreferences ✅");

    } catch (e) {
      print("Error fetching requisition counts: $e");
    } finally {
      setState(() {
        //isLoading = false; // hide loader always
      });
    }
  }

  bool isLoadingProfiles = false;

  getUserRoles() async {
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    setState(() {
      if (empRole == 1) {
        showHide = true;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //timeDilation = 1.8;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Pushes bottom content down
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Mythemes.whiteShadeSeventy),
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Mythemes.whiteShadeSeventy),
                  accountName: Text(name, style: TextStyle(color: Mythemes.black, fontWeight: FontWeight.bold)),
                  accountEmail: Text(emailid, style: TextStyle(color: Mythemes.black)),
                  margin: EdgeInsets.zero,
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                    backgroundColor: Mythemes.greyish,
                  ),
                ),
              ),
              Visibility(
                visible: userPanelPermissions == "MSS" || userPanelPermissions == "MSS_MO_ADMIN" || userPanelPermissions == "USER",
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    "Profiles".text.bold.size(17).make()
                  ],
                ).p8(),),

              /*Visibility(
            visible: userPanelPermission == "MSS" || userPanelPermission == "MSS_MO_ADMIN",
            child: ValueListenableBuilder<int>(
              valueListenable: selectedProfileIdNotifier,
              builder: (context, currentSelectedId, _) {
                return Column(
                  children: profileListGetter.map((profile) {
                    bool isSelected = currentSelectedId == profile.profileId;

                    return ListTile(
                      title: Text(
                        profile.profileName ?? '',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
                      tileColor: isSelected ? Colors.grey.shade200 : null,
                      onTap: () async {
                        selectedProfileId = profile.profileId!;
                        selectedProfileName = profile.profileName!;

                        await shared.setDefaultProfileId(selectedProfileId);
                        await shared.setDefaultProfileName(selectedProfileName);

                        selectedProfileIdNotifier.value = selectedProfileId!;
                        selectedProfileNameNotifier.value = selectedProfileName!;

                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),*/
              Visibility(
                visible: userPanelPermissions == "MSS" || userPanelPermissions == "MSS_MO_ADMIN" || userPanelPermissions == "USER",
                child: isLoadingProfiles
                    ? Center(child: CircularProgressIndicator()).p12()
                    : ValueListenableBuilder<int>(
                  valueListenable: selectedProfileIdNotifier,
                  builder: (context, currentSelectedId, _) {
                    return Column(
                      children: profileListGetter.map((profile) {
                        bool isSelected = currentSelectedId == profile.profileId;

                        return ListTile(
                            title: Text(
                              profile.profileName ?? '',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
                            tileColor: isSelected ? Colors.grey.shade200 : null,
                            onTap: () async {
                              selectedProfileId = profile.profileId!;
                              selectedProfileName = profile.profileName!;

                              // 🟢 Find the selected profile from the list using profileId
                              final selected = profileListGetter.firstWhere(
                                    (p) => p.profileId == selectedProfileId,
                                orElse: () => profile,
                              );

                              //MSS MO
                              // 🟢 Check if the selected profile has the Pending Attendance Request permission
                              String pendingAttReqMOPermValue = (selected.profilePermission?.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request permission
                              String leaveReqMOPermValue = (selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L1 permission
                              String leaveReqL1MOPermValue = (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L2 permission
                              String leaveReqL2MOPermValue = (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L2 permission
                              String othersLeaveReqMOPermValue = (selected.profilePermission?.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L1 permission
                              String pendingClaimL1MOPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L2 permission
                              String pendingClaimL2MOPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L3 permission
                              String pendingClaimL3MOPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Pending List permission
                              String pendingODListMOPermission = (selected.profilePermission?.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Activate permission
                              String odActivateMOPermission = (selected.profilePermission?.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Activate permission
                              String loanActivateMOPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L1 permission
                              String loanApprovalL1Permission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L2 permission
                              String loanApprovalL2Permission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L3 permission
                              String loanApprovalL3Permission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L1 Delete permission
                              String loanApprovalL1DeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L2 Delete permission
                              String loanApprovalL2DeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L3 Delete permission
                              String loanApprovalL3DeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_DELETE"
                                  : "0";

                              // 🟢 Check if the selected profile has the OD Pending List permission
                              String pendingAttendanceRequestMOL1 = (selected.profilePermission?.contains("ATT_APP_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Activate permission
                              String pendingAttendanceRequestMOL2 = (selected.profilePermission?.contains("ATT_APP_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the MY Team Activate permission
                              myTeamShow = (selected.profilePermission?.contains("HRIS_EMP_LIST_VIEW") ?? false)
                                  ? "1"
                                  : "0";


                              //MSS
                              // 🟢 Check if the selected profile has the Pending Attendance Request permission
                              String pendingAttReqMSSPermValue = (selected.profilePermission?.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request permission
                              String leaveReqMSSPermValue = (selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L1 permission
                              String leaveReqL1MSSPermValue = (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L2 permission
                              String leaveReqL2MSSPermValue = (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L2 permission
                              String othersLeaveReqMSSPermValue = (selected.profilePermission?.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L1 permission
                              String pendingClaimL1Permission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L2 permission
                              String pendingClaimL2Permission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L3 permission
                              String pendingClaimL3Permission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Pending List permission
                              String pendingODListPermission = (selected.profilePermission?.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Activate permission
                              String odActivatePermission = (selected.profilePermission?.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Activate permission
                              String loanActivatePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L1 permission
                              String loanApprovalL1MSSPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L2 permission
                              String loanApprovalL2MSSPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L3 permission
                              String loanApprovalL3MSSPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L1 Delete permission
                              String loanApprovalL1MSSDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L2 Delete permission
                              String loanApprovalL2MSSDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L3 Delete permission
                              String loanApprovalL3MSSDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_DELETE"
                                  : "0";

                              // 🟢 Check if the selected profile has the OD Pending List permission
                              String pendingAttendanceRequestMSSL1 = (selected.profilePermission?.contains("ATT_APP_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Activate permission
                              String pendingAttendanceRequestMSSL2 = (selected.profilePermission?.contains("ATT_APP_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";

                              //USER
                              // 🟢 Check if the selected profile has the Pending Attendance Request permission
                              String pendingAttReqUISPermValue = (selected.profilePermission?.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request permission
                              String leaveReqUISPermValue = (selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L1 permission
                              String leaveReqL1UISPermValue = (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L2 permission
                              String leaveReqL2UISPermValue = (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Leave Request L2 permission
                              String othersLeaveReqUISPermValue = (selected.profilePermission?.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L1 permission
                              String pendingClaimL1UISPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L2 permission
                              String pendingClaimL2UISPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Claim L3 permission
                              String pendingClaimL3UISPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Pending List permission
                              String pendingODListUISPermission = (selected.profilePermission?.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Activate permission
                              String odActivateUISPermission = (selected.profilePermission?.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Activate permission
                              String loanActivateUISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L1 permission
                              String loanApprovalL1UISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L2 permission
                              String loanApprovalL2UISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L3 permission
                              String loanApprovalL3UISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_ADD"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L1 Delete permission
                              String loanApprovalL1UISDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L2 Delete permission
                              String loanApprovalL2UISDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the Loan Approval L3 Delete permission
                              String loanApprovalL3UISDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_DELETE"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Pending List permission
                              String pendingAttendanceRequestUISL1 = (selected.profilePermission?.contains("ATT_APP_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // 🟢 Check if the selected profile has the OD Activate permission
                              String pendingAttendanceRequestUISL2 = (selected.profilePermission?.contains("ATT_APP_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";


                              // 🟢 Save the MSS MO permission to SharedPreferences
                              await shared.setPendingAttendanceReqMSSMOPermission(pendingAttReqMOPermValue);
                              await shared.setPendingLeaveReqMSSMOPermission(leaveReqMOPermValue);
                              await shared.setPendingLeaveReqL1MSSMOPermission(leaveReqL1MOPermValue);
                              await shared.setPendingLeaveReqL2MSSMOPermission(leaveReqL2MOPermValue);
                              await shared.setOthersLeaveReqMSSMOPermission(othersLeaveReqMOPermValue);
                              await shared.setClaimLevelOneMO(pendingClaimL1MOPermission);
                              await shared.setClaimLevelTwoMO(pendingClaimL2MOPermission);
                              await shared.setClaimLevelThreeMO(pendingClaimL3MOPermission);
                              await shared.setODActivateMO(odActivateMOPermission);
                              await shared.setODPendingListMO(pendingODListMOPermission);
                              await shared.setLoanPendingListMO(loanActivateMOPermission);
                              await shared.setLoanApprovalL1MO(loanApprovalL1Permission);
                              await shared.setLoanApprovalL2MO(loanApprovalL2Permission);
                              await shared.setLoanApprovalL3MO(loanApprovalL3Permission);
                              await shared.setLoanApprovalDeleteL1MO(loanApprovalL1DeletePermission);
                              await shared.setLoanApprovalDeleteL2MO(loanApprovalL2DeletePermission);
                              await shared.setLoanApprovalDeleteL3MO(loanApprovalL3DeletePermission);
                              shared.setPendingAttendanceReqL1MO(pendingAttendanceRequestMOL1);
                              shared.setPendingAttendanceReqL2MO(pendingAttendanceRequestMOL2);
                              shared.setMyTeamPageShow(myTeamShow);
                              print("✅ Attendance Permission for profileId $selectedProfileId: $pendingAttReqMOPermValue");
                              print("✅ Leave Permission for profileId $selectedProfileId: $leaveReqMOPermValue");
                              print("✅ Leave L1 Permission for profileId $selectedProfileId: $leaveReqL1MOPermValue");
                              print("✅ Leave L2 Permission for profileId $selectedProfileId: $leaveReqL2MOPermValue");
                              print("✅ Others Leave Permission for profileId $selectedProfileId: $othersLeaveReqMOPermValue");
                              print("✅ Claim L1 Permission for profileId $selectedProfileId: $pendingClaimL1MOPermission");
                              print("✅ Claim L2 Permission for profileId $selectedProfileId: $pendingClaimL2MOPermission");
                              print("✅ Claim L3 Permission for profileId $selectedProfileId: $pendingClaimL3MOPermission");
                              print("✅ OD Activate Permission for profileId $selectedProfileId: $odActivateMOPermission");
                              print("✅ Pending OD Permission for profileId $selectedProfileId: $pendingODListMOPermission");
                              print("✅ Loan Activate Permission for profileId $selectedProfileId: $loanActivateMOPermission");
                              print("✅ Loan Approval L1 Permission for profileId $selectedProfileId: $loanApprovalL1Permission");
                              print("✅ Loan Approval L2 Permission for profileId $selectedProfileId: $loanApprovalL2Permission");
                              print("✅ Loan Approval L3 Permission for profileId $selectedProfileId: $loanApprovalL3Permission");
                              print("✅ Loan Approval L1 Delete Permission for profileId $selectedProfileId: $loanApprovalL1DeletePermission");
                              print("✅ Loan Approval L2 Delete Permission for profileId $selectedProfileId: $loanApprovalL2DeletePermission");
                              print("✅ Loan Approval L3 Delete Permission for profileId $selectedProfileId: $loanApprovalL3DeletePermission");
                              print("✅ Pending Attendance L1 MO Permission for profileId $selectedProfileId: $pendingAttendanceRequestMOL1");
                              print("✅ Pending Attendance L2 MO Permission for profileId $selectedProfileId: $pendingAttendanceRequestMOL2");
                              print("✅ My Team MO Permission for profileId $selectedProfileId: $myTeamShow");

                              // 🟢 Save the MSS permission to SharedPreferences
                              await shared.setPendingAttendanceReqMSSPermission(pendingAttReqMSSPermValue);
                              await shared.setPendingLeaveReqMSSPermission(leaveReqMSSPermValue);
                              await shared.setPendingLeaveReqL1MSSPermission(leaveReqL1MSSPermValue);
                              await shared.setPendingLeaveReqL2MSSPermission(leaveReqL2MSSPermValue);
                              await shared.setOthersLeaveReqMSSPermission(othersLeaveReqMSSPermValue);
                              await shared.setClaimLevelOne(pendingClaimL1Permission);
                              await shared.setClaimLevelTwo(pendingClaimL2Permission);
                              await shared.setClaimLevelThree(pendingClaimL3Permission);
                              await shared.setODActivate(odActivatePermission);
                              await shared.setODPendingList(pendingODListPermission);
                              await shared.setLoanPendingList(loanActivatePermission);
                              await shared.setLoanApprovalL1MSS(loanApprovalL1MSSPermission);
                              await shared.setLoanApprovalL2MSS(loanApprovalL2MSSPermission);
                              await shared.setLoanApprovalL3MSS(loanApprovalL3MSSPermission);
                              await shared.setLoanApprovalDeleteL1MSS(loanApprovalL1MSSDeletePermission);
                              await shared.setLoanApprovalDeleteL2MSS(loanApprovalL2MSSDeletePermission);
                              await shared.setLoanApprovalDeleteL3MSS(loanApprovalL3MSSDeletePermission);
                              shared.setPendingAttendanceReqL1MSS(pendingAttendanceRequestMSSL1);
                              shared.setPendingAttendanceReqL2MSS(pendingAttendanceRequestMSSL2);
                              print("✅ Attendance Permission for profileId $selectedProfileId: $pendingAttReqMSSPermValue");
                              print("✅ Leave Permission for profileId $selectedProfileId: $leaveReqMSSPermValue");
                              print("✅ Leave L1 Permission for profileId $selectedProfileId: $leaveReqL1MSSPermValue");
                              print("✅ Leave L2 Permission for profileId $selectedProfileId: $leaveReqL2MSSPermValue");
                              print("✅ Others Leave Permission for profileId $selectedProfileId: $othersLeaveReqMSSPermValue");
                              print("✅ Claim L1 Permission for profileId $selectedProfileId: $pendingClaimL1Permission");
                              print("✅ Claim L2 Permission for profileId $selectedProfileId: $pendingClaimL2Permission");
                              print("✅ Claim L3 Permission for profileId $selectedProfileId: $pendingClaimL3Permission");
                              print("✅ OD Activate Permission for profileId $selectedProfileId: $odActivatePermission");
                              print("✅ Pending OD List Permission for profileId $selectedProfileId: $pendingODListPermission");
                              print("✅ Loan Activate Permission for profileId $selectedProfileId: $loanActivatePermission");
                              print("✅ Loan Approval L1 Permission for profileId $selectedProfileId: $loanApprovalL1MSSPermission");
                              print("✅ Loan Approval L2 Permission for profileId $selectedProfileId: $loanApprovalL2MSSPermission");
                              print("✅ Loan Approval L3 Permission for profileId $selectedProfileId: $loanApprovalL3MSSPermission");
                              print("✅ Loan Approval L1 Delete Permission for profileId $selectedProfileId: $loanApprovalL1MSSDeletePermission");
                              print("✅ Loan Approval L2 Delete Permission for profileId $selectedProfileId: $loanApprovalL2MSSDeletePermission");
                              print("✅ Loan Approval L3 Delete Permission for profileId $selectedProfileId: $loanApprovalL3MSSDeletePermission");
                              print("✅ Pending Attendance L1 MSS Permission for profileId $selectedProfileId: $pendingAttendanceRequestMSSL1");
                              print("✅ Pending Attendance L2 MSS Permission for profileId $selectedProfileId: $pendingAttendanceRequestMSSL2");
                              // Notify global listener
                              permissionNotifier.updatePermission(pendingClaimL1Permission);
                              permissionNotifier.updatePermission(pendingClaimL2Permission);
                              permissionNotifier.updatePermission(pendingClaimL3Permission);
                              permissionNotifier.updatePermission(pendingClaimL1MOPermission);
                              permissionNotifier.updatePermission(pendingClaimL2MOPermission);
                              permissionNotifier.updatePermission(pendingClaimL3MOPermission);
                              // 🟢 Save the UIS permission to SharedPreferences
                              await shared.setPendingAttendanceReqUISPermission(pendingAttReqUISPermValue);
                              await shared.setPendingLeaveReqUISPermission(leaveReqUISPermValue);
                              await shared.setPendingLeaveReqL1UISPermission(leaveReqL1UISPermValue);
                              await shared.setPendingLeaveReqL2UISPermission(leaveReqL2UISPermValue);
                              await shared.setOthersLeaveReqUISPermission(othersLeaveReqUISPermValue);
                              await shared.setClaimLevelOneUIS(pendingClaimL1UISPermission);
                              await shared.setClaimLevelTwoUIS(pendingClaimL2UISPermission);
                              await shared.setClaimLevelThreeUIS(pendingClaimL3UISPermission);
                              await shared.setODActivateUIS(odActivateUISPermission);
                              await shared.setODPendingListUIS(pendingODListUISPermission);
                              await shared.setLoanPendingListUIS(loanActivateUISPermission);
                              await shared.setLoanApprovalL1UIS(loanApprovalL1UISPermission);
                              await shared.setLoanApprovalL2UIS(loanApprovalL2UISPermission);
                              await shared.setLoanApprovalL3UIS(loanApprovalL3UISPermission);
                              await shared.setLoanApprovalDeleteL1UIS(loanApprovalL1UISDeletePermission);
                              await shared.setLoanApprovalDeleteL2UIS(loanApprovalL2UISDeletePermission);
                              await shared.setLoanApprovalDeleteL3UIS(loanApprovalL3UISDeletePermission);
                              shared.setPendingAttendanceReqL1UIS(pendingAttendanceRequestUISL1);
                              shared.setPendingAttendanceReqL2UIS(pendingAttendanceRequestUISL2);
                              print("✅ Attendance Permission for profileId $selectedProfileId: $pendingAttReqUISPermValue");
                              print("✅ Leave Permission for profileId $selectedProfileId: $leaveReqUISPermValue");
                              print("✅ Leave L1 Permission for profileId $selectedProfileId: $leaveReqL1UISPermValue");
                              print("✅ Leave L2 Permission for profileId $selectedProfileId: $leaveReqL2UISPermValue");
                              print("✅ Others Leave Permission for profileId $selectedProfileId: $othersLeaveReqUISPermValue");
                              print("✅ Claim L1 Permission for profileId $selectedProfileId: $pendingClaimL1UISPermission");
                              print("✅ Claim L2 Permission for profileId $selectedProfileId: $pendingClaimL2UISPermission");
                              print("✅ Claim L3 Permission for profileId $selectedProfileId: $pendingClaimL3UISPermission");
                              print("✅ OD Activate Permission for profileId $selectedProfileId: $odActivateUISPermission");
                              print("✅ Pending OD List Permission for profileId $selectedProfileId: $pendingODListUISPermission");
                              print("✅ Loan Approval L1 Permission for profileId $selectedProfileId: $loanApprovalL1UISPermission");
                              print("✅ Loan Approval L2 Permission for profileId $selectedProfileId: $loanApprovalL2UISPermission");
                              print("✅ Loan Approval L3 Permission for profileId $selectedProfileId: $loanApprovalL3UISPermission");
                              print("✅ Loan Approval L1 Delete Permission for profileId $selectedProfileId: $loanApprovalL1UISDeletePermission");
                              print("✅ Loan Approval L2 Delete Permission for profileId $selectedProfileId: $loanApprovalL2UISDeletePermission");
                              print("✅ Loan Approval L3 Delete Permission for profileId $selectedProfileId: $loanApprovalL3UISDeletePermission");
                              print("✅ Pending Attendance L1 UIS Permission for profileId $selectedProfileId: $pendingAttendanceRequestUISL1");
                              print("✅ Pending Attendance L2 UIS Permission for profileId $selectedProfileId: $pendingAttendanceRequestUISL2");
                              // 🟢 Save selected profile details
                              await shared.setDefaultProfileId(selectedProfileId);
                              await shared.setDefaultProfileName(selectedProfileName);

                              selectedProfileIdNotifier.value = selectedProfileId!;
                              selectedProfileNameNotifier.value = selectedProfileName!;
                              setState(() {

                              });
                              getRequisitionCounts(sessionId!);
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,))
                              );
                            }
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),



          // 🔽 Bottom section (Settings)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, thickness: 1, color: Colors.grey.shade300),

              ListTile(
                leading: Icon(Icons.lock_reset, color: Mythemes.black),
                title: Text(
                  'Reset Password',
                  style: TextStyle(color: Mythemes.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.security_update_good_outlined, color: Mythemes.black),
                title: Text(
                  'Check for Updates',
                  style: TextStyle(color: Mythemes.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateChecker()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.policy, color: Mythemes.black),
                title: Text(
                  'Company Policies',
                  style: TextStyle(color: Mythemes.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompanyPoliciesPage()),
                  );
                },
              ),
            ],
          ).py32(),

          /*...profileListGetter.map((profile) {
            bool isSelected = selectedProfileId == profile.profileId;
            return ListTile(
              title: Text(
                profile.profileName ?? '',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
              tileColor: isSelected ? Colors.grey.shade200 : null,
              onTap: () async {
                setState(() {
                  selectedProfileId = profile.profileId!;
                  selectedProfileName = profile.profileName!;
                });

                await shared.setDefaultProfileId(selectedProfileId);
                await shared.setDefaultProfileName(selectedProfileName);

                selectedProfileIdNotifier.value = selectedProfileId!;
                selectedProfileNameNotifier.value = selectedProfileName!;

                Navigator.pop(context); // Close Drawer
              },
            );
          }).toList(),*/
        ],
      ),
    );
  }
}
