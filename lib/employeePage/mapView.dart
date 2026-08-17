import 'dart:async';
import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/employeePage/employeeListPage.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../themes/empThemes.dart';
import 'empTimeLinePage.dart';
import 'modalClasses/historyTrackModal.dart';
import 'dart:ui' as ui;

class HistoryMapView extends StatefulWidget {
  String empName;
  int? empId;

  HistoryMapView(this.empName, this.empId, {super.key});

  @override
  State<HistoryMapView> createState() => _HistoryMapViewState(empName, empId);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
HistoryTrackingModal? historyTrackingModalGlobal;
String? selectedDate;
var ltt = 0.0;
var lngg = 0.0;
var taskLtt;
var taskLang;

class _HistoryMapViewState extends State<HistoryMapView> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlng = <LatLng>[
    //LatLng(ltt, lngg), LatLng(taskLtt!, taskLang!),
  ];

  _HistoryMapViewState(String empName, int? empId);

  var empNames;
  var empIds;

  var distanceLength;
  var inImage;
  var outImage;

  var defaultDate = "DD-MM-YYYY";

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    //addCustomIcon();
    empNames = empName;
    empIds = empId;

    Future.delayed(Duration.zero, () {
      dateSelection();
      final List<LatLng> latlng = <LatLng>[];
    });

