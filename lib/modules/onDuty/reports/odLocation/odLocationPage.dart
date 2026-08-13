import 'dart:async';
import 'dart:io';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'odPunchUpload.dart';
import 'odWorkDonePage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class ODLocationView extends StatefulWidget {
  const ODLocationView({Key? key}) : super(key: key);

  @override
  State<ODLocationView> createState() => _ODLocationViewState();
}
StreamSubscription<Position>? positionStream;

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));

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
  LatLng? currentPostion;
  GoogleMapController? _mapController;
  late GoogleMapController googleMapController;
  Timer? _clockTimer;
  String? _locationError;
  bool _isLocating = true;

  @override
  void initState() {
    super.initState();
    getUserName();
    timeString = _formatDateTime(DateTime.now());
    _clockTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _initializeLocation();
  }
  Future getUserName() async {
    UserName = await shared.getempName();
    print('Response snapshot: ${UserName}');
  }

  Future<void> _initializeLocation() async {
    if (mounted) {
      setState(() {
        _isLocating = true;
        _locationError = null;
      });
    }
    try {
      final savedLat = await shared.getLatitude();
      final savedLng = await shared.getLongitude();
      if (savedLat != 0 && savedLng != 0 && mounted) {
        setState(() => currentPostion = LatLng(savedLat, savedLng));
      }

      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Please enable location service.';
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw 'Location permission is required for OD punch.';
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        currentPostion = LatLng(position.latitude, position.longitude);
        _locationError = null;
      });
      await shared.setLatitude(position.latitude);
      await shared.setLongitude(position.longitude);
      await getAddress(position);
      _startLocationTracking();
    } catch (error) {
      if (mounted) setState(() => _locationError = error.toString());
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }


  void _startLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // update every 5 meter movement
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position pos) {
      if (!mounted) return;
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
          CameraUpdate.newLatLng(
            LatLng(pos.latitude, pos.longitude),
          ),
        );
      }

      print('🏃‍♂️ Position Updated: $currentPostion');
    });
  }

  Future<void> getAddress(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        print("❌ No placemark found");
        return;
      }

      final p = placemarks.first;

      // Build address safely (ignores null values)
      final List<String> addressParts = [
        p.street ?? '',
        p.name ?? '',
        p.subLocality ?? '',
        p.locality ?? '',
        p.administrativeArea ?? '',
        p.country ?? '',
        p.postalCode ?? '',
      ];

      // Join non-null, non-empty values
      // Filter empty strings and join
      final formattedAddress = addressParts
          .where((part) => part.trim().isNotEmpty)
          .join(", ");

      if (!mounted) return;
      setState(() {
        currentAddress = formattedAddress;
      });

      print('📍 Current Address: $currentAddress');

    } catch (e) {
      print("❌ Error getting address: $e");
      currentAddress = "Address Not Find";
    }
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
  void dispose() {
    _clockTimer?.cancel();
    positionStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<bool> _ensureLocationReady() async {
    if (currentPostion != null) return true;
    await _initializeLocation();
    if (currentPostion != null) return true;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_locationError ?? 'Current location unavailable.')),
      );
    }
    return false;
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
                child: currentPostion == null
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isLocating) const CircularProgressIndicator(),
                          if (!_isLocating)
                            const Icon(Icons.location_off_outlined, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            _locationError ?? 'Getting current location...',
                            textAlign: TextAlign.center,
                          ),
                          if (!_isLocating)
                            TextButton.icon(
                              onPressed: _initializeLocation,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                        ],
                      ),
                    )
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
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: imageString?.trim().isNotEmpty == true
                          ? NetworkImage(imageString!)
                          : null,
                      child: imageString?.trim().isNotEmpty == true
                          ? null
                          : const Icon(Icons.person, color: Colors.white),
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
                              if (!await _ensureLocationReady()) return;
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
                              if (!await _ensureLocationReady()) return;
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
                              if (!await _ensureLocationReady()) return;
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
