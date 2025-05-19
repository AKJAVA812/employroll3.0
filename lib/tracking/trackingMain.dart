
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/tracking/DB/SaveLatlng.dart';
import 'package:er_flutter_project/tracking/LocationClient.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'dart:math' show asin, cos, sqrt;
import 'dart:developer';

import 'package:workmanager/workmanager.dart';

import '../main.dart';
import 'LocationPermissionRequest.dart';

const String taskName = "background_location_task";
/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
   // _listenLocation();
    getlocation();
    return Future.value(false);
  });
}*/

/*
void getlocation()
{
  print("Wrok manager working ");
}
*/

class Trackingmain extends StatefulWidget {
  const Trackingmain({super.key});

  @override
  State<Trackingmain> createState() => _TrackingmainState();
}

class _TrackingmainState extends State<Trackingmain> {
  final _locationClient = LocationClient();
  final Set<Polyline> _polylines = {};
  final _points = <LatLng>[];
  LatLng? _currPosition;
  bool _isServiceRunning = false;
  late GoogleMapController _mapController;
  late LocationSettings locationSettings;
  final Set<Marker> _markers = {};
  final databaseLatlngSave = SaveLatlng();


  @override
  void initState() {
    // TODO: implement initState
    //workManagerMain();
    //requestLocationPermissions();
    initDBLatlng();
    _requestLocationPermission();
    _locationClient.init();
    _listenLocation();

    //getLatlngAll();
    //_addPolyline();
    //_addMarker();
    initDBLatlng();
    super.initState();
  }
  /*void workManagerMain() async
  {
    WidgetsFlutterBinding.ensureInitialized();

    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    await Workmanager().registerPeriodicTask(
      "1",
      taskName,
      frequency: Duration(minutes: 15), // Runs every 10 minutes
    );
  }*/

  initDBLatlng() async {
    await databaseLatlngSave.init();
    getLatlngAll();
    String deviceIdString = await getUniqueDeviceId();

    print('deviceIdString ${deviceIdString}');
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

      /*  var time = DateTime.timestamp();
        final timeFormat = DateFormat('yyyy-MM-dd hh:mm');
        print(timeFormat.format( DateTime.fromMillisecondsSinceEpoch(myvalue*1000)));
        print("time ${timeFormat.toString()}");*/
        String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
        print('time $formattedDate');
        //print("laglng $_currPosition");
        if(_points.length>2){
          //print("print $_points[_points.length-2].latitude $_points[_points.length-2].longitude");
          //print("print $_points[_points.length-1].latitude $_points[_points.length-1].longitude");
          for(int i=0 ;i<=_points.length-1;i++){
            double latlng = _points[i].longitude;
            print("latlnd $i  $latlng");
          }
          totalDistance = calculateDistance(_points[_points.length-2].latitude, _points[_points.length-2].longitude, _points[_points.length-1].latitude, _points[_points.length-1].longitude);
          print("Total distance :- $totalDistance");
          String latLngString = '${_currPosition?.latitude},${_currPosition?.longitude}';
          print('latlong String  $latLngString');

          insertLatlngData(latLngString,  formattedDate);

          _points.add(_currPosition!);
          //_addPolyline();
          //_addMarker();
          //Stop service
          /*if(_points.length>50){
            _locationClient.stopLocationService();
            print("location Stop");
          }*/
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
    print('insertLatlng $latlng');
    print('insertLatlng $time');
    Map<String, dynamic> rowData = {
      SaveLatlng.latlng : latlng,
      SaveLatlng.timestamp : time,
    };
    final latlngIdSave = databaseLatlngSave.insertlatlng(rowData);
    print("Save latlng $latlngIdSave");
  }

  void getLatlngAll() async {
    //final allLatlng = await databaseLatlngSave.queryAllRowCount();
    final allLatlng = await databaseLatlngSave.getAllData();
    //print('total number Data $allLatlng');
    log('data $allLatlng');
    print(allLatlng);
    for (final row in allLatlng) {
        print("latlng ${row[SaveLatlng.id]}");
        print("latlng ${row[SaveLatlng.latlng]}");
        print("latlng ${row[SaveLatlng.timestamp]}");
      }
  }

  Future<void> requestLocationPermissions() async {
    PermissionStatus permission = await Location().requestPermission();
    final Location location = Location();

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return Future.value(false);
    }
    if(permissionGranted==PermissionStatus.deniedForever){
      print("location permission not granted");
      openAppSettingsDialog();
      return ;
    }
/*
    LocationData? currentLocation = await location.getLocation();
    print("Background Location: ${currentLocation.latitude}, ${currentLocation.longitude}");
*/

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

  void _addPolyline() {
    final polyline = Polyline(
      polylineId: PolylineId("route1"),
      color: Colors.blue,
      width: 4,
      points: _points,
    );
    setState(() {
      print("Polyline Mapping ");
      _polylines.add(polyline);
    });
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
  void _addMarker() {
    final marker = Marker(
      markerId: MarkerId('marker_1'),
      position: _points[0], // Marker position
      infoWindow: InfoWindow(
        title: 'San Francisco',
        snippet: 'This is a marker in San Francisco!',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      print("Add marker running ${_points[0].longitude}");
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, _) {
              return _currPosition == null
                  ? const CircularProgressIndicator()
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(_currPosition!.latitude,
                              _currPosition!.longitude),
                          zoom: 14),
                      //markers:_markers,
                      polylines: _polylines,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      mapToolbarEnabled: true,
                    );

              /* FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  //initialCenter:  LatLng(_currPosition!.latitude,_currPosition!.latitude),
                ),*/
              /*children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.geolocation.app',
                  ),

                ],*/
            },
          ),
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(_currPosition,id: "001",offset: ,this),
        child: const Icon(Icons.location_on),
      ),*/
    );

  }

}