    // TODO: implement initState
    super.initState();
    _determinePosition();
    _getUserLocation();
    //selectedDate = _dateController;
  }

  dateSelection() async {
    DateTime? date = DateTime.now();
    FocusScope.of(context).requestFocus(FocusNode());

    date = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );
    setState(() {
      singleDateString = DateFormat('dd-MM-yyyy').format(date!);
      _dateController.text = DateFormat("yyyy-MM-dd").format(date);
      selectedDate = _dateController.text;
      getSharedPrfanceList();

      //  DateFormat.yMd().format(date!).toString();
    });

  }

  Future<HistoryTrackingModal> getTracking(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.historyTracking;

    // âœ… Clear previous tracking data before fetching new data
    setState(() {
      _markers.clear();
      _polyline.clear();
    });

    // âœ… API Call
    var urlapi = Uri.parse(
      "$conn$apiUrl?sessionId=$sessionId&date=$selectedDate&empId=$empId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    // âœ… Decode JSON Response
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];

    // âœ… Parse Response into Model
    HistoryTrackingModal historyTrackingModal = HistoryTrackingModal.fromJson(
      mapResponse,
    );

    // âœ… Ensure Distance Data is Updated
    distanceLength = historyTrackingModal.distance;

    // âœ… Clear previous images before loading new ones
    inImage = null;
    outImage = null;

    // âœ… Load Punch In & Out Images
    for (int i = 0; i < historyTrackingModal.attData!.length; i++) {
      inImage = historyTrackingModal.attData![i].inPhoto;
      outImage = historyTrackingModal.attData![i].outPhoto;
    }

    // âœ… Ensure UI updates with new data
    setState(() {});

    return historyTrackingModal;
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/workdoneMarker.png",
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  Uint8List? marketimages;
  List<String> images = ['assets/images/workdoneMarker.png'];

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  final Set<Polyline> _polyline = {};

  /*loadDataOld() async {
    List<LatLng> newPunchLatlng=[];
    List<LatLng> newPunchOutLatlng=[];
    List<LatLng> newAddLatlng=[];

    for(int i=0 ; i<historyTrackingModalGlobal!.attData!.length;i++){
      final Uint8List markIcons = await getImages('assets/images/fingerMaker.png', 200);
      print('lengthPunchIn $i');
      var long = historyTrackingModalGlobal!.attData![i].inlng;
      print('object2 $long');
      var lati = historyTrackingModalGlobal!.attData![i].inlat;
      var inImage = historyTrackingModalGlobal!.attData![i].inPhoto;
      if(lati != null || long != null) {
        newPunchLatlng.add(LatLng(lati, long));
      }

      setState(() {
        _markers.add(Marker(markerId: MarkerId(i.toString()), icon: BitmapDescriptor.fromBytes(markIcons),
            position: LatLng(lati, long),
            onTap: () {

              _customInfoWindowController.addInfoWindow!(
                  Card(
                    child: Container(
                      height: 300,
                      width: 200,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('$inImage'),
                                fit: BoxFit.fitWidth,
                                filterQuality: FilterQuality.high,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),

                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        historyTrackingModalGlobal!.attData![i].inAddress.toString(), style: TextStyle(color: Mythemes.black),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      historyTrackingModalGlobal!.attData![i].inDate.toString(), style: TextStyle(color: Mythemes.black),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      historyTrackingModalGlobal!.attData![i].inTime.toString(), style: TextStyle(color: Mythemes.black),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  newPunchLatlng[i]
              );
            }
        ));
      });



      setState(() {

      });
      _polyline.add(
          Polyline(
            geodesic: true,
            endCap: Cap.roundCap,
            jointType: JointType.mitered,
            width: 10,
            polylineId: PolylineId('1'),
            points: newPunchLatlng,
            color: Mythemes.lightBluishColor,
          )
      );
    }

    for(int i=0 ; i<historyTrackingModalGlobal!.attData!.length;i++){
      final Uint8List markIcons = await getImages('assets/images/fingerMakerOut.png', 200);
      print('lengthPunchOut $i');
      var outLong = historyTrackingModalGlobal!.attData![i].outlng;
      var outLati = historyTrackingModalGlobal!.attData![i].outlat;
      var outImage = historyTrackingModalGlobal!.attData![i].outPhoto;
      if(outLong != null || outLati != null) {
        newPunchOutLatlng.add(LatLng(outLati, outLong));
      }

      setState(() {
        _markers.add(Marker(markerId: MarkerId(i.toString()), icon: BitmapDescriptor.fromBytes(markIcons),
            position: LatLng(outLati, outLong),
            onTap: () {

              _customInfoWindowController.addInfoWindow!(
                  Card(
                    child: Container(
                      height: 300,
                      width: 200,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('$outImage'),
                                fit: BoxFit.fitWidth,
                                filterQuality: FilterQuality.high,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),

                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        historyTrackingModalGlobal!.attData![i].outAddress.toString(), style: TextStyle(color: Mythemes.black),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      historyTrackingModalGlobal!.attData![i].outDate.toString(), style: TextStyle(color: Mythemes.black),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      historyTrackingModalGlobal!.attData![i].outTime.toString(), style: TextStyle(color: Mythemes.black),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  newPunchOutLatlng[i]
              );
            }
        ));
      });



      setState(() {

      });
      _polyline.add(
          Polyline(
            geodesic: true,
            endCap: Cap.roundCap,
            jointType: JointType.mitered,
            width: 10,
            polylineId: PolylineId('2'),
            points: newPunchOutLatlng,
            color: Mythemes.lightBluishColor,
          )
      );
    }

    for(int i=0 ; i<historyTrackingModalGlobal!.taskData!.length;i++){
      final Uint8List markIcons = await getImages('assets/images/workdoneMarker.png', 200);
      print('lengthI $i');
      var latlng = double.parse(historyTrackingModalGlobal!.taskData![i].tasklng);
      var ltt = double.parse(historyTrackingModalGlobal!.taskData![i].tasklat);
      var taskImage = historyTrackingModalGlobal!.taskData![i].taskPhoto;
      newAddLatlng.add(LatLng(ltt, latlng));
      setState(() {
        _markers.add(
            Marker(

                draggable: true,
                zIndex: 0,
                markerId: MarkerId(i.toString()), icon: BitmapDescriptor.fromBytes(markIcons),
                position: LatLng(ltt, latlng),
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                      Card(
                        child: Container(
                          height: 300,
                          width: 200,
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage('$taskImage'),
                                    fit: BoxFit.fitWidth,
                                    filterQuality: FilterQuality.high,

                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),

                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          historyTrackingModalGlobal!.taskData![i].comment.toString(), style: TextStyle(color: Mythemes.black),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            historyTrackingModalGlobal!.taskData![i].address.toString(), style: TextStyle(color: Mythemes.black),maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          historyTrackingModalGlobal!.taskData![i].taskDate.toString(), style: TextStyle(color: Mythemes.black),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      newAddLatlng[i]
                  );
                }
            ));
      });



      setState(() {

      });
      _polyline.add(
          Polyline(
            geodesic: true,
            endCap: Cap.roundCap,
            jointType: JointType.mitered,
            width: 10,
            polylineId: PolylineId('3'),
            points: newAddLatlng,
            color: Mythemes.successColor,
          )
      );
    }
  }*/

  void loadData() async {
    List<LatLng> newPunchLatlng = [];
    List<LatLng> newPunchOutLatlng = [];
    List<LatLng> newAddLatlng = [];

    // âœ… Load "In Time" Punch Data
    for (int i = 0; i < historyTrackingModalGlobal!.attData!.length; i++) {
      final Uint8List markIconsIn = await getImages(
        'assets/images/fingerMaker.png',
        150,
      );
      var inLat = historyTrackingModalGlobal!.attData![i].inlat;
      var inLng = historyTrackingModalGlobal!.attData![i].inlng;
      var inImage = historyTrackingModalGlobal!.attData![i].inPhoto;

      if (inLat != null && inLng != null) {
        LatLng inLatLng = LatLng(inLat, inLng);
        newPunchLatlng.add(inLatLng);

        _addMarker(
          'in_$i', // âœ… Unique ID for "In Time" markers
          markIconsIn,
          inLatLng,
          inImage,
          historyTrackingModalGlobal!.attData![i].inAddress,
          historyTrackingModalGlobal!.attData![i].inDate,
          historyTrackingModalGlobal!.attData![i].inTime,
        );
      }
    }

    // âœ… Load "Out Time" Punch Data
    for (int i = 0; i < historyTrackingModalGlobal!.attData!.length; i++) {
      final Uint8List markIconsOut = await getImages(
        'assets/images/fingerMakerOut.png',
        150,
      );
      var outLat = historyTrackingModalGlobal!.attData![i].outlat;
      var outLng = historyTrackingModalGlobal!.attData![i].outlng;
      var outImage = historyTrackingModalGlobal!.attData![i].outPhoto;

      if (outLat != null && outLng != null) {
        LatLng outLatLng = LatLng(outLat, outLng);
        newPunchOutLatlng.add(outLatLng);

        _addMarker(
          'out_$i', // âœ… Unique ID for "Out Time" markers
          markIconsOut,
          outLatLng,
          outImage,
          historyTrackingModalGlobal!.attData![i].outAddress,
          historyTrackingModalGlobal!.attData![i].outDate,
          historyTrackingModalGlobal!.attData![i].outTime,
        );
      }
    }

    // âœ… Add Polyline for In Punch Data
    if (newPunchLatlng.isNotEmpty) {
      _addPolyline('in_polyline', newPunchLatlng, Colors.blue);
    }

    // âœ… Add Polyline for Out Punch Data
    if (newPunchOutLatlng.isNotEmpty) {
      _addPolyline('out_polyline', newPunchOutLatlng, Colors.red);
    }

    setState(() {});

    // âœ… Load Tracking Data (data)
    List<LatLng> trackingLatLng = [];
    for (int i = 0; i < historyTrackingModalGlobal!.data!.length; i++) {
      var lat = historyTrackingModalGlobal!.data![i].lat;
      var lng = historyTrackingModalGlobal!.data![i].lng;

      if (lat != null && lng != null) {
        trackingLatLng.add(LatLng(lat, lng));
      }
    }
    if (trackingLatLng.isNotEmpty) {
      _addPolyline('3', trackingLatLng, Colors.green);
    }

    // âœ… Load Task Data
    for (int i = 0; i < historyTrackingModalGlobal!.taskData!.length; i++) {
      final Uint8List markIcons = await getImages(
        'assets/images/workdoneMarker.png',
        150,
      );
      var latlng = double.parse(
        historyTrackingModalGlobal!.taskData![i].tasklng,
      );
      var ltt = double.parse(historyTrackingModalGlobal!.taskData![i].tasklat);
      var taskImage = historyTrackingModalGlobal!.taskData![i].taskPhoto;
      LatLng taskLatLng = LatLng(ltt, latlng);

      newAddLatlng.add(taskLatLng);

      _addTaskMarker(
        i,
        markIcons,
        taskLatLng,
        taskImage,
        historyTrackingModalGlobal!.taskData![i],
      );
    }
    if (newAddLatlng.isNotEmpty) _addPolyline('4', newAddLatlng, Colors.orange);
  }

  // âœ… Function to Add a Marker for Punch In & Out
  void _addMarker(
    dynamic index,
    Uint8List icon,
    LatLng position,
    String? image,
    String? address,
    String? date,
    String? time,
  ) {
    _markers.add(
      Marker(
        markerId: MarkerId('marker_$index'),
        icon: BitmapDescriptor.fromBytes(icon),
        position: position,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            _buildInfoWindow(image, address, date, time),
            position,
          );
        },
      ),
    );
    setState(() {});
  }

  // âœ… Function to Add a Marker for Tasks
  void _addTaskMarker(
    int index,
    Uint8List icon,
    LatLng position,
    String? image,
    dynamic taskData,
  ) {
    _markers.add(
      Marker(
        markerId: MarkerId('task_marker_$index'),
        icon: BitmapDescriptor.fromBytes(icon),
        position: position,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            _buildTaskInfoWindow(image, taskData),
            position,
          );
        },
      ),
    );
    setState(() {});
  }

  // âœ… Function to Add a Polyline
  void _addPolyline(String id, List<LatLng> points, Color color) {
    if (points.length < 2) {
      return; // Prevents creating polylines with < 2 points
    }
    _polyline.add(
      Polyline(
        polylineId: PolylineId(id),
        points: points,
        width: 5,
        color: color,
        endCap: Cap.roundCap,
        jointType: JointType.mitered,
        geodesic: true,
      ),
    );
    setState(() {});
  }

  // âœ… Info Window for Punch In/Out
  Widget _buildInfoWindow(
    String? image,
    String? address,
    String? date,
    String? time,
  ) {
    return Card(
      child: SizedBox(
        height: 250,
        width: 200,
        child: Column(
          children: [
            _buildImageContainer(image),
            _buildInfoRow("ðŸ“ Address:", address),
            _buildInfoRow("ðŸ“… Date:", date),
            _buildInfoRow("â° Time:", time),
          ],
        ),
      ),
    );
  }

  // âœ… Info Window for Task Data
  Widget _buildTaskInfoWindow(String? image, dynamic taskData) {
    return Card(
      child: SizedBox(
        height: 250,
        width: 200,
        child: Column(
          children: [
            _buildImageContainer(image),
            _buildInfoRow("ðŸ“Œ Comment:", taskData.comment),
            _buildInfoRow("ðŸ“ Address:", taskData.address),
            _buildInfoRow("ðŸ“… Date:", taskData.taskDate),
          ],
        ),
      ),
    );
  }

  // âœ… Helper Function to Build Image Container
  Widget _buildImageContainer(String? imageUrl) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl ?? ""),
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  // âœ… Helper Function to Build Info Row
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              value ?? "N/A",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<HistoryTrackingModal> getEmployeeList11 = getTracking(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {

        historyTrackingModalGlobal = value;

        loadData();
      });
    });
  }

  final LatLng _center = LatLng(32.5367794, -121.2714404);

  Position? position;
  LatLng? currentPostion;
  late GoogleMapController googleMapController;

  getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  String singleDateString = "";

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

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
    var lastPosition = await Geolocator.getLastKnownPosition();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);

      StreamSubscription<ServiceStatus> serviceStatusStream =
          Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
          });
    });
  }

  static final _initialCameraPosition = CameraPosition(
    zoom: 11,
    tilt: 30,
    target: LatLng(28.5367794, 77.2714404),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$empNames"),

        actions: [
          IconButton(
            onPressed: () {
              dateSelection();
            },
            icon: Icon(Icons.date_range_rounded),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Mythemes.whitish,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ), // âœ… Adds spacing for responsiveness
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // âœ… Date Button (Flexible)
                  Expanded(
                    child:
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ), // âœ… Ensures equal padding
                            backgroundColor:
                                Mythemes.whitish, // âœ… Background color
                          ),
                          onPressed: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              "Date".text.bold
                                  .color(Mythemes.black)
                                  .make(), // âœ… Title
                              selectedDate == null
                                  ? defaultDate.text
                                      .color(Mythemes.whitish)
                                      .make()
                                  : DateFormat('dd-MM-yyyy')
                                      .format(
                                        DateTime.parse(selectedDate.toString()),
                                      )
                                      .text
                                      .bold
                                      .color(Mythemes.black)
                                      .make(), // âœ… Formatted Date
                            ],
                          ),
                        ).px8(),
                  ),

                  // âœ… Distance Button (Flexible)
                  Expanded(
                    child:
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ), // âœ… Ensures equal padding
                            backgroundColor:
                                Mythemes.whitish, // âœ… Background color
                          ),
                          onPressed: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              "Distance".text.bold
                                  .color(Mythemes.black)
                                  .make(), // âœ… Title
                              (distanceLength == null
                                      ? "0 KM"
                                      : "$distanceLength KM")
                                  .text
                                  .bold
                                  .color(Mythemes.black)
                                  .make(), // âœ… Dynamic Distance
                            ],
                          ),
                        ).px8(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: false,
            mapType: MapType.normal,
            buildingsEnabled: true,
            rotateGesturesEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            markers: Set<Marker>.of(_markers),
            polylines: _polyline,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controler) {
              _customInfoWindowController.googleMapController = controler;
            },
          ),

          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 250,
            width: 300,
            offset: 35,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TimeLineEmp(empId, selectedDate),
            ),
          );
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.timeline, color: Mythemes.whitish, size: 28),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
