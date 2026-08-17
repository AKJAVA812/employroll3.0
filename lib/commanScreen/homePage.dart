import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:er_flutter_project/ess/essDashboard.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/punchInUploadPage.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/workDonePage.dart';
import 'package:er_flutter_project/commanScreen/ujalaCreditWorkdone.dart';
import 'package:er_flutter_project/profiles/profilePage.dart';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ntp/ntp.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UIS_Bundle/dashboard/adminDashboard.dart' as mss;
import '../ess/essDashboard.dart' as ess;
//import 'package:safe_device/safe_device.dart';
//import 'package:trust_location/trust_location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/services/attendance_punch_api.dart';
import '../MSS_Bundle/mobile_mss/mss_mobile_dashboard.dart';
//import 'package:er_flutter_project/adminPage/adminDashboard/adminDashboard.dart';
import '../adminPage/modelClass/dashboardModel.dart';
import '../ess/myAllReports.dart';
import '../modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../mss_profiles/global_profile.dart';
import '../mss_profiles/organisationListModal.dart';
import '../mss_profiles/profileListModal.dart';
import '../settings/checkForUpdates.dart';
import '../settings/companyPolicyList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../services/mobile_auth_service.dart';
import '../services/mobile_mo_organisation_service.dart';
import '../services/mobile_mss_dashboard_service.dart';
import '../services/mobile_panel_service.dart';
import '../services/mobile_permission_service.dart';
import '../services/mobile_profile_cache.dart';
import '../services/notification_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';

import '../singUP/resetPassword/resetPasswordPage.dart';
import 'allAPIList.dart';
import '../utils/profile_image_provider.dart';
import 'commanNotificationPage.dart';
import 'digiWeighWorkDone.dart';
import 'modalClass/geofenceListModal.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({super.key, this.selectedIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

int pageIndex = 0;
int currentIndex = 0;
var orgId;
var setGeofenceActive;
dynamic empIdGet;
var myTeamShow = "0";
var exitResignationListView = "0";
var exitResignationApproveL1View = "0";
var exitResignationApproveL2View = "0";
var exitResignationDisApproveL1View = "0";
var exitResignationDisApproveL2View = "0";
Position? positionCheck = Position(
  longitude: 0.0,
  latitude: 0.0,
  timestamp: date,
  accuracy: 0.0,
  altitude: 0.0,
  altitudeAccuracy: 0.0,
  heading: 0.0,
  headingAccuracy: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);

LatLng? currentPostion;
late GoogleMapController googleMapControllerNew;
var currentAddressNew = "Address Not Found";
var todayDate = "dd/mm/yyyy";
var todayDateShowNew = "dd/mm/yyyy";
late LoginModel _loginModel;
String timeStringNew = "";
String? sessionId;
String? userType;
int? orgnizationID = 0;
String UserName = "Employee Name";
String employeeCode = "101";
String? imageStringNew;
String? defaultProfileName;
dynamic defaultProfileId;
dynamic profileIdGetter;
dynamic profileNameGetter;
String? userPanelPermission;
String? activePanel;

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
final screens = [
  const DefaultPage(),
  const Workflow(),
  const MyRequests(),
  const Report(),
  Dashboard(),
  //ProfileCheck(),
];

class _HomePageState extends State<HomePage> {
  OrganisationListModal? organisationListModal;
  DateTime ntpTime = DateTime.now();
  MobileEssPermissionState? _essPermissionState;
  bool _panelContextLoaded = false;

