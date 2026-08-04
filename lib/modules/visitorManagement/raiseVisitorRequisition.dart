import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;


import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';

class RaiseVisitorRequisition extends StatefulWidget {
  final File? value;


  RaiseVisitorRequisition({required this.value});

  @override
  State<RaiseVisitorRequisition> createState() => _RaiseVisitorRequisitionState(value);
}
late String? sessionId ;
int? orgnizationID=0;
SessionManager shared = SessionManager();
String? deviceId = "Unknown";

class _RaiseVisitorRequisitionState extends State<RaiseVisitorRequisition> {
  //Hive Box
  final _myBox = Hive.box('myBox');
  int? saveCount = 0;
  var listCount;
  //Box? _myBox;
  //List<dynamic> data = [];
  var fullName = "";
  var mobileNo = "";
  var purpose = "";
  var host = "";
  var time = "";
  final String phoneNumber = "+99******1233";

  @override
  void initState() {
    print("image - $value");
    print(value!.lengthSync());
    saveCount = _myBox.get('saveCount') ?? 0;
    // TODO: implement initState
    getSharedPrfanceList();
    //initPlatformState();
    //deleteData();
    super.initState();
  }
  //Write Data
  void writeData() async {
    _myBox.delete(saveCount);
    // Increment saveCount and save it to Hive
    saveCount = (saveCount ?? 0) + 1;
    _myBox.put('saveCount', saveCount);
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
    _myBox.put(saveCount, newData);
    // _myBox.put(_myBox.get(1), [sessionId, this.clockingType, currentDateFormatString, currentAddress, lat, lng, bytes]);
  }

  //Read Data
  void readData() {
    for (int i = 0; i <= _myBox.get(saveCount, defaultValue: 0); i++) {
      print(_myBox.get(i));
    }
  }


  //Delete Data
  void deleteData() {
    _myBox.delete(4);
  }

  int _clickCount = 0;

  _incrementCounter() {

    print("$_clickCount");
  }
  String? _platformVersion = 'Unknown', _autoTimezone, _autoTime, _daftar = "";
  Map<String, dynamic>? _list;
  final File? value;
  late var result;
  double lat=0;
  double lng=0;
  _RaiseVisitorRequisitionState(this.value);

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
    sessionId = await shared.getSessionId();
    lat=await shared.getLatitude();

    lng=await shared.getLongitude();
    orgnizationID=await shared.getOrgId();
    _getDeviceId();

