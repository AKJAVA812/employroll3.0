import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'modalClass/onboardBranchListModal.dart';
import 'modalClass/onboardDeptListModal.dart';
import 'modalClass/onboardDesignationListModal.dart';
import 'modalClass/onboardDocTypeListModal.dart';
import 'modalClass/onboardUserTypeListModal.dart';

class AddInductionProcess extends StatefulWidget {
  const AddInductionProcess({super.key});

  @override
  State<AddInductionProcess> createState() => _AddInductionProcessState();
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

class _AddInductionProcessState extends State<AddInductionProcess> {
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

  var titleName = "Induction Process";
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
  TextEditingController firstNameController = TextEditingController();
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
  /*  final List<Map<String, String>> files = [
    {'name': 'Menu-icon.png', 'size': '14Kb', 'status': 'Finished', 'type': 'png'},
    {'name': 'App-layout.pdf', 'size': '92.6 of 125.8Mb', 'status': 'Cancel', 'type': 'pdf'},
    {'name': 'Wireframes.pdf', 'size': '22.5 of 90.7Mb', 'status': 'Cancel', 'type': 'pdf'},
    {'name': 'Assets.zip', 'size': '5.8Mb', 'status': 'Finished', 'type': 'zip'},
  ];*/

  // Files list to display
  final List<Map<String, dynamic>> files = [];

  /*  // Function to open camera
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        files.add({
          'name': photo.name,
          'path': photo.path,
          'size': '${(File(photo.path).lengthSync() / 1024).toStringAsFixed(2)} Kb',
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
  }*/

  void _openCamera(int index) async {
    // Simulate file upload and get the document name (replace with your actual logic)
    String uploadedDocName = "Photo_${index + 1}.jpg";

    // Update the map with the uploaded document name
    setState(() {
      uploadedDocuments[index] = uploadedDocName;
    });

    Navigator.pop(context); // Close the modal
  }

  void _browseFiles(int index) async {
    // Simulate file upload and get the document name (replace with your actual logic)
    String uploadedDocName = "Document_${index + 1}.pdf";

    // Update the map with the uploaded document name
    setState(() {
      uploadedDocuments[index] = uploadedDocName;
    });

    Navigator.pop(context); // Close the modal
  }

