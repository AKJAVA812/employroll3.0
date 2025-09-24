import 'dart:io';
import 'package:er_flutter_project/MSS_Bundle/dashboard/mssDashboard.dart';
import 'package:er_flutter_project/MSS_Bundle/hris/fnfListMSS.dart';
import 'package:er_flutter_project/MSS_Bundle/hris/inactiveListMSS.dart';
import 'package:er_flutter_project/MSS_Bundle/incidentReporting/incidentReportingPage.dart';
import 'package:er_flutter_project/adminPage/adminPanelScreen.dart';
import 'package:er_flutter_project/ess/loan&Advance/myLoanRequestList.dart';
import 'package:er_flutter_project/firebasePushNotification/firebase_api.dart';
import 'package:er_flutter_project/firebase_options.dart';
import 'package:er_flutter_project/settings/checkForUpdates.dart';
import 'package:er_flutter_project/settings/companyPolicyList.dart';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordEmail.dart';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordNewCreation.dart';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordOtp.dart';
import 'package:er_flutter_project/singUP/resetPassword/resetPasswordPage.dart';
import 'package:er_flutter_project/tracking/geolocator/GeolocatorTracking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:er_flutter_project/adminPage/modelClass/dashboardModel.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/punchInUploadPage.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/workDonePage.dart';
import 'package:er_flutter_project/employeePage/employeeListPage.dart';
import 'package:er_flutter_project/employeePage/mapView.dart';
import 'package:er_flutter_project/ess/coustomCalender/customCalender.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/mss/claimMssItems.dart';
import 'package:er_flutter_project/modules/helpDesk/helpdeskItem/helpdeskItem.dart';
import 'package:er_flutter_project/modules/leaveManagement/reports/leaveManageReport.dart';
import 'package:er_flutter_project/modules/loanAndAdvance/reports/loanAdvanceReport.dart';
import 'package:er_flutter_project/modules/onDuty/reports/onDutyReport.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attReportDateSelection.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceReport.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/attendanceList.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/timeAndAttReports.dart';
import 'package:er_flutter_project/profiles/profilePage.dart';
import 'package:er_flutter_project/profiles/profilePageWithHead.dart';
import 'package:er_flutter_project/reports/reportPage.dart';
import 'package:er_flutter_project/reports/reportPageHead.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:er_flutter_project/tracking/trackingMain.dart';
import 'package:er_flutter_project/widgets/expendableList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';
/*import 'ESS_Bundle/timeAndAttendance/reports/attendanceRequisition/attendanceList.dart';
import 'ESS_Bundle/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';*/
import 'EZNew/landingPage.dart';
import 'MSS_Bundle/dashboard/adminDashboard.dart';
import 'MSS_Bundle/incidentReporting/incidentReportList.dart';
import 'MSS_Bundle/leaveManagement/levelOneLeaveReq.dart';
import 'MSS_Bundle/leaveManagement/levelTwoLeaveReq.dart';
import 'MSS_Bundle/leaveManagement/othersEmpRequisition.dart';
import 'MSS_Bundle/leaveManagement/pendingRequisitionList.dart';
import 'MSS_Bundle/loans&Advance/loanApprovalPage.dart';
import 'MSS_Bundle/loans&Advance/pendingLoanRequestList.dart';
import 'MSS_Bundle/reports/RoWorkDoneReportFiltering.dart' as mss;
import 'MSS_Bundle/timeAndAttendance/mssAttendanceApprovalListL1.dart';
import 'MSS_Bundle/timeAndAttendance/mssAttendanceApprovalListL2.dart';
import 'MSS_Bundle/timeAndAttendance/mssAttendanceApprovalListL3.dart';
import 'MSS_Bundle/timeAndAttendance/otherEmpRequisitionAttendance.dart';
import 'MSS_Bundle/timeAndAttendance/outDuty/pendingRequisitionList.dart';
import 'MSS_Bundle/timeAndAttendance/pendingReqListRo.dart';
import 'MSS_Bundle/travelAndExpense/claimMssItems.dart';
import 'MSS_MO_Bundle/dashboard/adminDashboard.dart';
import 'MSS_MO_Bundle/dashboard/mssDashboard.dart';
import 'MSS_MO_Bundle/exitProcess/exitListMO.dart';
import 'MSS_MO_Bundle/leaveManagement/levelOneLeaveReq.dart';
import 'MSS_MO_Bundle/leaveManagement/levelTwoLeaveReq.dart';
import 'MSS_MO_Bundle/leaveManagement/othersEmpRequisition.dart';
import 'MSS_MO_Bundle/leaveManagement/pendingRequisitionList.dart';
import 'MSS_MO_Bundle/loans&Advance/pendingLoanRequestList.dart';
import 'MSS_MO_Bundle/myTeam/myTeams.dart';
import 'MSS_MO_Bundle/reports/RoWorkDoneReportFiltering.dart';
import 'MSS_MO_Bundle/timeAndAttendance/mssMoAttendanceApprovalListL1.dart';
import 'MSS_MO_Bundle/timeAndAttendance/mssMoAttendanceApprovalListL2.dart';
import 'MSS_MO_Bundle/timeAndAttendance/otherEmpRequisitionAttendance.dart';
import 'MSS_MO_Bundle/timeAndAttendance/outDuty/pendingRequisitionList.dart';
import 'MSS_MO_Bundle/timeAndAttendance/pendingReqListRo.dart';
import 'MSS_MO_Bundle/travelAndExpense/claimMssItems.dart';
import 'UIS_Bundle/dashboard/adminDashboard.dart';
import 'UIS_Bundle/dashboard/mssDashboard.dart';
import 'UIS_Bundle/leaveManagement/levelOneLeaveReq.dart';
import 'UIS_Bundle/leaveManagement/levelTwoLeaveReq.dart';
import 'UIS_Bundle/leaveManagement/othersEmpRequisition.dart';
import 'UIS_Bundle/leaveManagement/pendingRequisitionList.dart';
import 'UIS_Bundle/reports/RoWorkDoneReportFiltering.dart';
import 'UIS_Bundle/timeAndAttendance/otherEmpRequisitionAttendance.dart';
import 'UIS_Bundle/timeAndAttendance/outDuty/pendingRequisitionList.dart';
import 'UIS_Bundle/timeAndAttendance/pendingReqListRo.dart';
import 'UIS_Bundle/travelAndExpense/claimMssItems.dart';
import 'adminPage/adminDashboard/adminDashboard.dart';
import 'adminPage/adminDashboard/adminPanelDashboard.dart';
import 'adminPage/mssDashboard.dart';
import 'alarmClock/alarmRing.dart';
import 'cameraImplement/cameraImplement.dart';
import 'commanScreen/accountSuspend.dart';
import 'commanScreen/digiWeighWorkDone.dart';
import 'commanScreen/digiWeighWorkDone2.dart';
import 'commanScreen/homePage.dart';
import 'commanScreen/realTimeLocation.dart';
import 'commanScreen/ujalaCreditWorkdone.dart';
import 'commanScreen/ujalaWorkDone2.dart';
import 'ess/EssDashboarrddModel.dart';
import 'ess/MyReportingOfficers.dart';
import 'ess/essDashboard.dart';
import 'ess/essDashboardNavigate.dart';
import 'ess/loan&Advance/myLoanLedger.dart';
import 'ess/loan&Advance/myLoanRequestRaisePage.dart';
import 'ess/loan&Advance/myLoanSummary.dart';
import 'ess/myAllReports.dart';
import 'ess/myAllRequestsPage.dart';
import 'ess/realtimeESSDashboard.dart';
import 'ess/time&Attendance/essAttendanceApprovedList.dart';
import 'faceRecognizationAttendance/FaceRecognitionHome.dart';
import 'faceRecognizationAttendance/attendancMarkAi.dart';
import 'faceRecognizationAttendance/empListFaceRegistered.dart';
import 'faceRecognizationAttendance/faceRecognizeEmployeeList.dart';
import 'modules/Meal_Scanner/Meal_Scan.dart';
import 'modules/claimAndReimbursement/claimAdvance/claimAdvanceList.dart';
import 'modules/claimAndReimbursement/claimItems/addExpense/addExpensePage.dart';
import 'modules/claimAndReimbursement/claimItems/addExpense/expenseList.dart';
import 'modules/claimAndReimbursement/claimItems/addExpense/expenseListDelete.dart';
import 'modules/claimAndReimbursement/claimItems/advanceRequisition/advanceRequisitionList.dart';
import 'modules/claimAndReimbursement/claimItems/advanceRequisition/advanceRequisitionPage.dart';
import 'modules/claimAndReimbursement/claimItems/approvalDisListReimbursement/approvalDisappListReimb.dart';
import 'modules/claimAndReimbursement/claimItems/approveDisAdvanceList/approveDisappAdvanceList.dart';
import 'modules/claimAndReimbursement/claimItems/claimItemsList.dart';
import 'modules/claimAndReimbursement/claimItems/claimRequisitionList.dart';
import 'modules/claimAndReimbursement/claimItems/modalClass/advanceRequisitionListModal.dart';
import 'modules/claimAndReimbursement/claimItems/modalClass/appDisAdvListModal.dart';
import 'modules/claimAndReimbursement/claimItems/modalClass/appDisReimbListModal.dart';
import 'modules/claimAndReimbursement/claimItems/modalClass/expensesListModal.dart';
import 'modules/claimAndReimbursement/claimItems/modalClass/pendingAdvanceReqListModal.dart';
import 'modules/claimAndReimbursement/claimItems/modalClass/pendingReimbListModal.dart';
import 'modules/claimAndReimbursement/claimItems/pendingAdvanceReq/pendingAdvReqAppDis.dart';
import 'modules/claimAndReimbursement/claimItems/pendingAdvanceReq/pendingAdvanceReqList.dart';
import 'modules/claimAndReimbursement/claimItems/pendingReimbursment/approveDisReimbursement.dart';
import 'modules/claimAndReimbursement/claimItems/pendingReimbursment/pendingList.dart';
import 'modules/claimAndReimbursement/claimItems/travelExpenseAdd/travelExpenseRequestRaise.dart';
import 'modules/documentsAdded/documentsAdded.dart';
import 'modules/documentsAdded/downloadLetter.dart';
import 'modules/exitManagement/exitEmployeeList.dart';
import 'modules/exitManagement/exitList.dart';
import 'modules/exitManagement/exitWorkflow.dart';
import 'modules/helpDesk/helpdeskItem/hdCancelledTicket.dart';
import 'modules/helpDesk/helpdeskItem/hdDueTodayTickets.dart';
import 'modules/helpDesk/helpdeskItem/hdNewTickets.dart';
import 'modules/helpDesk/helpdeskItem/hdOnHoldTickets.dart';
import 'modules/helpDesk/helpdeskItem/hdOpenTickets.dart';
import 'modules/helpDesk/helpdeskItem/hdOverdueTickets.dart';
import 'modules/helpDesk/helpdeskItem/hdRaisedTicketReply.dart';
import 'modules/helpDesk/helpdeskItem/hdReOpenTicket.dart';
import 'modules/helpDesk/helpdeskItem/hdResolvedTicket.dart';
import 'modules/hris/hrisDetails.dart';
import 'modules/inductionOnboarding/inductionOnboarding.dart';
import 'modules/inductionOnboarding/onboardingList.dart';
import 'modules/leaveManagement/reports/approvedReqList/approvedLeaveReqModal.dart';
import 'modules/leaveManagement/reports/approvedReqList/roApprovedReqList.dart';
import 'modules/leaveManagement/reports/leaveBalance/leaveBalancePage.dart';
import 'modules/leaveManagement/reports/leaveRequisition/leaveRequisitionPage.dart';
import 'modules/leaveManagement/reports/levelOneLeaveReq.dart';
import 'modules/leaveManagement/reports/levelOnePendingApproval.dart';
import 'modules/leaveManagement/reports/levelTwoLeaveReq.dart';
import 'modules/leaveManagement/reports/modalClass/levelOnePendingLeaveModal.dart';
import 'modules/leaveManagement/reports/modalClass/levelTwoPendingLeaveModal.dart';
import 'modules/leaveManagement/reports/modalClass/pendingLeaveRequisitionModal.dart';
import 'modules/leaveManagement/reports/modalClass/selfLeaveRequisitionModal.dart';
import 'modules/leaveManagement/reports/othersAttendanceList.dart';
import 'modules/leaveManagement/reports/othersRequisition/appDisLeaveRequisition.dart';
import 'modules/leaveManagement/reports/othersRequisition/othersEmpReqList.dart';
import 'modules/leaveManagement/reports/othersRequisition/othersEmpRequisition.dart';
import 'modules/leaveManagement/reports/pendingRequisition/pendingLeaveApprovalDis.dart';
import 'modules/leaveManagement/reports/pendingRequisition/pendingRequisitionList.dart';
import 'modules/leaveManagement/reports/requestedRequisition/requestedRequisitionList.dart';
import 'modules/loanAndAdvance/reports/loanApprovedReqList/loanApprovedReqList.dart';
import 'modules/loanAndAdvance/reports/loanRequest/loanRequestPage.dart';
import 'modules/loanAndAdvance/reports/loanRequestedList/loanRequestedList.dart';
import 'modules/loanAndAdvance/reports/modalClass/loanAdvanceReqModal.dart';
import 'modules/loanAndAdvance/reports/modalClass/loanApprovedListModal.dart';
import 'modules/onDuty/reports/odLocation/odLocationPage.dart';
import 'modules/onDuty/reports/odLocation/odWorkDonePage.dart';
import 'modules/onDuty/reports/odRequisition/odAttendanceList.dart';
import 'modules/onDuty/reports/odRequisition/odRequisitionGetDet.dart';
import 'modules/onDuty/reports/odRequisition/odRequisitionPage.dart';
import 'modules/onDuty/reports/onDutyTypes.dart';
import 'modules/onDuty/reports/pendingRequisition/modalClass/pendingOdReqList.dart';
import 'modules/onDuty/reports/pendingRequisition/odAttendanceApproval.dart';
import 'modules/onDuty/reports/pendingRequisition/pendingRequisitionList.dart';
import 'modules/onDuty/reports/selfRequisition/selfOdReqDateSelect.dart';
import 'modules/onDuty/reports/selfRequisition/selfOdRequisitionList.dart';
import 'modules/payroll/payrollItems.dart';
import 'modules/payroll/salarySlip/salarySlipDownload.dart';
import 'modules/preInductionOnboarding/ApprovePreOnboarding.dart';
import 'modules/preInductionOnboarding/pendingPreOnboardingList.dart';
import 'modules/preInductionOnboarding/preInductionList.dart';
import 'modules/preInductionOnboarding/preInductionProcess.dart';
import 'modules/preInductionOnboarding/preOnboardingItems.dart';
import 'modules/projectManagement/projectItems/projectItemsList.dart';
import 'modules/qrBasedAttendance/qrAttendanceItems/qrAttItems.dart';
import 'modules/qrBasedAttendance/qrAttendanceItems/qrAttendanceWithLocation/qrAttWithLocation.dart';
import 'modules/qrBasedAttendance/qrAttendanceItems/qrAttendanceWithoutLocation/qrAttWithoutLocation.dart';
import 'modules/timeAndAttendance/calendarPage/attendanceRequetCalendar.dart';
import 'modules/timeAndAttendance/reports/approvedRequisition/approvedRequisitionList.dart';
import 'modules/timeAndAttendance/reports/approvedRequisition/approvedRequisitionModel.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/attendanceRequisition.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/model/onDateReportModel.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/othersAttendanceRequisitionPage.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/othersOnDateAttendanceModal.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/othersSingleDateAttendance.dart';
import 'modules/timeAndAttendance/reports/attendanceRequisition/singleDateAttendance.dart';
import 'modules/timeAndAttendance/reports/disapprovedRequisition/disApprovedRequisitionModel.dart';
import 'modules/timeAndAttendance/reports/disapprovedRequisition/disapprovedRequisition.dart';
import 'modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';
import 'modules/timeAndAttendance/reports/modelClass/pendingRequisitionModel.dart';
import 'modules/timeAndAttendance/reports/modelClass/selfRequisitionModel.dart';
import 'modules/timeAndAttendance/reports/otherEmpRequisitionAttendance.dart';
import 'modules/timeAndAttendance/reports/pendingRequisition/pendingReqAppDiss.dart';
import 'modules/timeAndAttendance/reports/pendingRequisition/pendingReqListRo.dart';
import 'modules/timeAndAttendance/reports/pendingRequisition/selfRequisition.dart';
import 'modules/timeAndAttendance/reports/workDoneReport/RoWorkDoneReportFiltering.dart' as taa;
import 'modules/timeAndAttendance/reports/workDoneReport/roWorkDoneReport.dart';
import 'modules/timeAndAttendance/reports/workDoneReport/workDoneReport.dart';
import 'modules/timeAndAttendance/reports/workDoneReport/workDoneReportDateSelect.dart';
import 'modules/visitorManagement/visitorMgntSections.dart';
import 'ocr/ocr.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
const String taskName = "background_location_task";
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    final Location location = Location();


    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      return Future.value(false);
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return Future.value(false);
    }
    if(permissionGranted==PermissionStatus.deniedForever){
      openAppSettingsDialog();
      return false;
    }

    LocationData? currentLocation = await location.getLocation();
    print("Background Location: ${currentLocation.latitude}, ${currentLocation.longitude}");

    return Future.value(true);
  });
}*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  final notificationService = NotificationService();
  await notificationService.initFCM();
  _requestPermission();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  //await initializeService();
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  //iOS-specific initialization settings with permission requests
  final iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  InitializationSettings initializationSettings =
  InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosInitializationSettings
  );



  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //await Firebase.initializeApp();
  //await FirebaseApi().initNotifications();
  //await setupNotificationChannel();
  // Add try-catch to handle initialization errors
  /*try {
    await FlutterDownloader.initialize(
      debug: true, // Set to false for production
    );
  } catch (e) {
    print('Error initializing FlutterDownloader: $e');
  }*/
