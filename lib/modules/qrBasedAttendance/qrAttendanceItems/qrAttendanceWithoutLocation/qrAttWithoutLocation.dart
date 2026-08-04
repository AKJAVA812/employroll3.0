import 'dart:async';
import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';

class QRAttWithoutLocation extends StatefulWidget {
  const QRAttWithoutLocation({Key? key}) : super(key: key);

  @override
  State<QRAttWithoutLocation> createState() => _QRAttWithoutLocationState();
}

class _QRAttWithoutLocationState extends State<QRAttWithoutLocation> {



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
SessionManager shared = SessionManager();
String? clockingType=" ";
class _QRPageViewState extends State<QRPageView> {
  var getQrResult;
  var getEmpCode;
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
    //empCode = await shared!.getEmpCode()??"N/A";
    lng=await shared.getLongitude();
    orgnizationID=await shared.getOrgId();

    print('Response snapshot: ${sessionId}');
    print('Response Lat: ${lat}');
    print('Response Long: ${lng}');
    print('Response snapshot: ${orgnizationID}');

  }
  /*Future _qrScanner(BuildContext context) async{
    var cameraStatus = await Permission.camera.status;

    *//*if(cameraStatus.isGranted) {*//*

        final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

        if (!mounted) return;
        setState(() {
          getQrResult = qrCode;
          getEmpCode = qrCode.toString();
        });

         getEmpCode = qrCode.split("No:")[1].split(" Blood Group:")[0];
        print("empCodeNew $getEmpCode");
        print("QRCode Result $qrCode");

      *//*on PlatformException {
        getQrResult = "Failed to scan qr";
      }*//*
      *//*MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(
              facing: CameraFacing.front, torchEnabled: true),
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              debugPrint('Barcode found! $code');
            }
          });*//*
      //String? cameraScanResult = await scanner.scan();
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
          "battery=$battery");
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
      //print("Heloo Bharat  $cameraScanResult");
      *//*CommonNotificationPage.showWorkDoneSuccess(
            context,
            "$qrData"
                .upperCamelCase +
                " ",
            "Successfully Punch $clockingType");*//*

    *//*else {
      var isGrant = await Permission.camera.request();
      *//**//*if(isGrant.isGranted){
        String? qrData = await scanner.scan();
        print(qrData);
      }*//**//*
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


    return GridView.count(crossAxisCount: 3,
    children: [
      Card(
        color: Mythemes.whitish,
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
          child: Stack(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.fingerprint,
                  size: 50,
                  color: Mythemes.successColor,
                ),
                /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 80, left: 10),
                  padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                  child: Text(
                    'Punch In',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Mythemes.blackish, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Card(
        color: Mythemes.whitish,
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
              clockingType="Out";
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
          child: Stack(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.fingerprint,
                  size: 50,
                  color: Mythemes.dangerColorOne ,
                ),
                /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 80, left: 10),
                  padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                  child: Text(
                    'Punch Out',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Mythemes.blackish, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
    );



      /*Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Mythemes.whitish,
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
                          _qrScanner(context);
                          //Navigator.pushNamed(context, MyRoutings.qrScreenRoute);
                          //getImageODIn();
                        }

                        *//*    getUploadImage();
                            clockingType = "In";
                            print("click in");
                            _getId();
                            *//**//*await AndroidMultipleIdentifier
                                            .requestPermission();*//**//*
                            punchInnew(sessionId);*//*
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Icon(
                              Icons.fingerprint,
                              size: 50,
                              color: Mythemes.greyish,
                            ),
                            *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 80, left: 10),
                              padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'Punch In',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Mythemes.blackish, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Mythemes.whitish,
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
                          clockingType="Out";
                          _qrScanner(context);
                          //Navigator.pushNamed(context, MyRoutings.qrScreenRoute);
                          //getImageODIn();
                        }

                        *//*    getUploadImage();
                            clockingType = "In";
                            print("click in");
                            _getId();
                            *//**//*await AndroidMultipleIdentifier
                                            .requestPermission();*//**//*
                            punchInnew(sessionId);*//*
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Icon(
                              Icons.fingerprint,
                              size: 50,
                              color: Mythemes.greyish,
                            ),
                            *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 80, left: 10),
                              padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'Punch Out',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Mythemes.blackish, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                 *//* Container(
                    width: 125,
                    child: Card(
                      elevation: 1,
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
                            _qrScanner(context);
                            //Navigator.pushNamed(context, MyRoutings.qrScreenRoute);
                            //getImageODIn();
                          }

                          *//**//*    getUploadImage();
                            clockingType = "In";
                            print("click in");
                            _getId();
                            *//**//**//**//*await AndroidMultipleIdentifier
                                            .requestPermission();*//**//**//**//*
                            punchInnew(sessionId);*//**//*
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
                  ),
                  Container(
                    width: 125,
                    child: Card(
                      elevation: 1,
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
                            clockingType="Out";
                            _qrScanner(context);
                            //Navigator.pushNamed(context, MyRoutings.qrScreenRoute);
                            //getImageODIn();
                          }

                          *//**//*    getUploadImage();
                            clockingType = "In";
                            print("click in");
                            _getId();
                            *//**//**//**//*await AndroidMultipleIdentifier
                                            .requestPermission();*//**//**//**//*
                            punchInnew(sessionId);*//**//*
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
                                height: 10, color: Mythemes.whiteShadeSeventy),
                            Container(
                              padding: EdgeInsets.all(8),
                              //margin: EdgeInsets.all(5),
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
                  ),*//*
                ],
              ),
            ],
          ),
        )
      ],
    );*/
  }
}
