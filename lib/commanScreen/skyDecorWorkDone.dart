/*
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/commanNotificationPage.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import 'allAPIList.dart';
import 'modalClass/skyDecClientDataModal.dart';

class SkyDecorWorkDone extends StatefulWidget {
  final File? value;
  final String time;
  final String address;
  final ClientDataListModal? clientDataListModal1;


   SkyDecorWorkDone(
      {required this.value, required this.address, required this.time, this.clientDataListModal1});

  @override
  State<SkyDecorWorkDone> createState() => _SkyDecorWorkDoneState(value, address, time, ClientDataListModal());
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
ClientDataListModal? clientDataListModalGlobal;
late List<String?> clientDatalist;
late List<String?> clientContact;

int? orgnizationID = 0;
double lattt = 0;
double lnggg = 0;

class _SkyDecorWorkDoneState extends State<SkyDecorWorkDone> {
  File? value;
  String time;
  String currentAddress;
  var clientIndex;
  final _formKey = GlobalKey<FormState>();
  ClientDataListModal clientDataListModal1;
  static final List<String> clientName =[];
  static final List<String> clientContacts =[];
  var _contController;
  var _emailIdController;

  _SkyDecorWorkDoneState(this.value, this.currentAddress, this.time, this.clientDataListModal1);

  TextEditingController _remarkController = new TextEditingController();
  TextEditingController _clientNameController = new TextEditingController();
  TextEditingController _orgNameController = new TextEditingController();
  //TextEditingController _emailIdController = new TextEditingController();
  //TextEditingController _contNoController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  String? _selectedCity;
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
    lattt = await shared!.getLatitude();

    lnggg = await shared!.getLongitude();
    orgnizationID = await shared.getOrgId();

    print('Response snapshot: ${sessionId}');
    print('Response snapshot: ${lattt}');
    print('Response snapshot: ${lnggg}');
    print('Response snapshot: ${orgnizationID}');

    Future<ClientDataListModal> getEmployeeList11 = getClientList(sessionId!);
    getEmployeeList11.then((value) {
      setState(() {
        clientDataListModalGlobal=value;
      });
      print('clientDataLength ${clientDataListModalGlobal!.data!.length}');
    });



  }

  static List<String> getSuggestions(String query) {

    List<String> matches = <String>[];
    matches.addAll(clientName);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Future<ClientDataListModal> getClientList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.skyWorkDoneClientApi;
    clientDatalist = [];
    clientContact = [];

    print('employeeList11: ${SessionId}');
    ClientDataListModal clientDataListModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId");
    final response = await http.post(urlapi);

    print('URL ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    //print('responseemployeeList $getData');
    clientDataListModal=ClientDataListModal.fromJson(mapResponse);
    var lengthModal = clientDataListModal!.data!.length;
    print('object$lengthModal');
    for(int i=0; i<clientDataListModal!.data!.length;i++){
    //  var clientData = clientDataListModal!.data![i].clientName;
      clientDatalist.add(clientDataListModal!.data![i].clientName);
      //print('clientDataList $clientData');
    }
    var lengthsugg = clientDatalist.length;
    print('object$lengthsugg');

    for(int i=0 ; i< clientDatalist.length ; i++){
      clientName.add(clientDatalist[i]!);
      print('object$clientName');
    }
    return clientDataListModal;
  }

  Future getUploadImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      //final imageTemperory = File(image.path);

      // final imagePermanent = await saveImagePermanent(value);
      */
/*setState(() {
        this._image = value;
      });*//*

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
    request.fields['image'] = value.toString();
    request.fields['address'] = currentAddress;
    request.fields['taskTime'] = formattedDate;
    request.fields['taskDone'] = "DONE";
    request.fields['taskDetails'] = _remarkController.text;
    request.fields['lat'] = lattt.toString();
    request.fields['lng'] = lnggg.toString();
    request.fields['cname'] = _clientNameController.text;
    request.fields['contactnumber'] = _contController;
    request.fields['emailid'] = _emailIdController;
    request.fields['orgname'] = _orgNameController.text;
    request.fields['battery'] = "90";

    */
/* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+_emailIdController.text),
    ));*//*

    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);
    http.Response response = await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());
    */
/*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run"+response.body),
    ));*//*

    String resultSuccess = result['result'];
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      if (resultSuccess.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showSuccessGo(
            context, "You have successfully submitted task details on server at".toString() + " " + formattedDate, "Task Submitted");
      } else if (resultSuccess.compareToIgnoringCase("failed") == 0) {
        CommonNotificationPage.showSuccessGo(
            context, resultSuccess, " Failed ");
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop(); Navigator.of(context).pop();
      CommonNotificationPage.showDialgError(context, result, "reason");
    }
    var reasonSuccess = result['reason'];
    print('result${result}');
    */
/* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sucessfully Run" + result['result']),
    ));*//*

    print('Response body: ${result}');
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
                      */
/*child: Image.file(value!,
                        height: 150,
                        fit: BoxFit.fitWidth,),*//*

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

                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: this._typeAheadController,
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
                            suggestionsCallback: (pattern) {
                              return _SkyDecorWorkDoneState.getSuggestions(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion!),
                              );
                            },
                            transitionBuilder: (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              clientIndex = clientName.indexOf(suggestion);
                              print("Client Index $clientIndex");
                              var clientCont = clientDataListModalGlobal!.data![clientIndex].clientContact;
                              var clientEmail = clientDataListModalGlobal!.data![clientIndex].clientMailId;
                              print("ClientContactNo $clientCont");
                              print("ClientMailId $clientEmail");
                              setState(() {
                                _contController = clientCont;
                                _emailIdController = clientEmail;
                              });
                              this._typeAheadController.text = suggestion!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a city';
                              }
                            },
                            onSaved: (value) => this._selectedCity = value!,
                          ),


                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: TextEditingController(
                                text: _emailIdController == null ? '' : '$_emailIdController'),
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
                            controller: TextEditingController(
                                text: _contController == null ? 'Contact' :'$_contController'),
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
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
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

class CitiesService {

  //static final cities = ['name','ankur','rahul'];


 */
/* static List<String?> getSuggestions(String query) {
     //clientDatalist = <Data>[]<String?>();
     clientDatalist.addAll(cities);
     print("Client List New $clientDatalist");

     clientDatalist.retainWhere((s) => s!.toLowerCase().contains(query.toLowerCase()));
    return clientDatalist;
  }*//*

  */
/*static List<String> getSuggestions(String query) {

    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }*//*

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
}*/