  void _loadNTPTime() async {
    setState(() async {
      ntpTime = await NTP.now();
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _loginModel = LoginModel();
    _initializePanelContext();
    loadRequisitionCountsFromPrefs();
    currentIndex = widget.selectedIndex;
    if (currentIndex == 4) {
      title = "My Dashboard";
    }
    var now = DateTime.now();
    var newFormat = DateFormat('dd-MM-yyyy');
    todayDateShowNew = newFormat.format(now);
    getUserNameImage();
    MobileAuthService.instance.syncOnAppOpen();
  }

  Future<void> _initializePanelContext() async {
    await getSharedPrfanceList();
    await _loadEssPermissionState();
    if (!mounted) return;
    setState(() => _panelContextLoaded = true);
  }

  Future<void> _loadEssPermissionState() async {
    final state = await MobilePermissionService.loadEssState();
    if (!mounted) return;
    setState(() {
      _essPermissionState = state;
      if (!state.hasAnyMobileAccess && activePanel == MobilePanel.ess) {
        currentIndex = 0;
        title = 'Home';
      }
    });
  }

  Future<bool> _canOpenEssTab(int index) async {
    if (index == 0 || activePanel != MobilePanel.ess) return true;
    final state =
        _essPermissionState ?? await MobilePermissionService.loadEssState();
    if (state.hasAnyMobileAccess) {
      if (mounted && _essPermissionState == null) {
        setState(() => _essPermissionState = state);
      }
      return true;
    }
    if (!mounted) return false;
    setState(() {
      _essPermissionState = state;
      currentIndex = 0;
      title = 'Home';
    });
    await showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Permission required'),
            content: const Text(
              'You do not have permission to access this tab.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ],
          ),
    );
    return false;
  }

  var type = "0";
  var title = "Home";

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

  showLogoutPopup(BuildContext buildContext, result, alert) {
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
            await getLogout(context);
            shared.setSessionId("");
            shared.setAdminRole(0);
            shared.setEmpRoll(0);
            shared.setRoRoll(0);
            shared.setMobAction(0);
            final service = FlutterBackgroundService();
            var isRunning = await service.isRunning();

            if (isRunning) {
              service.invoke("stopService");
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

  Future getLogout(BuildContext buildContext) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.logoutAPi;
    final currentSessionId = await shared.getMobileSessionId();
    final accessToken = await shared.getAccessToken();
    final tokenType = await shared.getTokenType() ?? 'Bearer';
    final urlapi = Uri.parse("$conn$apiUrl");

    final response = await MobileHttpClient.instance.post(
      urlapi,
      headers: {
        if (accessToken != null && accessToken.isNotEmpty)
          'Authorization': '$tokenType $accessToken',
        if (currentSessionId != null && currentSessionId.isNotEmpty)
          'X-Mobile-Session-Id': currentSessionId,
      },
    );

    if (response.body.isNotEmpty) {
      mapResponse = json.decode(response.body);
    } else {
      mapResponse = <String, dynamic>{};
    }

    final result =
        (mapResponse['status'] ?? mapResponse['result'] ?? '').toString();
    final message =
        (mapResponse['message'] ?? mapResponse['reason'] ?? '').toString();

    if (response.statusCode == 200 &&
        result.compareToIgnoringCase('success') == 0) {
      await NotificationService.instance.deactivateCurrentToken();
      await shared.clearMobileAuth();
      Fluttertoast.showToast(
        msg: message.isNotEmpty ? message : "Logout Successfully !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: message.isNotEmpty ? message : "Logout Error !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  logoutApp(context) {
    showLogoutPopup(
      context,
      "Do You Want To Logout? ",
      "Alert",
    );
  }

  Future getUserNameImage() async {
    profileImage = await shared.getProfileImage();
    name = await shared.getempName();
    emailid = await shared.getEmailId();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    orgId = await shared.getOrgId();
    setGeofenceActive = await shared.getGeofenceActive();
    empIdGet = await shared.getEmpId();
    userType = await shared.getUserType();
    defaultProfileName = await shared.getDefaultProfileName();
    defaultProfileId = await shared.getDefaultProfileId();
    userPanelPermission = await shared.getUserPanel();
    activePanel = await shared.getActivePanel() ?? MobilePanel.ess;

    Future<OrganisationListModal> getOrgList = getOrganisationList(sessionId!);
    getOrgList.then((value) {
      setState(() {
        organisationListModal = value;
      });
    });
    setState(() {});

    imageStringNew = await shared.getProfileImage();
    UserName = await shared.getempName();
    employeeCode = await shared.getEmpCode();
    lat = await shared.getLatitude();
    lng = await shared.getLongitude();
  }

  Future<OrganisationListModal> getOrganisationList(String sessionId) async {
    try {
      organisationListModal =
          await MobileMoOrganisationService.loadForActivePanel();


      return organisationListModal!;
    } catch (e) {
      rethrow;
    }
  }

  showDialgSucess(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(" Info "),
        ],
      ),
      content: Container(
        //width: MediaQuery.of(buildContext).size.width,
        padding: EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [Center()]),
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: "Cancel".text.color(Mythemes.dangerColorOne).make(),
        ),
        TextButton(
          onPressed: () {
            shared.setSessionId("");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
          },
          child: "Logout".text.color(Mythemes.warningColor).make(),
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

  @override
  Widget build(BuildContext context) {
    late CameraController controller;
    if (!_panelContextLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isManagerPanel = MobilePanel.isManager(activePanel);
    final activeIndex = isManagerPanel && currentIndex > 3 ? 0 : currentIndex;
    final managerScreens = [
      const DefaultPage(),
      MssTeamDashboardScreen(
        onViewRequests: () {
          setState(() {
            currentIndex = 2;
            title = 'Requests';
          });
        },
      ),
      const MssRequestsScreen(),
      const MssPeopleScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title - ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Mythemes.successColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: selectedProfileNameNotifier,
                        builder: (context, value, _) {
                          final displayText =
                              (activePanel == MobilePanel.ess) ? "ESS" : value;

                          return Text(
                            displayText,
                            style: TextStyle(
                              color: Mythemes.whitish,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
          actions: <Widget>[
            if (isManagerPanel && activeIndex > 0)
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: MobileMssDashboardService.requestManualRefresh,
              ),
            IconButton(
              icon: Icon(Icons.power_settings_new_outlined),
              onPressed: () {
                logoutApp(context);
              },
            ),
          ],
        ),
        body:
            isManagerPanel
                ? managerScreens[activeIndex]
                : (_essPermissionState != null &&
                    !_essPermissionState!.hasAnyMobileAccess)
                ? screens[0]
                : screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: activeIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) async {
            if (isManagerPanel) {
              final titles = ['Home', 'Team', 'Requests', 'People'];
              setState(() {
                currentIndex = index;
                title = titles[index];
              });
              return;
            }
            if (!await _canOpenEssTab(index)) return;
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
                newTitle = "My Requests";
                break;
              case 3:
                newTitle = "My Reports";
                break;
              case 4:
                newTitle = "My Dashboard";
                screens[4] = Dashboard(key: UniqueKey());
                break;
            }

            setState(() {
              currentIndex = index;
              title = newTitle;
            });
          },
          items:
              isManagerPanel
                  ? const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard_customize),
                      label: 'Team',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pending_actions),
                      label: 'Requests',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people_alt),
                      label: 'People',
                    ),
                  ]
                  : [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.manage_accounts_outlined),
                      label: 'Workflow',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.app_badge_fill),
                      label: 'My Requests',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.doc_chart),
                      label: 'My Reports',
                    ),
                    if (userType != 'COMPANY_ADMIN')
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                  ],
        ),
        drawer: DrawerFile(),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text("Loading..."),
          ),
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

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: const Text('Do you really want to close this app?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
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
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
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
            Navigator.pop(context);
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
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void showDialgErro(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      title: Row(children: [Icon(Icons.warning), Text("   Alert Dialog")]),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}

class _NoEssPermissionHome extends StatelessWidget {
  const _NoEssPermissionHome();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 44, color: Mythemes.greyish),
            const SizedBox(height: 12),
            const Text(
              'No ESS permission assigned',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Contact your administrator to enable mobile access.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Mythemes.blackish, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

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
  dynamic mobAction;
  String? mockLat;
  String? mockLong;
  bool? isMock = false;
  GoogleMapController? _mapController;

  @override
  void initState() {
    //print('initState');
    // TODO: implement initState
    _determinePosition();
    //_getUserLocation();
    _startLocationTracking();
    timeStringNew = _formatDateTime(DateTime.now());
    getSharedPrfanceList();
    _getTime();
    initPlatformState();
    super.initState();
  }

  StreamSubscription<Position>? positionStream;
  @override
  void dispose() {
    // TODO: implement dispose
    //TrustLocation.stop();
    positionStream?.cancel();
    super.dispose();
  }

  void _startLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // update every 5 meter movement
    );

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position pos) {
      setState(() {
        currentPostion = LatLng(pos.latitude, pos.longitude);
      });

      // Save position
      shared.setLatitude(pos.latitude);
      shared.setLongitude(pos.longitude);

      // Update address dynamically
      getAddress(pos);

      // Update map center dynamically
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
        );
      }

    });
  }

  // âœ… Main method to get Geofence list
  Future<GeofenceListModal> getGeofenceList(String sessionId) async {
    try {
      final context = await AttendancePunchApi().getPunchContext();
      if (mounted) setState(() => setGeofenceActive = context.geofenceRequired);
      return context.toLegacyGeofenceList();
    } catch (e) {
      // âœ… Return empty model in case of failure
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
        builder:
            (_) => AlertDialog(
              title: const Text("Select Your Location"),
              content: const Text("No geofence data available"),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    // Ensure saved id exists in fetched list; otherwise ignore it
    bool savedExists =
        savedGeofenceId != null &&
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                      items:
                          geofenceList.userdata!
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
                        const SnackBar(
                          content: Text("Please select a geofence"),
                        ),
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
        builder:
            (_) => AlertDialog(
              title: const Text("Select Your Location"),
              content: const Text("No geofence data available"),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    // Ensure saved id exists in fetched list; otherwise ignore it
    bool savedExists =
        savedGeofenceId != null &&
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                      items:
                          geofenceList.userdata!
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
                  onPressed: () async {
                    if (selectedGeofenceId != null) {
                      // Save selected id to shared preferences
                      await _saveGeofenceId(selectedGeofenceId!);

                      // Close dialog and trigger punch-in (as you had)
                      Navigator.pop(context, selectedGeofenceId);

                      // Call your punch-in method with selected id
                      if (context.mounted) {
                        getPunchOutWithGeofence(
                          context,
                          selectedGeofenceId,
                        ); // âœ… Pass selected ID to your method
                      }
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
            );
          },
        );
      },
    );
  }

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
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getUserLocation() async {
    double lat = shared.getLatitude();
    double lng = shared.getLongitude();
    currentPostion = LatLng(lat, lng);
    positionCheck = await GeolocatorPlatform.instance.getCurrentPosition();
    //position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 5));
    //print('SetcurrentCL  $position');
    //var lastPosition = await Geolocator.getLastKnownPosition();
    //print('SetcurrentLast  $lastPosition');
    // bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (positionCheck != null) {
      setState(() {
        currentPostion = LatLng(
          positionCheck!.latitude,
          positionCheck!.longitude,
        );
        shared.setLatitude(positionCheck!.latitude);
        shared.setLongitude(positionCheck!.longitude);
        getAddress(positionCheck!);
      });
    } else {
      showAboutDialog(context: context);
    }
  }

  Future<void> getAddress(Position positionCheck) async {
    List<Placemark> pleaceMark = await placemarkFromCoordinates(
      positionCheck.latitude,
      positionCheck.longitude,
    );
    Placemark placemarkee = pleaceMark[0];
    var contryName = placemarkee.country;
    var locality = placemarkee.locality;
    var sublocality = placemarkee.subLocality;
    var administrativeArea = placemarkee.administrativeArea;
    var street = placemarkee.street;
    var postalCode = placemarkee.postalCode;
    var nameAdd = placemarkee.name;
    setState(() {
      currentAddressNew =
          '$street ' '$nameAdd ' '$sublocality ' '$locality ' '$administrativeArea ' +
          '$contryName ' +
          '$postalCode ';
    });
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (!mounted) return;
    setState(() {
      timeStringNew = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;

  var attAction;

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    lat = await shared.getLatitude();
    //position= Position(longitude: shared.getLongitude(), latitude: shared.getLatitude(), timestamp: date, accuracy: 1, altitude: 1, altitudeAccuracy: 1, heading: 1, headingAccuracy: 1, speed: 1, speedAccuracy: 1);
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    timeStringNew = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    lng = await shared.getLongitude();
    orgnizationID = await shared.getOrgId();
    attAction = await shared.getAttAction();
    //print("Long - $lng");
    currentPostion = LatLng(positionCheck!.latitude, positionCheck!.longitude);

    mobAction = await shared.getMobAction();

    setState(() {
      if (empRole == 1) {
        showHide = true;
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
      }
      if (adminRole == 1) {
        showAdmin = true;
      }
      if (roRole == 0) {
        showRo = false;

      }
      if (roRole == 1) {
        showRo = true;
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
    getImageForWorkdone() async {
      try {
        final imageValue = await ImagePicker()
            .pickImage(source: ImageSource.camera)
            .then((value) {
              if (value != null) _workDoneImage = File(value.path);
              if (value == null) {
                Navigator.pushNamed(context, MyRoutings.punchInRoute);
                //Navigator.pushNamed(context, MyRoutings.addInductionProcessRoute);
              } else {
                setState(() {
                  if (orgnizationID == 108) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => UjalaCreditWorkdone(
                              value: _workDoneImage,
                              address: currentAddressNew,
                              time: timeStringNew,
                            ),
                      ),
                    );
                  } else if (orgnizationID == 110) {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SkyDecorWorkDone(value: _workDoneImage, address: currentAddressNew, time: timeStringNew )));
                  } else if (orgnizationID == 119) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => DigiWeighWorkDone(
                              value: _workDoneImage,
                              address: currentAddressNew,
                              time: timeStringNew,
                            ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => WorkDonePage(
                              value: _workDoneImage,
                              address: currentAddressNew,
                              time: timeStringNew,
                            ),
                      ),
                    );
                  }
                });
              }
            });
        //if(imageValue==null) return;

        //final imagePath= File(imageValue.path);
      } on PlatformException {
        //print('failed to upload: $e');
      }
    }

    getImagePunchOut() async {
      try {
        //Navigator.pushNamed(context, MyRoutings.cameraPageRoute);

        final imageValue = await ImagePicker()
            .pickImage(source: ImageSource.camera)
            .then((value) {
              _workDoneImage = File(value!.path);
            });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => ImageUploaded(
                  value: _workDoneImage,
                  address: currentAddressNew,
                  time: timeStringNew,
                  punchType: clockingType,
                ),
          ),
        );
      } catch (e) {
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Card(
              child:
                  currentPostion == null
                      ? Center(child: CircularProgressIndicator())
                      : GoogleMap(
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            currentPostion!.latitude,
                            currentPostion!.longitude,
                          ),
                          zoom: 16,
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
              title: ("$UserName($employeeCode)").text.make(),
              subtitle: Text(currentAddressNew),
              leading: SizedBox(
                width: 45,
                height: 45,
                child:
                    imageStringNew == null
                        ? Center(child: CircularProgressIndicator())
                        : CircleAvatar(
                          radius: 30,
                          backgroundImage: profileImageProvider(imageStringNew),
                          backgroundColor: Colors.grey,
                          // child: Image.network(imageStringNew!),
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
                      Container(height: 10),
                      //Padding(padding: EdgeInsets.all(0)),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          todayDateShowNew,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
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
                      Container(height: 12, color: Mythemes.whiteShadeSeventy),
                      //Padding(padding: EdgeInsets.all(0)),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          timeStringNew,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          mobAction == 0
              ? SizedBox(height: 0)
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please check your Internet connection.",
                                        ),
                                      ),
                                    );
                                  });
                                } else if (Platform.isAndroid) {
                                  bool isFakeLocation =
                                      await DetectFakeLocation()
                                          .detectFakeLocation();
                                  if (isFakeLocation == true) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Mock Location Detected'),
                                          content: Text(
                                            'You have enabled a mock or fake location. Please disable it to proceed with marking your attendance.',
                                          ),
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
                                    if (!timeAuto) {
                                      //DatetimeSetting.openSetting();
                                      showAutoTimeZone(
                                        context,
                                        "Your mobile timing not updated, please change time setting to auto.",
                                        "Info ",
                                      );
                                    } else {
                                      clockingType = "In";
                                      if (attAction == '0') {
                                        if (orgId == 201 ||
                                            orgId == 200 ||
                                            orgId == 199 ||
                                            orgId == 202 ||
                                            orgId == 145) {
                                          /*showDialog(
                                              context: context,
                                              barrierDismissible: false, // user can't close by tapping outside
                                              builder: (BuildContext context) {
                                                String? selectedGeofence;
                                                List<String> geofenceList = [
                                                  "Office - Main Gate",
                                                  "Office - Back Gate",
                                                  "Warehouse Zone",
                                                  "Factory Area",
                                                  "Guest Parking",
                                                  "HR Building",
                                                ];
                                                List<String> filteredList = List.from(geofenceList);
                                                final TextEditingController searchController = TextEditingController();

                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                      title: const Text(
                                                        "Select Geofence",
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      content: SizedBox(
                                                        width: double.maxFinite,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            // ðŸ“ Dropdown List
                                                            DropdownButtonFormField<String>(
                                                              value: selectedGeofence,
                                                              isExpanded: true,
                                                              decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: "Select Geofence",
                                                              ),
                                                              items: filteredList
                                                                  .map((geo) => DropdownMenuItem<String>(
                                                                value: geo,
                                                                child: Text(geo),
                                                              ))
                                                                  .toList(),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  selectedGeofence = value;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // ðŸ”˜ Buttons
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
                                                          onPressed: () {
                                                            print("SELECTED GEOFENCE - $selectedGeofence");
                                                            if (selectedGeofence != null) {
                                                              Navigator.pop(context, selectedGeofence);
                                                              getPunchIn(context);
                                                              // tu yahan apna attendance method call kar sakta hai
                                                              // getPunchIn(context, selectedGeofence);
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
                                            );*/
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
                                          var imageValue = await _picker
                                              .pickImage(
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
                                          setState(() {
                                            final imagePath = File(
                                              imageValue!.path,
                                            );
                                            _workDoneImage = imagePath;
                                          });
                                          imageValue = null;
                                          //imageCache.clear();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ImageUploaded(
                                                    value: _workDoneImage,
                                                    address: currentAddressNew,
                                                    time: timeStringNew,
                                                    punchType: clockingType,
                                                  ),
                                            ),
                                          );
                                        } on Exception catch (e) {
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  clockingType = "In";
                                  if (attAction == '0') {
                                    if (setGeofenceActive == true) {
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
                                      var imageValue = await _picker.pickImage(
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
                                      setState(() {
                                        final imagePath = File(
                                          imageValue!.path,
                                        );
                                        _workDoneImage = imagePath;
                                      });
                                      imageValue = null;
                                      //imageCache.clear();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ImageUploaded(
                                                value: _workDoneImage,
                                                address: currentAddressNew,
                                                time: timeStringNew,
                                                punchType: clockingType,
                                              ),
                                        ),
                                      );
                                    } on Exception catch (e) {
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
                                      backgroundColor: Mythemes.successColor,
                                      radius: 30,
                                      child: Icon(
                                        Icons.touch_app,
                                        size: 30,
                                        color: Mythemes.creamColor,
                                      ),
                                    ),
                                  ),
                                  Container(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    //margin: EdgeInsets.all(5),
                                    child: Text(
                                      "Punch In",
                                      style: TextStyle(fontSize: 16),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please check your Internet connection.",
                                        ),
                                      ),
                                    );
                                  });
                                } else if (Platform.isAndroid) {
                                  bool isFakeLocation =
                                      await DetectFakeLocation()
                                          .detectFakeLocation();
                                  if (isFakeLocation == true) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Mock Location Detected'),
                                          content: Text(
                                            'You have enabled a mock or fake location. Please disable it to proceed with marking your work done.',
                                          ),
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
                                    if (!timeAuto) {
                                      //DatetimeSetting.openSetting();
                                      showAutoTimeZone(
                                        context,
                                        "Your mobile timing not updated, please change time setting to auto.",
                                        "Info ",
                                      );
                                    } else {
                                      getImageForWorkdone();
                                    }
                                  }
                                } else {
                                  getImageForWorkdone();
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Mythemes.lightBluishColor,
                                      radius: 30,
                                      child: Icon(
                                        Icons.work_history,
                                        size: 30,
                                        color: Mythemes.creamColor,
                                      ),
                                    ),
                                  ),
                                  Container(height: 5),
                                  Padding(padding: EdgeInsets.all(0)),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Work Done",
                                      style: TextStyle(fontSize: 16),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please check your Internet connection.",
                                        ),
                                      ),
                                    );
                                  });
                                } else if (Platform.isAndroid) {
                                  bool isFakeLocation =
                                      await DetectFakeLocation()
                                          .detectFakeLocation();
                                  if (isFakeLocation == true) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Mock Location Detected'),
                                          content: Text(
                                            'You have enabled a mock or fake location. Please disable it to proceed with marking your attendance.',
                                          ),
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
                                    if (!timeAuto) {
                                      //DatetimeSetting.openSetting();
                                      showAutoTimeZone(
                                        context,
                                        "Your mobile timing not updated, please change time setting to auto.",
                                        "Info ",
                                      );
                                    } else {
                                      clockingType = "Out";
                                      if (attAction == '0') {
                                        if (setGeofenceActive == true) {
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
                                  clockingType = "Out";
                                  if (attAction == '0') {
                                    if (setGeofenceActive == true) {
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
                                      backgroundColor: Mythemes.dangerColorOne,
                                      radius: 30,
                                      child: Icon(
                                        Icons.touch_app,
                                        size: 30,
                                        color: Mythemes.creamColor,
                                      ),
                                    ),
                                  ),
                                  Container(height: 5),
                                  Padding(padding: EdgeInsets.all(0)),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Punch Out",
                                      style: TextStyle(fontSize: 16),
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
            if (setGeofenceActive == true) {
              showGeofenceDialog(
                buildContext,
                sessionId: sessionId!,
                empId: empIdGet,
                orgId: orgId,
              );
            } else {
              getPunchIn(buildContext);
            }
          },
          child: Text("Retry"),
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

  showAutoTimeZone(BuildContext buildContext, result, alert) {
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
            DatetimeSetting.openSetting();
            Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: Container(child: Text("Ok")),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      barrierDismissible: false,
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
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

  Future<void> getPunchIn(BuildContext context) async {
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
    http.Response response = await AttendancePunchApi().punchWithoutSelfie(
      action: clockingType!,
      latitude: lat,
      longitude: lng,
      accuracyMeters: positionCheck?.accuracy ?? 50,
      address: currentAddressNew,
    );
    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
          context,
          "${reasonSuccess.upperCamelCase} $formattedDate",
          "Successfully Punch In",
        );
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
          context,
          reasonSuccess.upperCamelCase,
          " Failed ",
        );
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialgError(
        context,
        result,
        "Your Punch Not Submitted, Please Try Again",
      );
    }
  }

  Future<void> getPunchInWithGeofence(
    BuildContext context,
    dynamic selectedGeofenceId,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithGeofence;

    // âœ… Use root context to show dialogs safely
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

    http.Response response = await AttendancePunchApi().punchWithoutSelfie(
      action: clockingType!,
      latitude: lat,
      longitude: lng,
      accuracyMeters: positionCheck?.accuracy ?? 50,
      address: currentAddressNew,
      geofenceId: int.tryParse(selectedGeofenceId.toString()),
    );

    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];


    // âœ… Always pop loader safely
    if (rootContext.mounted) {
      Navigator.of(rootContext, rootNavigator: true).pop();
    }

    // âœ… Use rootContext to show success popup (not the old one)
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
    http.Response response = await AttendancePunchApi().punchWithoutSelfie(
      action: clockingType!,
      latitude: lat,
      longitude: lng,
      accuracyMeters: positionCheck?.accuracy ?? 50,
      address: currentAddressNew,
    );
    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
          context,
          "${reasonSuccess.upperCamelCase} $formattedDate",
          "Successfully Punch Out",
        );
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
          context,
          reasonSuccess.upperCamelCase,
          " Failed ",
        );
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialgError(
        context,
        result,
        "Your Punch Not Submitted, Please Try Again",
      );
    }
  }

  Future<void> getPunchOutWithGeofence(
    BuildContext context,
    dynamic selectedGeofenceId,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithGeofence;

    // âœ… Use root context to show dialogs safely
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
    http.Response response = await AttendancePunchApi().punchWithoutSelfie(
      action: clockingType!,
      latitude: lat,
      longitude: lng,
      accuracyMeters: positionCheck?.accuracy ?? 50,
      address: currentAddressNew,
      geofenceId: int.tryParse(selectedGeofenceId.toString()),
    );
    result = json.decode(response.body.toString());
    String resultSuccess = result['result'];
    String reasonSuccess = result['reason'];

    if (response.statusCode == 200) {
      // âœ… Always pop loader safely
      if (rootContext.mounted) {
        Navigator.of(rootContext, rootNavigator: true).pop();
      }
      // Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessStay(
          rootContext,
          "${reasonSuccess.upperCamelCase} $formattedDate",
          "Successfully Punch Out",
        );
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessStay(
          rootContext,
          reasonSuccess.upperCamelCase,
          " Failed ",
        );
      }
    } else {
      Navigator.of(rootContext, rootNavigator: true).pop();
      showDialgError(
        rootContext,
        result,
        "Your Punch Not Submitted, Please Try Again",
      );
    }
  }

  Future punchInnew(String? sessionId) async {
    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;
    var urlapi = Uri.parse(
      "http://www.employroll.com/restful/service/attendance/via/mobile/without/image?"
      "sessionId=$sessionId&"
      "address=$currentAddressNew&"
      "clocking=$sessionId&"
      "clockingType=$clockingType&"
      "lat=$lat&"
      "lng=$lng&"
      "currentDate=$todayDate&"
      "firstImei=$sessionId&"
      "secondImei=$sessionId&"
      "macAddress=$sessionId&"
      "deviceId=$sessionId&"
      "battery=$sessionId&",
    );
    final response = await MobileHttpClient.instance.get(urlapi);
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return null;
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
  const Workflow({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectList();
  }
}

class MyRequests extends StatelessWidget {
  const MyRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return GetAttendanceDet(showAppBar: false);
  }
}

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAllReportsPage(showAppBar: false);
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
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var title = "Dashboard";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMss = userPanelPermission == "USER";
    return isMss
        ? mss.Admin_UIS_Dashboard(DashboardModel())
        : ess.EssAdminDashboard(EssDashboarrdModel());
  }
}

