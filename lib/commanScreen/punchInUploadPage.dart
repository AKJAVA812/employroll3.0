import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../sharedPrefancePage/ShardPre.dart';
import '../themes/empThemes.dart';
import 'allAPIList.dart';
import 'commanNotificationPage.dart';
import 'modalClass/geofenceListModal.dart';

class ImageUploaded extends StatefulWidget {
  final File? value;
  final String time;
  final String address;
  final String? punchType;


  ImageUploaded({required this.value, required this.time, required this.address, required this.punchType});

  @override
  State<ImageUploaded> createState() => _ImageUploadedState(value,time,address,punchType);
}
final attendanceBox = Hive.box('attendanceBox');
late String? sessionId ;
int? orgnizationID=0;
SessionManager shared = SessionManager();
String? deviceId = "Unknown";

class _ImageUploadedState extends State<ImageUploaded> {
  //Hive Box
  //final _myBox = Hive.box('myBox');
  int? saveCount = 0;
  var listCount;
  //Box? _myBox;
  //List<dynamic> data = [];

  @override
  void initState() {
    print("image - $value");
    print(value!.lengthSync());
    //saveCount = _myBox.get('saveCount') ?? 0;
    // TODO: implement initState
    getSharedPrfanceList();
    //initPlatformState();
    //deleteData();
    super.initState();
  }
  //Write Data
  void writeData() async {
    //_myBox!.delete(saveCount);
    // Increment saveCount and save it to Hive
    saveCount = (saveCount ?? 0) + 1;
    //_myBox.put('saveCount', saveCount);
    DateTime now = DateTime.now();
    DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    DateFormat currentDateFormat=DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateFormatString = currentDateFormat.format(now);


    //Image Getter
    var stream = http.ByteStream(value!.openRead());
    print("Save Count - $saveCount");
    stream.cast();
    var length = await value!.length();
    var bytes = await stream.toBytes();
    var multipart = http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));


    final newData = [sessionId, clockingType, currentDateFormatString, currentAddress, lat, lng, bytes];
    //_myBox.put(saveCount, newData);
    // _myBox.put(_myBox.get(1), [sessionId, this.clockingType, currentDateFormatString, currentAddress, lat, lng, bytes]);
  }

  //Read Data
  /*void readData() {
    for (int i = 0; i <= _myBox.get(saveCount, defaultValue: 0); i++) {
      print(_myBox.get(i));
    }
  }*/
/*  void readData() {
    for(int i=0; i<=_myBox.length; i++) {
      print("Data - ${_myBox.get(listCount)}");
    }
  }*/

  /*void writeData() async{

    *//*if (value == null || sessionId == null || clockingType == null || currentAddress == null || lat == null || lng == null) {
      print('One or more required fields are null.');
      return;
    }*//*
    DateTime now = DateTime.now();
    DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    DateFormat currentDateFormat=DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateFormatString = currentDateFormat.format(now);


    //Image Getter
    var stream = http.ByteStream(value!.openRead());
    stream.cast();
    var length = await value!.length();
    var bytes = await stream.toBytes();
    var multipart = http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));

    final newData = [sessionId, clockingType, currentDateFormatString, currentAddress, lat, lng, bytes];
    int newKey = _myBox!.length ?? 0; // Generate a new key based on the current length of the box
    _myBox!.put(newKey, newData);
    readData(); // Refresh the data after writing
  }

  void readData() {
    setState(() {
      data = _myBox?.values.toList() ?? [];
    });
    print(data);
  }*/

  //Delete Data
  void deleteData() {
    //_myBox!.delete(4);
  }

  int _clickCount = 0;

  _incrementCounter() {

    print("$_clickCount");
  }
  String? _platformVersion = 'Unknown', _autoTimezone, _autoTime, _daftar = "";
  Map<String, dynamic>? _list;
  final File? value;
  final String time;
  final String address;
  final String? clockingType;
  late dynamic result;
  double lat=0;
  double lng=0;
  _ImageUploadedState(this.value,this.time,this.address,this.clockingType);

