import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/employeePage/employeeListPage.dart';
import 'package:http/http.dart' as http;
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
import 'modalClasses/liveTrackModal.dart';
import 'dart:ui' as ui;
class LiveMapView extends StatefulWidget {
  String empName;
  int? empId;

  LiveMapView(this.empName, this.empId);

  @override
  State<LiveMapView> createState() => _LiveMapViewState(empName, empId);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
LiveTrackingModal? liveTrackingModalGlobal;
String? selectedDate;
class _LiveMapViewState extends State<LiveMapView> {
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final List <Marker> _markers = <Marker>[];

  late BitmapDescriptor icon;
  _LiveMapViewState(String empName, int? empId);

  var empNames;
  var empIds;

  var distanceLength;
  var inImage;
  var outImage;
  double? ltt;
  double? lngg;
  var defaultDate = "DD-MM-YYYY";
  var todayDate = "dd-mm-yyyy";

  Position? position;
  LatLng? currentPostion;
  late GoogleMapController googleMapController;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    empNames = empName;
    empIds = empId;
    print('empNames $empName');
    print('empIds $empId');
    // TODO: implement initState
    super.initState();
    _determinePosition();
    _getUserLocation();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    todayDate = formatter.format(now);
    print('todayDate $todayDate');
    //selectedDate = _dateController;
    print('selectedDate $selectedDate');
    getSharedPrfanceList();
  }

  dateSelection() async {
    DateTime? date = DateTime.now();
    FocusScope.of(context).requestFocus(new FocusNode());

    date = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate:DateTime(1947),
        lastDate: DateTime.now().add(Duration(days: 0)));
    setState(() {
      singleDateString = DateFormat('dd-MM-yyyy').format(date!);
      _dateController.text = DateFormat("yyyy-MM-dd").format(date!);
      selectedDate = _dateController.text;
      getSharedPrfanceList();

      //  DateFormat.yMd().format(date!).toString();
    });

