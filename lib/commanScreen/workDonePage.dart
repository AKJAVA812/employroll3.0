import 'dart:convert';
import 'dart:io';

import 'package:er_flutter_project/commanScreen/routes.dart';
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
import 'package:http/http.dart' as http;

class WorkDonePage extends StatefulWidget {
  final File? value;
  final String time;
  final String address;

  const WorkDonePage(
      {required this.value, required this.address, required this.time});

  @override
  State<WorkDonePage> createState() => _WorkDonePageState(value, address, time);
}

late String? sessionId;

int? orgnizationID = 0;
SessionManager shared = SessionManager();
var lat;
var lng;

class _WorkDonePageState extends State<WorkDonePage> {
  File? value;
  String time;
  String currentAddress;
  final _formKey = GlobalKey<FormState>();

  _WorkDonePageState(this.value, this.currentAddress, this.time);

  TextEditingController _remarkController = new TextEditingController();
  TextEditingController _clientNameController = new TextEditingController();
  TextEditingController _orgNameController = new TextEditingController();
  TextEditingController _emailIdController = new TextEditingController();
  TextEditingController _contNoController = new TextEditingController();

  bool _enabled = false;
  File? _image;
  late var result;

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
    sessionId = await shared!.getSessionId();
    lat = await shared!.getLatitude();

    lng = await shared!.getLongitude();
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
    CommonNotificationPage.showLoaderDialog(context);
    var stream = http.ByteStream(value!.openRead());
    stream.cast();

    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    var length = await value!.length();
    print('Response status: ${length}');
    print('Response body: ${stream}');
    print('Response body: ${value}');

    //var uri = Uri.parse("http://23ba-122-176-34-239.ngrok.io/restful/service/task/via/mobile");
    var uri = Uri.parse("http://www.employroll.com/restful/service/task/via/mobile");
    var request = new http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId!;
    request.fields['taskTime'] = formattedDate;
    request.fields['address'] = currentAddress;
    request.fields['taskDone'] = "DONE";
    request.fields['lat'] = lat.toString();
    request.fields['lng'] = lng.toString();
    request.fields['cname'] = _clientNameController.text;
    request.fields['contactnumber'] = _contNoController.text;
    request.fields['emailid'] = _emailIdController.text;
    request.fields['orgname'] = _orgNameController.text;
    request.fields['taskDetails'] = _remarkController.text;

   /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+_emailIdController.text),
    ));*/
    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
    // Construct API URL with parameters
    String apiWithParams = uri.toString() + '?' + request.fields.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

    // Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    http.Response response = await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+response.body),
    ));*/
    String resultSuccess = result['result'];

    if (response.statusCode == 200) {
      //print(response.request);
      Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        showSuccessGo(
            context, "You have successfully submitted task details on server at".toString() + " " + formattedDate, "Task Submitted");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        showSuccessGo(
            context, resultSuccess, " Failed ");
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialgError(context, result, "reason");
    }
    //String reasonSuccess = result['reason'];

    print('result${result}');
   /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run" + result['result']),
    ));*/
    print('Response body: ${result}');
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
              fontSize: 20,
          ),)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(result),
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

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ButtonBar(
                            alignment: MainAxisAlignment.center,
                            buttonPadding: Vx.mOnly(right: 16),
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    return
                                      setState(() {
                                        AlertDialog(
                                          content: "Please add remarks".text.make(),
                                        );
                                        uploadImage(context);
                                      });
                                  }

                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Mythemes.lightBluishColor),
                                ),
                                child: "Submit".text.make(),
                              ).wh(150, 40).py12()
                            ]),
                      ],
                    )
                    //submitButton(title: 'Submit', onClick: getUploadImage),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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