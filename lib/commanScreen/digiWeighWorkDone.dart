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
import 'package:http/http.dart' as http;

import 'digiWeighWorkDone2.dart';

class DigiWeighWorkDone extends StatefulWidget {
  final File? value;
  final String time;
  final String address;

  const DigiWeighWorkDone(
      {super.key, required this.value, required this.address, required this.time});

  @override
  State<DigiWeighWorkDone> createState() => _DigiWeighWorkDoneState(value, address, time);
}

late String? sessionId;
var custName;
var custLocation;
var systemDet;
var natureComplaint;
var dateComplaint;
var imageValu;

int? orgnizationID = 0;
SessionManager shared = SessionManager();
double latt = 0;
double lngg = 0;

class _DigiWeighWorkDoneState extends State<DigiWeighWorkDone> {
  File? value;
  String time;
  String currentAddress;
  final _formKey = GlobalKey<FormState>();

  _DigiWeighWorkDoneState(this.value, this.currentAddress, this.time);

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerLocationController = TextEditingController();
  final TextEditingController _systemDetController = TextEditingController();
  final TextEditingController _natureController = TextEditingController();
  final TextEditingController _contNoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final bool _enabled = false;
  File? _image;
  late var result;

  @override
  void initState() {
    //getUploadImage();
    getSharedPrfanceList();

    setState(() {

    });
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    latt = await shared.getLatitude();

    lngg = await shared.getLongitude();
    orgnizationID = await shared.getOrgId();

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

    //var uri = Uri.parse("http://23ba-122-176-34-239.ngrok.io/restful/service/task/via/mobile");
    var uri = Uri.parse("http://www.employroll.com/restful/service/task/via/mobile");
    var request = http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId!;
    request.fields['taskTime'] = formattedDate;
    request.fields['address'] = currentAddress;
    request.fields['taskDone'] = "DONE";
    request.fields['lat'] = latt.toString();
    request.fields['lng'] = lngg.toString();
    //request.fields['cname'] = _clientNameController.text;
    request.fields['contactnumber'] = _contNoController.text;
    //request.fields['emailid'] = _emailIdController.text;
    //request.fields['orgname'] = _orgNameController.text;
    //request.fields['taskDetails'] = _remarkController.text;

    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+_emailIdController.text),
    ));*/
    var multipart = http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
    http.Response response = await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+response.body),
    ));*/
    String resultSuccess = result['result'];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessGo(
            context, "You have successfully submitted task details on server at $formattedDate", "Task Submitted");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessGo(
            context, resultSuccess, " Failed ");
      }
    } else {
      Navigator.pop(context);
      CommonNotificationPage.showDialgError(context, result, "reason");
    }
    String reasonSuccess = result['reason'];
    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run" + result['result']),
    ));*/
  }
  String singleDateString="";

  DateTime _date = (DateTime.now());
  String formattedDate = DateFormat.ABBR_MONTH;
  String dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse("2019-09-30"));
  Future <Null> _selectDate (BuildContext context) async {
    DateTime? datePicker =await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2040),
    );

    if(datePicker != null && datePicker != _date){
      setState(() {
        _date = datePicker;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          elevation: 0.5,
          title: "Workdone Report".text.make(),
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
                            controller: _customerNameController,
                            decoration: const InputDecoration(
                                hintText: "Enter Customer Name",
                                labelText: "Customer Name",
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.edit_note_sharp,
                                  ),
                                  onPressed: null,
                                )),
                          ),
                          TextFormField(
                            controller: _customerLocationController,
                            decoration: const InputDecoration(
                                hintText: "Enter Customer Location",
                                labelText: "Customer Location",
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.edit_note_sharp,
                                  ),
                                  onPressed: null,
                                )),
                          ),
                          TextFormField(
                            controller: _systemDetController,
                            decoration: const InputDecoration(
                                hintText: "Enter System Details",
                                labelText: "System Details",
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.edit_note_sharp,
                                  ),
                                  onPressed: null,
                                )),
                          ),
                          TextFormField(
                            controller: _natureController,
                            decoration: const InputDecoration(
                                hintText: "Enter Nature Of Complaint",
                                labelText: "Nature Of Complaint",
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.edit_note_sharp,
                                  ),
                                  onPressed: null,
                                )),
                          ),
                          TextFormField(
                            onTap: () async{
                              DateTime? date = DateTime.now();
                              FocusScope.of(context).requestFocus(FocusNode());

                              date = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate:DateTime(1947),
                                  lastDate: DateTime(2050));
                              setState(() {
                                singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                _dateController.text = DateFormat("dd-MM-yyyy").format(date);

                                //  DateFormat.yMd().format(date!).toString();
                              });

                            },
                            readOnly: true,
                            //initialValue: "dd-mm-yyyy",
                            controller: _dateController,
                            decoration:  InputDecoration(
                              labelText: "Date Of Complaint",
                              prefixIcon: Icon(Icons.calendar_month),
                              hintText: DateFormat("DD-MM-YYYY").format(_date),
                              // hintText: DateFormat.yMd().format(_date).toString(),
                            ),

                          ),

                        ],
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OverflowBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  imageValu = value;
                                  custName = _customerNameController.text;
                                  custLocation = _customerLocationController.text;
                                  systemDet = _systemDetController.text;
                                  natureComplaint = _natureController.text;
                                  dateComplaint = _dateController.text;
                                  if (_formKey.currentState!.validate()) {
                                    return
                                      setState(() {
                                        AlertDialog(
                                          content: "Please add remarks".text.make(),
                                        );
                                        //Navigator.pushNamed(context, MyRoutings.digiWeighWdSubmitRoute);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                            DigiWeighWDSubmit(imageValu,custName, custLocation,systemDet,natureComplaint,dateComplaint)));
                                        //uploadImage(context);
                                      });
                                  }

                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  WidgetStateProperty.all(Mythemes.lightBluishColor),
                                ),
                                child: "Next".text.make(),
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
  const DismissKeyboard({super.key, required this.child});

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