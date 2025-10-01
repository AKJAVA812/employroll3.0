import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/commanNotificationPage.dart';
import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/ujalaCreditWorkdone.dart';
import 'package:er_flutter_project/commanScreen/ujalaWorkDone2.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../adminPage/adminDashboard/adminDashboard.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'allAPIList.dart';
import 'digiWeighWorkDone.dart';

class DigiWeighWDSubmit extends StatefulWidget {
  var imageValu;
  String? custName;
  String? custLocation;
  String? systemDet;
  String? natureComplaint;
  String? dateComplaint;


  DigiWeighWDSubmit(this.imageValu, this.custName, this.custLocation,this.systemDet,this.natureComplaint,this.dateComplaint);
  @override
  State<DigiWeighWDSubmit> createState() => _DigiWeighWDSubmitState(imageValu,custName!, custLocation!,systemDet!,natureComplaint!,dateComplaint!);
}

late String? sessionId;

int? orgnizationID = 0;
SessionManager shared = SessionManager();
double latt = 0;
double lngg = 0;

class _DigiWeighWDSubmitState extends State<DigiWeighWDSubmit> {

  _DigiWeighWDSubmitState(imageValu, String custName, String custLocation, String systemDet, String natureComplaint, String dateComplaint);


  var titleName = "Workdone Report";
  TextEditingController _rectificationController = new TextEditingController();
  final TextEditingController _attendingDate = TextEditingController();
  final TextEditingController _rectificationDate = TextEditingController();
  final TextEditingController _stampingDate = TextEditingController();
  final TextEditingController _amcVisit = TextEditingController();
  final TextEditingController _amcPeriod = TextEditingController();
  final TextEditingController _prospect = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
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

  var imageVal;
  var custNameGet;
  var custLocationGet;
  var systemDetGet;
  var natureCompGet;
  var dateCompGet;
  var attendingDate;
  var rectification;
  var rectificationDate;
  var stampingDate;
  var amcVisit;
  var amcPeriod;
  var prospect;
  var remarks;
  late var result;
  @override
  void initState() {
    custNameGet = custName;
    imageVal = imageValu;
    print('Customer Name Get $custNameGet');
    custLocationGet = custLocation;
    systemDetGet = systemDet;
    natureCompGet = natureComplaint;
    dateCompGet = dateComplaint;


    getSharedPrfanceList();
    // TODO: implement initState
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
    attendingDate = _attendingDate.text;
    rectification = _rectificationController;
    rectificationDate = _rectificationDate.text;
    stampingDate = _stampingDate.text;
    amcVisit = _amcVisit.text;
    amcPeriod = _amcPeriod.text;
    prospect = _prospect.text;
    remarks = _remarksController.text;
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
        "taskDetails=$remarks"
        "lat=$latt&"
        "lng=$lngg&"
        "battery= 90&"
        "customerName=$custNameGet&"
        "location=$custLocationGet&"
        "systemDetails=$systemDetGet&"
        "complaintNature=$natureCompGet&"
        "dateOfComplain=$dateCompGet&"
        "dateOfAttending=$attendingDate&"
        "rectificationDet=$rectification&"
        "dateOfRectification=$rectificationDate&"
        "dateOfStamping=$stampingDate&"
        "dateOfAMCVisit=$amcVisit&"
        "amcPeriod=$amcPeriod&"
        "prospect=$prospect&"
        "remarkUser=$remarks"

    );
    //final response = await http.post(urlapi);
    var request = new http.MultipartRequest("Post", urlapi);
    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
    http.Response response = await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    print('responseemployeeList ${response.request}');
    print('response body ${response.body}');
    //var uri = Uri.parse("http://23ba-122-176-34-239.ngrok.io/restful/service/task/via/mobile");



    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+response.body),
    ));*/
    String resultSuccess = result['result'];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessGo(
            context, "You have successfully submitted task details on server at".toString() + " " + formattedDate, "Task Submitted");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessGo(
            context, resultSuccess, " Failed ");
      }
    } else {
      Navigator.pop(context);
      CommonNotificationPage.showDialgError(context, result, "reason");
    }
    var reasonSuccess = result['reason'];
    print('result${result}');
    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run" + result['result']),
    ));*/
    print('Response body: ${result}');
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
              child: Center(
                child: Column(
                  children: [
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
                            _attendingDate.text = DateFormat("dd-MM-yyyy").format(date!);

                            //  DateFormat.yMd().format(date!).toString();
                          });

                          print(date);
                        },
                        readOnly: true,
                        //initialValue: "dd-mm-yyyy",
                        controller: _attendingDate,
                        decoration:  InputDecoration(
                          labelText: "Date of Attending",
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: DateFormat("DD-MM-YYYY").format(_date),
                          // hintText: DateFormat.yMd().format(_date).toString(),
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _rectificationController,
                        decoration: const InputDecoration(
                            hintText: "Enter Rectification Details",
                            labelText: "Rectification Details",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.text_snippet,
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
                            _rectificationDate.text = DateFormat("dd-MM-yyyy").format(date!);

                            //  DateFormat.yMd().format(date!).toString();
                          });

                          print(date);
                        },
                        readOnly: true,
                        //initialValue: "dd-mm-yyyy",
                        controller: _rectificationDate,
                        decoration:  InputDecoration(
                          labelText: "Date of Rectification",
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: DateFormat("DD-MM-YYYY").format(_date),
                          // hintText: DateFormat.yMd().format(_date).toString(),
                        ),

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
                            _stampingDate.text = DateFormat("dd-MM-yyyy").format(date!);

                            //  DateFormat.yMd().format(date!).toString();
                          });

                          print(date);
                        },
                        readOnly: true,
                        //initialValue: "dd-mm-yyyy",
                        controller: _stampingDate,
                        decoration:  InputDecoration(
                          labelText: "Date of Stamping",
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: DateFormat("DD-MM-YYYY").format(_date),
                          // hintText: DateFormat.yMd().format(_date).toString(),
                        ),

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
                            _amcVisit.text = DateFormat("dd-MM-yyyy").format(date!);

                            //  DateFormat.yMd().format(date!).toString();
                          });

                          print(date);
                        },
                        readOnly: true,
                        //initialValue: "dd-mm-yyyy",
                        controller: _amcVisit,
                        decoration:  InputDecoration(
                          labelText: "Date of AMC Visit",
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: DateFormat("DD-MM-YYYY").format(_date),
                          // hintText: DateFormat.yMd().format(_date).toString(),
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _amcPeriod,
                        decoration: const InputDecoration(
                            hintText: "Enter AMC Period",
                            labelText: "AMC Period",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.text_snippet,
                              ),
                              onPressed: (null),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _prospect,
                        decoration: const InputDecoration(
                            hintText: "Enter Prospect",
                            labelText: "Prospect",
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.text_snippet,
                              ),
                              onPressed: (null),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                                onPressed: () {
                                  uploadImage(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Mythemes.lightBluishColor),
                                ),
                                child: "Submit".text.make(),
                              ).wh(150, 40).py12()
                            ]),
                      ],
                    ).py12()
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