/*  Future getUploadImage() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      //final imageTemperory = File(image.path);

      final imagePermanent = await saveImagePermanent(image.path);
    } on PlatformException catch (e) {
      print('failed to upload: $e');
    }

  }*/

  Future<File> saveImagePermanent(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }



  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion, autoTimezone, autoTime;
    Map<String, dynamic>? list;

    /*try {
      autoTimezone = await GlobalSettingsList.autoTimeZone;
      list = await GlobalSettingsList.list;
      autoTime = await GlobalSettingsList.autoTime;
      print('autoupdateChange $_autoTimezone $_autoTime');
    } on PlatformException {
      print('autoupdateChangeex $_autoTimezone $_autoTime');
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
      _list = list;
      _daftar = "";
      print('autoupdateChange $_platformVersion $_autoTimezone $autoTime');
      list!.forEach((k, v) {
        _daftar = "$k : $v \n";
      });
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    lat=await shared!.getLatitude();
    getGeofenceList(sessionId!);
    lng=await shared!.getLongitude();
    orgnizationID=await shared.getOrgId();
    _getDeviceId();
/*
    print('Response snapshot: ${sessionId}');
    print('Response snapshot: ${lat}');
    print('Response snapshot: ${lng}');
    print('Response snapshot: ${orgnizationID}');*/

  }



  showDialgError(BuildContext context, result,reason) {
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
            Navigator.of(context, rootNavigator: true).pop();
            print("ORGID - $orgId");
            if (orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202) {
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
                                    // 📍 Dropdown List
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

                              // 🔘 Buttons
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
                                      uploadImage(context);
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
              uploadImage(context);
            }
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
            //uploadImage(context);
          },
          child: Text("Retry"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  slowInternetPop(BuildContext context, result,reason) {
    var alertDialog = AlertDialog(
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result,style: TextStyle(fontSize: 14),),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {

            setState(() {
              _clickCount++;
              //print("$_clickCount");
            });
            Navigator.of(context, rootNavigator: true).pop();
            if (_clickCount > 2) {
              //print("I am touched 2 times");
              //Navigator.of(context, rootNavigator: true).pop();
              savedDataLocally(context,"Data Saved Offline !"+"","Your punch is saved offline, Please sync the punch once you are in network area.");
              writeData();
              //readData();
            } else {
              print("ORGID - $orgId");
              if (orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202) {
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
                                    // 📍 Dropdown List
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

                              // 🔘 Buttons
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
                                      uploadImage(context);
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
                uploadImage(context);
              }
            }


            //Navigator.of(context, rootNavigator: true).pop();
            //uploadImage(context);
          },
          child: Text("Retry"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  savedDataLocally(BuildContext context, result,reason) {
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
            Navigator.of(context, rootNavigator: true).pop();
            //Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text("Ok"),
        ),

        /*TextButton(
          onPressed: () {
            setState(() {
              _clickCount++;
              print("$_clickCount");
            });

            if (_clickCount > 2) {
              print("I am touched 2 times");
              Navigator.of(context, rootNavigator: true).pop();
              savedDataLocally(context,"Data Saved Offline !"+"","Your punch is saved offline, Please sync the punch once you are in network area.");
              writeData();
            }

            uploadImage(context);
            //Navigator.of(context, rootNavigator: true).pop();
            //uploadImage(context);
          },
          child: Text("Retry"),
        )*/
      ],
      elevation: 24.0,
    );
    showDialog(
        context:context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<void> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();


    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Unique ID on Android
       /* print('Device ID 1 - ${androidInfo.id}');
        print("Device ID 2- ${androidInfo.serialNumber}");
        print("Device ID 3- ${androidInfo.hardware}");
        print("Device ID 4- ${androidInfo.device}");
        print("Device ID 5- ${androidInfo.board}");
        print("Device ID 6- ${androidInfo.bootloader}");
        print("Device ID 7- ${androidInfo.brand}");
        print("Device ID 8- ${androidInfo.display}");
        //print("Device ID 9- ${androidInfo.displayMetrics}");
        print("Device ID 10- ${androidInfo.fingerprint}");
        print("Device ID 11- ${androidInfo.host}");
        print("Device ID 12- ${androidInfo.isPhysicalDevice}");
        print("Device ID 13- ${androidInfo.manufacturer}");
        print("Device ID 14- ${androidInfo.model}");
        print("Device ID 15- ${androidInfo.product}");
        print("Device ID 16- ${androidInfo.tags}");
        print("Device ID 17- ${androidInfo.version}");
        print("Device ID 18- ${androidInfo.type}");
        print("Device ID 19- ${androidInfo.data}");*/
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor; // Unique ID on iOS
        print('Device ID 1 - ${iosInfo.identifierForVendor}');
      } else {
        deviceId = 'Unsupported platform';
      }
    } catch (e) {
      deviceId = 'Failed to get device ID: $e';
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchIn;
    CommonNotificationPage.showLoaderDialog(context);

    bool internetCheck = await InternetConnectionChecker().hasConnection;
    if(internetCheck == false) {
      setState(() {
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(context,"Slow Internet Connection !"+"","Your Punch in not submitted, Please try again.");
      });

    }

    var stream = http.ByteStream(value!.openRead());
    stream.cast();

    DateTime now = DateTime.now();
    DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    DateFormat currentDateFormat=DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateFormatString = currentDateFormat.format(now);
    setState(() {

    });
    var length = await value!.length();

    //var uri = Uri.parse("http://23ba-122-176-34-239.ngrok.io/restful/service/attendance/via/mobile");
    var uri = Uri.parse("$conn$apiUrl");
    var request = new http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId!;
    request.fields['currentDate'] = currentDateFormatString;
    request.fields['address'] = currentAddress;
    request.fields['clockingType'] = clockingType!;
    request.fields['lat'] = lat.toString();
    request.fields['lng'] = lng.toString();
    request.fields['firstImei'] = sessionId!;
    request.fields['secondImei'] = sessionId!;
    request.fields['macAddress'] = deviceId!;
    request.fields['deviceId'] = deviceId!;
    request.fields['battery'] = sessionId!;


    //print("stream.length");
    //print(stream.length.toString());

    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
// Construct API URL with parameters
    String apiWithParams = uri.toString() + '?' + request.fields.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

// Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    //http.Response response = await http.Response.fromStream(await request.send());

    try {
      http.Response response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 30)));
      // Process the response here

      print('Response received: ${response.body}');
      //print('URL ${response.request}');

      if(response.statusCode==500){
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(context,"Slow Internet Connection !"+"","Your Punch in not submitted, Please try again.");
      }
      result= json.decode(response.body.toString());
      String resultSuccess=result['result'];
      String reasonSuccess=result['reason'];
      print('URL ${response.request}');
      print('result${result}');
      print("Reason: ${result['reason']}, Type: ${result['reason'].runtimeType}");
      print("Result: ${result['result']}, Type: ${result['result'].runtimeType}");


      print('Response body: ${result}');

      //var response = await request.send();
      // listen for response

      //var responseData = await response.stream.bytesToString();



      if(response.statusCode==200){
        print("I am hit 2 times");
        Navigator.of(context, rootNavigator: true).pop();
        if(resultSuccess.compareToIgnoringCase("success")==0){
          showSuccessGo(context,reasonSuccess.upperCamelCase+" "+formattedDate,"Successfully Punch $clockingType");
        }else if(resultSuccess.compareToIgnoringCase("failed")==0){
          if (reasonSuccess == "non-geofence area") {
            showSuccessGo(context, reasonSuccess.upperCamelCase+" "+formattedDate, " Non Geofence Area ");
          } else {
            showSuccessGo(context,reasonSuccess.upperCamelCase, "Failed");
          }

        }
      }else {
        //Navigator.pop(context);
        showDialgError(context, result,"Your Punch Not Submitted, Please Try Again");
      }
    } on TimeoutException catch (_) {
      // Show retry popup if the request times out
      //showDialgError(context, "Alert", "Please Try again !");
    }



  }

  Future<void> uploadImageWithGeofence(BuildContext context, dynamic selectedGeofenceId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchWithGeofenceSelfie;
    CommonNotificationPage.showLoaderDialog(context);

    bool internetCheck = await InternetConnectionChecker().hasConnection;
    if(internetCheck == false) {
      setState(() {
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(context,"Slow Internet Connection !"+"","Your Punch in not submitted, Please try again.");
      });

    }

    var stream = http.ByteStream(value!.openRead());
    stream.cast();

    DateTime now = DateTime.now();
    DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    DateFormat currentDateFormat=DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateFormatString = currentDateFormat.format(now);
    setState(() {

    });
    var length = await value!.length();

    //var uri = Uri.parse("http://23ba-122-176-34-239.ngrok.io/restful/service/attendance/via/mobile");
    var uri = Uri.parse("$conn$apiUrl");
    var request = new http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId!;
    request.fields['currentDate'] = currentDateFormatString;
    request.fields['address'] = currentAddress;
    request.fields['clockingType'] = clockingType!;
    request.fields['lat'] = lat.toString();
    request.fields['lng'] = lng.toString();
    request.fields['firstImei'] = sessionId!;
    request.fields['secondImei'] = sessionId!;
    request.fields['macAddress'] = deviceId!;
    request.fields['deviceId'] = deviceId!;
    request.fields['battery'] = sessionId!;
    request.fields['geofenceId'] = sessionId!;


    //print("stream.length");
    //print(stream.length.toString());

    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
// Construct API URL with parameters
    String apiWithParams = uri.toString() + '?' + request.fields.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

// Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    //http.Response response = await http.Response.fromStream(await request.send());

    try {
      http.Response response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 30)));
      // Process the response here

      print('Response received: ${response.body}');
      //print('URL ${response.request}');

      if(response.statusCode==500){
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(context,"Slow Internet Connection !"+"","Your Punch in not submitted, Please try again.");
      }
      result= json.decode(response.body.toString());
      String resultSuccess=result['result'];
      String reasonSuccess=result['reason'];
      print('URL ${response.request}');
      print('result${result}');
      print("Reason: ${result['reason']}, Type: ${result['reason'].runtimeType}");
      print("Result: ${result['result']}, Type: ${result['result'].runtimeType}");


      print('Response body: ${result}');

      //var response = await request.send();
      // listen for response

      //var responseData = await response.stream.bytesToString();



      if(response.statusCode==200){
        print("I am hit 2 times");
        Navigator.of(context, rootNavigator: true).pop();
        if(resultSuccess.compareToIgnoringCase("success")==0){
          showSuccessGo(context,reasonSuccess.upperCamelCase+" "+formattedDate,"Successfully Punch $clockingType");
        }else if(resultSuccess.compareToIgnoringCase("failed")==0){
          if (reasonSuccess == "non-geofence area") {
            showSuccessGo(context, reasonSuccess.upperCamelCase+" "+formattedDate, " Non Geofence Area ");
          } else {
            showSuccessGo(context,reasonSuccess.upperCamelCase, "Failed");
          }

        }
      }else {
        //Navigator.pop(context);
        showDialgError(context, result,"Your Punch Not Submitted, Please Try Again");
      }
    } on TimeoutException catch (_) {
      // Show retry popup if the request times out
      //showDialgError(context, "Alert", "Please Try again !");
    }



  }

  /*Future<void> uploadImage(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.punchIn;
    CommonNotificationPage.showLoaderDialog(context);

    bool internetCheck = await InternetConnectionChecker().hasConnection;
    if (internetCheck == false) {
      setState(() {
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(
            context,
            "Slow Internet Connection !" + "",
            "Your Punch in not submitted, Please try again.");
      });
      return;
    }

    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    DateFormat currentDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateFormatString = currentDateFormat.format(now);

    // ✅ Convert image file to Base64 string
    List<int> imageBytes = await value!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    var uri = Uri.parse("$conn$apiUrl");

    // ✅ Prepare JSON body
    Map<String, dynamic> body = {
      "sessionId": sessionId!,
      "currentDate": currentDateFormatString,
      "address": currentAddress,
      "clockingType": clockingType!,
      "lat": lat.toString(),
      "lng": lng.toString(),
      "firstImei": sessionId!,
      "secondImei": sessionId!,
      "macAddress": deviceId!,
      "deviceId": deviceId!,
      "battery": sessionId!,
      "image": base64Image, // ✅ sending as base64 string
    };

    // Print API with parameters (except image, just for debug readability)
    String apiWithParams = uri.toString() +
        '?' +
        body.entries
            .where((e) => e.key != "image")
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
    print('API URL with Parameters: $apiWithParams');
    print('Image length (Base64 chars): ${base64Image.length}');

    try {
      http.Response response = await http
          .post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 30));

      print('Response received: ${response.body}');

      if (response.statusCode == 500) {
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(
            context,
            "Slow Internet Connection !" + "",
            "Your Punch in not submitted, Please try again.");
      }

      result = json.decode(response.body.toString());
      String resultSuccess = result['result'];
      String reasonSuccess = result['reason'];

      print('URL ${response.request}');
      print('result $result');
      print("Reason: ${result['reason']}, Type: ${result['reason'].runtimeType}");
      print("Result: ${result['result']}, Type: ${result['result'].runtimeType}");

      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        if (resultSuccess.compareToIgnoringCase("success") == 0) {
          showSuccessGo(
              context,
              reasonSuccess.upperCamelCase + " " + formattedDate,
              "Successfully Punch $clockingType");
        } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
          if (reasonSuccess == "non-geofence area") {
            showSuccessGo(context,
                reasonSuccess.upperCamelCase + " " + formattedDate, " Non Geofence Area ");
          } else {
            showSuccessGo(context, reasonSuccess.upperCamelCase, "Failed");
          }
        }
      } else {
        showDialgError(context, result, "Your Punch Not Submitted, Please Try Again");
      }
    } on TimeoutException catch (_) {
      // Timeout
      // showDialgError(context, "Alert", "Please Try again !");
    }
  }*/
  //code commit