    print('Response snapshot: ${sessionId}');
    print('Response snapshot: ${lat}');
    print('Response snapshot: ${lng}');
    print('Response snapshot: ${orgnizationID}');

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
            uploadImage(context);
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
              //Navigator.pop(context);
              savedDataLocally(context,"Data Saved Offline !"+"","Your punch is saved offline, Please sync the punch once you are in network area.");
              writeData();
              readData();
            } else {
              uploadImage(context);
            }


            //Navigator.pop(context);
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
            //Navigator.pop(context);
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
              Navigator.pop(context);
              savedDataLocally(context,"Data Saved Offline !"+"","Your punch is saved offline, Please sync the punch once you are in network area.");
              writeData();
            }

            uploadImage(context);
            //Navigator.pop(context);
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
        print('Device ID 1 - ${androidInfo.id}');
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
        print("Device ID 19- ${androidInfo.data}");
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
    var length = await value!.length();
    print('Response status - Image: ${length}');
    print('Response Date: ${currentDateFormatString}');
    print('Response body: ${stream}');
    print('Response body: ${value}');
    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sucessfully Run"+formattedDate!),
      ));*/
    //var uri = Uri.parse("http://23ba-122-176-34-239.ngrok.io/restful/service/attendance/via/mobile");
    var uri = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("Post", uri);
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
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sucessfully Run"+orgnizationID.toString()!),
      ));*/
    var multipart = http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);

    //http.Response response = await http.Response.fromStream(await request.send());

    try {
      http.Response response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 30)));
      // Process the response here

      print('Response received: ${response.body}');
      print('URL ${response.request}');
      if(response.statusCode==500){
        Navigator.of(context, rootNavigator: true).pop();
        slowInternetPop(context,"Slow Internet Connection !"+"","Your Punch in not submitted, Please try again.");
      }
      result= json.decode(response.body.toString());
      String resultSuccess=result['result'];
      String reasonSuccess=result['reason'];
      print('URL ${response.request}');
      print('result${result}');

      /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+result['result']),
    ));*/
      /*Timer(const Duration(seconds: 10), () {
      print("Timer is done");
      Navigator.of(context, rootNavigator: true).pop();
      showDialgError(context, "Alert", "Please Try again !");
    },);*/
      print('Response body: ${result}');

      //var response = await request.send();
      // listen for response
      /* response.stream.transform(utf8.decoder).listen((value) {
        //var body = json.decoder(value);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Sucessfully Run" + value),
        ));
      });*/
      //var responseData = await response.stream.bytesToString();



      if(response.statusCode==200){
        Navigator.of(context, rootNavigator: true).pop();
        if(resultSuccess.compareToIgnoringCase("success")==0){
          CommonNotificationPage.showSuccessGo(context,reasonSuccess.upperCamelCase+" "+formattedDate,"Successfully Punch");
        }else if(resultSuccess.compareToIgnoringCase("failed")==0){
          if (reasonSuccess == "non-geofence area") {
            showSuccessGo(context, result, " Non Geofence Area ");
          } else {
            CommonNotificationPage.showSuccessGo(context,reasonSuccess.upperCamelCase, " Failed ");
          }

        }
      }else {
        Navigator.of(context, rootNavigator: true).pop();
        showDialgError(context, result,"Your Punch Not Submitted, Please Try Again");
      }
    } on TimeoutException catch (_) {
      // Show retry popup if the request times out
      showDialgError(context, "Alert", "Please Try again !");
    }



  }

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
      content: Stack(
        children: <Widget>[
         /* Container(
            child: "Location".text.align(TextAlign.left).color(Mythemes.greyish).make() ,
          ),
          currentAddress.text.letterSpacing(0.5).make().py20(),*/
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
        ],
      ).px8(),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
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

  String valuenew="listText";
  String valuenewOne="listText";
  var dropdownNewvalue;
  var dropdownNewvalueOne;
  String _inTimePicker = '00:00';

  void imagePickerModal(BuildContext context,
      {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 450,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    "Verification Code".text.fontFamily('Raleway').color(Mythemes.blackishade).size(24).make().px8(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    "We have sent the code verification to".text.fontFamily('Raleway').color(Mythemes.greyish).size(14).make().px8(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Mythemes.black, // Set the color for the phone number text
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Define the action when "Change phone number?" is clicked
                        print("Change phone number clicked!");
                      },
                      child: Text(
                        'Change phone number?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue, // Set the color for the clickable text
                          decoration: TextDecoration.underline, // Optional underline for the link-like appearance
                        ),
                      ),
                    ),
                  ],
                ).py8().px8(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          elevation: 0.5,
          title: Text('Visitor Requisition'),
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

                    //uploadImage(context);
                    imagePickerModal(context,
                        onCameraTap: () {}, onGalleryTap: () {});

                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Mythemes.lightBluishColor),
                  ),
                  child: "Send".text.make(),
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

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: TextEditingController(text: fullName),
                            enabled: true,
                            //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Mythemes.lightBluishColor,
                                ),
                                hintText: "Full Name",
                                labelText: "Full  Name"
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: TextEditingController(text: mobileNo),
                            enabled: true,
                            //initialValue: "${branchName}",
                            decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Mythemes.lightBluishColor,
                                ),
                                hintText: "Mobile No.",
                                labelText: "Mobile No."
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: dropdownNewvalue,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.work_history,
                                  color: Mythemes.lightBluishColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Purpose",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('Official'),
                                  value: 1,

                                ),
                                DropdownMenuItem(
                                  child: Text('Meeting'),
                                  value: 2,

                                ),
                                DropdownMenuItem(
                                  child: Text('Personal'),
                                  value: 3,

                                ),
                              ],
                              onChanged: (newVal) {
                                valuenew = newVal.toString();
                                //int i =leaveTypeList.indexOf(valuenew);
                                //var leaveTypeId = leaveBalanceLabel?.leaveTypeListDetails?[i].leaveId;
                                //var policyidnew= leaveTypeList.elementAt(i);
                                //leavereqIdGlobel = newVal.toString().split('-');
                                //String idn=leavereqIdGlobel.last;
                                //print('leaveTypeId $idn');
                                setState(() {
                                  dropdownNewvalue = newVal;
                                  print("Dropvalue $dropdownNewvalue");

                                });
                              }
                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: dropdownNewvalueOne,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.verified_user,
                                  color: Mythemes.lightBluishColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Host",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('Ankur Kumar'),
                                  value: 1,

                                ),
                                DropdownMenuItem(
                                  child: Text('Ankush Sethi'),
                                  value: 2,

                                ),
                                DropdownMenuItem(
                                  child: Text('Suket Chauhan'),
                                  value: 3,

                                ),
                              ],
                              onChanged: (newVal) {
                                valuenewOne = newVal.toString();
                                //int i =leaveTypeList.indexOf(valuenew);
                                //var leaveTypeId = leaveBalanceLabel?.leaveTypeListDetails?[i].leaveId;
                                //var policyidnew= leaveTypeList.elementAt(i);
                                //leavereqIdGlobel = newVal.toString().split('-');
                                //String idn=leavereqIdGlobel.last;
                                //print('leaveTypeId $idn');
                                setState(() {
                                  dropdownNewvalueOne = newVal;
                                  print("Dropvalue $dropdownNewvalueOne");

                                });
                              }
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  child: Container(
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

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}