/*  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask(
    "1",
    taskName,
    frequency: Duration(minutes: 10), // Runs every 10 minutes
  );*/

  runApp(const MyApp());
}

/*void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}*/

/// Requests notification permission from the user
Future<void> _requestPermission() async {
  // Request permission for alerts, badges, and sounds
  final result = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Log the user's permission decision
  print('User granted permission: ${result.authorizationStatus}');
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
             // openAppSettings();
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/*Future<void> setupNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'location_updates_channel', // Channel ID (must be unique)
    'Location Updates', // Channel Name
    description: 'Used for  tracking location in background', // Description
    importance: Importance.high, // Importance level
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}*/

double? latitude;
double? longitude;
String stringResponse = "";
SessionManager shared = SessionManager();
String? sessionId;
LatLng? currentPostion;

class MyApp extends StatelessWidget {
  static var navigatorKey;

  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Employroll",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // Add other locales as needed
        const Locale('es', 'ES'), // Example of another locale (Spanish)
      ],
      themeMode: ThemeMode.light,
      theme:Mythemes.lightTheme(context),
      darkTheme: Mythemes.darkTheme(context),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, 
    required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  //_LocationTrackingScreenState createState() => _LocationTrackingScreenState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Location _location = Location();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;



  @override
  void initState() {
    getSharedPrfanceList();
    _determinePosition();
    _getUserLocation();
    //requestPermission();
    //_startLocationTracking();
    //requestStoragePermission();
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in foreground: ${message.notification?.title}');

      // Show local notification
      if (message.notification != null) {
        _showNotification(message.notification!);
      }
    });
    super.initState();
  }
  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel', // id
      'General Notifications', // title
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

