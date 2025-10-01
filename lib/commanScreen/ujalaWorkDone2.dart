import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/commanNotificationPage.dart';
import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/ujalaCreditWorkdone.dart';
import 'package:er_flutter_project/commanScreen/ujalaWorkDone2.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../adminPage/adminDashboard/adminDashboard.dart';
import 'allAPIList.dart';

class UjalaCreditWDSubmit extends StatefulWidget {
  var imageValue;
  String? DropValueName;
  String? clientNamesend;
  String? clientNamesendTwo;
  String? clientNamesendThree;
  String? clientNamesendFour;
  String? clientNamesendFive;
  String? clientContactSend;
  String? clientContSendTwo;
  String? clientContSendThree;
  String? clientContSendFour;
  String? clientContSendFive;
  String? noOfNewMem;
  String? noOfNewAdvi;

  UjalaCreditWDSubmit(this.imageValue,this.DropValueName, this.clientNamesend, this.clientNamesendTwo, this.clientNamesendThree,
      this.clientNamesendFour, this.clientNamesendFive, this.clientContactSend, this.clientContSendTwo,
      this.clientContSendThree, this.clientContSendFour, this.clientContSendFive, this.noOfNewMem, this.noOfNewAdvi,);

  @override
  State<UjalaCreditWDSubmit> createState() => _UjalaCreditWDSubmitState(imageValue,
      DropValueName!,clientNamesend!,clientNamesendTwo!,clientNamesendThree!,clientNamesendFour!,
      clientNamesendFive!,clientContactSend!,clientContSendTwo!, clientContSendThree!,clientContSendFour!,
      clientContSendFive!,noOfNewMem!,noOfNewAdvi!
  );
}

late String? sessionId;

int? orgnizationID = 0;
SessionManager shared = SessionManager();
double latt = 0;
double lngg = 0;
final _formKey = GlobalKey<FormState>();

class _UjalaCreditWDSubmitState extends State<UjalaCreditWDSubmit> {
  _UjalaCreditWDSubmitState(imageValue,String DropValueName, String clientNamesend, String clientNamesendTwo,
      String clientNamesendThree, String clientNamesendFour, String clientNamesendFive, String clientContactSend,
      String clientContSendTwo, String clientContSendThree, String clientContSendFour, String clientContSendFive,
      String noOfNewMem, String noOfNewAdvi
      );

  var titleName = "Workdone Report";
  TextEditingController _ussNoController = new TextEditingController();
  TextEditingController _ujalaJyoti = new TextEditingController();
  TextEditingController _todayBusiness = new TextEditingController();
  TextEditingController _remarksController = new TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String singleDateString="";

