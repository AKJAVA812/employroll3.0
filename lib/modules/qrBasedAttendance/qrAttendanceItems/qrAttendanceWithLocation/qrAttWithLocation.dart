import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';

class QRAttLocationPage extends StatefulWidget {
  const QRAttLocationPage({Key? key}) : super(key: key);

  @override
  State<QRAttLocationPage> createState() => _QRAttLocationPageState();
}
String? sessionId;
int? orgnizationID=0;
class _QRAttLocationPageState extends State<QRAttLocationPage> {



  @override
  Widget build(BuildContext context) {
    var titleName = "QR Attendance";

    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),

      body: QRPageView(),
    );
  }
}

class QRPageView extends StatefulWidget {
  const QRPageView({Key? key}) : super(key: key);

  @override
  State<QRPageView> createState() => _QRPageViewState();

}
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? clockingType=" ";
class _QRPageViewState extends State<QRPageView> {

  var getQrResult;
  late var result;
  double lat = 0;
  double lng = 0;
  showDialgError(BuildContext buildContext, result,reason) {
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
            //getPunchIn(buildContext);
          },
          child: Text("Retry"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
  var getEmpCode;
  var empCode;
  var clocking = "Clock";
  var firstImei;
  var secondImei;
  var macAddress;
  var deviceId;
  var battery;
  void initState() {
    getSharedPrfanceList();
    empCode = "THUMB141";
    clocking = "clocking";
    firstImei = "860427054190032";
    secondImei = "860427054190032";
    macAddress = "12:3d:1e:c9:c4:73";
    deviceId = "12:3d:1e:c9:c4:73";
    battery = "55";
    // TODO: implement initState
    getUserName();
    timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }
  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    lat=await shared.getLatitude();

    lng=await shared.getLongitude();
    orgnizationID=await shared.getOrgId();

    print('Response snapshot: ${sessionId}');
    print('Response snapshot: ${lat}');
    print('Response snapshot: ${lng}');
    print('Response snapshot: ${orgnizationID}');

  }
 /* Future _qrScanner(BuildContext context) async{
      //var cameraStatus = await Permission.camera.status;
      //if(cameraStatus.isGranted) {
    try{
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        getQrResult = qrCode;
        getEmpCode = qrCode.toString();
      });

      getEmpCode = qrCode.split("No:")[1].split(" Blood Group:")[0];
      print("empCodeNew $getEmpCode");
      print("QRCode Result $qrCode");
    }
    on PlatformException {
      getQrResult = "Failed to scan qr";
    }
        //String? qrData = await scanner.scan();
        String conn = ApiDetails.server;
        String apiUrl = ApiDetails.qrBasedAttendance;
        double lat = currentPostion!.latitude;
        double lng = currentPostion!.longitude;
        DateTime now = DateTime.now();
        DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
        String formattedDate = dateFormat.format(now);
        *//*var stream = http.ByteStream(value!.openRead());
    stream.cast();*//*
        var urlapi = Uri.parse("$conn$apiUrl?"
            "sessionId=$sessionId&"
            "address=$currentAddress&"
            "clocking=$clocking&"
            "clockingType=$clockingType&"
            "lat=$lat&"
            "empCode=$getEmpCode&"
            "lng=$lng&"
            "currentDate=$todayDate&"
            "firstImei=$firstImei&"
            "secondImei=$secondImei&"
            "macAddress=$macAddress&"
            "deviceId=$deviceId&"
            "battery=$battery&");
        var request = new http.MultipartRequest("Post", urlapi);
        http.Response response = await http.Response.fromStream(await request.send());
        result= json.decode(response.body.toString());
        String resultSuccess=result['result'];
        String reasonSuccess=result['reason'];
        print('result${result}');

        print('URL ${response.request}');
        if(response.statusCode==200){
          print("I m Punch $clockingType with QR");
          //Navigator.pop(context);
          if(resultSuccess.compareToIgnoringCase("success")==0){
            CommonNotificationPage.showSuccessStay(context,reasonSuccess.upperCamelCase+" "+formattedDate,"Successfully Punch $clockingType");
          }else if(resultSuccess.compareToIgnoringCase("failed")==0){
            CommonNotificationPage.showSuccessStay(context,reasonSuccess.upperCamelCase, " Failed ");
          }
        }else {
          Navigator.pop(context);
          showDialgError(context, result,"Your Punch Not Submitted, Please Try Again");
        }
        //print("Heloo Bharat  $qrData");
        *//*CommonNotificationPage.showWorkDoneSuccess(
            context,
            "$qrData"
                .upperCamelCase +
                " ",
            "Successfully Punch $clockingType");*//*

      *//*else {
        var isGrant = await Permission.camera.request();
        if(isGrant.isGranted){
          String? qrData = await scanner.scan();
          print(qrData);
        }
      }*//*


  }*/

  /*Future _qrScanner(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    if(cameraStatus.isGranted) {
      String? qrData = await scanner.scan();
      print("Heloo Bharat  $qrData");
      CommonNotificationPage.showWorkDoneSuccess(
          context,
          "$qrData"
              .upperCamelCase +
              " ",
          "Successfully Punch $clockingType");
    }
    else {
      var isGrant = await Permission.camera.request();
      if(isGrant.isGranted){
        String? qrData = await scanner.scan();
        print(qrData);
      }
    }

  }*/

  String UserName = "Employee Name1 ";
  File? _workDoneImage;

  Future getUserName() async {
    UserName = await shared.getempName();
    print('Response snapshot: ${UserName}');
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      timeString = formattedDateTime;
    });
  }
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }
  @override
  Widget build(BuildContext context) {


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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 0,
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
                              clockingType="In";
                              //_qrScanner(context);
                              //Navigator.pushNamed(context, MyRoutings.qrScreenRoute);
                              //getImageODIn();
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
                                    Icons.fingerprint,
                                    size: 30,
                                    color: Mythemes.creamColor,
                                  ),
                                  backgroundColor: Mythemes.successColor,
                                  radius: 20,
                                ),
                              ),
                              Container(
                                  height: 10, color: Mythemes.whiteShadeSeventy),
                              Container(
                                padding: EdgeInsets.all(8),
                                //margin: EdgeInsets.all(5),
                                child: Text(
                                  "Punch In",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
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
                              clockingType = "Out";
                              //_qrScanner(context);
                              //Navigator.pushNamed(context, MyRoutings.qrScreenRoute);
                              //getImageODOut();
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.fingerprint,
                                    size: 30,
                                    color: Mythemes.creamColor,
                                  ),
                                  backgroundColor: Mythemes.dangerColorOne,
                                  radius: 20,
                                ),
                              ),
                              Container(
                                  height: 15, color: Mythemes.creamColor),
                              Padding(padding: EdgeInsets.all(0)),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Punch Out",
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
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