/*  Future<void> _startLocationTracking() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    await _location.enableBackgroundMode(enable: true);

    _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
      print("Foreground Location: ${locationData.latitude}, ${locationData.longitude}");
    });
  }*/

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      openAppSettings();
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
        openAppSettings();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      openAppSettings();
      return Future.error(

          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _getUserLocation() async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    var lastPosition = await Geolocator.getLastKnownPosition();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    //print('Response1111l $lastPosition');

    setState(() {
      if (position != null) {
        currentPostion = LatLng(position!.latitude, position!.longitude);
        shared.setLatitude(position!.latitude);
        shared.setLongitude(position!.longitude);
        //print('Response1111c $currentAddress');
      } else {
        showAboutDialog(context: this.context);
      }
    });
    positionCheck = await GeolocatorPlatform.instance.getCurrentPosition();
    var lastPositionCheck = await Geolocator.getLastKnownPosition();
    bool isLocationServiceEnabledCheck = await Geolocator.isLocationServiceEnabled();
    //print('Response1111l $lastPosition');

    setState(() {
      if (positionCheck != null) {
        currentPostion = LatLng(positionCheck!.latitude, positionCheck!.longitude);
        shared.setLatitude(positionCheck!.latitude);
        shared.setLongitude(positionCheck!.longitude);
        //print('Response1111c $currentAddress');
      } else {
        showAboutDialog(context: this.context);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return UpgradeAlert(
      barrierDismissible: true,
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        title: "Employroll",
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // Add other locales as needed
          const Locale('es', 'ES'), // Example of another locale (Spanish)
        ],
        themeMode: ThemeMode.light,
        theme:Mythemes.lightTheme(context),
        darkTheme: Mythemes.darkTheme(context),
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        //initialRoute: sessionId == null || sessionId == "" ? MyRoutings.loginRoute:MyRoutings.punchInRoute,
        //initialRoute: MyRoutings.loginRoute,
        initialRoute: MyRoutings.loginRoute,
        routes: {
          MyRoutings.customCalender:(context)=>customCalender(),
          MyRoutings.loginRoute: (context) => LoginPage(),
          MyRoutings.punchInRoute: (context) => PunchInOUtActivity(),
          MyRoutings.reportSection: (context) => ReportPage(),
          MyRoutings.reportSectionHead: (context) => ReportPageHead(),
          MyRoutings.homePageRoute: (context) => HomePage(),
          MyRoutings.adminPanelRoute: (context) => AdminPanelScreen(),
          MyRoutings.adminPanelDashRoute: (context) => AdminPanelDashboard(DashboardModel()),
          MyRoutings.projectListRoute: (context) => ProjectList(),
          MyRoutings.mapViewRoute: (context) => HistoryMapView('',0),
          MyRoutings.expendableListRoute: (context) => TileApp(),
          MyRoutings.imageUploadRoute: (context) => ImageUploaded(value:File("path"), address: " ", time: " ",punchType: " "),
          MyRoutings.empListRoute: (context) => EmpListView(),
          MyRoutings.workDoneRoute: (context) => WorkDonePage(value:File("path"), address: " ", time: " "),
          MyRoutings.profileRoute: (context) => ProfilePage(),
          MyRoutings.timeAttRoute: (context) => TimeAndAttendanceReports(),
          MyRoutings.attReportRoute: (context) => AttReport(),
          MyRoutings.leaveManageReportRoute: (context) => LeaveManageReports(),
          MyRoutings.loanAdvanceRoute: (context) => LoanAdvanceReport(),
          MyRoutings.onDutyReportRoute: (context) => OnDutyReports(),
          MyRoutings.helpDeskItemsRoute: (context) => HelpDeskItems(),
          MyRoutings.attendanceReportRoute: (context) => AttendanceReport(forDateString: " ",toDateString: " "),
          MyRoutings.attendanceListRoute: (context) => AttendanceList(AttendanceReportModel()),
          MyRoutings.attendanceRequisitionRoute: (context) => AttendanceRequisition(new AttendanceReportModel(), OnDateAttModel(),0 ),
          MyRoutings.getAttendanceDetRoute: (context) => GetAttendanceDet(),
          MyRoutings.pendingReqRoute: (context) => PendingRequisition(SelfRequisitionModel()),
          MyRoutings.approvedReqRoute: (context) => ApprovedRequisiton(ApprovedRequisitionModel()),
          MyRoutings.disApprovedReqRoute: (context) => DisApprovedRequisiton(DisapprovedRequisitionModel()),
          MyRoutings.workDoneDateReportRoute: (context) => WorkDoneReportDateSelect(),
          MyRoutings.workDoneReportRoute: (context) => WorkDoneReport(forDatePickedString: "", toDatePickedString: ""),
          MyRoutings.pendingReqRoRoute: (context) => PendingRequisitionRo(PendingRequisitionModel()),
          MyRoutings.approveDisapproveReqRoute: (context) => ApproveDisapproveReq(new PendingRequisitionModel(),0),
          MyRoutings.adminDashboardRoute: (context) => AdminDashboard(DashboardModel()),
          MyRoutings.singleDateAttendanceRoute: (context) => SingleDateAttendance(singleDateString: ""),
          MyRoutings.leaveBalanceRoute: (context) => LeaveBalancePage(),
          MyRoutings.leaveRequisitionRoute: (context) => LeaveRequisitionPage(),
          MyRoutings.requestedRequisitionRoute: (context) => RequestedRequisitionList(SelfLeaveRequisitionListModal()),
          MyRoutings.othersReqListRoute: (context) => OthersRequisitionList(),
          MyRoutings.approveDisapproveLeaveReqRoute: (context) => ApproveDisapproveLeaveReq(),
          MyRoutings.approvedLeaveReqListRoute: (context) => ApprovedLeaveRequisitionList(ApprovedLeaveReqModal()),
          MyRoutings.loanAdvanceReqRoute: (context) => LoanAdvanceRequisition(),
          MyRoutings.pendingLoanRequestedRoute: (context) => PendingLoanRequestedList(LoanAdvanceReqModal()),
          MyRoutings.claimItemsListRoute: (context) => ClaimItemsList(),
          MyRoutings.advanceRequisitionListRoute: (context) => AdvanceRequisitionList(AdvanceRequestedListModal()),
          MyRoutings.advanceRequisitionPageRoute: (context) => AdvanceRequisitionPage(),
          MyRoutings.pendingAdvanceReqListRoute: (context) => PendingAdvanceReqList(PendingAdvReqListModal()),
          MyRoutings.approveDisAdvanceReqRoute: (context) => AppDispPendingAdvanceReq(new PendingAdvReqListModal(), 0),
          MyRoutings.expenseListRoute: (context) => ExpenseList(ExpensesListModal()),
          MyRoutings.addExpenseRoute: (context) => AddExpensePage(),
          MyRoutings.deleteExpenseListRoute: (context) => DeleteExpenseList(new ExpensesListModal(), 0),
          MyRoutings.pendingReimbursementRoute: (context) => PendingListReimbursement(PendingReimbListModal()),
          MyRoutings.approveDisReimbursementRoute: (context) => ApproveDisappReimbursement(new PendingReimbListModal(), 0),
          MyRoutings.approveDisReimbursementListRoute: (context) => ApprovalListReimbursement(AppDisReimbListModal()),
          MyRoutings.approveDisAdvanceListRoute: (context) => ApproveDisapAdvanceRequisitionList(AppDisAdvListModal()),
          MyRoutings.onDutyTypes: (context) => OnDutyTypes(),
          MyRoutings.odRequisitionSelectRoute: (context) => ODRequisitionSelection(),
          MyRoutings.odAttendanceListRoute: (context) => ODAttendanceList(),
          MyRoutings.odRequisitionPageRoute: (context) => ODRequisitionPage(new AttendanceReportModel(), OnDateAttModel(),0),
          MyRoutings.pendingRequisitionListRoute: (context) => PendingOdRequisition(PendingOdReqList()),
          MyRoutings.odApproveDisapproveReqRoute: (context) => OdApproveDisapproveReq(new PendingOdReqList(), 0),
          MyRoutings.selfOdRequisitionRoute: (context) => SelfODRequisitionList(startDate: "", endDate: "",),
          MyRoutings.odLocationViewRoute: (context) => ODLocationView(),
          MyRoutings.hdOpenTicketRoute: (context) => HDOpenTickets(),
          MyRoutings.hdOverdueTicketRoute: (context) => HDOverdueTickets(),
          MyRoutings.hdDueTodayTicketRoute: (context) => HDDueTodayTickets(),
          MyRoutings.hdOnHoldTicketRoute: (context) => HDOnHoldTickets(),
          MyRoutings.hdNewTicketRoute: (context) => HDNewTickets(),
          MyRoutings.hdReOpenTicketRoute: (context) => HDReOpenTickets(),
          MyRoutings.hdResolvedTicketRoute: (context) => HDResolvedTickets(),
          MyRoutings.hdCancelledTicketRoute: (context) => HDCancelledTickets(),
          MyRoutings.hdRaisedTicketReplyRoute: (context) => HDRaisedTicketReply(),
          MyRoutings.qrItemsRoute: (context) => QRAttTypes(),
          MyRoutings.qrAttLocationRoute: (context) => QRAttLocationPage(),
          MyRoutings.qrAttWithoutLocRoute: (context) => QRAttWithoutLocation(),
          MyRoutings.pendingLeaveReqListRoute: (context) => PendingLeaveRequisitionList(PendingLeaveRequisitionModal()),
          MyRoutings.levelOnePendingRoute: (context) => LevelOnePendingLeave(LevelOnePendingLeaveModal()),
          MyRoutings.levelTwoPendingRoute: (context) => LevelTwoPendingLeave(LevelTwoPendingLeaveModal()),
          MyRoutings.pendingLeaveAppDisRoute: (context) => PendingLeaveApproveDisapprove(new PendingLeaveRequisitionModal(), 0),
          MyRoutings.levelOneApprovalRoute: (context) => LevelOnePendingApproval(new LevelOnePendingLeaveModal(), 0),
          MyRoutings.projectManageItemsRoute: (context) => ProjectManageItems(),
          MyRoutings.othersEmpReqRoute: (context) => OthersLeaveReqPage(),
          MyRoutings.odSelfReqDateSelectRoute: (context) => OdSelfReqDate(),
          MyRoutings.ujalaWdSubmitRoute: (context) => UjalaCreditWDSubmit('',DropValueName,'', '', '', '', '','0','0','0','0','0','0','0'),
          MyRoutings.digiWeighWdSubmitRoute: (context) => DigiWeighWDSubmit('', '', '', '', '', ''),
          MyRoutings.ujalaWorkDoneRoute: (context) => UjalaCreditWorkdone(value:File("path"), address: " ", time: " "),
          MyRoutings.digiWeighWorkDoneRoute: (context) => DigiWeighWorkDone(value:File("path"), address: " ", time: " "),
          MyRoutings.odWorkDoneRoute: (context) => OdWorkDonePage(value:File("path"), address: " ", time: " "),
          MyRoutings.alarmSetRoute: (context) => AlarmSetRing(),
          //MyRoutings.testPdfDownload: (context) => TestSalarySlipDownload(),
          MyRoutings.payrollItemRoute: (context) => PayrollItems(),
          MyRoutings.cameraPageRoute: (context) => CameraApp(),
          MyRoutings.loanApprovedReqRoute: (context) => LoanApprovedReqList(LoanApprovedReqModal()),
          //MyRoutings.rosterPageRoute: (context) => RosterCreation(),
          //MyRoutings.rosterCalendarRoute: (context) => RosterCalendar(),
          MyRoutings.inductionOnboardRoute: (context) => OnboardListView(),
          MyRoutings.addInductionProcessRoute: (context) => AddInductionProcess(),
          MyRoutings.roWorkDoneFilterRoute: (context) => taa.RoWorkDoneReportFiltering(),
          MyRoutings.documentsAddedRoute: (context) => DocumentsAdded(),
          MyRoutings.documentDownloadRoute: (context) => DownloadLetters("0", ""),
          MyRoutings.roWorkDoneReportRoute: (context) => RoWorkDoneReport(taa.fromDatePickedStringRo, taa.toDatePickedStringRo, taa.filterType, taa.empNewIdRo),
          MyRoutings.hrDetailsRoute: (context) => HRISDetails(),
          MyRoutings.ocrPageRoute: (context) => OCRPage(),
          MyRoutings.faceRecognitionHome: (context) => FaceRecognitinHome(),
          MyRoutings.testPdfDownload: (context) => SalarySlipDownload(),
          MyRoutings.visitorManageSections: (context) => VisitorManageSections(),

          MyRoutings.claimReqListRoute: (context) => ClaimRequisitionList(),
          MyRoutings.claimAdvanceRoute: (context) => ClaimAdvanceList(),
          MyRoutings.landingPageRoute: (context) => LandingPage(),
          MyRoutings.accountSuspend: (context) => AccountSuspendPage(),
          MyRoutings.profilePageHeadRoute: (context) => ProfilePageNew(),
          MyRoutings.otherEmpReqAttendance: (context) => OthersAttendanceRequisitionPage(),
          MyRoutings.mssDashboardRoute: (context) => MSSDashboard(DashboardModel()),
          MyRoutings.otherSingleAttendance: (context) => OthersSingleDateAttendance(singleDateString: "", empId: 0,),
          MyRoutings.otherAttendanceReq: (context) => OthersAttendanceRequisition(new AttendanceReportModel(), OthersOnDateAttendanceModal(),0 ),
          MyRoutings.otherAttendanceListRoute: (context) => OthersAttendanceList(AttendanceReportModel(),0),
          MyRoutings.realTimeLocationRoute: (context) => RealTimeLocationWithAddress(),
          MyRoutings.essDashboardRoute: (context) => EssAdminDashboard(EssDashboarrdModel()),
          MyRoutings.essDashboardNavigateRoute: (context) => EssAdminDashboardHead(EssDashboarrdModel()),
          MyRoutings.attendanceReqCalendar: (context) => AttendanceRequisitionCalendar( AttendanceReportModel(), OnDateAttModel(),0, ""),
          MyRoutings.travelExpReqRoute: (context) => TravelExpenseRequestRaise(),
          MyRoutings.exitListRoute: (context) => ExitListView(),
          MyRoutings.exitWorkflowRoute: (context) => ExitWorkflow(0, ""),
          //MyRoutings.trackingPage:(context)=> const Trackingmain(),
          //MyRoutings.trackingPage:(context)=> const Geolocatortracking(),
          MyRoutings.claimMssItemsRoute:(context)=>ClaimMSSItemsList(),
          MyRoutings.travelExpApprovalPageRoute:(context)=>ClaimMSSItemsList(),
          MyRoutings.empListFaceRegistration:(context)=>EmpListFaceRegistered(),
          MyRoutings.empListFaceRecognize:(context)=>EmpListFaceRecognize(),
          MyRoutings.markAiAttendanceRoute:(context)=>MarkAttendanceAI(empId: 0,),
          MyRoutings.mealScannerRoute:(context)=>MealSelectionPage(),
          MyRoutings.geoLocationTracking:(context)=>const Geolocatortracking(),
          MyRoutings.preOnboardListRoute: (context) => PreOnboardListView(),
          MyRoutings.pendingPreOnboardListRoute: (context) => PendingPreOnboardingList(),
          MyRoutings.approvePreOnboardingRoute: (context) => ApprovePreOnboarding("","","","","","","","","","","","","","","","","","","","","",""),
          MyRoutings.preOnboardProcessRoute: (context) => PreInductionProcess(),
          MyRoutings.forgetPasswordEmailRoute: (context) => ForgotPasswordEmailPage(),
          MyRoutings.forgetPasswordOtpRoute: (context) => ForgotPasswordOtpPage(""),
          MyRoutings.resetPasswordRoute: (context) => ForgotPasswordResetPage(""),
          MyRoutings.resetPasswordPageRoute: (context) => ResetPasswordPage(),
          MyRoutings.preOnboardItemRoute: (context) => PreOnboardingItems(),
          MyRoutings.exitEmpListRoute: (context) => ExitEmployeeListView(),
          MyRoutings.essAttendanceApprovedReq: (context) => ESSAttApprovedRequisiton(ApprovedRequisitionModel()),

          //MSS Bundle
          MyRoutings.mssAttPendingRequestRoRoute: (context) => MSS_Att_PendingRequisitionRo(PendingRequisitionModel()),
          MyRoutings.mssAttPendingRequestL1Route: (context) => MSS_Att_PendingRequisitionL1(PendingRequisitionModel()),
          MyRoutings.mssAttPendingRequestL2Route: (context) => MSS_Att_PendingRequisitionL2(PendingRequisitionModel()),
          MyRoutings.mssAttPendingRequestL3Route: (context) => MSS_Att_PendingRequisitionL3(PendingRequisitionModel()),
          MyRoutings.mssPendingOdRequisitionRoute: (context) => MSS_PendingOdRequisition(PendingOdReqList()),
          MyRoutings.mssOthersAttRequestPageRoute: (context) => MSS_OthersAttendanceRequisitionPage(),

          //Leave
          MyRoutings.mssPendingLeaveRequestRoute: (context) => MSS_PendingLeaveRequisitionList(PendingLeaveRequisitionModal()),
          MyRoutings.mssLevelOnePendingReqRoute: (context) => MSS_LevelOnePendingLeave(LevelOnePendingLeaveModal()),
          MyRoutings.mssLevelTwoPendingReqRoute: (context) => MSS_LevelTwoPendingLeave(LevelTwoPendingLeaveModal()),
          MyRoutings.mssOtherLeaveReqRoute: (context) => MSS_OthersLeaveReqPage(),

          //Dashboards
          MyRoutings.mssNewDashboardRoute: (context) => MSSNewDashboard(DashboardModel()),
          MyRoutings.adminNewDashboardRoute: (context) => AdminNewDashboard(DashboardModel()),

          //Reports
          MyRoutings.mssWorkDoneReportRoute: (context) => mss.MSS_RoWorkDoneReportFiltering(),

          //Claim
          MyRoutings.mssClaimItemRoute: (context) => MSS_ClaimMSSItemsList(),


          //MSS MO Bundle
          MyRoutings.mssMoAttPendingRequestRoRoute: (context) => MSS_MO_PendingRequisitionRo(PendingRequisitionModel()),
          MyRoutings.mssMoPendingOdRequisitionRoute: (context) => MSS_MO_PendingOdRequisition(PendingOdReqList()),
          MyRoutings.mssMoOthersAttRequestPageRoute: (context) => MSS_MO_OthersAttendanceRequisitionPage(),
          MyRoutings.mssMOPendingAttReqL1: (context) => MSS_MO_Att_PendingRequisitionL1(PendingRequisitionModel()),
          MyRoutings.mssMOPendingAttReqL2: (context) => MSS_MO_Att_PendingRequisitionL2(PendingRequisitionModel()),
          //Leave
          MyRoutings.mssMoPendingLeaveRequestRoute: (context) => MSS_MO_PendingLeaveRequisitionList(PendingLeaveRequisitionModal()),
          MyRoutings.mssMoLevelOnePendingReqRoute: (context) => MSS_MO_LevelOnePendingLeave(LevelOnePendingLeaveModal()),
          MyRoutings.mssMoLevelTwoPendingReqRoute: (context) => MSS_MO_LevelTwoPendingLeave(LevelTwoPendingLeaveModal()),
          MyRoutings.mssMoOtherLeaveReqRoute: (context) => MSS_MO_OthersLeaveReqPage(),

          //Dashboards
          MyRoutings.mssMoNewDashboardRoute: (context) => MSS_MO_Dashboard(DashboardModel()),
          MyRoutings.adminNewMoDashboardRoute: (context) => Admin_MSS_MO_Dashboard(DashboardModel()),

          //Reports
          MyRoutings.mssMoWorkDoneReportRoute: (context) => MSS_MO_RoWorkDoneReportFiltering(),

          //Claim
          MyRoutings.mssMoClaimItemRoute: (context) => MSS_MO_ClaimMSSItemsList(),

          //My Teams MO
          MyRoutings.myTeamMORoute: (context) => EmpListViewMO(),

          //Exit List MO
          MyRoutings.exitListMORoute: (context) => ExitListViewMO(),
          //Loan List MO
          MyRoutings.pendingLoanListMO: (context) => PendingLoanRequestListMO(),

          //UIS Bundle
          MyRoutings.uisAttPendingRequestRoRoute: (context) => UIS_PendingRequisitionRo(PendingRequisitionModel()),
          MyRoutings.uisPendingOdRequisitionRoute: (context) => UIS_PendingOdRequisition(PendingOdReqList()),
          MyRoutings.uisOthersAttRequestPageRoute: (context) => UIS_OthersAttendanceRequisitionPage(),
          MyRoutings.uisPendingAttReqL1: (context) => MSS_MO_Att_PendingRequisitionL1(PendingRequisitionModel()),
          MyRoutings.uisPendingAttReqL2: (context) => MSS_MO_Att_PendingRequisitionL2(PendingRequisitionModel()),
          //Leave
          MyRoutings.uisPendingLeaveRequestRoute: (context) => UIS_PendingLeaveRequisitionList(PendingLeaveRequisitionModal()),
          MyRoutings.uisLevelOnePendingReqRoute: (context) => UIS_LevelOnePendingLeave(LevelOnePendingLeaveModal()),
          MyRoutings.uisLevelTwoPendingReqRoute: (context) => UIS_LevelTwoPendingLeave(LevelTwoPendingLeaveModal()),
          MyRoutings.uisOtherLeaveReqRoute: (context) => UIS_OthersLeaveReqPage(),

          //Dashboards
          MyRoutings.uisNewDashboardRoute: (context) => UIS_Dashboard(DashboardModel()),
          MyRoutings.adminNewUisDashboardRoute: (context) => Admin_UIS_Dashboard(DashboardModel()),

          //Reports
          MyRoutings.uisWorkDoneReportRoute: (context) => UIS_RoWorkDoneReportFiltering(),

          //Claim
          MyRoutings.uisClaimItemRoute: (context) => UIS_ClaimMSSItemsList(),

          //ESS
          MyRoutings.myAllRequestRoute: (context) => MyAllRequestPage(),
          MyRoutings.myAllReportsRoute: (context) => MyAllReportsPage(),


          //Incident Reporting
          MyRoutings.incidentReportListRoute: (context) => IncidentListPage(),
          MyRoutings.incidentReportPageRoute: (context) => IncidentFormPage(),

          //Loan
          MyRoutings.myLoanRequestListRoute: (context) => MyLoanRequestList(),
          MyRoutings.myLoanRequestRaiseRoute: (context) => LoanRequestPage(),
          MyRoutings.myLoanSummaryRoute: (context) => LoanSummaryPage(),
          MyRoutings.myLoanLedgerRoute: (context) => MyLoanLedgerPage(),
          MyRoutings.pendingLoanRequestListRoute: (context) => PendingLoanRequestList(),
          MyRoutings.loanApprovalPageRoute: (context) => LoanApprovalPage(loanReqId: 0,),
          //Check for updates
          MyRoutings.checkForUpdatesRoute: (context) => UpdateChecker(),

          //Company Policy
          MyRoutings.companyPolicyListRoute: (context) => CompanyPoliciesPage(),

          //Real-Time Dashboards
          MyRoutings.realtimeESSDashboard: (context) => RealTimeESSDashboard(EssDashboarrdModel()),

          //Reporting Officer Page
          MyRoutings.reportingOfficerPageRoute: (context) => ReportingOfficersPage(),


          //HRIS
          MyRoutings.inactiveListMSSRoute: (context) => InactiveListMSS(),
          MyRoutings.fnfListMSSRoute: (context) => FNFListMSS(),


        },

      ),
    );
  }
}
Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}