    print(date);
  }



  Future<LiveTrackingModal> getTracking(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.historyTracking;
    print('employeeList11: ${SessionId}');
    LiveTrackingModal liveTrackingModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "date=$todayDate&"
        "empId=$empId"
    );
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');


    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    liveTrackingModal=LiveTrackingModal.fromJson(mapResponse);


    for(int i=0; i<liveTrackingModal!.attData!.length;i++){
      inImage = liveTrackingModal!.attData![i].inPhoto;

      print('inImage $inImage');
      print('outImage $outImage');
    }
    distanceLength = liveTrackingModal!.distance;

    return liveTrackingModal;
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
    var lastPosition = await Geolocator.getLastKnownPosition();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Response1111l $lastPosition');

    setState(() {
      //currentPostion = LatLng(ltt, lngg);
      //print('Response1111c $currentPostion');

      StreamSubscription<ServiceStatus> serviceStatusStream =
      Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
        print('Response1111s $status');
      });
      print('Response1111s $serviceStatusStream');
    });

  }


  Uint8List? marketimages;
  List<String> images = ['assets/images/workdoneMarker.png'];


  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }


  final Set<Polyline> _polyline = {};

  loadData() async {
    List<LatLng> newPunchLatlng=[];
    List<LatLng> newAddLatlng=[];

    for(int i=0 ; i<liveTrackingModalGlobal!.attData!.length;i++){
      final Uint8List markIcons = await getImages('assets/images/fingerMaker.png', 200);
      print('lengthPunchIn $i');
      var long = liveTrackingModalGlobal!.attData![i].inlng;
      print('object2 $long');
      var lati = liveTrackingModalGlobal!.attData![i].inlat;
      var inImage = liveTrackingModalGlobal!.attData![i].inPhoto;
      newPunchLatlng.add(LatLng(lati, long));
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
                                        liveTrackingModalGlobal!.attData![i].inAddress.toString(), style: TextStyle(color: Mythemes.black),
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
                                      liveTrackingModalGlobal!.attData![i].inDate.toString(), style: TextStyle(color: Mythemes.black),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      liveTrackingModalGlobal!.attData![i].inTime.toString(), style: TextStyle(color: Mythemes.black),
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

    for(int i=0 ; i<liveTrackingModalGlobal!.taskData!.length;i++){
      final Uint8List markIcons = await getImages('assets/images/workdoneMarker.png', 200);
      print('lengthI $i');
      var latlng = double.parse(liveTrackingModalGlobal!.taskData![i].tasklng);
      var ltt = double.parse(liveTrackingModalGlobal!.taskData![i].tasklat);
      var taskImage = liveTrackingModalGlobal!.taskData![i].taskPhoto;
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
                                          liveTrackingModalGlobal!.taskData![i].comment.toString(), style: TextStyle(color: Mythemes.black),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            liveTrackingModalGlobal!.taskData![i].address.toString(), style: TextStyle(color: Mythemes.black),maxLines: 1,
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
                                          liveTrackingModalGlobal!.taskData![i].taskDate.toString(), style: TextStyle(color: Mythemes.black),
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
  }
  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LiveTrackingModal> getEmployeeList11 = getTracking(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        liveTrackingModalGlobal=value;
        loadData();
      });
      print('employeeList00${liveTrackingModalGlobal!.data!.length}');

     /* for(int i=0; i<liveTrackingModalGlobal!.data!.length;i++){
        ltt = liveTrackingModalGlobal!.data![i].lat;
        lngg = liveTrackingModalGlobal!.data![i].lng;

        print('latt $ltt');
        print('longg $lngg');
      }*/

      /*markers.clear();
      print('lttt $ltt');
      print('long $lngg');

      markers.add(Marker(markerId: const MarkerId('currentLocation'),
          position: LatLng(ltt! , lngg!),
          icon: BitmapDescriptor.defaultMarker,

          infoWindow: InfoWindow(
            title: CircleAvatar(
              backgroundColor: Mythemes.greyish,
              radius: 25,
              backgroundImage: NetworkImage('$inImage'),
            ).toString(),
          )

      ));*/
    });

    //Position position = await _determinePosition();


    /*googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(28.5318562, 77.2731763), zoom: 17)));*/




      print('Response1111c Onpressed $position');

  }
  LatLng _center = LatLng(32.5367794, -121.2714404);


  getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  String singleDateString="";

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

  Set<Marker> markers = {


  };


  static final _initialCameraPosition = CameraPosition(
    zoom: 10,
    target: LatLng(28.5367794, 77.2714404),
    tilt: 30.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$empNames"),

        actions: [
          Center(
            child: "Live".text.xl.color(Mythemes.black).make().px8()
                .badge(
              size: 10,
              color: Mythemes.dangerColor
            ).px8(),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Mythemes.whitish,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding: Vx.mOnly(right: 30),
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                            //primary: Mythemes.whitish,
                        elevation: 0

                        ),

                        onPressed: (){},
                        child: Column(
                          children: [
                            Row(
                             children: [
                               "Date".text.color(Mythemes.blackish).make(),
                             ],
                            ),
                            Row(
                              children: [

                                todayDate == null ? defaultDate.text.color(Mythemes.blackish).make() :

                                DateFormat('dd-MM-yyyy').format(DateTime.parse(todayDate)).text.color(Mythemes.blackish).make()
                              ],
                            ),
                          ],
                        ),
                    ).px16(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          //primary: Mythemes.whitish, elevation: 0
                      ),
                      onPressed: (){},
                      child: Column(
                        children: [
                          Row(
                            children: [
                              "Distance".text.color(Mythemes.blackish).make(),
                            ],
                          ),
                          Row(
                            children: [
                              distanceLength == null ? "0 KM".text.color(Mythemes.blackish).make() :
                              '$distanceLength KM'.toString().text.color(Mythemes.blackish).make()
                            ],
                          ),
                        ],
                      ),
                    ).px16(),
                  ]),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapType: MapType.normal,
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

          CustomInfoWindow(controller: _customInfoWindowController,
            height: 250,
            width: 300,
            offset: 35,
          )
        ]
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
              TimeLineEmp(empId,selectedDate)));
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(
          Icons.timeline, color: Mythemes.whitish, size: 28,
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 17)));

          setState(() {
            markers.clear();

            markers.add(Marker(markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude)));

            print('Response1111c Onpressed $position');
          });

        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.location_history),
      ),*/
    );
  }
}
