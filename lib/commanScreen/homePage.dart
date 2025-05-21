import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:er_flutter_project/employeePage/mapView.dart';
import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:er_flutter_project/ess/essDashboard.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:image_cropper/image_cropper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

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
import '../adminPage/modelClass/dashboardModel.dart';
import '../reports/reportPage.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';

import 'allAPIList.dart';
import 'commanNotificationPage.dart';
import 'digiWeighWorkDone.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

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
    speedAccuracy: 0.0);

LatLng? currentPostion;
late GoogleMapController googleMapControllerNew;
var currentAddressNew = "Address Not Found";
var todayDate = "dd/mm/yyyy";
var todayDateShowNew = "dd/mm/yyyy";
late LoginModel _loginModel;
String timeStringNew = "";
String? sessionId;
String? userType;
int? orgnizationID=0;
late String UserName="Employee Name";
late String employeeCode="101";
String? imageStringNew;
String? defaultProfileName;
String? defaultProfileId;

SessionManager shared = SessionManager();
String? clockingType = " ";
int pageIndex = 0;
int currentIndex = 0;
String profileImage = "";
String emailid = "abc@gmail.com";
String name = "Employee Name ";
final screens = [
  const DefaultPage(),
  const Workflow(),
  const Report(),
  Dashboard(),
  ProfileCheck(),
];

class _HomePageState extends State<HomePage> {
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

    var now = new DateTime.now();
    //var now =  ntpTime.toUtc();

    print("NTP TIME -  $todayDate");
    var newFormat = new DateFormat('dd-MM-yyyy');
    todayDateShowNew = newFormat.format(now);
    print("todaydate  $todayDateShowNew");
    getUserNameImage();
    super.initState();
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
    userType = await shared!.getUserType();
    defaultProfileName = await shared!.getDefaultProfileName();
    defaultProfileId = await shared!.getDefaultProfileId();
    print("Default Profile Name - $defaultProfileName");
    print("Default Profile Id - $defaultProfileId");
    setState(() {

    });
    print("User Type - $userType");
    imageStringNew = await shared!.getProfileImage();
    UserName = await shared!.getempName();
    employeeCode = await shared!.getEmpCode();
    lat= await shared!.getLatitude();
    lng = await shared!.getLongitude();
    //currentPostion = LatLng(lat, lng);
    //print('Response snapshot: ${sessionId}');
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
    late CameraController controller;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,