/*

  // Save Punch Offline
  void savePunchOffline(Map<String, dynamic> punch) async {
    await attendanceBox.add(punch); // list style save
   */
/* ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Punch saved offline!")),
    );*//*

    setState(() {}); // Refresh UI
  }

  // Delete Punch after sync
  void deletePunch(int index) async {
    await attendanceBox.deleteAt(index);
    setState(() {});
  }

  // Mock Sync Function (Replace with API Call)
  Future<void> syncPunch(int index, Map<String, dynamic> punch) async {
    // TODO: Replace with your actual API POST call
    print("Syncing to server: $punch");

    await Future.delayed(Duration(seconds: 2)); // simulate API call

    // अगर सफल हुआ तो delete कर दें
    deletePunch(index);

   */
/* ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Punch synced successfully!")),
    );*//*

  }
*/

  showSuccessGo(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$result'),
            /*Container(
              child: "Location".text.align(TextAlign.left).color(Mythemes.greyish).make().py12() ,
            ),*/
            Container(
              child: Text(
                "Location",
                textAlign: TextAlign.left,
                style: TextStyle(color: Mythemes.greyish),
              ),
            ).py12(),
            Text(
              currentAddress,
              style: TextStyle(letterSpacing: 0.5),
            ),
           /* currentAddress.text.letterSpacing(0.5).make(),*/
          ],
        ).px8(),
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.pushNamed(buildContext, MyRoutings.punchInRoute);
            },
            child: Container(
              child: Text("Ok"),
            )
        ),

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