  DateTime _date = (DateTime.now());
  String formattedDate = DateFormat.ABBR_MONTH;
  String dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse("2019-09-30"));

  Future <Null> _selectDate (BuildContext context) async {
    DateTime? _datePicker =await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2040),
    );

    if(_datePicker != null && _datePicker != _date){
      setState(() {
        _date = _datePicker;
      });
    }
  }

  var dropName;
  var imageVal;
  var clientNsend;
  var clientNsendTwo;
  var clientNsendThree;
  var clientNsendFour;
  var clientNsendFive;
  var clientConSend;
  var clientConSendTwo;
  var clientConSendThree;
  var clientConSendFour;
  var clientConSendFive;
  var clientNoOfNewMem;
  var clientNoOfNewAdv;
  late var result;
  @override
  void initState() {
    dropName = DropValueName;
    imageVal = imageValue;
    clientNsend = clientNamesend;
    clientNsendTwo = clientNamesendTwo;
    clientNsendThree = clientNamesendThree;
    clientNsendFour = clientNamesendFour;
    clientNsendFive = clientNamesendFive;
    clientConSend = clientContactSend;
    clientConSendTwo = clientContSendTwo;
    clientConSendThree = clientContSendThree;
    clientConSendFour = clientContSendFour;
    clientConSendFive = clientContSendFive;
    clientNoOfNewMem = noOfNewMem;
    clientNoOfNewAdv = noOfNewAdvi;
    print("Drops $dropName");
    getSharedPrfanceList();
    super.initState();
  }



  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    latt = await shared!.getLatitude();

    lngg = await shared!.getLongitude();
    orgnizationID = await shared.getOrgId();

    print('Response snapshot: ${sessionId}');
    print('Response snapshot: ${latt}');
    print('Response snapshot: ${lngg}');
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
    var stream = http.ByteStream(imageVal!.openRead());
    stream.cast();

    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    String formattedDate = dateFormat.format(now);
    var length = await imageVal!.length();
    print('Response status: ${length}');
    print('Response body: ${stream}');
    print('Response body: ${imageVal}');
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.customWorkDoneApi;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "image=$imageVal&"
        "address=$currentAddress&"
        "taskTime=$formattedDate&"
        "taskDone='DONE'&"
        "taskDetails=${_remarksController.text}"
        "lat=$latt&"
        "lng=$lngg&"
        "coh=$dropName&"
        "cname1=$clientNsend&"
        "cname2=$clientNsendTwo&"
        "cname3=$clientNsendThree&"
        "cname4=$clientNsendFour&"
        "cname5=$clientNsendFive&"
        "client1number=$clientConSend&"
        "client2number=$clientConSendTwo&"
        "client3number=$clientConSendThree&"
        "client4number=$clientConSendFour&"
        "client5number=$clientConSendFive&"
        "noOfNewMember=$clientNoOfNewMem&"
        "noOfNewAdvisor=$clientNoOfNewAdv&"
        "uss=${_ussNoController.text}&"
        "ujalaJyoti=${_ujalaJyoti.text}&"
        "todayBusiness=${_todayBusiness.text}&"
        "nextFollowUp=${_dateController.text}&"
        "ujalaRemarks=${_remarksController.text}"

    );
    //final response = await http.post(urlapi);
    var request = new http.MultipartRequest("Post", urlapi);
    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
    String apiWithParams = urlapi.toString() + '?' + request.fields.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

    // Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    http.Response response = await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
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
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          title: titleName.text.make(),
        ),

        body: Container(
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: _ussNoController,
                        decoration: const InputDecoration(
                            hintText: "Enter USS Number",
                            labelText: "USS Number",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.timelapse,
                              ),
                              onPressed: (null),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: _ujalaJyoti,
                        decoration: const InputDecoration(
                            hintText: "Enter Ujala Jyoti",
                            labelText: "Ujala Jyoti",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: (null),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: _todayBusiness,
                        decoration: const InputDecoration(
                            hintText: "Enter Today Business",
                            labelText: "Today Business",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: (null),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(

                        onTap: () async{
                          DateTime? date = DateTime.now();
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate:DateTime(1947),
                              lastDate: DateTime(2050));
                          setState(() {
                            singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                            _dateController.text = DateFormat("dd-MM-yyyy").format(date!);

                            //  DateFormat.yMd().format(date!).toString();
                          });

                          print(date);
                        },
                        readOnly: true,
                        //initialValue: "dd-mm-yyyy",
                        controller: _dateController,
                        decoration:  InputDecoration(
                          labelText: "Next Follow Up",
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: DateFormat("DD-MM-YYYY").format(_date),
                          // hintText: DateFormat.yMd().format(_date).toString(),
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please Add Remarks";
                          } else if (value!.length < 7) {
                            return "Remarks should be atleast of 7 characters";
                          }

                          return null;
                        },
                        //keyboardType: TextInputType.number,
                        controller: _remarksController,
                        decoration: const InputDecoration(
                            hintText: "Enter Remarks",
                            labelText: "Remarks",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.text_snippet,
                              ),
                              onPressed: (null),
                            )),
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonBar(
                            alignment: MainAxisAlignment.center,
                            buttonPadding: Vx.mOnly(right: 16),
                            children: [
                              ElevatedButton(
                                onPressed: ()  {
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
                    ).py64()
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