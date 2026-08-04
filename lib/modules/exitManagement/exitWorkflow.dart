import 'dart:convert';
import 'dart:developer';

import 'package:er_flutter_project/modules/exitManagement/exitList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import 'exitEmployeeList.dart';
import 'modalClasses/separationListModal.dart';

class ExitWorkflow extends StatefulWidget {
  int? empId;
  String? empName;
  ExitWorkflow(this.empId, this.empName);

  @override
  State<ExitWorkflow> createState() => _ExitWorkflowState(empId, empName);
}

SeparationListModal? separationListLabel;
late List<String?> separationList = [];

SessionManager sessionManager = SessionManager();
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<String> separationListGlobal = [];

const int STEPS = 5;

class _ExitWorkflowState extends State<ExitWorkflow> {
  _ExitWorkflowState(int? empId, String? empName);
  var titleName = "Pre-Exit Workflow";
  var empIds;
  var empNames;
  int activeStep = 0;
  bool basicDetExpanded = true;
  bool addressDetExpanded = false;
  bool emergencyContactExpanded = false;
  bool bankAccountExpanded = false;
  bool educationExpanded = false;
  bool previousYearExoExpanded = false;
  bool docUploadExpanded = false;
  bool skillTestExpanded = false;
  bool medicalExpanded = false;
  bool safetyExpanded = false;
  int upperBound = 0;
  final pageController = PageController();
  String radios = "fit";
  String visionSatRadios = "noVisionSat";
  String visualDefRadios = "noVisualDef";
  String visualDefSatRadios = "noVisualDefSat";
  String bPRadios = "BpNo";
  String bPRadiosSat = "bpNoSat";
  String visionRadios = "noVision";
  String hearingRadios = "hearingNo";
  String hearingRadioSat = "hearingNoSat";
  String underGoneRadios = "underGoneNo";
  String underGoneRadioSat = "undergoneNoSat";
  String csfaiRadios = "csfaiNo";
  String csfaiRadioSat = "csfaiNoSat";
  String hasiilsmRadios = "hasiilsmNo";
  String hasiilsmRadioSat = "hasiilsmNoSat";
  String totalVisualPerfRadios = "totalVisualNo";
  String totalVisualRadioSat = "totalVisualNoSat";
  String colorVisionRadios = "colorVisionNo";
  String colorVisionRadioSat = "colorVisionNoSat";
  String coronaRadios = "coronaNo";
  String hivRadios = "hivNo";

  TextEditingController aadharNoController = TextEditingController();
  TextEditingController aadharRegisNoController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();

  dynamic genderDrop = "";
  dynamic maritalStatusDrop = "";
  dynamic departmentDrop = "";
  dynamic designationDrop = "";
  dynamic branchDrop = "";
  dynamic userTypeDrop = "";
  dynamic skillTypeDrop = "";
  dynamic documentLink;
  dynamic exitPolicyDrop = "";
  dynamic fnfPolicyDrop = "";
  dynamic seperationModeDrop = "";
  String radiosSalaryHold = "no";
  String radiosNoticePeriod = "no";
  String radiosNoticePeriodCheck = "complete";
  String salaryHoldYes = "1";
  String salaryHoldNo = "0";
  String noticePeriodYes = "1";
  bool noticePeriodCheck = false;
  String noticePeriodNo = "0";
  String noticePeriodComplete = "1";
  bool partialDaysCheck = false;
  String noticePeriodPartial = "0";
  final TextEditingController actualLeaveDate = TextEditingController();
  final TextEditingController registrationDate = TextEditingController();
  final TextEditingController leavingDate = TextEditingController();
  final TextEditingController pfExitDateController = TextEditingController();
  final TextEditingController esicExitDateController = TextEditingController();
  final TextEditingController lastWorkDate = TextEditingController();
  final TextEditingController noticePeriodDaysController =
      TextEditingController();

  /*  final List<Map<String, String>> files = [
    {'name': 'Menu-icon.png', 'size': '14Kb', 'status': 'Finished', 'type': 'png'},
    {'name': 'App-layout.pdf', 'size': '92.6 of 125.8Mb', 'status': 'Cancel', 'type': 'pdf'},
    {'name': 'Wireframes.pdf', 'size': '22.5 of 90.7Mb', 'status': 'Cancel', 'type': 'pdf'},
    {'name': 'Assets.zip', 'size': '5.8Mb', 'status': 'Finished', 'type': 'zip'},
  ];*/

  // Files list to display
  final List<Map<String, dynamic>> files = [];

