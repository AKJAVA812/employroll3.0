import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:camera/camera.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../adminPage/modelClass/dashboardModel.dart';
import '../commanScreen/commanNotificationPage.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';

import 'adminDashboard/adminPanelDashboard.dart';

class AdminPanelScreen extends StatefulWidget {

  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

Position? positions;
LatLng? currentPostion;
late GoogleMapController googleMapController;
var currentAddresses = "Address Not Found";
var todayDate = "dd/mm/yyyy";
late LoginModel _loginModel;
String timeString = "";
String? sessionId;
int? orgnizationID=0;
String? imageString;


SessionManager shared = SessionManager();
String? clockingType=" ";
int pageIndex = 0;
int currentIndex = 0;
final screens = [
  Dashboard(),
  const Workflow(),
  const Report(),
  //const Notification(),
];
class _AdminPanelScreenState extends State<AdminPanelScreen> {
  var title = "Dashboard";

  logoutApp(context) {
    CommonNotificationPage.showLogoutPopup(
        context, "Do You Want To Logout?".toString() + " " , "Alert");
  }



   showDialgSucess(BuildContext buildContext, result,alert) {
     var alertDialog =  AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(" Info "),
        ],
      ),
      content:  Container(
        //width: MediaQuery.of(buildContext).size.width,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(

            )
          ],
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

    return WillPopScope(
      onWillPop: () async{
         return showAppCloseDialog(context, "result") as bool;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,

          //backgroundColor: Colors.white,
          title: Text(
            title,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.power_settings_new_outlined),
                onPressed: () {
                  logoutApp(context);
                })
          ],
        ),
        body:  screens[currentIndex],
        bottomNavigationBar:
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {

            if(index==0){
              title="Dashboard";
            }
            if(index==1){
              title="WorkFlow";
            }
            if(index==2){
              title="Reports";
            }
            setState(() => currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'WorkFlow',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_plaintext),
              label: 'Reports',
              //backgroundColor: Colors.blue,
            )
          ],
        ),

        drawer: DrawerFile(),
      ),
    );
  }



  static final _initialCameraPosition = CameraPosition(
    zoom: 15,
    target: LatLng(28.5367794, -121.2714404),
    tilt: 21.0,
  );


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

  void _getUserLocation() async {
    positions = await GeolocatorPlatform.instance.getCurrentPosition();
    var lastPosition = await Geolocator.getLastKnownPosition();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    //print('Response1111l $lastPosition');

    setState(() {
      if (positions != null) {
        currentPostion = LatLng(positions!.latitude, positions!.longitude);
        shared.setLatitude(positions!.latitude);
        shared.setLongitude(positions!.longitude);
        getAddress(positions!);
        //print('Response1111c $currentAddresses');
      } else {
        showAboutDialog(context: this.context);
      }
    });
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
 /*   final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      //onNewCameraSelected(cameraController.description);
    }*/
  }



  Future<void> getAddress(Position position) async {
    List<Placemark> pleaceMark =
    await placemarkFromCoordinates(position!.latitude, position.longitude);
    Placemark placemarkee = pleaceMark[0];
    //print('Response1111css $position');
    var contryName = placemarkee.country;
    var locality = placemarkee.locality;
    var sublocality = placemarkee.subLocality;
    var administrativeArea = placemarkee.administrativeArea;
    var street = placemarkee.street;
    var postalCode = placemarkee.postalCode;
    var nameAdd = placemarkee.name;
    currentAddresses = '$street ' +
        '$nameAdd ' +
        '$sublocality ' +
        '$locality ' +
        '$administrativeArea ' +
        '$contryName ' +
        '$postalCode ';
    setState(() {
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    imageString= await shared!.getProfileImage();
    print('Response snapshot: ${sessionId}');
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    //print('EmpRoleChec $empRole');
    //print('roRole $roRole');
    //print('adminRole $adminRole');
  }

  @override
  void initState() {
    // TODO: implement initState
    _loginModel=new LoginModel();
    _determinePosition();
    _getUserLocation();
    getSharedPrfanceList();
    currentAddresses;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    todayDate = formatter.format(now);
    super.initState();
    /*controller = CameraController(
      widget.camera,
      ResolutionPreset.low,
    );
    initializeController = cameraController.initialize();*/
  }

  void showAppCloseDialog(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
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


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var title = "Dashboard";
  @override
  Widget build(BuildContext context) {
    return AdminPanelDashboard(DashboardModel());
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
    return Center(
        child: Container(
          child: Text(
              'Reports'
          ),
        ));
  }
}



class DrawerFile extends StatefulWidget {
  @override
  State<DrawerFile> createState() => _DrawerFileState();
}


//SessionManager shared= SessionManager();
class _DrawerFileState extends State<DrawerFile> {
  String urlImage = "";
  String emailid="abc@gmail.com";
  String name="Employee Name ";

  Future getUserNameImage() async {
    urlImage= await shared.getProfileImage();
    name= await shared.getempName();
    emailid=await shared.getEmailId();
    print('drawer: ${urlImage}');
    print('drawer: ${name}');

    print('drawer: ${emailid}');
    setState(() { });
  }
  @override
  void didChangeDependencies() {
    //getUserNameImage();
    print('drawer: didChangeDependencies');
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {

    getUserNameImage();

    print('drawer: initState');
    // TODO: implement initState

    print('drawer: ${urlImage}');
    print('drawer: ${name}');

    super.initState();
  }
  @override
  void didUpdateWidget(covariant DrawerFile oldWidget) {
    //getUserNameImage();
    print('drawer: didUpdateWidget');
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  void setState(VoidCallback fn) {
    //getUserNameImage();
    print('drawer: setState');
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context)  {
    timeDilation = 1.8;
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SingleChildScrollView(
              child: DrawerHeader(
                decoration: BoxDecoration(
                    color: Mythemes.greyishade
                ),
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: Mythemes.greyishade
                  ),
                  accountName: Text(name , style: TextStyle(color: Mythemes.black, fontWeight: FontWeight.bold)),
                  accountEmail: Text(emailid, style: TextStyle(color: Mythemes.black)),
                  margin: EdgeInsets.zero,
                  /*   decoration: BoxDecoration(
                    color:Colors.red,
                  ),*/
                  currentAccountPicture:
                  CircleAvatar(backgroundImage:

                  NetworkImage('$urlImage') , backgroundColor: Mythemes.greyish,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(CupertinoIcons.profile_circled),
              title: Text(
                "Profile",
                textScaleFactor: 1.2,
              ),
              onTap: (){
                print("profile click");
                /*Fluttertoast.showToast(
                    msg: "Profile Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                Navigator.pushNamed(context, MyRoutings.profileRoute);
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.chart_bar_square),
              title: Text(
                "Dashboard ",
                textScaleFactor: 1.2,
              ),
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => screens[3]));
                setState(() {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                  //Navigator.pop(context);
                  print( "hollaa $screens[3]");
                  screens[3];
                });
                Navigator.pop(context);
                //currentIndex = 3;
                Fluttertoast.showToast(
                    msg: "Dashboard Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
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
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Workflow Click",
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
              tag: 'animatedDrawer',
              child: ListTile(
                leading: Icon(CupertinoIcons.list_bullet_below_rectangle),
                title: Text(
                  "Employee List",
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
                    Navigator.pushNamed(context, MyRoutings.empListRoute);
                  }
                },
              ),
            ),

            ListTile(
              leading: Icon(CupertinoIcons.settings_solid),
              title: Text(
                "Settings",
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
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Settings Click",
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
            ListTile(
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
                  Navigator.pop(context);
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
            ),
            /*ListTile(
              leading: Icon(Icons.support_agent_rounded),
              title: Text(
                "Helpdesk ",
                textScaleFactor: 1.2,
              ),
              onTap: (){
                print("I am helpdeksk");
                Navigator.pushNamed(context, MyRoutings.empListRoute);
               *//* Fluttertoast.showToast(
                    msg: "Helpdesk Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*//*
                Navigator.pop(context);
              },
            ),*/

          ],
        ),
      ),
    );
  }
}