class DrawerFile extends StatefulWidget {
  const DrawerFile({super.key});

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
  bool hasEssPanel = false;
  @override
  void initState() {
    super.initState();
    MobileProfileCache.revision.addListener(_reloadDrawerFromBootstrap);
    getUserRoles();
    getSharedPreferences();
    loadSelectedProfile();
    //getUserNameImage();
  }

  @override
  void dispose() {
    MobileProfileCache.revision.removeListener(_reloadDrawerFromBootstrap);
    super.dispose();
  }

  void _reloadDrawerFromBootstrap() {
    getSharedPreferences();
  }

  Future<void> getSharedPreferences() async {
    orgId = await shared.getOrgId();
    selectedProfileId = await shared.getDefaultProfileId();
    selectedProfileName = await shared.getDefaultProfileName();

    userPanelPermission = await shared.getUserPanel();
    activePanel = await shared.getActivePanel() ?? MobilePanel.ess;
    hasEssPanel = await shared.getHasEssPanel() ?? true;

    final currentSessionId = sessionId;
    if (currentSessionId != null) {
      getProfileList(currentSessionId).then((value) {
        if (!mounted) return;
        setState(() => profileListModal = value);
      });
    }
  }

  ProfileListModal? profileListModal;
  List<ProfileData> profileListGetter = [];