// ✅ Widget Method to show Geofence Dialog
  Future<void> showGeofenceDialog(
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
                      uploadImageWithGeofence(context, selectedGeofenceId); // ✅ Pass selected ID to your method
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mythemes.whitish,
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Attendance Punch'),
        leading: BackButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  PunchInOUtActivity()));
            }
        ),
      ),

      bottomNavigationBar: Container(
        color: context.cardColor,
        child: ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonPadding: Vx.mOnly(right: 16),
            children: [


              ElevatedButton(
                onPressed: (){
                  //getUploadImage();

                  print("ORGID - $orgId");
                  if (orgId == 201 || orgId == 200 || orgId == 199 || orgId == 202) {
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
                                    // 📍 Dropdown List
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

                              // 🔘 Buttons
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
                                      uploadImage(context);
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
                    uploadImage(context);
                  }

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Mythemes.lightBluishColor),
                ),
                child: "Punch $clockingType".text.make(),
              ).wh(150, 40).py32()
            ]
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Mythemes.whitish,
            width: 500,
            child:
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                value != null ? CircleAvatar(
                  maxRadius: 115,
                  backgroundColor: Mythemes.greyish,
                  backgroundImage: FileImage(value!),
                  /*child: Image.file(
                    value!,

                    fit: BoxFit.cover,),*/
                )
                    : Icon(Icons.verified_user_sharp, size: 150, color: Mythemes.greyish,),
                SizedBox(
                  height: 30,
                ),
                UploadedLocation(),
                SizedBox(
                  height: 10,
                ),
                UploadedTime(time),
                SizedBox(
                  height: 10,
                ),

                if(shared.getOrgId().toString().compareToIgnoringCase("3")==0)
                  UploadedReading(),
                SizedBox(
                  height: 100,
                ),
                //submitButton(title: 'Submit', onClick: getUploadImage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Widget submitButton({
  required String title,
  required VoidCallback onClick,
}) {
  return Container(
    child: MaterialButton(
      color: Mythemes.lightBluishColor,
      onPressed: onClick,
      child: Row(children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: title.text.color(Mythemes.whitish).make(),
          )
        )

      ],),
    ),
  );
}*/