  // Function to open camera
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        files.add({
          'name': photo.name,
          'path': photo.path,
          'size':
              '${(File(photo.path).lengthSync() / 1024).toStringAsFixed(2)} Kb',
          'status': 'Finished',
          'type': 'image', // Mark as an image
        });
      });
    }
    Navigator.pop(context);
  }

  // Function to browse files
  Future<void> _browseFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        files.add({
          'name': result.files.single.name,
          'path': result.files.single.path!,
          'size': '${(result.files.single.size / 1024).toStringAsFixed(2)} Kb',
          'status': 'Finished',
          'type': result.files.single.extension ?? 'file', // Get file type
        });
      });
    }
    Navigator.pop(context);
  }

  // Function to get file icon
  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'zip':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Function to delete a file
  void _deleteFile(int index) {
    setState(() {
      files.removeAt(index);
    });
  }

  //DOC Upload Code
  File? uploadedFile; // To store the selected file
  final ImagePicker _picker = ImagePicker();

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      //_openCamera();
                      final pickedFile = await _picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 15,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          uploadedFile = File(pickedFile.path);
                        });
                        if (uploadedFile != null) {
                          setState(() {
                            files.add({
                              'name': uploadedFile!.path,
                              'path': uploadedFile!.path,
                              'status': 'Finished',
                              'type': 'image',
                            });
                          });
                        }
                      }
                    },
                    child: "Camera".text.make(),
                  ).px8(),
                  ElevatedButton(
                    onPressed: () async {
                      //_browseFiles();
                      Navigator.pop(context); // Close the modal
                      final pickedFile = await _picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 15,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          uploadedFile = File(pickedFile.path);
                        });
                        if (uploadedFile != null) {
                          setState(() {
                            files.add({
                              'name': uploadedFile!.path,
                              'path': uploadedFile!.path,
                              'status': 'Finished',
                              'type': 'file',
                            });
                          });
                        }
                      }
                    },
                    child: "Browse".text.make(),
                  ),
                ],
              ),
              /*ElevatedButton.icon(
                  onPressed: _openCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text("Camera"),
                ),
                ElevatedButton.icon(
                  onPressed: _browseFiles,
                  icon: Icon(Icons.folder),
                  label: Text("Browse"),
                ),*/
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    empIds = empId;
    empNames = empName;
    print("EMP Id- $empIds");
    getSharedPrfanceList();
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();

    Future<SeparationListModal?> getLeaveType12 = getSeparationList(sessionId!);
    getLeaveType12.then((value) {
      setState(() {
        separationListLabel = value;
        //var leaveTypeId = value?.leaveData.leaveTypeList;
        //print('object$leaveTypeId');
      });
    });
  }

  Map<int, String> uploadedDocuments = {};

  //Separation List Method
  Future<SeparationListModal?> getSeparationList(String sessionId) async {
    separationList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.exitSeparationListApi;
    print('employeeList11: ${sessionId}');
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    print('responseLeaveTypeList ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['leaveTypeList'];
    print("GETDATA $getData");

    print('responseLeaveTypeList $getData');
    separationListLabel = SeparationListModal.fromJson(mapResponse);
    int? length = separationListLabel?.list?.length;

    print('totalleaveLength $length ');
    /*for(int i=0; i<leaveBalanceLabel!.leaveData!.leaveTypeList!.leaveTypelist!.length;i++){
      String? leaveTypeName = leaveBalanceLabel!.leaveData!.leaveTypeList!.leaveTypelist![i];
        leaveTypeList.add(leaveBalanceLabel!.leaveData!.leaveTypeList!.leaveTypelist![i]);

      print('dataLeaveTypeName $leaveTypeName');
    }*/
    for (int i = 0; i < mapResponse['list'].length; i++) {
      String? separationModeName = mapResponse['list'][i]['name'];
      separationList.add(mapResponse['list'][i]['name']);

      //print('dataLeaveTypeName $leaveTypeName');
      //print("HalfDayShow $halfDayRadioShow");
    }

    return separationListLabel;
  }

  var changeStep = "1";
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: titleName.text.make()),

        bottomNavigationBar: Container(
          height: 75,
          color: context.cardColor,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            //buttonPadding: Vx.mOnly(right: 16),
            children: [
              ElevatedButton(
                onPressed: () {
                  // Increment activeStep, when the next button is tapped. However, check for upper bound.
                  /* if (activeStep < 13) {
                      setState(() {
                        activeStep++;
                      });
                    }*/
                  if (lastWorkDate.text == "") {
                    Fluttertoast.showToast(
                      msg: "Please fill Last Working Date !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    saveExitFormality(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Mythemes.successColor,
                  ),
                ),
                child: "Save".text.make(),
              ).wh(150, 40).py12(),
            ],
          ),
        ),

        body: Container(
          height: double.infinity,
          color: Mythemes.whitish,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 720,
                    child: SingleChildScrollView(
                      child: Card(
                        margin: EdgeInsets.all(12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Exit Details".text.xl.bold.make(),
                              SizedBox(height: 8),
                              Divider(),

                              // Notice Period Label
                              "Notice Period".text.bold.size(13).make(),
                              SizedBox(height: 6),

                              // Yes / No Radios
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "yes",
                                          groupValue: radiosNoticePeriod,
                                          onChanged: (value) {
                                            setState(() {
                                              noticePeriodYes = "1";
                                              noticePeriodCheck = true;
                                              noticePeriodNo = "0";
                                              radiosNoticePeriod =
                                                  value.toString();
                                            });
                                          },
                                        ),
                                        "Yes".text.size(13).make(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "no",
                                          groupValue: radiosNoticePeriod,
                                          onChanged: (value) {
                                            setState(() {
                                              noticePeriodCheck = false;
                                              noticePeriodYes = "0";
                                              noticePeriodNo = "1";
                                              radiosNoticePeriod =
                                                  value.toString();
                                              radiosNoticePeriodCheck =
                                                  'complete';
                                            });
                                          },
                                        ),
                                        "No".text.size(13).make(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Complete / Partial Radios
                              Visibility(
                                visible: radiosNoticePeriod == 'yes',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: "complete",
                                                groupValue:
                                                    radiosNoticePeriodCheck,
                                                onChanged: (value) {
                                                  setState(() {
                                                    noticePeriodComplete = "1";
                                                    partialDaysCheck = false;
                                                    noticePeriodPartial = "0";
                                                    radiosNoticePeriodCheck =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                              "Complete".text.size(13).make(),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: "partial",
                                                groupValue:
                                                    radiosNoticePeriodCheck,
                                                onChanged: (value) {
                                                  setState(() {
                                                    partialDaysCheck = true;
                                                    noticePeriodComplete = "0";
                                                    noticePeriodPartial = "1";
                                                    radiosNoticePeriodCheck =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                              "Partial".text.size(13).make(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          radiosNoticePeriodCheck == 'partial',
                                      child:
                                          TextFormField(
                                            controller:
                                                noticePeriodDaysController,
                                            keyboardType:
                                                TextInputType.numberWithOptions(),
                                            decoration: InputDecoration(
                                              hintText: "Notice Days",
                                              labelText: "Notice Days",
                                              contentPadding: EdgeInsets.all(5),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color:
                                                          Mythemes.blackishade,
                                                    ),
                                                  ),
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Mythemes.blackish,
                                              ),
                                            ),
                                          ).p8(),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 12),

                              // Separation Mode
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: "Separation Mode",
                                  hintText: "Separation Mode",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                                items:
                                    separationList
                                        .map<DropdownMenuItem<String>>((
                                          String? value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value!),
                                          );
                                        })
                                        .toList(),
                                onChanged: (newVal) {
                                  valuenew = newVal.toString();
                                  int i = separationList.indexOf(valuenew);
                                  separationListId =
                                      mapResponse['list'][i]['id'];
                                  separationName =
                                      mapResponse['list'][i]['name'];
                                  separationListGlobal = newVal
                                      .toString()
                                      .split('-');
                                  String idn = separationListGlobal.last;
                                  print('SeparationId $separationListId');
                                  print('Separation Name $separationName');
                                  setState(() {
                                    dropdownNewvalue = newVal;
                                  });
                                },
                              ).p8(),

                              SizedBox(height: 12),

                              // Dates
                              Row(
                                children: [
                                  Visibility(
                                    visible: separationListId != 2,
                                    child: Expanded(
                                      child:
                                          TextFormField(
                                            onTap: () async {
                                              DateTime? fromDate =
                                                  DateTime.now();
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(FocusNode());
                                              fromDate = await showDatePicker(
                                                context: context,
                                                initialDate: fromDate,
                                                firstDate: DateTime(1947),
                                                lastDate: DateTime(2060),
                                              );
                                              setState(() {
                                                registrationDate
                                                    .text = DateFormat(
                                                  "dd-MM-yyyy",
                                                ).format(fromDate!);
                                              });
                                            },
                                            readOnly: true,
                                            controller: registrationDate,
                                            decoration: InputDecoration(
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (registrationDate
                                                      .text
                                                      .isNotEmpty)
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.clear,
                                                        size: 18,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          registrationDate
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  Icon(
                                                    Icons.calendar_month,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                              labelText: "Resignation Date",
                                              contentPadding: EdgeInsets.all(5),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color:
                                                          Mythemes.blackishade,
                                                    ),
                                                  ),
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Mythemes.blackish,
                                              ),
                                            ),
                                          ).p8(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        TextFormField(
                                          onTap: () async {
                                            FocusScope.of(context).requestFocus(
                                              FocusNode(),
                                            ); // to prevent keyboard
                                            DateTime? fromDate =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1947),
                                                  lastDate: DateTime(2060),
                                                );
                                            if (fromDate != null) {
                                              setState(() {
                                                lastWorkDate.text = DateFormat(
                                                  "dd-MM-yyyy",
                                                ).format(fromDate);
                                              });
                                            }
                                          },
                                          readOnly: true,
                                          controller: lastWorkDate,
                                          decoration: InputDecoration(
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (lastWorkDate
                                                    .text
                                                    .isNotEmpty)
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.clear,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        lastWorkDate.clear();
                                                      });
                                                    },
                                                  ),
                                                Icon(
                                                  Icons.calendar_month,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                            labelText: "Last Working Date",
                                            contentPadding: EdgeInsets.all(5),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish,
                                            ),
                                          ),
                                        ).p8(),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),
                              Divider(),

                              // Add Document Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        () => _showUploadOptions(context),
                                    child: Text('Add Document'),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              // Uploaded Files List
                              SizedBox(
                                height: 240,
                                child: ListView.builder(
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];
                                    return Card(
                                      margin: EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading:
                                            file['type'] == 'image'
                                                ? Image.file(
                                                  File(file['path']),
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  filterQuality:
                                                      FilterQuality.low,
                                                )
                                                : Icon(
                                                  _getFileIcon(file['type']),
                                                  size: 40,
                                                  color: Colors.blue,
                                                ),
                                        title: Text(
                                          file['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          '${file['size']} - ${file['status']}',
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _deleteFile(index),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _dobDateController = TextEditingController();
  final TextEditingController _dojDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _inductionDateController =
      TextEditingController();
  var dropdownNewvalue;
  var separationListId;
  var separationName;
  String valuenew = "listText";
  Widget body() {
    var filePath = "Document";
    const List<String> list = <String>[
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
    ];
    String dropdownValue = list.first;
    switch (activeStep) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Exit Details".text.xl.bold.make(),
                      SizedBox(height: 8),
                      Divider(),

                      // Notice Period Label
                      "Notice Period".text.bold.size(13).make(),
                      SizedBox(height: 6),

                      // Yes / No Radios
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: "yes",
                                  groupValue: radiosNoticePeriod,
                                  onChanged: (value) {
                                    setState(() {
                                      noticePeriodYes = "1";
                                      noticePeriodCheck = true;
                                      noticePeriodNo = "0";
                                      radiosNoticePeriod = value.toString();
                                    });
                                  },
                                ),
                                "Yes".text.size(13).make(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: "no",
                                  groupValue: radiosNoticePeriod,
                                  onChanged: (value) {
                                    setState(() {
                                      noticePeriodCheck = false;
                                      noticePeriodYes = "0";
                                      noticePeriodNo = "1";
                                      radiosNoticePeriod = value.toString();
                                      radiosNoticePeriodCheck = 'complete';
                                    });
                                  },
                                ),
                                "No".text.size(13).make(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Complete / Partial Radios
                      Visibility(
                        visible: radiosNoticePeriod == 'yes',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: "complete",
                                        groupValue: radiosNoticePeriodCheck,
                                        onChanged: (value) {
                                          setState(() {
                                            noticePeriodComplete = "1";
                                            partialDaysCheck = false;
                                            noticePeriodPartial = "0";
                                            radiosNoticePeriodCheck =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Complete".text.size(13).make(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: "partial",
                                        groupValue: radiosNoticePeriodCheck,
                                        onChanged: (value) {
                                          setState(() {
                                            partialDaysCheck = true;
                                            noticePeriodComplete = "0";
                                            noticePeriodPartial = "1";
                                            radiosNoticePeriodCheck =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Partial".text.size(13).make(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: radiosNoticePeriodCheck == 'partial',
                              child:
                                  TextFormField(
                                    controller: noticePeriodDaysController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                      hintText: "Notice Days",
                                      labelText: "Notice Days",
                                      contentPadding: EdgeInsets.all(5),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Mythemes.blackish,
                                      ),
                                    ),
                                  ).p8(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),
                      Divider(),

                      // Separation Mode
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Separation Mode",
                          hintText: "Separation Mode",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Mythemes.blackishade,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(5),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Mythemes.blackish,
                          ),
                        ),
                        items:
                            separationList.map<DropdownMenuItem<String>>((
                              String? value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value!),
                              );
                            }).toList(),
                        onChanged: (newVal) {
                          valuenew = newVal.toString();
                          int i = separationList.indexOf(valuenew);
                          separationListId = mapResponse['list'][i]['id'];
                          separationName = mapResponse['list'][i]['name'];
                          separationListGlobal = newVal.toString().split('-');
                          String idn = separationListGlobal.last;
                          print('SeparationId $separationListId');
                          print('Separation Name $separationName');
                          setState(() {
                            dropdownNewvalue = newVal;
                          });
                        },
                      ).p8(),

                      SizedBox(height: 12),
                      Divider(),

                      // Dates
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  onTap: () async {
                                    DateTime? fromDate = DateTime.now();
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    fromDate = await showDatePicker(
                                      context: context,
                                      initialDate: fromDate,
                                      firstDate: DateTime(1947),
                                      lastDate: DateTime(2060),
                                    );
                                    setState(() {
                                      registrationDate.text = DateFormat(
                                        "dd-MM-yyyy",
                                      ).format(fromDate!);
                                    });
                                  },
                                  readOnly: true,
                                  controller: registrationDate,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      size: 18,
                                    ),
                                    labelText: "Resignation Date",
                                    contentPadding: EdgeInsets.all(5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                ).p8(),
                          ),
                          Expanded(
                            child:
                                TextFormField(
                                  onTap: () async {
                                    DateTime? fromDate = DateTime.now();
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    fromDate = await showDatePicker(
                                      context: context,
                                      initialDate: fromDate,
                                      firstDate: DateTime(1947),
                                      lastDate: DateTime(2060),
                                    );
                                    setState(() {
                                      lastWorkDate.text = DateFormat(
                                        "dd-MM-yyyy",
                                      ).format(fromDate!);
                                    });
                                  },
                                  readOnly: true,
                                  controller: lastWorkDate,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      size: 18,
                                    ),
                                    labelText: "Last Working Date",
                                    contentPadding: EdgeInsets.all(5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                ).p8(),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Divider(),

                      // Add Document Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _showUploadOptions(context),
                            child: Text('Add Document'),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Uploaded Files List
                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                leading:
                                    file['type'] == 'image'
                                        ? Image.file(
                                          File(file['path']),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                        )
                                        : Icon(
                                          _getFileIcon(file['type']),
                                          size: 40,
                                          color: Colors.blue,
                                        ),
                                title: Text(
                                  file['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  '${file['size']} - ${file['status']}',
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteFile(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Card(
                  child: ExpansionTile(
                    //key: keyTile,
                    initiallyExpanded: skillTestExpanded,
                    childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                    title: "Skill Testing".text.make(),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Screened BY IR",
                                    labelText: "Screened BY IR",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Referred RO",
                                    labelText: "Referred RO",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "For",
                                    labelText: "For",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Suitable For Employment As",
                                    labelText: "Suitable For Employment As",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 2:
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Card(
                  child: ExpansionTile(
                    //key: keyTile,
                    initiallyExpanded: medicalExpanded,
                    childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                    title: "Medical".text.make(),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Certificate No.",
                                  labelText: "Medical Certificate No.",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              /*title:
                                "Designation/Trade of the work".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                //maxLines: 3,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Aadhar Number",
                                  labelText: "Aadhar Number",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*  border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Weight",
                                  labelText: "Weight",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              /*title:
                                "Designation/Trade of the work".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                //maxLines: 3,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Height",
                                  labelText: "Height",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*  border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              /*title:
                                "Designation/Trade of the work".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                //maxLines: 3,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Blood Group",
                                  labelText: "Blood Group",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*  border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Any Mark",
                                  labelText: "Identification Mark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              /*title:
                                "Designation/Trade of the work".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                //maxLines: 3,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Any Other Mark",
                                  labelText: "Other Identification Mark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*  border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Vision",
                                  labelText: "Vision",
                                  hintStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              /*title:
                                "Designation/Trade of the work".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                //maxLines: 3,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "DD-MM-YYYY",
                                  labelText: "Due date for periodic medical ex",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*  border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Medical Fitness Remarks",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Medical Fitness".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "fit",
                                        groupValue: radios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Fit Click"),
                                            ),
                                          );
                                          setState(() {
                                            radios = value.toString();
                                          });
                                        },
                                      ),
                                      "Fit".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "unFit",
                                        groupValue: radios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Un-Fit Click"),
                                            ),
                                          );
                                          setState(() {
                                            radios = value.toString();
                                          });
                                        },
                                      ),
                                      "Un Fit".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Vision Deficiency Observed".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: "yesVision",
                                          groupValue: visionRadios,
                                          onChanged: (value) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Yes Vision Click",
                                                ),
                                              ),
                                            );
                                            setState(() {
                                              visionRadios = value.toString();
                                            });
                                          },
                                        ),
                                        "Yes".text.make(),
                                      ],
                                    ),
                                  ).px1(),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: "noVision",
                                          groupValue: visionRadios,
                                          onChanged: (value) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "No vision Click",
                                                ),
                                              ),
                                            );
                                            setState(() {
                                              visionRadios = value.toString();
                                            });
                                          },
                                        ),
                                        "No".text.make(),
                                      ],
                                    ),
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Vision Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "yesVisionSat",
                                        groupValue: visionSatRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes vision satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            visionSatRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "noVisionSat",
                                        groupValue: visionSatRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No vision satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            visionSatRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Vision Remarks",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Vision Deformity/Physically Abnormally Do"
                                      .text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "yesVisualDef",
                                        groupValue: visualDefRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Visual Def Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            visualDefRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "noVisualDef",
                                        groupValue: visualDefRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No visual Def Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            visualDefRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Vision Deformity/Physically Abnormally Satisfactory"
                                      .text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "yesVisualDefSat",
                                        groupValue: visualDefSatRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes visual Def satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            visualDefSatRadios =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "noVisualDefSat",
                                        groupValue: visualDefSatRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No visual Def satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            visualDefSatRadios =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText:
                                      "Vision Deformity/Physically Abnormally",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Blood Pressure Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "BpYes",
                                        groupValue: bPRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Yes BP Click"),
                                            ),
                                          );
                                          setState(() {
                                            bPRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "BpNo",
                                        groupValue: bPRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("No BP Click"),
                                            ),
                                          );
                                          setState(() {
                                            bPRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Blood Pressure Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "bpYesSat",
                                        groupValue: bPRadiosSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes BP satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            bPRadiosSat = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "bpNoSat",
                                        groupValue: bPRadiosSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No BP satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            bPRadiosSat = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "BP Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Hearing Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hearingYes",
                                        groupValue: hearingRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Hearing Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            hearingRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hearingNo",
                                        groupValue: hearingRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("No Hearing Click"),
                                            ),
                                          );
                                          setState(() {
                                            hearingRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Hearing Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hearingYesSat",
                                        groupValue: hearingRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Hearing satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            hearingRadioSat = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hearingNoSat",
                                        groupValue: hearingRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Hearing satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            hearingRadioSat = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Hearing Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Undergone Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "underGoneYes",
                                        groupValue: underGoneRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Undergone Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            underGoneRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "underGoneNo",
                                        groupValue: underGoneRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Undergone Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            underGoneRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Undergone Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "undergoneYesSat",
                                        groupValue: underGoneRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Undergone satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            underGoneRadioSat =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "undergoneNoSat",
                                        groupValue: underGoneRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Undergone satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            underGoneRadioSat =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Undergone Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "CSFAI Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "csfaiYes",
                                        groupValue: csfaiRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Yes CSFAI Click"),
                                            ),
                                          );
                                          setState(() {
                                            csfaiRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "csfaiNo",
                                        groupValue: csfaiRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("No CSFAI Click"),
                                            ),
                                          );
                                          setState(() {
                                            csfaiRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "CSFAI Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "csfaiYesSat",
                                        groupValue: csfaiRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes CSFAI satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            csfaiRadioSat = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "csfaiNoSat",
                                        groupValue: csfaiRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No CSFAI satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            csfaiRadioSat = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "CSFAI Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "HASIILSM Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hasiilsmYes",
                                        groupValue: hasiilsmRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes HASIILSM Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            hasiilsmRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hasiilsmNo",
                                        groupValue: hasiilsmRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("No CSFAI Click"),
                                            ),
                                          );
                                          setState(() {
                                            hasiilsmRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "HASIILSM Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hasiilsmYesSat",
                                        groupValue: hasiilsmRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes HASIILSM satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            hasiilsmRadioSat = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hasiilsmNoSat",
                                        groupValue: hasiilsmRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No HASIILSM satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            hasiilsmRadioSat = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "HASIILSM Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Total Visual Performance Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "totalVisualYes",
                                        groupValue: totalVisualPerfRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Total Visual Performance Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            totalVisualPerfRadios =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "totalVisualNo",
                                        groupValue: totalVisualPerfRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Total Visual Performance Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            totalVisualPerfRadios =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Total Visual Performance Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "totalVisualYesSat",
                                        groupValue: totalVisualRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Total Visual Performance satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            totalVisualRadioSat =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "totalVisualNoSat",
                                        groupValue: totalVisualRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Total Visual Performance satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            totalVisualRadioSat =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Total Visual Performance Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title:
                                  "Colour Vision Do".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "colorVisionYes",
                                        groupValue: colorVisionRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Colour Vision Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            colorVisionRadios =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "colorVisionNo",
                                        groupValue: colorVisionRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Colour Vision Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            colorVisionRadios =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Colour Vision Satisfactory".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "colorVisionYesSat",
                                        groupValue: colorVisionRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Yes Colour Vision satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            colorVisionRadioSat =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "colorVisionNoSat",
                                        groupValue: colorVisionRadioSat,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "No Colour Vision satisfactory Click",
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            colorVisionRadioSat =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Colour Vision Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "Corona Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "Corona Deficiency Observed".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "coronaYes",
                                        groupValue: coronaRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Corona yes Click"),
                                            ),
                                          );
                                          setState(() {
                                            coronaRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "coronaNo",
                                        groupValue: coronaRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Corona No Click"),
                                            ),
                                          );
                                          setState(() {
                                            coronaRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              /* title:
                                "Medical Certificate No.".text.overflow(TextOverflow.ellipsis).maxLines(1).maxFontSize(12).make().px4().py2(),*/
                              subtitle: TextFormField(
                                //controller: _locationController,
                                enabled: true,
                                // initialValue: "Head Office",
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //<-- SEE HERE
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  hintText: "Enter Remarks",
                                  labelText: "HIV Remark",
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title:
                                  "HIV Deficiency Observed".text
                                      .overflow(TextOverflow.ellipsis)
                                      .maxLines(1)
                                      .maxFontSize(12)
                                      .make()
                                      .px4()
                                      .py2(),
                              subtitle: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hivYes",
                                        groupValue: hivRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("HIV yes Click"),
                                            ),
                                          );
                                          setState(() {
                                            hivRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "Yes".text.make(),
                                    ],
                                  ).px1(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "hivNo",
                                        groupValue: hivRadios,
                                        onChanged: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("HIV No Click"),
                                            ),
                                          );
                                          setState(() {
                                            hivRadios = value.toString();
                                          });
                                        },
                                      ),
                                      "No".text.make(),
                                    ],
                                  ).px1(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 3:
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Card(
                  child: ExpansionTile(
                    //key: keyTile,
                    initiallyExpanded: safetyExpanded,
                    childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                    title: "Safety".text.make(),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Previous Induction Reference",
                                    labelText: "Previous Induction Reference",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                ).p8(),
                          ),
                          Expanded(
                            child:
                                TextFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "IR Project Site",
                                    labelText: "IR Project Site",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                ).p8(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Induction Reference",
                                    labelText: "Induction Reference",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                ).p8(),
                          ),
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Approved For Employee By",
                                    labelText: "Approved For Employee By",
                                    hintStyle: TextStyle(fontSize: 13),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  onTap: () async {
                                    DateTime? fromDate = DateTime.now();
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());

                                    fromDate = await showDatePicker(
                                      context: context,
                                      initialDate: fromDate,
                                      firstDate: DateTime(1947),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 0),
                                      ),
                                    );
                                    setState(() {
                                      //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                      _inductionDateController
                                          .text = DateFormat(
                                        "dd-MM-yyyy",
                                      ).format(fromDate!);
                                    });

                                    print(fromDate);
                                  },
                                  readOnly: true,
                                  enabled: true,
                                  controller: _inductionDateController,
                                  // initialValue: "Head Office",
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      size: 18,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    labelText: "Induction Date",
                                    hintStyle: TextStyle(fontSize: 12),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                ).p8(),
                          ),
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Project Site",
                                    labelText: "Project Site",
                                    hintStyle: TextStyle(fontSize: 13),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Trade Recommandations",
                                    labelText: "Trade Recommandations",
                                    hintStyle: TextStyle(fontSize: 13),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                          Expanded(
                            child:
                                DropdownButtonFormField(
                                  /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Safety Approved By",
                                    labelText: "Safety Approved By",
                                    hintStyle: TextStyle(fontSize: 13),
                                    contentPadding: EdgeInsets.all(5),
                                    /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                    // labelText: "Location",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                  ],

                                  onChanged: (int? value) {
                                    setState(() {
                                      value = value!;
                                    });
                                  },
                                ).p8(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }

    return
    //ignore this section please
    ButtonBar(
      children: [
        /*ElevatedButton(
            onPressed: () {
            },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(Mythemes.dangerColorOne),
            ),
            child: "Back".text.make(),
          ).wh(150, 40).py12(),*/

        /* ElevatedButton(
            onPressed: () {

            },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(Mythemes.lightBluishColor),
            ),
            child: "Next".text.make(),
          ).wh(150, 40).py12()*/
      ],
    );
  }

  static showDialgSucess(
    BuildContext buildContext,
    String result,
    String alert,
  ) {
    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(children: [Expanded(child: Text(alert))]),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  // âœ… Using `context` inside the builder
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(); // Close the dialog
                  Navigator.of(buildContext).maybePop();
                } else {
                  print("âš ï¸ Warning: No route to close.");
                }
              },
              child: Text("Ok"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExitEmployeeListView(),
                  ),
                );
              },
              child: Text("Go to Exit List"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }

  Future<void> saveExitFormality(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.exitFormalitySaveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['empid'] = empIds.toString();
    request.fields['seprationId'] = separationListId.toString();
    request.fields['noticePayServeActive'] = noticePeriodCheck.toString();
    request.fields['partialDaysActive'] = partialDaysCheck.toString();
    request.fields['partialDaysValue'] = noticePeriodDaysController.text;
    request.fields['resignData'] = registrationDate.text;
    request.fields['lastworkingData'] = lastWorkDate.text;
    uploadedFile == null
        ? request.fields['document'] = ""
        : request.files.add(
          await http.MultipartFile.fromPath('document', uploadedFile!.path),
        );

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String status = mapResponse['status'];

        // Handle success or error response
        if (status.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (status.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  /*Future<void> saveExitFormality(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.exitFormalitySaveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");

    // Prepare document as base64 (if uploadedFile is not null)
    String documentBase64 = "";
    if (uploadedFile != null) {
      List<int> fileBytes = await uploadedFile!.readAsBytes();
      documentBase64 = base64Encode(fileBytes);
    }

    // Build JSON body
    Map<String, dynamic> requestBody = {
      'sessionId': sessionId!,
      'empid': empIds.toString(),
      'seprationId': separationListId.toString(),
      'noticePayServeActive': noticePeriodCheck.toString(),
      'partialDaysActive': partialDaysCheck.toString(),
      'partialDaysValue': noticePeriodDaysController.text,
      'resignData': registrationDate.text,
      'lastworkingData': lastWorkDate.text,
      'document': documentBase64, // send as base64 string in JSON
    };

    // Construct API with parameters (debug print only)
    String apiWithParams = urlapi.toString() +
        '?' +
        requestBody.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send as JSON POST
      http.Response httpResponse = await MobileHttpClient.instance.post(
        urlapi,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String status = mapResponse['status'];

        if (status.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (status.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }*/

  /*  IconData _getFileIcon(String type) {
    switch (type) {
      case 'png':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }*/

  //Image picker
  Future<String> pickImage({ImageSource? source}) async {
    final picker = ImagePicker();

    String path = '';

    try {
      final getImage = await picker.pickImage(source: source!);

      if (getImage != null) {
        path = getImage.path;
      } else {
        path = '';
      }
    } catch (e) {
      log(e.toString());
    }

    return path;
  }

  //Image crop
  Future<String> imageCropperView(String? path, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path!,

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Mythemes.lightBluishColor,
          toolbarWidgetColor: Mythemes.whitish,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        WebUiSettings(context: context),
      ],
    );

    if (croppedFile != null) {
      log("Image cropped");
      return croppedFile.path;
    } else {
      log("Do nothing");
      return '';
    }
  }

  /*void _showUploadOptions(BuildContext context,
      {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 120,
            child: Column(
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          pickImage(source: ImageSource.camera)
                              .then((value) {
                            if (value != '') {
                              imageCropperView(value, context)
                                  .then((value) {
                                    documentLink = value;
                                    print("Document Link -  ${documentLink}");

                              });
                            }
                          });
                        },
                        child: "Camera".text.make())
                        .px8(),
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: "Browse".text.make()),
                  ],
                )
              ],
            ),
          );
        });
  }*/

  Future<void> saveInductionData(
    String aadharNo,
    String aadharRegisNo,
    String firstName,
    String emailId,
    String mobileNo,
    String dob,
    String gender,
    String empStatus,
    String maritalStatus,
    String doj,
    String department,
    String designation,
    String branch,
    String userType,
    String skillType,
    String permanentAddress,
    String currentAddress,
    String docs,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardingSave;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "aadharNo=$aadharNo&"
      "aadharRegisNo=$aadharRegisNo&"
      "firstName=$firstName&"
      "emailId=$emailId&"
      "mobileNo=$mobileNo&"
      "dob=$dob&"
      "gender=$gender&"
      "empStatus=$empStatus&"
      "maritalStatus=$maritalStatus&"
      "doj=$doj&"
      "department=$department&"
      "designation=$designation&"
      "branch=$branch&"
      "userType=$userType&"
      "skillType=$skillType&"
      "permanentAddress=$permanentAddress&"
      "currentAddress=$currentAddress&"
      "docs=$docs",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      String status = mapResponse['status'];
      print('reason both $reason $status');
      print('reason${reason}');
      if (status.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase + " ",
          "Success",
        );
      } else if (status.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase,
          " Error ",
        );
      }
    }
  }

  Future<void> draftInductionData(
    String aadharNo,
    String aadharRegisNo,
    String firstName,
    String emailId,
    String mobileNo,
    String dob,
    String gender,
    String empStatus,
    String maritalStatus,
    String doj,
    String department,
    String designation,
    String branch,
    String userType,
    String skillType,
    String permanentAddress,
    String currentAddress,
    String docs,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardingSave;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "aadharNo=$aadharNo&"
      "aadharRegisNo=$aadharRegisNo&"
      "firstName=$firstName&"
      "emailId=$emailId&"
      "mobileNo=$mobileNo&"
      "dob=$dob&"
      "gender=$gender&"
      "empStatus=$empStatus&"
      "maritalStatus=$maritalStatus&"
      "doj=$doj&"
      "department=$department&"
      "designation=$designation&"
      "branch=$branch&"
      "userType=$userType&"
      "skillType=$skillType&"
      "permanentAddress=$permanentAddress&"
      "currentAddress=$currentAddress&"
      "docs=$docs",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.pop(context);
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      String status = mapResponse['status'];
      print('reason both $reason $status');
      print('reason${reason}');
      if (status.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase + " ",
          "Success",
        );
      } else if (status.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase,
          " Error ",
        );
      }
    }
  }

  Widget headerText() {
    switch (activeStep) {
      case 0:
        return 'Basic Details'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();

      case 1:
        return 'Document Verification'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();

      case 2:
        return 'ID Card'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();

      case 3:
        return 'Roles & Permissions'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();

      case 4:
        return 'Shift'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 5:
        return 'Leave Policy'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 6:
        return 'Paid Days Policy'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 7:
        return 'Salary Breakup'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 8:
        return 'Device/Mob Details'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 9:
        return 'Device Details'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 10:
        return 'Device Registration'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 11:
        return 'Salary Structure'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 12:
        return 'Induction Documentation'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
      case 13:
        return 'Final Approval'.text
            .align(TextAlign.left)
            .xl
            .fontWeight(FontWeight.w500)
            .make();
    }

    return SizedBox(height: 0);
  }

  void openFiles(List<PlatformFile> files) {}

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
    print('Bytes: ${file.name}');
    print('Size: ${file.size}');
    print('Size: ${file.extension}');
    print('Path: ${file.path}');
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}

// The DismissKeybaord widget (it's reusable)
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