  Future<void> _handleFileUpload(int index, {required bool isCamera}) async {
    if (isCamera) {
      // Open camera and pick image
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        String uploadedDocName = photo.name;

        // Update the uploaded document map
        setState(() {
          uploadedDocuments[index] = uploadedDocName;
          files.add({
            'name': uploadedDocName,
            'path': photo.path,
            'size':
                '${(File(photo.path).lengthSync() / 1024).toStringAsFixed(2)} Kb',
            'status': 'Finished',
            'type': 'image', // Mark as image
          });
        });
      }
    } else {
      // Browse files using FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        String uploadedDocName = result.files.single.name;

        // Update the uploaded document map
        setState(() {
          uploadedDocuments[index] = uploadedDocName;
          files.add({
            'name': uploadedDocName,
            'path': result.files.single.path!,
            'size':
                '${(result.files.single.size / 1024).toStringAsFixed(2)} Kb',
            'status': 'Finished',
            'type': result.files.single.extension ?? 'file', // Determine type
          });
        });
      }
    }
    Navigator.pop(context); // Close the modal
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

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    Future<OnboardBranchListModal> getEmployeeList13 = getBranchList(
      sessionId!,
    );
    getEmployeeList13.then((value) {
      setState(() {
        onboardBranchListModal = value;
      });

      //print('employeeList00${inductionListLabel!.data!.length}');
    });
    Future<OnboardDeptListModal> getEmployeeList14 = getDeptList(sessionId!);
    getEmployeeList14.then((value) {
      setState(() {
        onboardDeptListModal = value;
      });

      //print('employeeList00${inductionListLabel!.data!.length}');
    });
    Future<OnboardDesignationListModal> getEmployeeList15 = getDesignationList(
      sessionId!,
    );
    getEmployeeList15.then((value) {
      setState(() {
        onboardDesignationListModal = value;
      });

      //print('employeeList00${inductionListLabel!.data!.length}');
    });
    Future<OnboardUserTypeListModal> getEmployeeList16 = getUserTypeList(
      sessionId!,
    );
    getEmployeeList16.then((value) {
      setState(() {
        onboardUserTypeListModal = value;
      });

      //print('employeeList00${inductionListLabel!.data!.length}');
    });
    loadData();
    Future<OnboardDocTypeListModal> getEmployeeList17 = getDocTypeList(
      sessionId!,
    );
    getEmployeeList17.then((value) {
      setState(() {
        onboardDocTypeListModal = value;
      });

      //print('employeeList00${inductionListLabel!.data!.length}');
    });
  }

  Map<int, String> uploadedDocuments = {};

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
        appBar: AppBar(
          actions: [
            "Bharat Rajora".text
                .size(14)
                .bold
                .color(Mythemes.dangerColor)
                .make()
                .px(10),
          ],
          title: titleName.text.make(),
        ),

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
              ElevatedButton(
                onPressed: () {
                  /* if (activeStep > 0) {
                      setState(() {
                        activeStep--;
                      });
                    }*/
                  draftInductionData(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Mythemes.alertColor,
                  ),
                ),
                child: "Draft".text.make(),
              ).wh(150, 40).py12(),

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
              child: Column(
                children: [
                  /*NumberStepper(
                    enableStepTapping: true,
                    stepRadius: 18,
                    activeStep: activeStep,
                    activeStepColor: Mythemes.activeStepColor,
                    enableNextPreviousButtons: true,
                    lineColor: Mythemes.greyish,
                    lineLength: 50,
                    stepColor: Mythemes.stepColor,
                    numberStyle: TextStyle(
                        color: Mythemes.whitish
                    ),
                    stepReachedAnimationEffect: Curves.bounceIn,
                    stepReachedAnimationDuration: Duration(seconds: 2),
                    numbers: [

                      1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,14

                    ],
                    onStepReached: (index){
                      setState(() {
                        activeStep = index;
                      });
                    },
                  ),
                  headerText().px12(),*/
                  SizedBox(height: 720, child: body()),
                ],
              ),
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

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _dobDateController = TextEditingController();
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
                  child: ExpansionTile(
                    maintainState: true,
                    //key: keyTile,
                    initiallyExpanded: basicDetExpanded,
                    childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                    title: "Basic Details".text.make(),
                    children: [
                      Column(
                        children: [
                          //emp photo
                          Visibility(
                            visible: false,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: Mythemes.lightBluishColor, width: 3),
                                    shape: BoxShape.circle,
                                    color: Mythemes.whitish,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "assets/images/avatar.jpg",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: false,
                                child: Expanded(
                                  child:
                                      TextFormField(
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
                                          //labelText: "Select Department",
                                          hintText: "Employee ID",
                                          labelText: "Employee ID",
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
                              //Aadhar No.
                              Visibility(
                                visible: true,
                                child: Expanded(
                                  child:
                                      TextFormField(
                                        controller: aadharNoController,
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
                                        ),
                                      ).p8(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //Aadhar Registered Mobile No.
                              Visibility(
                                visible: true,
                                child: Expanded(
                                  child:
                                      TextFormField(
                                        controller: aadharRegisNoController,
                                        enabled: true,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(10),
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
                                          hintText:
                                              "Aadhar Registered Mobile No.",
                                          labelText:
                                              "Aadhar Registered Mobile No.",
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
                              //Fist Name
                              Visibility(
                                visible: true,
                                child: Expanded(
                                  child:
                                      TextFormField(
                                        controller: firstNameController,
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
                                          hintText: "First Name",
                                          labelText: "First Name",
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
                              //Email Id
                              Visibility(
                                visible: true,
                                child: Expanded(
                                  child:
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailIdController,
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
                                          hintText: "Email Id",
                                          labelText: "Email Id",
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
                          //Gender
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "Gender",
                                      labelText: "Gender",
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
                                          'Male',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Female',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text(
                                          'Others',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      /* DropdownMenuItem(
                                    child: Text('Advance'),
                                    value: 2,
                                  ),*/
                                    ],
                                    /*onChanged: (int? value) {
                            setState(() {
                              value = value!;
                            });
                              }*/
                                    onChanged: (int? value) {
                                      setState(() {
                                        genderDrop = value;
                                        if (genderDrop == 1) {
                                          genderName = "Male";
                                        }
                                        if (genderDrop == 2) {
                                          genderName = "Female";
                                        }
                                        if (genderDrop == 3) {
                                          genderName = "Others";
                                        }
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //Employee Status
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "Employee Status",
                                      labelText: "Employee Status",
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
                                          'Contract',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Permanent',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text(
                                          'Probationer',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 4,
                                        child: Text(
                                          'Temporary',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 5,
                                        child: Text(
                                          'Trainee',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 6,
                                        child: Text(
                                          'Regular',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 7,
                                        child: Text(
                                          'Contractual',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (int? value) {
                                      setState(() {
                                        empStatusDrop = value;
                                        if (empStatusDrop == 1) {
                                          empStatusName = "Contract";
                                        }
                                        if (empStatusDrop == 2) {
                                          empStatusName = "Permanent";
                                        }
                                        if (empStatusDrop == 3) {
                                          empStatusName = "Probationer";
                                        }
                                        if (empStatusDrop == 4) {
                                          empStatusName = "Temporary";
                                        }
                                        if (empStatusDrop == 5) {
                                          empStatusName = "Trainee";
                                        }
                                        if (empStatusDrop == 6) {
                                          empStatusName = "Regular";
                                        }
                                        if (empStatusDrop == 7) {
                                          empStatusName = "Contractual";
                                        }
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                          //Marital Status
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "Marital Status",
                                      labelText: "Marital Status",
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
                                          'Single',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Married',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text(
                                          'Divorced',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 4,
                                        child: Text(
                                          'Widowed',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 5,
                                        child: Text(
                                          "Domestic Partner",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 6,
                                        child: Text(
                                          'Separated',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (int? value) {
                                      setState(() {
                                        maritalStatusDrop = value!;
                                        if (maritalStatusDrop == 1) {
                                          maritalStatusName = "Single";
                                        }
                                        if (maritalStatusDrop == 2) {
                                          maritalStatusName = "Married";
                                        }
                                        if (maritalStatusDrop == 3) {
                                          maritalStatusName = "Divorced";
                                        }
                                        if (maritalStatusDrop == 4) {
                                          maritalStatusName = "Widowed";
                                        }
                                        if (maritalStatusDrop == 5) {
                                          maritalStatusName =
                                              "Domestic Partner";
                                        }
                                        if (maritalStatusDrop == 6) {
                                          maritalStatusName = "Separated";
                                        }
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
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
                          //Department
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "Department",
                                      labelText: "Department",
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
                                    items:
                                        onboardDeptList
                                            .map<DropdownMenuItem<String>>((
                                              String? value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value!,
                                                  style: TextStyle(fontSize: 9),
                                                  maxLines: 2,
                                                ),
                                              );
                                            })
                                            .toList(),

                                    onChanged: (newVal) {
                                      valuenewSub = newVal.toString();
                                      for (
                                        int i = 0;
                                        i < onboardDeptListModal!.data!.length;
                                        i++
                                      ) {
                                        if (onboardDeptListModal!.data![i].name
                                                .toString()
                                                .compareToIgnoringCase(
                                                  newVal.toString(),
                                                ) ==
                                            0) {
                                          deptId =
                                              onboardDeptListModal!.data![i].id!
                                                  .toString();
                                        }
                                      }
                                      setState(() {
                                        dropdownDepartmentValue = newVal;
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //Designation
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "Designation",
                                      labelText: "Designation",
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
                                    items:
                                        onboardDesignationList
                                            .map<DropdownMenuItem<String>>((
                                              String? value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value!,
                                                  style: TextStyle(fontSize: 9),
                                                  maxLines: 2,
                                                ),
                                              );
                                            })
                                            .toList(),

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
                          //Branch
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Branch",
                                      labelText: "Branch",
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
                                    items:
                                        onboardBranchList
                                            .map<DropdownMenuItem<String>>((
                                              String? value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value!,
                                                  style: TextStyle(fontSize: 9),
                                                  maxLines: 2,
                                                ),
                                              );
                                            })
                                            .toList(),

                                    onChanged: (newVal) {
                                      valuenew = newVal.toString();
                                      for (
                                        int i = 0;
                                        i <
                                            onboardBranchListModal!
                                                .data!
                                                .length;
                                        i++
                                      ) {
                                        if (onboardBranchListModal!
                                                .data![i]
                                                .name
                                                .toString()
                                                .compareToIgnoringCase(
                                                  newVal.toString(),
                                                ) ==
                                            0) {
                                          branchId =
                                              onboardBranchListModal!
                                                  .data![i]
                                                  .id!
                                                  .toString();
                                        }
                                      }
                                      setState(() {
                                        dropdownNewvalueNew = newVal;
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //User Type
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "User Type",
                                      labelText: "User Type",
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
                                    items:
                                        onboardUserTypeList
                                            .map<DropdownMenuItem<String>>((
                                              String? value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value!,
                                                  style: TextStyle(fontSize: 9),
                                                  maxLines: 2,
                                                ),
                                              );
                                            })
                                            .toList(),

                                    onChanged: (newVal) {
                                      valuenewUserType = newVal.toString();
                                      setState(() {
                                        dropdownNewvalueUserType = newVal;
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                          //Skill Type
                          Visibility(
                            visible: true,
                            child: Expanded(
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
                                      hintText: "Skill Type",
                                      labelText: "Skill Type",
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
                                          'Skilled',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Semi Skilled',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text(
                                          'Unskilled',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 4,
                                        child: Text(
                                          'Technical',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 5,
                                        child: Text(
                                          'Non Technical',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 6,
                                        child: Text(
                                          'Skill Non Defined',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 7,
                                        child: Text(
                                          'Highly Skilled',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 8,
                                        child: Text(
                                          'Chargehand',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 9,
                                        child: Text(
                                          'HighlySkilled',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 10,
                                        child: Text(
                                          'Senior Supervisor',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 11,
                                        child: Text(
                                          'Supervisor',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 12,
                                        child: Text(
                                          'Functional',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (int? value) {
                                      setState(() {
                                        skillTypeDrop = value!;
                                        if (skillTypeDrop == 1) {
                                          skillTypeName = "Skilled";
                                        }
                                        if (skillTypeDrop == 2) {
                                          skillTypeName = "Semi Skilled";
                                        }
                                        if (skillTypeDrop == 3) {
                                          skillTypeName = "Unskilled";
                                        }
                                        if (skillTypeDrop == 4) {
                                          skillTypeName = "Technical";
                                        }
                                        if (skillTypeDrop == 5) {
                                          skillTypeName = "Non Technical";
                                        }
                                        if (skillTypeDrop == 6) {
                                          skillTypeName = "Skill Non Defined";
                                        }
                                        if (skillTypeDrop == 7) {
                                          skillTypeName = "Highly Skilled";
                                        }
                                        if (skillTypeDrop == 8) {
                                          skillTypeName = "Chargehand";
                                        }
                                        if (skillTypeDrop == 9) {
                                          skillTypeName = "HighlySkilled";
                                        }
                                        if (skillTypeDrop == 10) {
                                          skillTypeName = "Senior Supervisor";
                                        }
                                        if (skillTypeDrop == 11) {
                                          skillTypeName = "Supervisor";
                                        }
                                        if (skillTypeDrop == 12) {
                                          skillTypeName = "Functional";
                                        }
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //Permanent Address
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    controller: permanentAddressController,
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Permanent Address",
                                      labelText: "Permanent Address",
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
                          //Current Address
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    controller: currentAddressController,
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Current Address",
                                      labelText: "Current Address",
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /* ElevatedButton(
                            onPressed: () => _showUploadOptions(context),
                            child: Text('Add Document'),
                          ),*/
                          "Add Documents".text.size(17).bold.make(),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading
                              ? Center(
                                child: CircularProgressIndicator(),
                              ) // Show loader
                              : onboardDocTypeListModal == null ||
                                  onboardDocTypeListModal!.data!.isEmpty
                              ? Center(child: Text('No data available'))
                              : Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount:
                                      onboardDocTypeListModal!.data!.length,
                                  itemBuilder: (context, itemCount) {
                                    return Card(
                                      child: ListTile(
                                        title: Text(
                                          onboardDocTypeListModal!
                                              .data![itemCount]
                                              .name
                                              .toString(),
                                        ),
                                        subtitle: Text(
                                          uploadedDocuments.containsKey(
                                                itemCount,
                                              )
                                              ? uploadedDocuments[itemCount]!
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
                                    );
                                  },
                                ),
                              ),
                          /*Expanded(
                            child: SizedBox(
                              height: 440,
                              child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return Card(
                                    margin: EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: file['type'] == 'image'
                                          ? Image.file(
                                        File(file['path']),
                                        width: 50,
                                        filterQuality: FilterQuality.low,
                                        height: 50,
                                        fit: BoxFit.cover,
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
                                      subtitle: Text('${file['size']} - ${file['status']}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteFile(index),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),*/
                          //Document List
                          Visibility(
                            visible: false,
                            child: Expanded(
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
                                      hintText: "Document List",
                                      labelText: "Document List",
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
                                          'Aadhar Card (Front)',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Aadhar Card (Back)',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text(
                                          'Pan Card',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 4,
                                        child: Text(
                                          'Police Verification',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 5,
                                        child: Text(
                                          'Medical Certificate',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 6,
                                        child: Text(
                                          'Employee Photo',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      /* DropdownMenuItem(
                                    child: Text('Advance'),
                                    value: 2,
                                  ),*/
                                    ],
                                    /*onChanged: (int? value) {
                            setState(() {
                              value = value!;
                            });
                              }*/
                                    onChanged: (int? value) {
                                      setState(() {
                                        value = value!;
                                      });
                                    },
                                  ).p8(),
                            ),
                          ),
                        ],
                      ),

                      /* Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              //controller: _locationController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "UAN",
                                labelText: "UAN",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ).p8(),

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                    borderSide: BorderSide(
                                        width: 1, color: Mythemes.blackishade),
                                  ),
                                  //labelText: "Select Department",
                                  hintText: "Department",
                                  labelText: "Department",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,fontSize: 13,
                                      color: Mythemes.blackish),
                                ),
                                items: [

                                  DropdownMenuItem(
                                    child:
                                    Text('IT',style: TextStyle(overflow: TextOverflow.ellipsis , fontSize: 13)) ,
                                    value: 1,
                                  ),
                                ],

                                onChanged: (int? value) {
                                  setState(() {
                                    value = value!;
                                  });
                                }

                            ).p8(),

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              /*disabledHint: Container(
                                width: 110,
                                child: "Select".text.size(13).overflow(TextOverflow.ellipsis).make(),
                              ),*/
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                    borderSide: BorderSide(
                                        width: 1, color: Mythemes.blackishade),
                                  ),
                                  //labelText: "Select Department",
                                  hintText: "Designation",
                                  labelText: "Designation",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  /*border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(8))),*/
                                  // labelText: "Location",
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,fontSize: 13,
                                      color: Mythemes.blackish),
                                ),
                                items: [

                                  DropdownMenuItem(
                                    child:
                                    Text('Designer',style: TextStyle(overflow: TextOverflow.ellipsis , fontSize: 13)) ,
                                    value: 1,
                                  ),
                                ],

                                onChanged: (int? value) {
                                  setState(() {
                                    value = value!;
                                  });
                                }

                            ).p8(),

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              //controller: _locationController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "Project Site",
                                labelText: "Project Site",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ).p8(),

                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              //controller: _locationController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "PAN No.",
                                labelText: "PAN No.",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ).p8(),

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              //controller: _locationController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "National Population Register",
                                labelText: "National Population Register",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ).p8(),

                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              //controller: _locationController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 1, color: Mythemes.blackishade),
                                ),
                                //labelText: "Select Department",
                                hintText: "Other Language Known",
                                labelText: "Other Language Known",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 13,
                                    color: Mythemes.blackish),
                              ),
                            ).p8(),

                          ),
                        ],
                      ),*/
                      Row(
                        children: [
                          Visibility(
                            visible: false,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    onTap: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(allowMultiple: true);
                                      if (result == null) return;

                                      final file = result.files.first;

                                      final newFile = await saveFilePermanently(
                                        file,
                                      );
                                      openFiles(result.files);
                                      final kb = file.size / 1024;
                                      final mb = kb / 1024;
                                      final fileSize =
                                          mb >= 1
                                              ? '${mb.toStringAsFixed(2)} MB'
                                              : '${kb.toStringAsFixed(2)} KB';
                                      final extension =
                                          file.extension ?? 'none';
                                      setState(() {
                                        filePath = file.name;
                                      });
                                      //openFile(file);
                                    },
                                    style: TextStyle(
                                      fontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    controller: TextEditingController(
                                      text: filePath,
                                    ),
                                    readOnly: true,
                                    // initialValue: "Head Office",
                                    //maxLines: 3,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.upload_file),
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: filePath,
                                      labelText: "Add Document",
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
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    child: ExpansionTile(
                      //key: keyTile,
                      initiallyExpanded: addressDetExpanded,
                      childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                      title: "Address Details".text.make(),
                      children: [
                        //permament address
                        Row(
                          children: [
                            Expanded(
                              child:
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    controller: TextEditingController(
                                      text: "Address",
                                    ),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Permanent Address",
                                      labelText: "Permanent Address",
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
                                      hintText: "State",
                                      labelText: "State",
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
                                      hintText: "City",
                                      labelText: "City",
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
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    //controller: TextEditingController(text: "Address"),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    //maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Pincode",
                                      labelText: "Pincode",
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
                        //current address
                        Row(
                          children: [
                            Expanded(
                              child:
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    controller: TextEditingController(
                                      text: "Address",
                                    ),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Current Address",
                                      labelText: "Current Address",
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
                                      hintText: "State",
                                      labelText: "State",
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
                                      hintText: "City",
                                      labelText: "City",
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
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    //controller: TextEditingController(text: "Address"),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    //maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Pincode",
                                      labelText: "Pincode",
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
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    child: ExpansionTile(
                      //key: keyTile,
                      initiallyExpanded: emergencyContactExpanded,
                      childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                      title: "Emergency Contact Details".text.make(),
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
                                      hintText: "Emergency Contact Person",
                                      labelText: "Contact Person",
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
                                      hintText: "Contact No.",
                                      labelText: "Contact No.",
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
                                      hintText: "State",
                                      labelText: "State",
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
                                      hintText: "City",
                                      labelText: "City",
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
                            Expanded(
                              child:
                                  TextFormField(
                                    style: TextStyle(fontSize: 13),
                                    //controller: TextEditingController(text: "Address"),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    //maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Pincode",
                                      labelText: "Pincode",
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
                                    style: TextStyle(fontSize: 13),
                                    controller: TextEditingController(
                                      text: "Address",
                                    ),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Emergency Address",
                                      labelText: "Emergency Address",
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
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    child: ExpansionTile(
                      //key: keyTile,
                      initiallyExpanded: bankAccountExpanded,
                      childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                      title: "Bank Account Details".text.make(),
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
                                      hintText: "Account No.",
                                      labelText: "Account No.",
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
                                      hintText: "Branch",
                                      labelText: "Branch",
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
                                    style: TextStyle(fontSize: 13),
                                    controller: TextEditingController(
                                      text: "Address",
                                    ),
                                    enabled: true,
                                    // initialValue: "Head Office",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: "Branch Address",
                                      labelText: "Branch Address",
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
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    child: ExpansionTile(
                      //key: keyTile,
                      initiallyExpanded: educationExpanded,
                      childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                      title: "Education".text.make(),
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
                                      hintText: "Examination Passed",
                                      labelText: "Examination Passed",
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
                                      hintText: "Year",
                                      labelText: "Year",
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
                                      hintText: "School Board",
                                      labelText: "School Board",
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
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    child: ExpansionTile(
                      //key: keyTile,
                      initiallyExpanded: previousYearExoExpanded,
                      childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                      title: "Previous Year Experience".text.make(),
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
                                      hintText: "Contractor/Organisation",
                                      labelText: "Contractor/Organisation",
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
                                      hintText: "Project Site",
                                      labelText: "Project Site",
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
                                      hintText: "Category",
                                      labelText: "Category",
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
                                        _fromDateController.text = DateFormat(
                                          "dd-MM-yyyy",
                                        ).format(fromDate!);
                                      });

                                    },
                                    readOnly: true,
                                    enabled: true,
                                    controller: _fromDateController,
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
                                      labelText: "Period From",
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
                                        _toDateController.text = DateFormat(
                                          "dd-MM-yyyy",
                                        ).format(fromDate!);
                                      });

                                    },
                                    readOnly: true,
                                    enabled: true,
                                    controller: _toDateController,
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
                                      labelText: "Period To",
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
                                      hintText: "Salary/Wages",
                                      labelText: "Salary/Wages",
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
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    child: ExpansionTile(
                      //key: keyTile,
                      initiallyExpanded: docUploadExpanded,
                      childrenPadding: EdgeInsets.all(0).copyWith(top: 0),
                      title: "Document Upload".text.make(),
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
                                      hintText: "Document Type",
                                      labelText: "Document Type",
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
                            Expanded(
                              child:
                                  TextFormField(
                                    onTap: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(allowMultiple: true);
                                      if (result == null) return;

                                      final file = result.files.first;

                                      final newFile = await saveFilePermanently(
                                        file,
                                      );
                                      openFiles(result.files);
                                      final kb = file.size / 1024;
                                      final mb = kb / 1024;
                                      final fileSize =
                                          mb >= 1
                                              ? '${mb.toStringAsFixed(2)} MB'
                                              : '${kb.toStringAsFixed(2)} KB';
                                      final extension =
                                          file.extension ?? 'none';
                                      setState(() {
                                        filePath = file.name;
                                      });
                                      //openFile(file);
                                    },
                                    style: TextStyle(
                                      fontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    controller: TextEditingController(
                                      text: filePath,
                                    ),
                                    readOnly: true,
                                    // initialValue: "Head Office",
                                    //maxLines: 3,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.upload_file),
                                      enabledBorder: UnderlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Mythemes.blackishade,
                                        ),
                                      ),
                                      //labelText: "Select Department",
                                      hintText: filePath,
                                      labelText: "Add Document",
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
                  ),
                ),
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

  Future<void> saveInductionDatas(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardingSave;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    /*var urlapi = Uri.parse("$conn$apiUrl?"
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
        "docs=$docs"
    );*/
    var request = http.MultipartRequest("Post", urlapi);
    request.fields['sessionId'] = sessionId!;
    request.fields['aadharNo'] = aadharNoController.text;
    request.fields['aadharRegisNo'] = aadharRegisNoController.text;
    request.fields['firstName'] = firstNameController.text;
    request.fields['emailId'] = emailIdController.text;
    request.fields['mobileNo'] = mobNoController.text;
    request.fields['dob'] = _dobDateController.text;
    request.fields['gender'] = genderName;
    request.fields['empStatus'] = empStatusName;
    request.fields['maritalStatus'] = maritalStatusName;
    request.fields['doj'] = _dojDateController.text;
    request.fields['department'] = deptId;
    request.fields['designation'] = desigId;
    request.fields['branch'] = branchId;
    request.fields['userType'] = userTypeId;
    request.fields['skillType'] = skillTypeName;
    request.fields['permanentAddress'] = permanentAddressController.text;
    request.fields['currentAddress'] = currentAddressController.text;
    request.fields['saveStatus'] = "FINAL";
    request.fields['docs'] = currentAddressController.text;

    // Construct API URL with parameters
    String apiWithParams =
        '$urlapi?${request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&')}';

    // Print the full API URL with parameters
    //final response = await MobileHttpClient.instance.post(urlapi);
    http.Response response = await http.Response.fromStream(
      await request.send(),
    );
    result = json.decode(response.body.toString());

    if (response.statusCode == 200) {
      var responseResult = response.body;
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      String result = mapResponse['result'];
      if (result.compareToIgnoringCase("Success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          "${reason.upperCamelCase} ",
          "Success",
        );
      } else if (result.compareToIgnoringCase("Error") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          reason.upperCamelCase,
          " Error ",
        );
      }
    }
  }

  Future<void> saveInductionData(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardingSave;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['aadharNo'] = aadharNoController.text;
    request.fields['aadharRegisNo'] = aadharRegisNoController.text;
    request.fields['firstName'] = firstNameController.text;
    request.fields['emailId'] = emailIdController.text;
    request.fields['mobileNo'] = mobNoController.text;
    request.fields['dob'] = _dobDateController.text;
    request.fields['gender'] = genderName;
    request.fields['empStatus'] = empStatusName;
    request.fields['maritalStatus'] = maritalStatusName;
    request.fields['doj'] = _dojDateController.text;
    request.fields['department'] = deptId;
    request.fields['designation'] = desigId;
    request.fields['branch'] = branchId;
    request.fields['userType'] = userTypeId;
    request.fields['skillType'] = skillTypeName;
    request.fields['permanentAddress'] = permanentAddressController.text;
    request.fields['currentAddress'] = currentAddressController.text;
    request.fields['saveStatus'] = "FINAL";

    // Add dynamic documents (if any)
    for (int i = 0; i < uploadedDocuments.length; i++) {
      String docType =
          onboardDocTypeListModal!.data![i].name ?? "unknownDocType";
      String filePath = uploadedDocuments[i] ?? "";

      if (filePath.isNotEmpty && File(filePath).existsSync()) {
        try {
          var file = await http.MultipartFile.fromPath(
            'docs[$docType]',
            filePath,
          ); // Use dynamic key
          request.files.add(file);
        } catch (e) {
        }
      } else {
      }
    }

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        '$urlapi?${request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&')}';

    // Debugging: Print the full API URL with parameters

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          CommonNotificationPage.showDialgSucess(
            context,
            "${reason.upperCamelCase} ",
            "Success",
          );
        } else if (result.compareToIgnoringCase("Error") == 0) {
          CommonNotificationPage.showDialgSucess(
            context,
            reason.upperCamelCase,
            "Error",
          );
        }
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> draftInductionData(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.onboardingSave;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    /*var urlapi = Uri.parse("$conn$apiUrl?"
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
        "docs=$docs"
    );*/
    var request = http.MultipartRequest("Post", urlapi);
    request.fields['sessionId'] = sessionId!;
    request.fields['aadharNo'] = aadharNoController.text;
    request.fields['aadharRegisNo'] = aadharRegisNoController.text;
    request.fields['firstName'] = firstNameController.text;
    request.fields['emailId'] = emailIdController.text;
    request.fields['mobileNo'] = mobNoController.text;
    request.fields['dob'] = _dobDateController.text;
    request.fields['gender'] = genderName;
    request.fields['empStatus'] = empStatusName;
    request.fields['maritalStatus'] = maritalStatusName;
    request.fields['doj'] = _dojDateController.text;
    request.fields['department'] = deptId;
    request.fields['designation'] = desigId;
    request.fields['branch'] = branchId;
    request.fields['userType'] = userTypeId;
    request.fields['skillType'] = skillTypeName;
    request.fields['permanentAddress'] = permanentAddressController.text;
    request.fields['currentAddress'] = currentAddressController.text;
    request.fields['saveStatus'] = "DRAFT";
    request.fields['docs'] = currentAddressController.text;

    // Construct API URL with parameters
    String apiWithParams =
        '$urlapi?${request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&')}';

    // Print the full API URL with parameters
    //final response = await MobileHttpClient.instance.post(urlapi);
    http.Response response = await http.Response.fromStream(
      await request.send(),
    );
    result = json.decode(response.body.toString());

    if (response.statusCode == 200) {
      var responseResult = response.body;
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      String result = mapResponse['result'];
      if (result.compareToIgnoringCase("Success") == 0) {
        CommonNotificationPage.showDialgSucess(
          context,
          "${reason.upperCamelCase} ",
          "Success",
        );
      } else if (result.compareToIgnoringCase("Error") == 0) {
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