@override
Widget UploadedLocation() {
  return Container(
    height: 80,
    child: SingleChildScrollView(
      child: Row(
        children: [
          Column(
            children: [
              Icon(Icons.add_location_outlined, size: 32, color: Mythemes.lightBluishColor,).py16(),
            ],
          ).px16(),
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child:   Container(
                    child: Text(
                      "Location",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Mythemes.greyish),
                    ),
                  ).py12(),
                ),
                /*currentAddress.text.letterSpacing(0.5).make(),*/

                Text(
                  currentAddress,
                  style: TextStyle(letterSpacing: 0.5),
                ),

              ],
            ).px8(),
          )

        ],
      ),
    ),

  );
}

@override
Widget UploadedTime(String time) {

  return Container(
    height: 68,
    child: Row(
      children: [
        Column(
          children: [
            Icon(Icons.access_time, size: 32, color: Mythemes.lightBluishColor,).py8(),
          ],
        ).px16(),
        Expanded(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: "Time".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: time.text.letterSpacing(0.5).make(),
                ),
              ),

            ],
          ).px8(),
        )

      ],
    ),

  );
}

@override
Widget UploadedReading() {
  return Container(

    height: 68,
    child: Row(
      children: [
        Column(
          children: [
            Icon(Icons.electric_meter_outlined, size: 32, color: Mythemes.lightBluishColor,).py8(),
          ],
        ).px16(),
        Expanded(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: "Meter Reading".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: "0.0".text.letterSpacing(0.5).make(),
                ),
              ),
            ],
          ).px8(),
        )

      ],
    ),

  );
}