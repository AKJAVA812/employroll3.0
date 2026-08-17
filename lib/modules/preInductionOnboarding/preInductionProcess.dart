import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as developer;
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
import '../inductionOnboarding/modalClass/onboardBranchListModal.dart';
import '../inductionOnboarding/modalClass/onboardDeptListModal.dart';
import '../inductionOnboarding/modalClass/onboardDesignationListModal.dart';
import '../inductionOnboarding/modalClass/onboardDocTypeListModal.dart';
import '../inductionOnboarding/modalClass/onboardUserTypeListModal.dart';

class PreInductionProcess extends StatefulWidget {
  const PreInductionProcess({super.key});

  @override
  State<PreInductionProcess> createState() => _PreInductionProcessState();
}

List<String?> onboardBranchList = [];
List<String?> onboardDeptList = [];
List<String?> onboardDesignationList = [];
List<String?> onboardUserTypeList = [];
List<String?> onboardDocTypeList = [];
List<String?> queryTypeList = [];
List<String?> subQueryTypeList = [];

SessionManager sessionManager = SessionManager();
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
late var result;
const int STEPS = 5;

class _PreInductionProcessState extends State<PreInductionProcess> {
  OnboardBranchListModal? onboardBranchListModal;
  OnboardDeptListModal? onboardDeptListModal;
  OnboardDesignationListModal? onboardDesignationListModal;
  OnboardUserTypeListModal? onboardUserTypeListModal;
  OnboardDocTypeListModal? onboardDocTypeListModal;

  @override
  void initState() {
    // TODO: implement initState
    getSharedPrfanceList();
    setState(() {});
    super.initState();
  }

  var titleName = "Pre-Onboarding Process";
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
  String valuenew = "listText";
  String valuenewSub = "listText";
  String valuenewDesignation = "listText";
  String valuenewUserType = "listText";
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController aadharRegisNoController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController inHandSalaryController = TextEditingController();
  TextEditingController nomineeNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController familyRelationController = TextEditingController();
  TextEditingController nomineeAadharController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();

  dynamic genderDrop = "";
  dynamic empStatusDrop = "";
  dynamic maritalStatusDrop = "";
  dynamic departmentDrop = "";
  dynamic designationDrop = "";
  dynamic branchDrop = "";
  dynamic userTypeDrop = "";
  dynamic skillTypeDrop = "";
  dynamic documentLink;

  var genderName = "";
  var empStatusName = "";
  var maritalStatusName = "";
  var skillTypeName = "";

  var branchId = "";
  var deptId = "";
  var desigId = "";
  var desigName = "";
  var userTypeId = "";
  var docTypeId = "";
  Color aadharVerifyColor = Mythemes.lightBluishColor;
  // Files list to display
  final List<Map<String, dynamic>> files = [];

