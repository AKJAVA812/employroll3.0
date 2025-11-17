import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/punchInUploadPage.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/workDonePage.dart';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'odPunchUpload.dart';
import 'odWorkDonePage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';


class ODLocationView extends StatefulWidget {
  const ODLocationView({Key? key}) : super(key: key);

  @override
  State<ODLocationView> createState() => _ODLocationViewState();
}

class _ODLocationViewState extends State<ODLocationView> {
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    var titleName = "OD Location";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
        }, icon: Icon(Icons.arrow_back_ios)),
        title: titleName.text.make(),
      ),

      body: ODPageView(),

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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GetAttendanceDet(showAppBar: true,)));
            //Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My All Requests');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if(index==4){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            /*Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );*/
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Profile');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
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
    );
  }
}

class ODPageView extends StatefulWidget {
  const ODPageView({Key? key}) : super(key: key);

  @override
  State<ODPageView> createState() => _ODPageViewState();
}
SessionManager shared = SessionManager();
String? clockingType=" ";
class _ODPageViewState extends State<ODPageView> {
  String UserName = "Employee Name";
  File? _workDoneImage;
  void initState() {
    // TODO: implement initState
    getUserName();
    timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }
  Future getUserName() async {
    UserName = await shared!.getempName();
    print('Response snapshot: ${UserName}');
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
  @override
  Widget build(BuildContext context) {

    Future<void> getImageODIn() async {
      try {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 20);

        if (pickedFile == null) return;

        final imagePath = File(pickedFile.path);

        setState(() => _workDoneImage = imagePath);

        if (!mounted) return; // ✅ Avoid calling Navigator after widget dispose

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ODImageUpload(
              value: _workDoneImage,
              address: currentAddress,
              time: timeString,
              punchType: clockingType,
            ),
          ),
        );
      } on PlatformException catch (e) {
        debugPrint('Image pick failed: $e'); // ✅ debugPrint is better for logs
      } catch (e, s) {
        debugPrint('Unexpected error: $e\n$s'); // ✅ Catch any unexpected exception
      }
    }

    /*getImageODIn() async{
      try{
        final imageValue = await ImagePicker().pickImage(source: ImageSource.camera);
        if(imageValue==null) return;
        print("Heloo ji ""$imageValue");
        final imagePath= File(imageValue.path);
        setState(() {
          this._workDoneImage=imagePath;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)
        =>ODImageUpload(value: _workDoneImage, address: currentAddress, time: timeString,
            punchType:clockingType )));
      }on PlatformException catch (e) {
        print('failed to upload: $e');
      }
    }*/
    getImageForWorkdone() async {
      try{

        final imageValue = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 20);
        if(imageValue==null) return;

        final imagePath= File(imageValue.path);
        setState(() {
          this._workDoneImage=imagePath;
          Navigator.of(context).push(MaterialPageRoute(builder: (context)
          =>OdWorkDonePage(value: _workDoneImage, address: currentAddress, time: timeString )));
        });

      }on PlatformException catch (e) {

        print('failed to upload: $e');
      }
    }
    /*getImageODOut() async{
      try{
        final imageValue = await ImagePicker().pickImage(source: ImageSource.camera);
        if(imageValue==null) return;

        final imagePath= File(imageValue.path);
        setState(() {
          this._workDoneImage=imagePath;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)
        =>ODImageUpload(value: _workDoneImage, address: currentAddress, time: timeString,punchType:clockingType )));
      }on PlatformException catch (e) {
        print('failed to upload: $e');
      }
    }*/
    Future<void> getImageODOut() async {
      try {
        // Step 1: Pick image from camera
        final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera,
        imageQuality: 20);
        if (pickedFile == null) return;

        // Step 2: Convert XFile → File
        final File imageFile = File(pickedFile.path);

        // Step 3: Update state
        if (!mounted) return; // avoid setState after widget dispose
        setState(() => _workDoneImage = imageFile);

        // Step 4: Navigate to upload page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ODImageUpload(
              value: _workDoneImage,
              address: currentAddress,
              time: timeString,
              punchType: clockingType,
            ),
          ),
        );
      } on PlatformException catch (e) {
        debugPrint('❌ Failed to pick image: $e');
      } catch (e, s) {
        debugPrint('⚠️ Unexpected error: $e\n$s');
      }
    }

    return Column(
      children: [
        Expanded(
            child: Container(
              child: Card(
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude),
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  onMapCreated: (GoogleMapController controler) {
                    googleMapController = controler;
                  },
                ),
              ),
            )),
        Container(height: 10, color: Colors.white70),

        SingleChildScrollView(
          child: Container(
            color: context.cardColor,
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    //title: Text({_loginModel.data?.userLoginned?.name}==null ?' ': " Name "),
                    title: Text(UserName),
                    subtitle: Text('$currentAddress'),
                    leading: Container(
                      child:imageString==null ? Center(child : CircularProgressIndicator()) :CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(imageString!),
                        backgroundColor: Colors.grey,
                        // child: Image.network(imageString!),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 20, width: 0, color: context.cardColor),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Today Date"),
                          ),
                          Container(
                              height: 12, color: Colors.white70),
                          Padding(padding: EdgeInsets.all(0)),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 25,
                            width: 125,
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
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Today Time"),
                          ),
                          Container(
                              height: 12, color: Mythemes.whiteShadeSeventy),
                          Padding(padding: EdgeInsets.all(0)),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 25,
                            width: 125,
                            child: Text(
                              '$timeString',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          margin: EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () async{
                              bool internetCheck = await InternetConnectionChecker().hasConnection;
                              if(internetCheck == false) {
                                setState(() {
                                  AlertDialog(
                                    content: "Please check your internet connection".text.make(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Please check your Internet connection."),
                                  ));
                                });

                              }
                              else {
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
                                            'You have enabled a mock or fake location. Please disable it to proceed with marking your OD.'),
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
                                  clockingType="In";
                                  getImageODIn();
                                }

                              }

                              /*    getUploadImage();
                                clockingType = "In";
                                print("click in");
                                _getId();
                                *//*await AndroidMultipleIdentifier
                                                .requestPermission();*//*
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
                                Container(
                                    height: 5),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  //margin: EdgeInsets.all(5),
                                  child: Text(
                                    "OD In",
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
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          margin: EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () async{
                              bool internetCheck = await InternetConnectionChecker().hasConnection;
                              if(internetCheck == false) {
                                setState(() {
                                  AlertDialog(
                                    content: "Please check your internet connection".text.make(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Please check your Internet connection."),
                                  ));
                                });

                              }
                              else {
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
                                  getImageForWorkdone();
                                }

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
                                    backgroundColor: Mythemes.lightBluishColor,
                                    radius: 30,
                                  ),
                                ),
                                Container(
                                    height: 5),
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
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          margin: EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () async{
                              bool internetCheck = await InternetConnectionChecker().hasConnection;
                              if(internetCheck == false) {
                                setState(() {
                                  AlertDialog(
                                    content: "Please check your internet connection".text.make(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Please check your Internet connection."),
                                  ));
                                });

                              }
                              else {
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
                                            'You have enabled a mock or fake location. Please disable it to proceed with marking your OD.'),
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
                                  clockingType = "Out";
                                  getImageODOut();
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
                                    backgroundColor: Mythemes.dangerColorOne,
                                    radius: 30,
                                  ),
                                ),
                                Container(
                                    height: 5),
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "OD Out",
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
                  ).p8(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