          //backgroundColor: Colors.white,
          title:
          RichText(
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
                    child: Text(
                      '$defaultProfileName',
                      style: TextStyle(
                        color: Mythemes.whitish,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.power_settings_new_outlined),
                onPressed: () {
                  logoutApp(context);
                })
          ],
        ),
        body: screens[currentIndex],
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

  Future<bool?> _showBackDialog() {
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
                Navigator.pop(this.context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  SystemNavigator.pop();
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
  dynamic mobAction;
  String? mockLat;
  String? mockLong;
  bool? isMock = false;

  @override
  void initState() {
    //print('initState');
    // TODO: implement initState
    _determinePosition();
    _getUserLocation();
    timeStringNew = _formatDateTime(DateTime.now());
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
    positionCheck = await GeolocatorPlatform.instance.getCurrentPosition();
    //position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 5));
    //print('SetcurrentCL  $position');
    var lastPosition = await Geolocator.getLastKnownPosition();
    //print('SetcurrentLast  $lastPosition');
    // bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (positionCheck != null) {
      setState(() {
        currentPostion = LatLng(positionCheck!.latitude, positionCheck!.longitude);
        shared.setLatitude(positionCheck!.latitude);
        shared.setLongitude(positionCheck!.longitude);
        getAddress(positionCheck!);
      });
    } else {
      showAboutDialog(context: this.context);
    }
  }

  Future<void> getAddress(Position positionCheck) async {
    List<Placemark> pleaceMark =
    await placemarkFromCoordinates(positionCheck!.latitude, positionCheck.longitude);
    Placemark placemarkee = pleaceMark[0];
    print('currentPosition $currentAddressNew');
    var contryName = placemarkee.country;
    var locality = placemarkee.locality;
    var sublocality = placemarkee.subLocality;
    var administrativeArea = placemarkee.administrativeArea;
    var street = placemarkee.street;
    var postalCode = placemarkee.postalCode;
    var nameAdd = placemarkee.name;
    setState(() {
      currentAddressNew = '$street ' +
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
    sessionId = await shared!.getSessionId();
    lat = await shared!.getLatitude();
    //position= Position(longitude: shared.getLongitude(), latitude: shared.getLatitude(), timestamp: date, accuracy: 1, altitude: 1, altitudeAccuracy: 1, heading: 1, headingAccuracy: 1, speed: 1, speedAccuracy: 1);
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    timeStringNew = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    lng = await shared.getLongitude();
    orgnizationID = await shared.getOrgId();
    attAction = await shared.getAttAction();
    print("LatLong - ${LatLng(positionCheck!.latitude, positionCheck!.longitude)}");
    //print("Long - $lng");
    currentPostion = LatLng(positionCheck!.latitude, positionCheck!.longitude);

    mobAction = await shared.getMobAction();
    print('mobActions $mobAction');

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

    getImageForWorkdone() async {
      try {
        final imageValue = await ImagePicker()
            .pickImage(source: ImageSource.camera)
            .then((value) {
          if (value != null) this._workDoneImage = File(value!.path);
          if (value == null) {
            Navigator.pushNamed(context, MyRoutings.punchInRoute);
            //Navigator.pushNamed(context, MyRoutings.addInductionProcessRoute);
          } else {
            setState(() {
              if (orgnizationID == 108) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UjalaCreditWorkdone(
                        value: _workDoneImage,
                        address: currentAddressNew,
                        time: timeStringNew)));
              } else if (orgnizationID == 110) {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SkyDecorWorkDone(value: _workDoneImage, address: currentAddressNew, time: timeStringNew )));
              } else if (orgnizationID == 119) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DigiWeighWorkDone(
                        value: _workDoneImage,
                        address: currentAddressNew,
                        time: timeStringNew)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WorkDonePage(
                        value: _workDoneImage,
                        address: currentAddressNew,
                        time: timeStringNew)));
              }
            });
          }
        });
        //if(imageValue==null) return;

        //final imagePath= File(imageValue.path);
      } on PlatformException catch (e) {
        //print('failed to upload: $e');
      }
    }

    getImagePunchOut() async {
      try {
        //Navigator.pushNamed(context, MyRoutings.cameraPageRoute);

        final imageValue = await ImagePicker()
            .pickImage(source: ImageSource.camera)
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
                address: currentAddressNew,
                time: timeStringNew,
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
                      currentPostion!.latitude, currentPostion!.longitude
                  ),
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
              subtitle: Text('$currentAddressNew'),
              leading: Container(
                width: 45,
                height: 45,
                child: imageStringNew == null
                    ? Center(child: CircularProgressIndicator())
                    : CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageStringNew!),
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
                          '$todayDateShowNew',
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
                      Container(height: 12, color: Mythemes.whiteShadeSeventy),
                      //Padding(padding: EdgeInsets.all(0)),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          timeStringNew,
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
                                  if (attAction == '0') {
                                    getPunchIn(context);
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
                                      print("Heloo ji " "$imageValue");
                                      setState(() {
                                        final imagePath =
                                        File(imageValue!.path);
                                        this._workDoneImage = imagePath;
                                      });
                                      imageValue = null;
                                      //imageCache.clear();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageUploaded(
                                                      value: _workDoneImage,
                                                      address:
                                                      currentAddressNew,
                                                      time: timeStringNew,
                                                      punchType:
                                                      clockingType)));
                                    } on Exception catch (e) {
                                      print('failed to upload: $e');
                                    }
                                  }
                                }
                              }

                            } else {
                              clockingType = "In";
                              if (attAction == '0') {
                                getPunchIn(context);
                              } else if (attAction == '1') {
                                //getImagePunchIn();
                                try {
                                  //ImagePicker picker = ImagePicker();
                                  var imageValue =
                                  await _picker.pickImage(
                                      source: ImageSource.camera,
                                    imageQuality: 20,);
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
                                  setState(() {
                                    final imagePath =
                                    File(imageValue!.path);
                                    this._workDoneImage = imagePath;
                                  });
                                  imageValue = null;
                                  //imageCache.clear();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ImageUploaded(
                                                  value: _workDoneImage,
                                                  address: currentAddressNew,
                                                  time: timeStringNew,
                                                  punchType:
                                                  clockingType)));
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
                                print("AUTO TIME $timeAuto");
                                print("AUTO TIME ZONE $timezoneAuto");
                                if (!timeAuto) {
                                  //DatetimeSetting.openSetting();
                                  showAutoTimeZone(
                                      context,
                                      "Your mobile timing not updated, please change time setting to auto.",
                                      "Info ");
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
                                print("AUTO TIME $timeAuto");
                                print("AUTO TIME ZONE $timezoneAuto");
                                if (!timeAuto) {
                                  //DatetimeSetting.openSetting();
                                  showAutoTimeZone(
                                      context,
                                      "Your mobile timing not updated, please change time setting to auto.",
                                      "Info ");
                                } else {
                                  clockingType = "Out";
                                  if (attAction == '0') {
                                    getPunchOut(context);
                                  } else if (attAction == '1') {
                                    getImagePunchOut();
                                  }
                                }
                              }

                            } else {
                              clockingType = "Out";
                              if (attAction == '0') {
                                getPunchOut(context);
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

  getTimeUpdate() {
    setState(() {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
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
    var urlapi = Uri.parse("$conn$apiUrl?"
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

  Future punchInnew(String? sessionId) async {
    double lat = currentPostion!.latitude;
    double lng = currentPostion!.longitude;
    print('click $lat');
    print('click $lng');
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
  var title = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return EssAdminDashboard(EssDashboarrdModel());
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

  @override
  void initState() {
    getUserRoles();
    //getUserNameImage();
    super.initState();
  }

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
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Mythemes.whiteShadeSeventy),
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Mythemes.whiteShadeSeventy),
                accountName: Text(name,
                    style: TextStyle(
                        color: Mythemes.black, fontWeight: FontWeight.bold)),
                accountEmail:
                Text(emailid, style: TextStyle(color: Mythemes.black)),
                margin: EdgeInsets.zero,
                /*   decoration: BoxDecoration(
                  color:Colors.red,
                ),*/
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  backgroundColor: Mythemes.greyish,
                ),
              ),
            ),

            /*ListTile(
              leading: Icon(CupertinoIcons.profile_circled),
              title: Text(
                "Profile",
                textScaler: TextScaler.linear(1.2),
              ),
              onTap: (){
                print("profile click");
                */ /*Fluttertoast.showToast(
                    msg: "Profile Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/ /*
                Navigator.pushNamed(context, MyRoutings.profileRoute);
                // Navigator.of(context, rootNavigator: true).pop();
              },
            ),*/
            /*ListTile(
              leading: Icon(CupertinoIcons.chart_bar_square),
              title: Text(
                "Dashboard ",
                textScaleFactor: 1.2,
              ),
              onTap: (){
                screens[currentIndex];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screens[3]),
                );
                //Navigator.of(context, rootNavigator: true).pop();
                //screens[3];
                //Dashboard();
                //Navigator.pushNamed(context, MyRoutings.alarmSetRoute);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => screens[3]));
                */ /*setState(() {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                  //Navigator.of(context, rootNavigator: true).pop();
                  print( "hollaa $screens[3]");
                  screens[3];
                });*/ /*
                //Navigator.of(context, rootNavigator: true).pop();
                //currentIndex = 3;
                */ /*Fluttertoast.showToast(
                    msg: "Dashboard Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/ /*
              },
            ),

            ListTile(
              leading: Icon(CupertinoIcons.antenna_radiowaves_left_right),
              title: Text(
                "Workflow ",
                textScaleFactor: 1.2,
              ),
              onTap: () async {
                bool internetCheck = await InternetConnectionChecker().hasConnection;
                if(internetCheck == false) {
                  setState(() {
                    AlertDialog(
                      content: "Please check your internet connection".text.make(),
                    );
                    Fluttertoast.showToast(
                        msg: "Please check your Internet connection",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM_RIGHT,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Mythemes.black,
                        textColor: Colors.white,
                        fontSize: 17.0
                    );
                  });

                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                  Fluttertoast.showToast(
                      msg: "Workflow Click",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM_RIGHT,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Mythemes.black,
                      textColor: Colors.white,
                      fontSize: 17.0
                  );
                  //Navigator.pushNamed(context, MyRoutings.cameraPageRoute);
                }
              },
            ),*/

            Visibility(
              visible: showHide || showAdmin,
              child: Hero(
                tag: 'animatedDrawer',
                child: ListTile(
                  leading: Icon(CupertinoIcons.list_bullet_below_rectangle),
                  title: Text(
                    "Employee List",
                    textScaler: TextScaler.linear(1.2),
                  ),
                  onTap: () async {
                    bool internetCheck =
                    await InternetConnectionChecker().hasConnection;
                    if (internetCheck == false) {
                      setState(() {
                        AlertDialog(
                          content: "Please check your internet connection"
                              .text
                              .make(),
                        );
                        Fluttertoast.showToast(
                            msg: "Please check your Internet connection",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM_RIGHT,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Mythemes.black,
                            textColor: Colors.white,
                            fontSize: 17.0);
                      });
                    } else {
                      Navigator.pushNamed(context, MyRoutings.empListRoute);
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: ListTile(
                leading: Icon(CupertinoIcons.settings_solid),
                title: Text(
                  "Settings",
                  textScaleFactor: 1.2,
                ),
                onTap: () async {
                  bool internetCheck =
                  await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content:
                        "Please check your internet connection".text.make(),
                      );
                      Fluttertoast.showToast(
                          msg: "Please check your Internet connection",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Mythemes.black,
                          textColor: Colors.white,
                          fontSize: 17.0);
                    });
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                    Fluttertoast.showToast(
                        msg: "Settings Click",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM_RIGHT,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Mythemes.black,
                        textColor: Colors.white,
                        fontSize: 17.0);
                  }
                },
              ),
            ),
            /*ListTile(
              leading: Icon(CupertinoIcons.folder),
              title: Text(
                "Reports",
                textScaleFactor: 1.2,
              ),
              onTap: () async {
                bool internetCheck = await InternetConnectionChecker().hasConnection;
                if(internetCheck == false) {
                  setState(() {
                    AlertDialog(
                      content: "Please check your internet connection".text.make(),
                    );
                    Fluttertoast.showToast(
                        msg: "Please check your Internet connection",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM_RIGHT,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Mythemes.black,
                        textColor: Colors.white,
                        fontSize: 17.0
                    );
                  });

                } else {
                  //Navigator.pushNamed(context, MyRoutings.testPdfDownload);
                  //Navigator.pushNamed(context, MyRoutings.ocrPageRoute);
                  Navigator.of(context, rootNavigator: true).pop();
                  Fluttertoast.showToast(
                      msg: "Reports Click",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM_RIGHT,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Mythemes.black,
                      textColor: Colors.white,
                      fontSize: 17.0
                  );
                }
              },
            ),
            Hero(
              tag: 'helpdeskItem',
              child: ListTile(
                leading: Icon(Icons.support_agent_rounded),
                title: Text(
                  "Helpdesk",
                  textScaleFactor: 1.2,
                ),
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      Fluttertoast.showToast(
                          msg: "Please check your Internet connection",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Mythemes.black,
                          textColor: Colors.white,
                          fontSize: 17.0
                      );
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                  }
                },
              ),
            ),*/
            /*ListTile(
              leading: Icon(Icons.support_agent_rounded),
              title: Text(
                "Helpdesk ",
                textScaleFactor: 1.2,
              ),
              onTap: (){
                print("I am helpdeksk");
                Navigator.pushNamed(context, MyRoutings.empListRoute);
               */ /* Fluttertoast.showToast(
                    msg: "Helpdesk Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/ /*
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