  Future<void> _handleFileUpload(int index, {required bool isCamera}) async {
    String titleKey = documentTitles[index];

    if (isCamera) {
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        String uploadedDocName = photo.name;

        setState(() {
          uploadedDocuments[titleKey] = photo.path; // ðŸ‘ˆ Save with key
          files.add({
            'name': uploadedDocName,
            'path': photo.path,
            'size':
                '${(File(photo.path).lengthSync() / 1024).toStringAsFixed(2)} Kb',
            'status': 'Finished',
            'type': 'image',
          });
        });
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        String uploadedDocName = result.files.single.name;

        setState(() {
          uploadedDocuments[titleKey] =
              result.files.single.path!; // ðŸ‘ˆ Save with key
          files.add({
            'name': uploadedDocName,
            'path': result.files.single.path!,
            'size':
                '${(result.files.single.size / 1024).toStringAsFixed(2)} Kb',
            'status': 'Finished',
            'type': result.files.single.extension ?? 'file',
          });
        });
      }
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

  Future<void> verifyAadhar(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.preOnboardAadharVerifyApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['aadharNumber'] = aadharNoController.text;

    try {
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);

      Navigator.of(context, rootNavigator: true).pop();

      if (httpResponse.statusCode == 200) {
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        if (result.compareToIgnoringCase("Success") == 0) {
          Fluttertoast.showToast(
            msg: reason,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Mythemes.successColor,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          setState(() {
            aadharVerifyColor = Mythemes.successColor;
          });
        } else if (result.compareToIgnoringCase("Error") == 0) {
          Fluttertoast.showToast(
            msg: reason,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Mythemes.dangerColor,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          setState(() {
            aadharVerifyColor = Mythemes.dangerColor;
          });
        }
      }
    } catch (e) {
    }
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    Future<OnboardBranchListModal> getEmployeeList13 = getBranchList(
      sessionId!,
    );
    getEmployeeList13.then((value) {
      setState(() {
        onboardBranchListModal = value;
      });
    });
    Future<OnboardDeptListModal> getEmployeeList14 = getDeptList(sessionId!);
    getEmployeeList14.then((value) {
      setState(() {
        onboardDeptListModal = value;
      });
    });
    Future<OnboardDesignationListModal> getEmployeeList15 = getDesignationList(
      sessionId!,
    );
    getEmployeeList15.then((value) {
      setState(() {
        onboardDesignationListModal = value;
      });
    });
    /*Future<OnboardUserTypeListModal> getEmployeeList16 = getUserTypeList(sessionId!);
    getEmployeeList16.then((value) {
      setState(() {
        onboardUserTypeListModal=value;
      });


    });
    loadData();*/
    /*Future<OnboardDocTypeListModal> getEmployeeList17 = getDocTypeList(sessionId!);
    getEmployeeList17.then((value) {
      setState(() {
        onboardDocTypeListModal=value;
      });


    });*/
  }

  Map<String, String> uploadedDocuments = {};

  Future<OnboardBranchListModal> getBranchList(String sessionId) async {
    onboardBranchList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardBranchList;

    //print('employeeList11: ${SessionId}');
    OnboardBranchListModal onboardBranchListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    onboardBranchListModal = OnboardBranchListModal.fromJson(mapResponse);

    for (int i = 0; i < mapResponse['data'].length; i++) {
      onboardBranchList.add(mapResponse['data'][i]['name'].toString());
      branchId = mapResponse['data'][i]['id'].toString();

      //print("HalfDayShow $halfDayRadioShow");
    }

    return onboardBranchListModal;
  }

  Future<OnboardDeptListModal> getDeptList(String sessionId) async {
    onboardDeptList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardDeptList;

    //print('employeeList11: ${SessionId}');
    OnboardDeptListModal onboardDeptListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    onboardDeptListModal = OnboardDeptListModal.fromJson(mapResponse);

    for (int i = 0; i < mapResponse['data'].length; i++) {
      onboardDeptList.add(mapResponse['data'][i]['name'].toString());
      deptId = mapResponse['data'][i]['id'].toString();

      //print("HalfDayShow $halfDayRadioShow");
    }

    return onboardDeptListModal;
  }

  Future<OnboardDesignationListModal> getDesignationList(
    String sessionId,
  ) async {
    onboardDesignationList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardDesignationList;

    //print('employeeList11: ${SessionId}');
    OnboardDesignationListModal onboardDesignationListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    onboardDesignationListModal = OnboardDesignationListModal.fromJson(
      mapResponse,
    );

    for (int i = 0; i < mapResponse['data'].length; i++) {
      onboardDesignationList.add(mapResponse['data'][i]['name'].toString());
      desigId = mapResponse['data'][i]['id'].toString();
      desigName = mapResponse['data'][i]['name'].toString();

      //print("HalfDayShow $halfDayRadioShow");
    }

    return onboardDesignationListModal;
  }

  Future<OnboardUserTypeListModal> getUserTypeList(String sessionId) async {
    onboardUserTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardUserTypeList;

    //print('employeeList11: ${SessionId}');
    OnboardUserTypeListModal onboardUserTypeListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    onboardUserTypeListModal = OnboardUserTypeListModal.fromJson(mapResponse);

    for (int i = 0; i < mapResponse['data'].length; i++) {
      onboardUserTypeList.add(mapResponse['data'][i]['name'].toString());
      userTypeId = mapResponse['data'][i]['id'].toString();

      //print("HalfDayShow $halfDayRadioShow");
    }

    return onboardUserTypeListModal;
  }

  var showNoData;

  var typeOfHiringRadio = "new";
  var accommodationRadio = "withoutAccommodation";
  String withoutAccommodation = "1";
  bool accomodationCheck = false;
  String withAccommodation = "0";
  String newHire = "1";
  String replacementHiring = "0";
  String typeOfHireName = "New";
  String reHiring = "2";

  Future<OnboardDocTypeListModal> getDocTypeList(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardDocTypeList;

    //print('employeeList11: ${SessionId}');
    OnboardDocTypeListModal onboardDocTypeListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    /*  setState(() {
      isLoading = true; // Start loading
    });*/
    developer.log("response:- ", name: response.body);
    mapResponse = json.decode(response.body);
    var getData = mapResponse.length;
    if (getData == 0) {
      showNoData = true;
    }
    onboardDocTypeListModal = OnboardDocTypeListModal.fromJson(mapResponse);
    return onboardDocTypeListModal;
  }

  void _showUploadOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OverflowBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _handleFileUpload(index, isCamera: true);
                      /* _openCamera(index);*/
                    },
                    child: "Camera".text.make(),
                  ).px8(),
                  ElevatedButton(
                    onPressed: () {
                      _handleFileUpload(index, isCamera: false);
                      /*  _browseFiles(index);*/
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

  var dropdownNewvalue;
  var dropdownNewvalueNew;
  var dropdownDepartmentValue;
  var dropdownDesignationValue;
  var dropdownNewvalueUserType;
  var changeStep = "1";
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: titleName.text.make()),

        bottomNavigationBar: Container(
          height: 75,
          color: context.cardColor,
          child: OverflowBar(
            alignment: MainAxisAlignment.center,
            //buttonPadding: Vx.mOnly(right: 16),
            children: [
              /* activeStep <= 0  ? SizedBox(
                  width: 0,
                ) :*/
              /*ElevatedButton(
                  onPressed: () {


                    draftInductionData(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Mythemes.alertColor),
                  ),
                  child: "Draft".text.make(),
                ).wh(150, 40).py12(),*/
              ElevatedButton(
                onPressed: () {
                  // Increment activeStep, when the next button is tapped. However, check for upper bound.
                  /* if (activeStep < 13) {
                      setState(() {
                        activeStep++;
                      });
                    }*/

                  saveInductionData(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
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
              child: Column(children: [SizedBox(height: 620, child: body())]),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = true;
  Future<void> loadData() async {
    onboardDocTypeListModal = await getDocTypeList(sessionId!);
    setState(() {
      isLoading = false; // Stop loading once data is loaded
    });
  }

  List<String> documentTitles = [
    "Aadhar Card Front",
    "Aadhar Card Back",
    "Pan Card",
    "Employee Photo",
  ];

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _dobDateController = TextEditingController();
  final TextEditingController _familyDobDateController =
      TextEditingController();
  final TextEditingController _dojDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _inductionDateController =
      TextEditingController();
  Widget body() {
    /* if(onboardDocTypeListModal!.data != 0){
      for(int i=0; i<onboardDocTypeListModal!.data!.length;i++){
        */ /* onboardUserTypeList.add(mapResponse['data'][i]['name'].toString());*/ /*
        docTypeId =onboardDocTypeListModal!.data![i].id.toString();

        print('ID -  $docTypeId');
        //print("HalfDayShow $halfDayRadioShow");
      }
    }*/

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
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["Type of Hiring".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Salary on hold
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "new",
                                  groupValue: typeOfHiringRadio,
                                  onChanged: (value) {
                                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("On Date Click"),
                        ));*/
                                    setState(() {
                                      newHire = "1";
                                      typeOfHireName = "New";
                                      replacementHiring = "0";
                                      replacementHiring = "2";
                                      typeOfHiringRadio = value.toString();
                                    });
                                  },
                                ),
                                "New".text.size(13).make(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "replacement",
                                  groupValue: typeOfHiringRadio,
                                  onChanged: (value) {
                                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Next Day Click"),
                        ));*/
                                    setState(() {
                                      newHire = "1";
                                      typeOfHireName = "Replacement";
                                      replacementHiring = "0";
                                      replacementHiring = "2";
                                      typeOfHiringRadio = value.toString();
                                    });
                                  },
                                ),
                                "Replace".text.size(13).make(),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "rehire",
                                  groupValue: typeOfHiringRadio,
                                  onChanged: (value) {
                                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Next Day Click"),
                        ));*/
                                    setState(() {
                                      newHire = "1";
                                      typeOfHireName = "Re-Hire";
                                      replacementHiring = "0";
                                      replacementHiring = "2";
                                      typeOfHiringRadio = value.toString();
                                    });
                                  },
                                ),
                                "Re-Hire".text.size(13).make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).py8(),
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["Basic Details".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        children: [
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    controller: aadharNoController,
                                    enabled: true,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(12),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                    ],
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
                                      //labelText: "Select Department",
                                      hintText: "Aadhar No.",
                                      labelText: "Aadhar No.",
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
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          verifyAadhar(context);
                                        },
                                        icon: Icon(
                                          Icons.check_circle,
                                          size: 22,
                                          color: aadharVerifyColor,
                                        ),
                                      ),
                                    ),
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Fist Name
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    controller: fullNameController,
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
                                      //labelText: "Select Department",
                                      hintText: "Full Name",
                                      labelText: "Full Name",
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
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //DOB
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                        _dobDateController.text = DateFormat(
                                          "dd-MM-yyyy",
                                        ).format(fromDate!);
                                      });

                                    },
                                    readOnly: true,
                                    enabled: true,
                                    controller: _dobDateController,
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
                                      labelText: "Date of Birth",
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
                          ),
                          //Date of Joining
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                        _dojDateController.text = DateFormat(
                                          "dd-MM-yyyy",
                                        ).format(fromDate!);
                                      });

                                    },
                                    readOnly: true,
                                    enabled: true,
                                    controller: _dojDateController,
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
                                      labelText: "Date of Joining",
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
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //Mobile No.
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                    ],
                                    controller: mobNoController,
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
                                      //labelText: "Select Department",
                                      hintText: "Mobile No.",
                                      labelText: "Mobile No.",
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ).py8(),
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["Job Details".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        children: [
                          // Branch dropdown
                          Expanded(
                            child: Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  isExpanded:
                                      true, // âœ… Important for avoiding overflow
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    hintText: "Branch",
                                    labelText: "Branch",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items:
                                      onboardBranchList.map((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value!,
                                            style: TextStyle(fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (newVal) {
                                    valuenew = newVal.toString();
                                    for (
                                      int i = 0;
                                      i < onboardBranchListModal!.data!.length;
                                      i++
                                    ) {
                                      if (onboardBranchListModal!.data![i].name
                                              .toString()
                                              .compareToIgnoringCase(
                                                newVal.toString(),
                                              ) ==
                                          0) {
                                        branchId =
                                            onboardBranchListModal!.data![i].id!
                                                .toString();
                                      }
                                    }
                                    setState(() {
                                      dropdownNewvalueNew = newVal;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Department
                          Expanded(
                            child: Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  isExpanded:
                                      true, // âœ… Make dropdown use full width
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    hintText: "Department",
                                    labelText: "Department",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Mythemes.blackish,
                                    ),
                                  ),
                                  items:
                                      onboardDeptList.map((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: FittedBox(
                                            // âœ… Fit text inside dropdown without overflow
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              value!,
                                              style: TextStyle(fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (newVal) {
                                    valuenewSub = newVal.toString();
                                    for (var dept
                                        in onboardDeptListModal!.data!) {
                                      if (dept.name!.toLowerCase() ==
                                          newVal!.toLowerCase()) {
                                        deptId = dept.id.toString();
                                      }
                                    }
                                    setState(() {
                                      dropdownDepartmentValue = newVal;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Designation
                          Expanded(
                            child: Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    DropdownButtonFormField<String>(
                                      /*disabledHint: Container(
                                    width: 110,
                                    child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                                  ),*/
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Mythemes.blackishade,
                                          ),
                                        ),
                                        hintText: "Designation",
                                        labelText: "Designation",
                                        hintStyle: TextStyle(fontSize: 14),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Mythemes.blackish,
                                        ),
                                      ),
                                      items:
                                          onboardDesignationList.map((
                                            String? value,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: FittedBox(
                                                // âœ… Fit text inside dropdown without overflow
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  value!,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            );
                                          }).toList(),

                                      onChanged: (newVal) {
                                        valuenewDesignation = newVal.toString();
                                        for (
                                          int i = 0;
                                          i <
                                              onboardDesignationListModal!
                                                  .data!
                                                  .length;
                                          i++
                                        ) {
                                          if (onboardDesignationListModal!
                                                  .data![i]
                                                  .name
                                                  .toString()
                                                  .compareToIgnoringCase(
                                                    newVal.toString(),
                                                  ) ==
                                              0) {
                                            desigId =
                                                onboardDesignationListModal!
                                                    .data![i]
                                                    .id!
                                                    .toString();
                                          }
                                        }
                                        setState(() {
                                          dropdownDesignationValue = newVal;
                                        });
                                      },
                                    ).p8(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).py8(),
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["Bank Details".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: bankNameController,
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
                                    //labelText: "Select Department",
                                    hintText: "Bank Name",
                                    labelText: "Bank Name",
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
                                  controller: accountNoController,
                                  enabled: true,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
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
                                    //labelText: "Select Department",
                                    hintText: "Account Number",
                                    labelText: "Account Number",
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
                                  controller: ifscCodeController,
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
                                    //labelText: "Select Department",
                                    hintText: "IFSC Code",
                                    labelText: "IFSC Code",
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
                    ],
                  ),
                ).py8(),
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["Salary Details".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: inHandSalaryController,
                                  enabled: true,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
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
                                    //labelText: "Select Department",
                                    hintText: "In Hand Salary",
                                    labelText: "In Hand Salary",
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
                        children: ["Accommodation".text.make()],
                      ).pLTRB(8, 6, 6, 0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Salary on hold
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "withAccommodation",
                                  groupValue: accommodationRadio,
                                  onChanged: (value) {
                                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("On Date Click"),
                        ));*/
                                    setState(() {
                                      accomodationCheck = true;
                                      withoutAccommodation = "1";
                                      withAccommodation = "0";
                                      accommodationRadio = value.toString();
                                    });
                                  },
                                ),
                                "Yes".text.size(10).make(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "withoutAccommodation",
                                  groupValue: accommodationRadio,
                                  onChanged: (value) {
                                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Next Day Click"),
                        ));*/
                                    setState(() {
                                      accomodationCheck = false;
                                      withoutAccommodation = "1";
                                      withAccommodation = "0";
                                      accommodationRadio = value.toString();
                                    });
                                  },
                                ),
                                "No".text.size(10).make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).py8(),
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["Nominee Details".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: nomineeNameController,
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
                                    //labelText: "Select Department",
                                    hintText: "Nominee Name",
                                    labelText: "Nominee Name",
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
                                  controller: familyRelationController,
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
                                    //labelText: "Select Department",
                                    hintText: "Relation",
                                    labelText: "Relation",
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
                                  controller: nomineeAadharController,
                                  enabled: true,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(12),
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Nominee Aadhar",
                                    labelText: "Nominee Aadhar",
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
                    ],
                  ),
                ).py8(),
                Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* ElevatedButton(
                            onPressed: () => _showUploadOptions(context),
                            child: Text('Add Document'),
                          ),*/
                          "Add Documents".text.bold.lg.make(),
                        ],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: documentTitles.length,
                              itemBuilder: (context, itemCount) {
                                return InkWell(
                                  onTap: () {
                                    _showUploadOptions(context, itemCount);
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(documentTitles[itemCount]),
                                      subtitle: Text(
                                        uploadedDocuments.containsKey(
                                              documentTitles[itemCount],
                                            )
                                            ? uploadedDocuments[documentTitles[itemCount]]!
                                            : "No document uploaded",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      trailing: IconButton(
                                        color: Mythemes.lightBluishColor,
                                        onPressed: () {
                                          _showUploadOptions(
                                            context,
                                            itemCount,
                                          );
                                        },
                                        icon: Icon(Icons.upload_file),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).py8(),
              ],
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
                                      value: 1,
                                      child: Text(
                                        'Designer',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                        ),
                                      ),
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
    OverflowBar(
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

  Future<void> saveInductionData(BuildContext context) async {
    // âœ… Step 1: Validate Aadhar Number
    String? aadharNumber = aadharNoController.text.trim();
    if (aadharNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter Aadhar number.")));
      return;
    }

    // âœ… Step 2: Validate Aadhar Documents
    String? aadharFront = uploadedDocuments["Aadhar Card Front"];
    String? aadharBack = uploadedDocuments["Aadhar Card Back"];
    bool isAadharFrontMissing =
        aadharFront == null || !File(aadharFront).existsSync();
    bool isAadharBackMissing =
        aadharBack == null || !File(aadharBack).existsSync();

    if (isAadharFrontMissing || isAadharBackMissing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please upload both Aadhar front and back documents."),
        ),
      );
      return;
    }

    // âœ… Proceed with the API call if both checks pass
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.preOnboardSaveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['aadharNumber'] = aadharNoController.text;
    request.fields['contact'] = mobNoController.text;
    request.fields['dateOfJoining'] = _dojDateController.text;
    request.fields['dob'] = _dobDateController.text;
    request.fields['fullName'] = fullNameController.text;
    request.fields['inHandSalary'] = inHandSalaryController.text;
    request.fields['typeOfHire'] = typeOfHireName;
    request.fields['branch'] = branchId;
    request.fields['department'] = deptId;
    request.fields['designation'] = desigId;
    request.fields['bankName'] = bankNameController.text;
    request.fields['accountNo'] = accountNoController.text;
    request.fields['ifscCode'] = ifscCodeController.text;
    request.fields['nomineeName'] = nomineeNameController.text;
    request.fields['nomineeRelation'] = familyRelationController.text;
    request.fields['nomineeAadhar'] = nomineeAadharController.text;
    request.fields['withAccomodation'] = accomodationCheck.toString();


    // Mapping titles to server keys
    Map<String, String> titleKeyMap = {
      "Aadhar Card Front": "aadharDocumentFront",
      "Aadhar Card Back": "aadharDocumentBack",
      "Pan Card": "panDocument",
      "Employee Photo": "empPhoto",
    };

    // Add files
    for (String title in documentTitles) {
      String? filePath = uploadedDocuments[title];
      String key = titleKeyMap[title] ?? "unknownDocument";

      if (filePath != null && File(filePath).existsSync()) {
        try {
          var file = await http.MultipartFile.fromPath(key, filePath);
          request.files.add(file);
        } catch (e) {
        }
      } else {
      }
    }

    try {
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);

      Navigator.of(context, rootNavigator: true).pop();

      if (httpResponse.statusCode == 200) {
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      }
    } catch (e) {
    }
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
                }
              },
              child: Text("Ok"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
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