  void loadSelectedProfile() async {
    selectedProfileId = await shared.getDefaultProfileId();
    selectedProfileName = await shared.getDefaultProfileName();

    // Optional: update the ValueNotifiers if needed globally
    selectedProfileIdNotifier.value = selectedProfileId;
    selectedProfileNameNotifier.value = selectedProfileName!;

    setState(() {});
  }

  Future<ProfileListModal> getProfileList(String sessionId) async {
    setState(() {
      isLoadingProfiles = true;
    });

    try {
      profileListModal = await MobileProfileCache.loadProfileList();
      profileListGetter.clear();
      profileListGetter.addAll(profileListModal?.data ?? []);

      for (int i = 0; i < profileListGetter.length; i++) {
      }

      if (profileListGetter.isNotEmpty) {
        if (activePanel == MobilePanel.ess) {
          selectedProfileId = 0;
          selectedProfileName = 'ESS';
        } else {
          final savedProfileId = await shared.getDefaultProfileId();
          final selected = profileListGetter.firstWhere(
            (profile) => profile.profileId == savedProfileId,
            orElse: () => profileListGetter.first,
          );
          selectedProfileId = selected.profileId ?? 0;
          selectedProfileName = selected.profileName ?? '';
          if (savedProfileId != selectedProfileId) {
            await MobilePanelService.activateProfile(selected);
            activePanel = MobilePanel.fromProfileType(selected.profileType);
          }
        }
        selectedProfileIdNotifier.value = selectedProfileId ?? 0;
        selectedProfileNameNotifier.value = selectedProfileName ?? '';
      } else {
        selectedProfileId = 0;
        selectedProfileName = '';
      }

      return profileListModal ?? ProfileListModal(data: <ProfileData>[]);
    } catch (e) {
      return ProfileListModal(data: <ProfileData>[]);
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

  }

  Future<void> getRequisitionCounts(String sessionId) async {
    try {
      String conn = ApiDetails.server;
      // Counts are supplied by the new dashboard data.
      return;
      String apiUrl = '';

      var urlapi = Uri.parse(
        "$conn$apiUrl?"
        "sessionId=$sessionId&"
        "profileId=$defaultProfileId&"
        "userPermission=$userPanelPermission",
      );

      final response = await MobileHttpClient.instance.post(urlapi);


      Map<String, dynamic> mapResponse = json.decode(response.body);

      // After decoding response
      int attReqCount = mapResponse['attReqCount'] ?? 0;
      int leaveReqCount = mapResponse['leaveReqCount'] ?? 0;
      int mobOdCount = mapResponse['mobOdCount'] ?? 0;
      int wfhReqCount =
          int.tryParse(
            '${mapResponse['wfhReqCount'] ?? mapResponse['wfhCount'] ?? 0}',
          ) ??
          0;
      int compOffReqCount =
          int.tryParse(
            '${mapResponse['compOffReqCount'] ?? mapResponse['compOffCount'] ?? 0}',
          ) ??
          0;

      // âœ… Update global notifiers
      attReqCountNotifier.value = attReqCount;
      leaveReqCountNotifier.value = leaveReqCount;
      odReqCountNotifier.value = mobOdCount;

      // âœ… Also persist in SharedPreferences for app relaunch
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("attReqCount", attReqCount);
      await prefs.setInt("leaveReqCount", leaveReqCount);
      await prefs.setInt("mobOdCount", mobOdCount);
      await prefs.setInt("wfhReqCount", wfhReqCount);
      await prefs.setInt("compOffReqCount", compOffReqCount);

      // âœ… Assign values to variables
      mobOdCount = mapResponse['mobOdCount'] ?? 0;
      leaveReqCount = mapResponse['leaveReqCount'] ?? 0;
      odReqCount = mapResponse['odReqCount'] ?? 0;
      tourReqCount = mapResponse['tourReqCount'] ?? 0;
      attReqCount = mapResponse['attReqCount'] ?? 0;

      // âœ… Save all data into SharedPreferences
      //final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("mobOdCount", mobOdCount);
      await prefs.setInt("leaveReqCount", leaveReqCount);
      await prefs.setInt("odReqCount", odReqCount);
      await prefs.setInt("tourReqCount", tourReqCount);
      await prefs.setInt("attReqCount", attReqCount);

    } catch (e) {
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
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
      }
      if (adminRole == 1) {
        showAdmin = true;
      }
      if (roRole == 0) {
        showRo = false;

      }
      if (roRole == 1) {
        showRo = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //timeDilation = 1.8;
    return Drawer(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // âœ… Pushes bottom content down
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Mythemes.whiteShadeSeventy),
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Mythemes.whiteShadeSeventy),
                  accountName: Text(
                    name,
                    style: TextStyle(
                      color: Mythemes.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    emailid,
                    style: TextStyle(color: Mythemes.black),
                  ),
                  margin: EdgeInsets.zero,
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: profileImageProvider(profileImage),
                    backgroundColor: Mythemes.greyish,
                  ),
                ),
              ),
              if (hasEssPanel)
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(
                    "ESS",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  subtitle: Text("Self service panel"),
                  trailing:
                      activePanel == MobilePanel.ess
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                  tileColor:
                      activePanel == MobilePanel.ess
                          ? Colors.grey.shade200
                          : null,
                  onTap: () async {
                    await MobilePanelService.activateEss();
                    activePanel = MobilePanel.ess;
                    userPanelPermission = "COMPANY_EMPLOYEE";
                    selectedProfileId = 0;
                    selectedProfileName = 'ESS';
                    selectedProfileIdNotifier.value = 0;
                    selectedProfileNameNotifier.value = 'ESS';
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(selectedIndex: 0),
                      ),
                    );
                  },
                ),
              Visibility(
                visible: profileListGetter.isNotEmpty,
                child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: ["Profiles".text.bold.size(17).make()],
                    ).p8(),
              ),

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
                visible: profileListGetter.isNotEmpty,
                child:
                    isLoadingProfiles
                        ? Center(child: CircularProgressIndicator()).p12()
                        : ValueListenableBuilder<int>(
                          valueListenable: selectedProfileIdNotifier,
                          builder: (context, currentSelectedId, _) {
                            return Column(
                              children:
                                  profileListGetter.map((profile) {
                                    bool isSelected =
                                        MobilePanel.isManager(activePanel) &&
                                        currentSelectedId == profile.profileId;

                                    return ListTile(
                                      title: Text(
                                        profile.profileName ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing:
                                          isSelected
                                              ? Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )
                                              : null,
                                      tileColor:
                                          isSelected
                                              ? Colors.grey.shade200
                                              : null,
                                      onTap: () async {
                                        selectedProfileId = profile.profileId!;
                                        selectedProfileName =
                                            profile.profileName!;

                                        // ðŸŸ¢ Find the selected profile from the list using profileId
                                        final selected = profileListGetter
                                            .firstWhere(
                                              (p) =>
                                                  p.profileId ==
                                                  selectedProfileId,
                                              orElse: () => profile,
                                            );

                                        //MSS MO
                                        // ðŸŸ¢ Check if the selected profile has the Pending Attendance Request permission
                                        /*String pendingAttReqMOPermValue = (selected.profilePermission?.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD",
                                            ) ==
                                            true) {
                                          shared
                                              .setPendingAttendanceReqMSSMOPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingAttendanceReqMSSMOPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request permission
                                        /*String leaveReqMOPermValue = (selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                                  "LEAVE_REQ_APPROVAL_MO_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission
                                                    ?.contains(
                                                      "LEAVE_REQ_MYTEAM_ADD",
                                                    ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqMSSMOPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingLeaveReqMSSMOPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L1 permission
                                        /*String leaveReqL1MOPermValue = (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                                  "LEVEL_ONE_LEAVE_APPROVE_MO_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                                                ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqL1MSSMOPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingLeaveReqL1MSSMOPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                                        /* String leaveReqL2MOPermValue = (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                                  "LEVEL_TWO_LEAVE_APPROVE_MO_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "FINAL_LEVEL_LEAVE_APPROVE_MO_ADD",
                                                ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqL2MSSMOPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingLeaveReqL2MSSMOPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                                        /* String othersLeaveReqMOPermValue = (selected.profilePermission?.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "OTHERS_LEAVE_REQUEST_MO_ADD",
                                                ) ==
                                            true) {
                                          shared
                                              .setOthersLeaveReqMSSMOPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setOthersLeaveReqMSSMOPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L1 permission
                                        /*String pendingClaimL1MOPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelOneMO("1");
                                          shared.setClaimLevelOne(
                                            "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
                                          );
                                          permissionNotifier.updatePermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setClaimLevelOneMO("0");
                                          shared.setClaimLevelOne("");
                                          permissionNotifier.updatePermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L2 permission
                                        /*String pendingClaimL2MOPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelTwoMO("1");
                                          shared.setClaimLevelTwo(
                                            "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
                                          );
                                          permissionNotifier.updatePermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setClaimLevelTwoMO("0");
                                          shared.setClaimLevelTwo("");
                                          permissionNotifier.updatePermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L3 permission
                                        /*String pendingClaimL3MOPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelThreeMO("1");
                                          shared.setClaimLevelThree(
                                            "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
                                          );
                                          permissionNotifier.updatePermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setClaimLevelThreeMO("0");
                                          shared.setClaimLevelThree("");
                                          permissionNotifier.updatePermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Pending List permission
                                        /* String pendingODListMOPermission = (selected.profilePermission?.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "MOBILE_OD_PENDING_REQ_ADD",
                                                ) ==
                                            true) {
                                          shared.setODPendingListMO("1");
                                        } else {
                                          shared.setODPendingListMO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Activate permission
                                        /*String odActivateMOPermission = (selected.profilePermission?.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "MOBILE_OD_ACTIVATE_ADD",
                                                ) ==
                                            true) {
                                          shared.setODActivateMO("1");
                                        } else {
                                          shared.setODActivateMO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Activate permission
                                        /*String loanActivateMOPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanPendingListMO("1");
                                        } else {
                                          shared.setLoanPendingListMO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L1 permission
                                        /*String loanApprovalL1Permission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_ADD"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanApprovalL1MO(
                                            "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL1MO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L2 permission
                                        /*String loanApprovalL2Permission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_ADD"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_TWO_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanApprovalL2MO(
                                            "LOAN_APPROVAL_LEVEL_TWO_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL2MO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L3 permission
                                        /*String loanApprovalL3Permission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_ADD"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_THREE_ADD",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalL3MO(
                                            "LOAN_APPROVAL_LEVEL_THREE_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL3MO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L1 Delete permission
                                        /*String loanApprovalL1DeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_ONE_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL1MO(
                                            "LOAN_APPROVAL_LEVEL_ONE_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL1MO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L2 Delete permission
                                        /*String loanApprovalL2DeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_TWO_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL2MO(
                                            "LOAN_APPROVAL_LEVEL_TWO_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL2MO("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L3 Delete permission
                                        /*String loanApprovalL3DeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_THREE_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL3MO(
                                            "LOAN_APPROVAL_LEVEL_THREE_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL3MO("0");
                                        }

                                        // ðŸŸ¢ Check if the selected profile has the OD Pending List permission
                                        /*String pendingAttendanceRequestMOL1 = (selected.profilePermission?.contains("ATT_APP_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains("ATT_APP_ONE_ADD") ==
                                            true) {
                                          shared.setPendingAttendanceReqL1MO(
                                            "1",
                                          );
                                        } else {
                                          shared.setPendingAttendanceReqL1MO(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Activate permission
                                        /*String pendingAttendanceRequestMOL2 = (selected.profilePermission?.contains("ATT_APP_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains("ATT_APP_TWO_ADD") ==
                                            true) {
                                          shared.setPendingAttendanceReqL2MO(
                                            "1",
                                          );
                                        } else {
                                          shared.setPendingAttendanceReqL2MO(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the MY Team Activate permission
                                        /* myTeamShow = (selected.profilePermission?.contains("HRIS_EMP_LIST_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "HRIS_EMP_LIST_VIEW",
                                                ) ==
                                            true) {
                                          shared.setMyTeamShow("true");
                                          shared.setMyTeamPageShow("1");
                                        } else {
                                          shared.setMyTeamShow("false");
                                          shared.setMyTeamPageShow("0");
                                        }

                                        // ðŸŸ¢ Check if the selected profile has the Exit Resignation List Activate permission
                                        // exitResignationListView = (selected.profilePermission?.contains("EXIT_RESIGN_REQUEST_LIST_VIEW") ?? false)
                                        //     ? "1"
                                        //     : "0";
                                        if (selected.profilePermission?.contains(
                                              "EXIT_RESIGN_REQUEST_LIST_VIEW",
                                            ) ==
                                            true) {
                                          shared.setExitResignationListShow(
                                            "true",
                                          );
                                          shared.setExitResignationListView(
                                            "1",
                                          );
                                        } else {
                                          shared.setExitResignationListShow(
                                            "false",
                                          );
                                          shared.setExitResignationListView(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Exit Resignation List Activate permission
                                        /*exitResignationApproveL1View = (selected.profilePermission?.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD",
                                            ) ==
                                            true) {
                                          shared
                                              .setExitResignationApproveL1View(
                                                "1",
                                              );
                                          shared
                                              .setExitResignationApproveL1Show(
                                                "true",
                                              );
                                        } else {
                                          shared
                                              .setExitResignationApproveL1View(
                                                "0",
                                              );
                                          shared
                                              .setExitResignationApproveL1Show(
                                                "false",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Exit Resignation List Activate permission
                                        /*exitResignationApproveL2View = (selected.profilePermission?.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD",
                                            ) ==
                                            true) {
                                          shared
                                              .setExitResignationApproveL2View(
                                                "1",
                                              );
                                          shared
                                              .setExitResignationApproveL2Show(
                                                "true",
                                              );
                                        } else {
                                          shared
                                              .setExitResignationApproveL2View(
                                                "0",
                                              );
                                          shared
                                              .setExitResignationApproveL2Show(
                                                "false",
                                              );
                                        }

                                        // ðŸŸ¢ Check if the selected profile has the Exit Resignation List Activate permission
                                        /* exitResignationDisApproveL1View = (selected.profilePermission?.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE",
                                            ) ==
                                            true) {
                                          shared
                                              .setExitResignationDisApproveL1View(
                                                "1",
                                              );
                                          shared
                                              .setExitResignationDisApproveL1Show(
                                                "true",
                                              );
                                        } else {
                                          shared
                                              .setExitResignationDisApproveL1View(
                                                "0",
                                              );
                                          shared
                                              .setExitResignationDisApproveL1Show(
                                                "false",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Exit Resignation List Activate permission
                                        /*exitResignationDisApproveL2View = (selected.profilePermission?.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE",
                                            ) ==
                                            true) {
                                          shared
                                              .setExitResignationDisApproveL2View(
                                                "1",
                                              );
                                          shared
                                              .setExitResignationDisApproveL2Show(
                                                "true",
                                              );
                                        } else {
                                          shared
                                              .setExitResignationDisApproveL2View(
                                                "0",
                                              );
                                          shared
                                              .setExitResignationDisApproveL2Show(
                                                "false",
                                              );
                                        }

                                        //MSS
                                        // ðŸŸ¢ Check if the selected profile has the Pending Attendance Request permission
                                        /*String pendingAttReqMSSPermValue = (selected.profilePermission?.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
                                            ) ==
                                            true) {
                                          shared
                                              .setPendingAttendanceReqMSSPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingAttendanceReqMSSPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request permission
                                        /*String leaveReqMSSPermValue =
                              ((selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_ADD") ?? false) ||
                                  (selected.profilePermission?.contains("LEAVE_APP_MYTEAM_ADD") ?? false))
                                  ? "1"
                                  : "0";*/

                                        if (selected.profilePermission
                                                    ?.contains(
                                                      "LEAVE_REQ_APPROVAL_ADD",
                                                    ) ==
                                                true ||
                                            selected.profilePermission
                                                    ?.contains(
                                                      "LEAVE_APP_MYTEAM_ADD",
                                                    ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqMSSPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingLeaveReqMSSPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L1 permission
                                        /* String leaveReqL1MSSPermValue =
                              ((selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false) ||
                                  (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false))
                                  ? "1"
                                  : "0";*/

                                        if (selected.profilePermission?.contains(
                                                  "LEVEL_ONE_LEAVE_APPROVE_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                                                ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqL1MSSPermission(
                                                "1",
                                              );
                                          shared.setLevelOne("true");
                                        } else {
                                          shared
                                              .setPendingLeaveReqL1MSSPermission(
                                                "0",
                                              );
                                          shared.setLevelOne("false");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                                        /* String leaveReqL2MSSPermValue =
                              ((selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false) ||
                                  (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false))
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                                  "LEVEL_TWO_LEAVE_APPROVE_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                                                ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqL2MSSPermission(
                                                "1",
                                              );
                                          shared.setLevelTwo("true");
                                        } else {
                                          shared
                                              .setPendingLeaveReqL2MSSPermission(
                                                "0",
                                              );
                                          shared.setLevelTwo("false");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                                        /*String othersLeaveReqMSSPermValue = (selected.profilePermission?.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "OTHERS_LEAVE_REQUEST_ADD",
                                                ) ==
                                            true) {
                                          shared.setOthersLeaveReqMSSPermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setOthersLeaveReqMSSPermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L1 permission
                                        /*String pendingClaimL1Permission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelOne("1");
                                          shared.setClaimLevelOne(
                                            "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
                                          );
                                          permissionNotifier.updatePermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setClaimLevelOne("0");
                                          shared.setClaimLevelOne("");
                                          permissionNotifier.updatePermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L2 permission
                                        /*String pendingClaimL2Permission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelTwo("1");
                                          shared.setClaimLevelTwo(
                                            "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
                                          );
                                          permissionNotifier.updatePermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setClaimLevelTwo("0");
                                          shared.setClaimLevelTwo("");
                                          permissionNotifier.updatePermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L3 permission
                                        /* String pendingClaimL3Permission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelThree("1");
                                          permissionNotifier.updatePermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setClaimLevelThree("0");
                                          permissionNotifier.updatePermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Pending List permission
                                        /*String pendingODListPermission = (selected.profilePermission?.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "MOBILE_OD_PENDING_REQ_ADD",
                                                ) ==
                                            true) {
                                          shared.setODPendingList("1");
                                        } else {
                                          shared.setODPendingList("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Activate permission
                                        /*String odActivatePermission = (selected.profilePermission?.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "MOBILE_OD_ACTIVATE_ADD",
                                                ) ==
                                            true) {
                                          shared.setODActivate("1");
                                        } else {
                                          shared.setODActivate("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Activate permission
                                        /* String loanActivatePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanPendingList("1");
                                        } else {
                                          shared.setLoanPendingList("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L1 permission
                                        /*String loanApprovalL1MSSPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_ADD"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanApprovalL1MSS(
                                            "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL1MSS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L2 permission
                                        /*String loanApprovalL2MSSPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_ADD"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_TWO_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanApprovalL2MSS(
                                            "LOAN_APPROVAL_LEVEL_TWO_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL2MSS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L3 permission
                                        /*String loanApprovalL3MSSPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_ADD"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_THREE_ADD",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalL3MSS(
                                            "LOAN_APPROVAL_LEVEL_THREE_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL3MSS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L1 Delete permission
                                        /*String loanApprovalL1MSSDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_ONE_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL1MSS(
                                            "LOAN_APPROVAL_LEVEL_ONE_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL1MSS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L2 Delete permission
                                        /*String loanApprovalL2MSSDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_TWO_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL2MSS(
                                            "LOAN_APPROVAL_LEVEL_TWO_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL2MSS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L3 Delete permission
                                        /*String loanApprovalL3MSSDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_THREE_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL3MSS(
                                            "LOAN_APPROVAL_LEVEL_THREE_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL3MSS(
                                            "0",
                                          );
                                        }

                                        // ðŸŸ¢ Check if the selected profile has the OD Pending List permission
                                        /* String pendingAttendanceRequestMSSL1 = (selected.profilePermission?.contains("ATT_APP_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains("ATT_APP_ONE_ADD") ==
                                            true) {
                                          shared.setPendingAttendanceReqL1MSS(
                                            "1",
                                          );
                                        } else {
                                          shared.setPendingAttendanceReqL1MSS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Activate permission
                                        /*String pendingAttendanceRequestMSSL2 = (selected.profilePermission?.contains("ATT_APP_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains("ATT_APP_TWO_ADD") ==
                                            true) {
                                          shared.setPendingAttendanceReqL2MSS(
                                            "1",
                                          );
                                        } else {
                                          shared.setPendingAttendanceReqL2MSS(
                                            "0",
                                          );
                                        }

                                        //USER
                                        // ðŸŸ¢ Check if the selected profile has the Pending Attendance Request permission
                                        /*String pendingAttReqUISPermValue = (selected.profilePermission?.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
                                            ) ==
                                            true) {
                                          shared
                                              .setPendingAttendanceReqUISPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingAttendanceReqUISPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request permission
                                        /* String leaveReqUISPermValue = (selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // ðŸŸ¢ Check if the selected profile has the Leave Request L1 permission
                              String leaveReqL1UISPermValue = (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
                                  ? "1"
                                  : "0";
                              // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                              String leaveReqL2UISPermValue = (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        /*String leaveReqUISPermValue =
                              ((selected.profilePermission?.contains("LEAVE_REQ_APPROVAL_ADD") ?? false) ||
                                  (selected.profilePermission?.contains("LEAVE_APP_MYTEAM_ADD") ?? false))
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                    ?.contains(
                                                      "LEAVE_REQ_APPROVAL_ADD",
                                                    ) ==
                                                true ||
                                            selected.profilePermission
                                                    ?.contains(
                                                      "LEAVE_APP_MYTEAM_ADD",
                                                    ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqUISPermission(
                                                "1",
                                              );
                                          shared.setPendingLeaveReq("true");
                                        } else {
                                          shared
                                              .setPendingLeaveReqUISPermission(
                                                "0",
                                              );
                                          shared.setPendingLeaveReq("false");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L1 permission
                                        /* String leaveReqL1UISPermValue =
                              ((selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false) ||
                                  (selected.profilePermission?.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false))
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                                  "LEVEL_ONE_LEAVE_APPROVE_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                                                ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqL1UISPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingLeaveReqL1UISPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                                        /*String leaveReqL2UISPermValue =
                              ((selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false) ||
                                  (selected.profilePermission?.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false))
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                                  "LEVEL_TWO_LEAVE_APPROVE_ADD",
                                                ) ==
                                                true ||
                                            selected.profilePermission?.contains(
                                                  "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                                                ) ==
                                                true) {
                                          shared
                                              .setPendingLeaveReqL2UISPermission(
                                                "1",
                                              );
                                        } else {
                                          shared
                                              .setPendingLeaveReqL2UISPermission(
                                                "0",
                                              );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Leave Request L2 permission
                                        /*  String othersLeaveReqUISPermValue = (selected.profilePermission?.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "OTHERS_LEAVE_REQUEST_ADD",
                                                ) ==
                                            true) {
                                          shared.setOthersLeaveReqUISPermission(
                                            "1",
                                          );
                                        } else {
                                          shared.setOthersLeaveReqUISPermission(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L1 permission
                                        /*String pendingClaimL1UISPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelOneUIS("1");
                                          shared.setClaimLevelOne(
                                            "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
                                          );
                                        } else {
                                          shared.setClaimLevelOneUIS("0");
                                          shared.setClaimLevelOne("");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L2 permission
                                        /*String pendingClaimL2UISPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelTwoUIS("1");
                                          shared.setClaimLevelTwo(
                                            "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
                                          );
                                        } else {
                                          shared.setClaimLevelTwoUIS("0");
                                          shared.setClaimLevelTwo("");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Claim L3 permission
                                        /*String pendingClaimL3UISPermission = (selected.profilePermission?.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
                                            ) ==
                                            true) {
                                          shared.setClaimLevelThreeUIS("1");
                                          shared.setClaimLevelThree(
                                            "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
                                          );
                                        } else {
                                          shared.setClaimLevelThreeUIS("0");
                                          shared.setClaimLevelThree("");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Pending List permission
                                        /*String pendingODListUISPermission = (selected.profilePermission?.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "MOBILE_OD_PENDING_REQ_ADD",
                                                ) ==
                                            true) {
                                          shared.setODPendingListUIS("1");
                                        } else {
                                          shared.setODPendingListUIS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Activate permission
                                        /*String odActivateUISPermission = (selected.profilePermission?.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "MOBILE_OD_ACTIVATE_ADD",
                                                ) ==
                                            true) {
                                          shared.setODActivateUIS("1");
                                        } else {
                                          shared.setODActivateUIS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Activate permission
                                        /*String loanActivateUISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanPendingListUIS("1");
                                        } else {
                                          shared.setLoanPendingListUIS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L1 permission
                                        /*String loanApprovalL1UISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_ADD"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanApprovalL1UIS(
                                            "LOAN_APPROVAL_LEVEL_ONE_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL1UIS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L2 permission
                                        /*String loanApprovalL2UISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_ADD"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains(
                                                  "LOAN_APPROVAL_LEVEL_TWO_ADD",
                                                ) ==
                                            true) {
                                          shared.setLoanApprovalL2UIS(
                                            "LOAN_APPROVAL_LEVEL_TWO_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL2UIS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L3 permission
                                        /*String loanApprovalL3UISPermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_ADD") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_ADD"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_THREE_ADD",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalL3UIS(
                                            "LOAN_APPROVAL_LEVEL_THREE_ADD",
                                          );
                                        } else {
                                          shared.setLoanApprovalL3UIS("0");
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L1 Delete permission
                                        /*String loanApprovalL1UISDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_ONE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_ONE_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_ONE_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL1UIS(
                                            "LOAN_APPROVAL_LEVEL_ONE_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL1UIS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L2 Delete permission
                                        /*String loanApprovalL2UISDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_TWO_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_TWO_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_TWO_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL2UIS(
                                            "LOAN_APPROVAL_LEVEL_TWO_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL2UIS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the Loan Approval L3 Delete permission
                                        /*String loanApprovalL3UISDeletePermission = (selected.profilePermission?.contains("LOAN_APPROVAL_LEVEL_THREE_DELETE") ?? false)
                                  ? "LOAN_APPROVAL_LEVEL_THREE_DELETE"
                                  : "0";*/
                                        if (selected.profilePermission?.contains(
                                              "LOAN_APPROVAL_LEVEL_THREE_DELETE",
                                            ) ==
                                            true) {
                                          shared.setLoanApprovalDeleteL3UIS(
                                            "LOAN_APPROVAL_LEVEL_THREE_DELETE",
                                          );
                                        } else {
                                          shared.setLoanApprovalDeleteL3UIS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Pending List permission
                                        /*String pendingAttendanceRequestUISL1 = (selected.profilePermission?.contains("ATT_APP_ONE_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains("ATT_APP_ONE_ADD") ==
                                            true) {
                                          shared.setPendingAttendanceReqL1UIS(
                                            "1",
                                          );
                                        } else {
                                          shared.setPendingAttendanceReqL1UIS(
                                            "0",
                                          );
                                        }
                                        // ðŸŸ¢ Check if the selected profile has the OD Activate permission
                                        /*String pendingAttendanceRequestUISL2 = (selected.profilePermission?.contains("ATT_APP_TWO_ADD") ?? false)
                                  ? "1"
                                  : "0";*/
                                        if (selected.profilePermission
                                                ?.contains("ATT_APP_TWO_ADD") ==
                                            true) {
                                          shared.setPendingAttendanceReqL2UIS(
                                            "1",
                                          );
                                        } else {
                                          shared.setPendingAttendanceReqL2UIS(
                                            "0",
                                          );
                                        }

                                        // ðŸŸ¢ Save the MSS MO permission to SharedPreferences
                                        /*await shared.setPendingAttendanceReqMSSMOPermission(pendingAttReqMOPermValue);
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
                              shared.setExitResignationListView(exitResignationListView);
                              shared.setExitResignationApproveL1View(exitResignationApproveL1View);
                              shared.setExitResignationApproveL2View(exitResignationApproveL2View);
                              shared.setExitResignationDisApproveL1View(exitResignationDisApproveL1View);
                              shared.setExitResignationDisApproveL2View(exitResignationDisApproveL2View);
                              print("âœ… Attendance Permission for profileId $selectedProfileId: $pendingAttReqMOPermValue");
                              print("âœ… Leave Permission for profileId $selectedProfileId: $leaveReqMOPermValue");
                              print("âœ… Leave L1 Permission for profileId $selectedProfileId: $leaveReqL1MOPermValue");
                              print("âœ… Leave L2 Permission for profileId $selectedProfileId: $leaveReqL2MOPermValue");
                              print("âœ… Others Leave Permission for profileId $selectedProfileId: $othersLeaveReqMOPermValue");
                              print("âœ… Claim L1 Permission for profileId $selectedProfileId: $pendingClaimL1MOPermission");
                              print("âœ… Claim L2 Permission for profileId $selectedProfileId: $pendingClaimL2MOPermission");
                              print("âœ… Claim L3 Permission for profileId $selectedProfileId: $pendingClaimL3MOPermission");
                              print("âœ… OD Activate Permission for profileId $selectedProfileId: $odActivateMOPermission");
                              print("âœ… Pending OD Permission for profileId $selectedProfileId: $pendingODListMOPermission");
                              print("âœ… Loan Activate Permission for profileId $selectedProfileId: $loanActivateMOPermission");
                              print("âœ… Loan Approval L1 Permission for profileId $selectedProfileId: $loanApprovalL1Permission");
                              print("âœ… Loan Approval L2 Permission for profileId $selectedProfileId: $loanApprovalL2Permission");
                              print("âœ… Loan Approval L3 Permission for profileId $selectedProfileId: $loanApprovalL3Permission");
                              print("âœ… Loan Approval L1 Delete Permission for profileId $selectedProfileId: $loanApprovalL1DeletePermission");
                              print("âœ… Loan Approval L2 Delete Permission for profileId $selectedProfileId: $loanApprovalL2DeletePermission");
                              print("âœ… Loan Approval L3 Delete Permission for profileId $selectedProfileId: $loanApprovalL3DeletePermission");
                              print("âœ… Pending Attendance L1 MO Permission for profileId $selectedProfileId: $pendingAttendanceRequestMOL1");
                              print("âœ… Pending Attendance L2 MO Permission for profileId $selectedProfileId: $pendingAttendanceRequestMOL2");
                              print("âœ… My Team MO Permission for profileId $selectedProfileId: $myTeamShow");
                              print("âœ… Exit Resignation List Permission for profileId $selectedProfileId: $exitResignationListView");
                              print("âœ… Exit Resignation Approve L1 Permission for profileId $selectedProfileId: $exitResignationApproveL1View");
                              print("âœ… Exit Resignation Approve L2 Permission for profileId $selectedProfileId: $exitResignationApproveL2View");
                              print("âœ… Exit Resignation Disapprove L1 Permission for profileId $selectedProfileId: $exitResignationDisApproveL1View");
                              print("âœ… Exit Resignation Disapprove L2 Permission for profileId $selectedProfileId: $exitResignationDisApproveL2View");

                              // ðŸŸ¢ Save the MSS permission to SharedPreferences
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
                              print("âœ… Attendance Permission for profileId $selectedProfileId: $pendingAttReqMSSPermValue");
                              print("âœ… Leave Permission for profileId $selectedProfileId: $leaveReqMSSPermValue");
                              print("âœ… Leave L1 Permission for profileId $selectedProfileId: $leaveReqL1MSSPermValue");
                              print("âœ… Leave L2 Permission for profileId $selectedProfileId: $leaveReqL2MSSPermValue");
                              print("âœ… Others Leave Permission for profileId $selectedProfileId: $othersLeaveReqMSSPermValue");
                              print("âœ… Claim L1 Permission for profileId $selectedProfileId: $pendingClaimL1Permission");
                              print("âœ… Claim L2 Permission for profileId $selectedProfileId: $pendingClaimL2Permission");
                              print("âœ… Claim L3 Permission for profileId $selectedProfileId: $pendingClaimL3Permission");
                              print("âœ… OD Activate Permission for profileId $selectedProfileId: $odActivatePermission");
                              print("âœ… Pending OD List Permission for profileId $selectedProfileId: $pendingODListPermission");
                              print("âœ… Loan Activate Permission for profileId $selectedProfileId: $loanActivatePermission");
                              print("âœ… Loan Approval L1 Permission for profileId $selectedProfileId: $loanApprovalL1MSSPermission");
                              print("âœ… Loan Approval L2 Permission for profileId $selectedProfileId: $loanApprovalL2MSSPermission");
                              print("âœ… Loan Approval L3 Permission for profileId $selectedProfileId: $loanApprovalL3MSSPermission");
                              print("âœ… Loan Approval L1 Delete Permission for profileId $selectedProfileId: $loanApprovalL1MSSDeletePermission");
                              print("âœ… Loan Approval L2 Delete Permission for profileId $selectedProfileId: $loanApprovalL2MSSDeletePermission");
                              print("âœ… Loan Approval L3 Delete Permission for profileId $selectedProfileId: $loanApprovalL3MSSDeletePermission");
                              print("âœ… Pending Attendance L1 MSS Permission for profileId $selectedProfileId: $pendingAttendanceRequestMSSL1");
                              print("âœ… Pending Attendance L2 MSS Permission for profileId $selectedProfileId: $pendingAttendanceRequestMSSL2");
                              // Notify global listener
                              permissionNotifier.updatePermission(pendingClaimL1Permission);
                              permissionNotifier.updatePermission(pendingClaimL2Permission);
                              permissionNotifier.updatePermission(pendingClaimL3Permission);
                              permissionNotifier.updatePermission(pendingClaimL1MOPermission);
                              permissionNotifier.updatePermission(pendingClaimL2MOPermission);
                              permissionNotifier.updatePermission(pendingClaimL3MOPermission);
                              // ðŸŸ¢ Save the UIS permission to SharedPreferences
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
                              print("âœ… Attendance Permission for profileId $selectedProfileId: $pendingAttReqUISPermValue");
                              print("âœ… Leave Permission for profileId $selectedProfileId: $leaveReqUISPermValue");
                              print("âœ… Leave L1 Permission for profileId $selectedProfileId: $leaveReqL1UISPermValue");
                              print("âœ… Leave L2 Permission for profileId $selectedProfileId: $leaveReqL2UISPermValue");
                              print("âœ… Others Leave Permission for profileId $selectedProfileId: $othersLeaveReqUISPermValue");
                              print("âœ… Claim L1 Permission for profileId $selectedProfileId: $pendingClaimL1UISPermission");
                              print("âœ… Claim L2 Permission for profileId $selectedProfileId: $pendingClaimL2UISPermission");
                              print("âœ… Claim L3 Permission for profileId $selectedProfileId: $pendingClaimL3UISPermission");
                              print("âœ… OD Activate Permission for profileId $selectedProfileId: $odActivateUISPermission");
                              print("âœ… Pending OD List Permission for profileId $selectedProfileId: $pendingODListUISPermission");
                              print("âœ… Loan Approval L1 Permission for profileId $selectedProfileId: $loanApprovalL1UISPermission");
                              print("âœ… Loan Approval L2 Permission for profileId $selectedProfileId: $loanApprovalL2UISPermission");
                              print("âœ… Loan Approval L3 Permission for profileId $selectedProfileId: $loanApprovalL3UISPermission");
                              print("âœ… Loan Approval L1 Delete Permission for profileId $selectedProfileId: $loanApprovalL1UISDeletePermission");
                              print("âœ… Loan Approval L2 Delete Permission for profileId $selectedProfileId: $loanApprovalL2UISDeletePermission");
                              print("âœ… Loan Approval L3 Delete Permission for profileId $selectedProfileId: $loanApprovalL3UISDeletePermission");
                              print("âœ… Pending Attendance L1 UIS Permission for profileId $selectedProfileId: $pendingAttendanceRequestUISL1");
                              print("âœ… Pending Attendance L2 UIS Permission for profileId $selectedProfileId: $pendingAttendanceRequestUISL2");*/
                                        // ðŸŸ¢ Save selected profile details
                                        try {
                                          await MobilePanelService.activateProfile(
                                            selected,
                                          );
                                        } catch (error) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Unable to change profile.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        activePanel =
                                            MobilePanel.fromProfileType(
                                              selected.profileType,
                                            );
                                        userPanelPermission =
                                            MobilePanel.userPermissionFor(
                                              activePanel,
                                            );

                                        selectedProfileIdNotifier.value =
                                            selectedProfileId!;
                                        selectedProfileNameNotifier.value =
                                            selectedProfileName!;
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    HomePage(selectedIndex: 1),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                            );
                          },
                        ),
              ),
            ],
          ),
          // ðŸ”½ Bottom section (Settings)
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
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.security_update_good_outlined,
                  color: Mythemes.black,
                ),
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
                    MaterialPageRoute(
                      builder: (context) => CompanyPoliciesPage(),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
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
