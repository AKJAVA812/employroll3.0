import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/commanNotificationPage.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/work_done_api.dart';

import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../profiles/profilePageWithHead.dart';

class OdWorkDonePage extends StatefulWidget {
  final File? value;
  final String time;
  final String address;

  const OdWorkDonePage(
      {required this.value, required this.address, required this.time});

  @override
  State<OdWorkDonePage> createState() => _OdWorkDonePageState(value, address, time);
}

late String? sessionId;

int? orgnizationID = 0;
SessionManager shared = SessionManager();
double lat = 0;
double lng = 0;

class _OdWorkDonePageState extends State<OdWorkDonePage> {
  File? value;
  String time;
  String currentAddress;
  final _formKey = GlobalKey<FormState>();

  _OdWorkDonePageState(this.value, this.currentAddress, this.time);

  TextEditingController _remarkController = TextEditingController();
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _orgNameController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _contNoController = TextEditingController();

  bool _enabled = false;
  File? _image;

  @override
  void initState() {
    //getUploadImage();
    print('Workdone${value}');
    print('Workdone${time}');
    print('Workdone${currentAddress}');
    getSharedPrfanceList();
    setState(() {

    });
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    lat = await shared.getLatitude();

    lng = await shared.getLongitude();
    orgnizationID = await shared.getOrgId();

    print('Response snapshot: ${sessionId}');
    print('Response snapshot: ${lat}');
    print('Response snapshot: ${lng}');
    print('Response snapshot: ${orgnizationID}');
  }

  Future getUploadImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      //final imageTemperory = File(image.path);

      // final imagePermanent = await saveImagePermanent(value);
      /*setState(() {
        this._image = value;
      });*/
    } on PlatformException catch (e) {
      print('failed to upload: $e');
    }
  }

  Future<File> saveImagePermanent(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<void> uploadImage(BuildContext context) async {
    if (value == null) {
      CommonNotificationPage.showDialgError(context, "Image Required", "Please capture work done image first.");
      return;
    }

    final formattedDate = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());
    print('[MOBILE-WORKDONE][OD] screen submit -> image=${value!.path} lat=$lat lng=$lng address=$currentAddress');
    CommonNotificationPage.showLoaderDialog(context);
    try {
      final response = await WorkDoneApi().submit(
        image: value!,
        latitude: lat,
        longitude: lng,
        address: currentAddress,
        taskDetails: _remarkController.text,
        clientName: _clientNameController.text,
        contactNumber: _contNoController.text,
        emailId: _emailIdController.text,
        organisationName: _orgNameController.text,
        extraPayload: <String, Object?>{
          'source': 'OD',
        },
      );
      final decoded = _decodeWorkDoneResponse(response.body);
      final resultSuccess = decoded['result']?.toString() ?? 'failed';
      final reason = decoded['reason']?.toString() ?? 'Work done request failed';

      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (response.statusCode == 200 && resultSuccess.compareToIgnoringCase("success") == 0) {
        showSuccessGo(
          context,
          "You have successfully submitted task details on server at $formattedDate",
          "Task Submitted",
        );
      } else {
        CommonNotificationPage.showDialgError(context, "Failed", reason);
      }
      print('[MOBILE-WORKDONE][OD] response status=${response.statusCode} body=$decoded');
    } catch (error) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      print('[MOBILE-WORKDONE][OD] submit error -> $error');
      CommonNotificationPage.showDialgError(context, "Failed", error.toString());
    }
  }

  Map<String, dynamic> _decodeWorkDoneResponse(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return <String, dynamic>{
      'result': 'failed',
      'reason': body.isEmpty ? 'Work done request failed' : body,
    };
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
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(result),
           /* Container(
              child: "Location".text.align(TextAlign.left).color(Mythemes.greyish).make().py12() ,
            ),*/
            Container(
              child: Text(
                "Location",
                textAlign: TextAlign.left,
                style: TextStyle(color: Mythemes.greyish),
              ),
            ).py12(),
            /*currentAddress.text.letterSpacing(0.5).make(),*/
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Workdone".text.make(),
      ),
      body: Container(
        color: Mythemes.whitish,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  value != null
                      ? CircleAvatar(
                    backgroundColor: Mythemes.greyish,
                    maxRadius: 115,
                    backgroundImage: FileImage(value!),
                    /*child: Image.file(value!,
                      height: 150,
                      fit: BoxFit.fitWidth,),*/
                  )
                      : Icon(
                    Icons.verified_user_sharp,
                    size: 150,
                    color: Mythemes.greyish,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          //controller: _locationController,
                          enabled: false,
                          initialValue: currentAddress,
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: "Location",
                              labelText: "Location",
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Mythemes.blackish),
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                ),
                                onPressed: null,
                              )),
                        ),
                        TextFormField(
                          onChanged: (value){
                            setState(() {
                            });
                          },
                          enabled: false,
                          initialValue: time,
                          decoration: InputDecoration(
                              hintText: "Enter Time",
                              labelText: "Time",
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Mythemes.blackish),
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.timelapse,
                                ),
                                onPressed: null,
                              )),
                        ),
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
                          decoration: const InputDecoration(
                              hintText: "Enter Remarks",
                              labelText: "Remarks*",
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.edit_note_sharp,
                                ),
                                onPressed: null,
                              )),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _clientNameController,
                          decoration: const InputDecoration(
                              hintText: "Enter Client Name",
                              labelText: "Client Name",
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.person,
                                ),
                                onPressed: null,
                              )),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailIdController,
                          decoration: const InputDecoration(
                              hintText: "Enter Mail Id",
                              labelText: "Client Mail Id",
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.mail,
                                ),
                                onPressed: null,
                              )),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          controller: _contNoController,
                          decoration: const InputDecoration(
                              hintText: "Enter Contact Number",
                              labelText: "Client Contact Number",
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.phone,
                                ),
                                onPressed: (null),
                              )),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _orgNameController,
                          decoration: const InputDecoration(
                              hintText: "Enter Organisation Name",
                              labelText: "Organisation Name",
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.apartment,
                                ),
                                onPressed: null,
                              )),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    color: context.cardColor,
                    child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        buttonPadding: Vx.mOnly(right: 16),
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await uploadImage(context);
                              }

                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Mythemes.lightBluishColor),
                            ),
                            child: "Submit".text.make(),
                          ).wh(150, 40).py12()
                        ]),
                  ),
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
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
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
    );
  }
}

