import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';


import '../../../../commanScreen/homePage.dart';
import '../../../../profiles/profilePageWithHead.dart';
import 'odLocationPage.dart';

class ODImageUpload extends StatefulWidget {
  final File? value;
  final String time;
  final String address;
  final String? punchType;

  ODImageUpload({required this.value, required this.time, required this.address, required this.punchType});

  @override
  State<ODImageUpload> createState() => _ODImageUploadState(value,time,address,punchType);
}

late String? sessionId ;
int? orgnizationID=0;
SessionManager shared = SessionManager();

class _ODImageUploadState extends State<ODImageUpload> {
  TextEditingController _remarkController = new TextEditingController();
  String? _platformVersion = 'Unknown', _autoTimezone, _autoTime, _daftar = "";
  Map<String, dynamic>? _list;
  final File? value;
  final String time;
  final String address;
  final String? clockingType;
  late var result;
  double lat=0;
  double lng=0;
  var firstImei;
  var secondImei;
  var macAddress;
  _ODImageUploadState(this.value,this.time,this.address,this.clockingType);

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
  @override
  void initState() {
    // TODO: implement initState
    getSharedPrfanceList();
    firstImei = "860427054190032";
    secondImei = "860427054190032";
    macAddress = "12:3d:1e:c9:c4:73";
    //initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion, autoTimezone, autoTime;
    Map<String, dynamic>? list;

 /*   try {
      autoTimezone = await GlobalSettingsList.autoTimeZone;
      list = await GlobalSettingsList.list;
      autoTime = await GlobalSettingsList.autoTime;
      print('autoupdateChange $_autoTimezone $_autoTime');
    } on PlatformException {
      print('autoupdateChangeex $_autoTimezone $_autoTime');
      autoTimezone = 'Gagal';
      autoTime = 'Gagal';
    }
*/
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

  }
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
            odUploadImage(buildContext);
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

  Future<void> odUploadImage(BuildContext context) async {
    print("Od API Hit");
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.odInOtApi;
    CommonNotificationPage.showLoaderDialog(context);
    var stream = http.ByteStream(value!.openRead());
    stream.cast();
    DateTime now = DateTime.now();
    DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    DateFormat currentDateFormat=DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat currentTimeFormat=DateFormat("HH:mm:ss");
    String currentDateFormatString = currentDateFormat.format(now);
    String currentTimeFormatString = currentTimeFormat.format(now);
    var length = await value!.length();
    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    var uri = Uri.parse("$conn$apiUrl");
    var request = new http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId!;
    request.files.add(multipart);
    request.fields['address'] = currentAddress;
    request.fields['clocking'] = currentTimeFormatString;
    request.fields['clockingType'] = clockingType!;
    request.fields['lat'] = lat.toString();
    request.fields['lng'] = lng.toString();
    request.fields['currentDate'] = currentDateFormatString;
    request.fields['firstImei'] = firstImei;
    request.fields['secondImei'] = secondImei;
    request.fields['macAddress'] = macAddress;
    request.fields['remark'] = _remarkController.text;

    http.Response response = await http.Response.fromStream(await request.send());
    result= json.decode(response.body.toString());
    String resultSuccess=result['result'];
    String reasonSuccess=result['reason'];

    if(response.statusCode==200){
      Navigator.of(context, rootNavigator: true).pop();
      if(resultSuccess.compareToIgnoringCase("success")==0){
        showSuccessGo(context,reasonSuccess.upperCamelCase+" "+formattedDate,"Successfully OD Punch $clockingType");
      }else if(resultSuccess.compareToIgnoringCase("Error")==0){
        showSuccessGo(context,reasonSuccess.upperCamelCase, " Failed ");
      }
    }else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialgError(context, result,"Your OD Punch Not Submitted, Please Try Again");
    }
  }

  void navigatePage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ODLocationView(),));
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
      content:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(result),
           /* Container(
              child: "Location".text.align(TextAlign.left).color(Mythemes.greyish).make().py12() ,
            ),
            currentAddress.text.letterSpacing(0.5).make(),*/
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
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              Navigator.pushNamed(buildContext, MyRoutings.odLocationViewRoute);
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
  int pageIndex = 0;
  int currentIndex = 2;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return navigatePage(context) as bool;
      },
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Mythemes.whitish,
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
            }, icon: Icon(Icons.arrow_back_ios)),
            elevation: 0.5,
            title: Text('OD Attendance Punch'),
          ),

          /*bottomNavigationBar: Container(
            color: context.cardColor,
            child: ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding: Vx.mOnly(right: 16),
                children: [


                  ElevatedButton(
                    onPressed: (){
                      //getUploadImage();
                      odUploadImage(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Mythemes.lightBluishColor),
                    ),
                    child: "Punch $clockingType".text.make(),
                  ).wh(150, 40).py32()
                ]
            ),
          ),*/
          body: Container(
            color: Mythemes.whitish,
            child:
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
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
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                      ),
                      Row(
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
                                  child:  Container(
                                    child: Text(
                                      "Location",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Mythemes.greyish),
                                    ),
                                  ).py12(),
                                ),
                                Text(
                                  currentAddress,
                                  style: TextStyle(letterSpacing: 0.5),
                                ),
                              ],
                            ).px8(),
                          )

                        ],
                      ).p8(),

                      Row(
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
                      ).p8(),


                      if(shared.getOrgId().toString().compareToIgnoringCase("3")==0)
                        UploadedReading().p8(),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return "Please Add Remarks";
                                    } else if (value!.length < 7) {
                                      return "Remarks should be atleast of 7 characters";
                                    }

                                    return null;
                                  },
                                  controller: _remarkController,
                                  decoration:  InputDecoration(
                                      hintText: "Enter Remarks",
                                      labelText: "Remarks*",
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          Icons.edit_note_sharp,size: 32, color: Mythemes.lightBluishColor,
                                        ).py8(),
                                        onPressed: null,
                                      )),
                                ),
                              ],
                            ).px8(),
                          )

                        ],
                      ).p8(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ButtonBar(
                              alignment: MainAxisAlignment.center,
                              buttonPadding: Vx.mOnly(right: 16),
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    //getUploadImage();
                                    odUploadImage(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Mythemes.lightBluishColor),
                                  ),
                                  child: "OD $clockingType".text.make(),
                                ).wh(150, 40).py64()
                              ]
                          ),
                        ],
                      )
                      //submitButton(title: 'Submit', onClick: getUploadImage),
                    ],
                  ),
                ),
              ),
            ),
          ),

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
                    MaterialPageRoute(builder: (context) => HomePage()));
                //Navigator.of(context, rootNavigator: true).pop();
                print('home tab');
              }
              if(index==1){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
                //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
                print('Workflow');
              }
              if(index==2){
                Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                print('OD');
              }
              if(index==3){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
                );
                //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                print('Dashboard');
              }
              if(index==4){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePageNew())
                );
                //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
                print('Profile');
              }
              /*if(index==3){
                title="Notifications";
              }*/
              setState(() => currentIndex = index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts_outlined),
                label: 'Workflow',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.outbond_outlined),
                label: 'OD',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_customize),
                label: 'Dashboard',
                //backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
                //backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*@override
Widget UploadedLocation() {
  return Container(
    //height: 80,
    child: SingleChildScrollView(
      child:
    ),

  );
}

@override
Widget UploadedTime(String time) {

  return Container(
    //height: 68,
    child:

  );
}*/

@override
Widget UploadedReading() {
  return Container(

    //height: 68,
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
