import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:er_flutter_project/modules/preInductionOnboarding/pendingPreOnboardingList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linear_step_indicator/linear_step_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ApprovePreOnboarding extends StatefulWidget {
  String? typeOfHiring;
  String? aadharNo;
  String? fullName;
  String? dob;
  String? doj;
  String? contactNo;
  String? inHandSalary;
  String? accomodationCheck;
  String? aadharCardFront;
  String? aadharCardBack;
  String? panCard;
  String? empPhoto;
  String? idCheck;
  String branchName;
  String departmentName;
  String designationName;
  String bankName;
  String accountNo;
  String ifscCode;
  String nomineeName;
  String nomineeAadhar;
  String nomineeRelation;

  ApprovePreOnboarding(
    this.typeOfHiring,
    this.aadharNo,
    this.fullName,
    this.dob,
    this.doj,
    this.contactNo,
    this.inHandSalary,
    this.accomodationCheck,
    this.aadharCardFront,
    this.aadharCardBack,
    this.panCard,
    this.empPhoto,
    this.idCheck,
    this.branchName,
    this.departmentName,
    this.designationName,
    this.bankName,
    this.accountNo,
    this.ifscCode,
    this.nomineeName,
    this.nomineeAadhar,
    this.nomineeRelation,
  );

  @override
  State<ApprovePreOnboarding> createState() => _ApprovePreOnboardingState(
    typeOfHiring,
    aadharNo,
    fullName,
    dob,
    doj,
    contactNo,
    inHandSalary,
    accomodationCheck,
    aadharCardFront,
    aadharCardBack,
    panCard,
    empPhoto,
    idCheck,
    branchName,
    departmentName,
    designationName,
    bankName,
    accountNo,
    ifscCode,
    nomineeName,
    nomineeAadhar,
    nomineeRelation,
  );
}

late List<String?> onboardBranchList = [];
late List<String?> onboardDeptList = [];
late List<String?> onboardDesignationList = [];
late List<String?> onboardUserTypeList = [];
late List<String?> onboardDocTypeList = [];
late List<String?> queryTypeList = [];
late List<String?> subQueryTypeList = [];

SessionManager sessionManager = SessionManager();
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
late var result;
const int STEPS = 5;

class _ApprovePreOnboardingState extends State<ApprovePreOnboarding> {
  _ApprovePreOnboardingState(
    String? typeOfHiring,
    String? aadharNo,
    String? fullName,
    String? dob,
    String? doj,
    String? contactNo,
    String? inHandSalary,
    String? accomodationCheck,
    String? aadharCardFront,
    String? aadharCardBack,
    String? panCard,
    String? empPhoto,
    String? idCheck,
    String? branchName,
    String? departmentName,
    String? designationName,
    String? bankName,
    String? accountNo,
    String? ifscCode,
    String? nomineeName,
    String? nomineeAadhar,
    String? nomineeRelation,
  );

  var typeOfHiringCheck;
  var aadharNoCheck;
  var fullNameCheck;
  var dobCheck;
  var dojCheck;
  var contactNoCheck;
  var inHandSalaryCheck;
  var accomodationCheckCheck;
  var aadharCardCheckFront;
  var aadharCardCheckBack;
  var panCardCheck;
  var empPhotoCheck;
  var idSendCheck;
  var branchNameCheck;
  var departmentNameCheck;
  var designationNameCheck;
  var bankNameCheck;
  var accountNoCheck;
  var ifscCodeCheck;
  var nomineeNameCheck;
  var nomineeAadharCheck;
  var nomineeRelationCheck;

  @override
  void initState() {
    // TODO: implement initState
    getSharedPrfanceList();
    setState(() {});
    typeOfHiringRadio = typeOfHiring;
    print("Hiring Radio - $typeOfHiringRadio");
    aadharNoController.text = aadharNo;
    fullNameController.text = fullName;
    _dobDateController.text = dob;
    _dojDateController.text = doj;
    mobNoController.text = contactNo;
    inHandSalaryController.text = inHandSalary;
    accommodationRadio = accomodationCheck;
    print("Accommodation Radio - $accommodationRadio");
    aadharCardCheckFront = aadharCardFront;
    aadharCardCheckBack = aadharCardBack;
    panCardCheck = panCard;
    empPhotoCheck = empPhoto;
    idSendCheck = idCheck;
    branchNameController.text = branchName;
    departmentNameController.text = departmentName;
    designationNameController.text = designationName;
    bankNameController.text = bankName;
    accountNoController.text = accountNo;
    ifscCodeController.text = ifscCode;
    nomineeNameController.text = nomineeName;
    nomineeAadharController.text = nomineeAadhar;
    familyRelationController.text = nomineeRelation;
    super.initState();
  }

  var titleName = "Approve Pre-Onboarding";
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
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController familyRelationController = TextEditingController();
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
          print("Photo path - ${photo.path}");
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
          print("File path - ${result.files.single.path!}");
        });
      }
    }
    Navigator.pop(context); // Close the modal
  }

  void showDocumentDialog(BuildContext context, String filePath, bool isPdf) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.all(8),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child:
                isPdf
                    ? PDFView(
                      filePath: filePath,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageSnap: true,
                      fitPolicy: FitPolicy.BOTH,
                      onError: (error) {
                        print(error.toString());
                      },
                    )
                    : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            "There is no document added.",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  List<String> documentTitles = ["Aadhar Card", "Pan Card", "Employee Photo"];

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
    sessionId = await shared!.getSessionId();
  }

  Map<int, String> uploadedDocuments = {};

  var showNoData;

  var typeOfHiringRadio = "new";
  var accommodationRadio = "false";
  String withoutAccommodation = "1";
  String withAccommodation = "0";
  String newHire = "1";
  String replacementHiring = "0";
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
    print('Holiday URL ${response.request}');
    print('response body ${response.body}');
    developer.log("response:- ", name: response.body);
    mapResponse = json.decode(response.body);
    var getData = mapResponse.length;
    if (getData == 0) {
      print("getData111 $getData");
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
              ButtonBar(
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
            "${fullNameController.text}".text
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
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            //buttonPadding: Vx.mOnly(right: 16),
            children: [
              /* activeStep <= 0  ? SizedBox(
                  width: 0,
                ) :*/
              ElevatedButton(
                onPressed: () {
                  disApprovePreOnboarding(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Mythemes.dangerColor,
                  ),
                ),
                child: "Disapprove".text.make(),
              ).wh(150, 40).py12(),

              ElevatedButton(
                onPressed: () {
                  approvePreOnboarding(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Mythemes.successColor,
                  ),
                ),
                child: "Approve".text.make(),
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
              child: Column(children: [Container(height: 620, child: body())]),
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _dobDateController = TextEditingController();
  final TextEditingController _familyDobDateController =
      TextEditingController();
  final TextEditingController _dojDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _inductionDateController =
      TextEditingController();
  final TextEditingController departmentNameController =
      TextEditingController();
  final TextEditingController designationNameController =
      TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  TextEditingController nomineeNameController = TextEditingController();
  TextEditingController nomineeAadharController = TextEditingController();
  Widget body() {
    List<Map<String, String>> documents = [
      {
        "title": "Aadhar Card Front",
        "url": aadharCardCheckFront, // Set actual URL/path
      },
      {
        "title": "Aadhar Card Back",
        "url": aadharCardCheckBack, // Set actual URL/path
      },
      {
        "title": "Pan Card",
        "url": panCardCheck, // Set actual URL/path
      },
      {
        "title": "Employee Photo",
        "url": empPhotoCheck, // Set actual URL/path
      },
    ];
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
                                  value: "New",
                                  groupValue: typeOfHiringRadio,
                                  onChanged: null,
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
                                  value: "Replacement",
                                  groupValue: typeOfHiringRadio,
                                  onChanged: null,
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
                                  value: "Re-Hire",
                                  groupValue: typeOfHiringRadio,
                                  onChanged: null,
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
                                    controller: aadharNoController,
                                    readOnly: true,
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
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.check_circle,
                                          size: 22,
                                          color: Mythemes.successColor,
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
                                    readOnly: true,
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
                                      ).requestFocus(new FocusNode());

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

                                      print(fromDate);
                                    },
                                    readOnly: true,
                                    enabled: false,
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
                                      ).requestFocus(new FocusNode());

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

                                      print(fromDate);
                                    },
                                    readOnly: true,
                                    enabled: false,
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
                                    readOnly: true,
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
                          //Branch
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    controller: branchNameController,
                                    readOnly: true,
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
                                      hintText: "Branch Name",
                                      labelText: "Branch Name",
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
                          //Department
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    controller: departmentNameController,
                                    readOnly: true,
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
                                      hintText: "Department Name",
                                      labelText: "Department Name",
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Designation
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child:
                                  TextFormField(
                                    controller: designationNameController,
                                    readOnly: true,
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
                                      hintText: "Designation Name",
                                      labelText: "Designation Name",
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
                        children: ["Bank Details".text.bold.lg.make()],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: bankNameController,
                                  readOnly: true,
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
                                  readOnly: true,
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
                                  readOnly: true,
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
                                  readOnly: true,
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
                                  value: "true",
                                  groupValue: accommodationRadio,
                                  onChanged: null,
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
                                  value: "false",
                                  groupValue: accommodationRadio,
                                  onChanged: null,
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
                                  readOnly: true,
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
                                  readOnly: true,
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
                                  readOnly: true,
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
                          "Added Documents".text.bold.lg.make(),
                        ],
                      ).pLTRB(8, 6, 6, 0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                final doc = documents[index];
                                final fileUrl = doc["url"] ?? "";
                                final fileTitle = doc["title"] ?? "";

                                return Card(
                                  child: ListTile(
                                    onTap: () async {
                                      if (fileUrl.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "There is no document added!",
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                        );
                                      } else {
                                        final ext =
                                            fileUrl
                                                .split('.')
                                                .last
                                                .toLowerCase();

                                        if (['pdf'].contains(ext)) {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: Container(
                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.8,
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.8,
                                                    child: const PDF().cachedFromUrl(
                                                      fileUrl,
                                                      placeholder:
                                                          (progress) => Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                                  value:
                                                                      progress /
                                                                      100,
                                                                ),
                                                          ),
                                                      errorWidget:
                                                          (error) => Center(
                                                            child: Text(
                                                              'Failed to load PDF',
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        if (Navigator.of(
                                                          context,
                                                        ).canPop()) {
                                                          // âœ… Using `context` inside the builder
                                                          Navigator.of(
                                                            context,
                                                            rootNavigator: true,
                                                          ).pop(); // Close the dialog
                                                        } else {
                                                          print(
                                                            "âš ï¸ Warning: No route to close.",
                                                          );
                                                        }
                                                      },
                                                      child: Text("Close"),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        } else if ([
                                          'jpg',
                                          'jpeg',
                                          'png',
                                        ].contains(ext)) {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  content: Image.network(
                                                    fileUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        if (Navigator.of(
                                                          context,
                                                        ).canPop()) {
                                                          // âœ… Using `context` inside the builder
                                                          Navigator.of(
                                                            context,
                                                            rootNavigator: true,
                                                          ).pop(); // Close the dialog
                                                        } else {
                                                          print(
                                                            "âš ï¸ Warning: No route to close.",
                                                          );
                                                        }
                                                      },
                                                      child: Text("Close"),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        } else {
                                          final status =
                                              await Permission.storage
                                                  .request();
                                          if (status.isGranted) {
                                            final fileName =
                                                fileUrl.split('/').last;
                                            final dir =
                                                await getExternalStorageDirectory();
                                            final savePath =
                                                '${dir!.path}/$fileName';

                                            try {
                                              final response = await Dio()
                                                  .download(fileUrl, savePath);
                                              if (response.statusCode == 200) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Downloaded to $savePath",
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: "Download failed",
                                                );
                                              }
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                msg: "Error downloading file",
                                              );
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Permission denied",
                                            );
                                          }
                                        }
                                      }
                                    },
                                    title: Text(fileTitle),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        if (fileUrl.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "There is no document added!",
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                          );
                                        } else {
                                          final ext =
                                              fileUrl
                                                  .split('.')
                                                  .last
                                                  .toLowerCase();

                                          if (['pdf'].contains(ext)) {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (_) => AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    content: Container(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.8,
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.8,
                                                      child: const PDF().cachedFromUrl(
                                                        fileUrl,
                                                        placeholder:
                                                            (
                                                              progress,
                                                            ) => Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    value:
                                                                        progress /
                                                                        100,
                                                                  ),
                                                            ),
                                                        errorWidget:
                                                            (error) => Center(
                                                              child: Text(
                                                                'Failed to load PDF',
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (Navigator.of(
                                                            context,
                                                          ).canPop()) {
                                                            // âœ… Using `context` inside the builder
                                                            Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true,
                                                            ).pop(); // Close the dialog
                                                          } else {
                                                            print(
                                                              "âš ï¸ Warning: No route to close.",
                                                            );
                                                          }
                                                        },
                                                        child: Text("Close"),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          } else if ([
                                            'jpg',
                                            'jpeg',
                                            'png',
                                          ].contains(ext)) {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (_) => AlertDialog(
                                                    content: Image.network(
                                                      fileUrl,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (Navigator.of(
                                                            context,
                                                          ).canPop()) {
                                                            // âœ… Using `context` inside the builder
                                                            Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true,
                                                            ).pop(); // Close the dialog
                                                          } else {
                                                            print(
                                                              "âš ï¸ Warning: No route to close.",
                                                            );
                                                          }
                                                        },
                                                        child: Text("Close"),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          } else {
                                            final status =
                                                await Permission.storage
                                                    .request();
                                            if (status.isGranted) {
                                              final fileName =
                                                  fileUrl.split('/').last;
                                              final dir =
                                                  await getExternalStorageDirectory();
                                              final savePath =
                                                  '${dir!.path}/$fileName';

                                              try {
                                                final response = await Dio()
                                                    .download(
                                                      fileUrl,
                                                      savePath,
                                                    );
                                                if (response.statusCode ==
                                                    200) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Downloaded to $savePath",
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg: "Download failed",
                                                  );
                                                }
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                  msg: "Error downloading file",
                                                );
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: "Permission denied",
                                              );
                                            }
                                          }
                                        }
                                      },
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
                                        child: Text(
                                          'Aadhar Card (Front)',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Aadhar Card (Back)',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Pan Card',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: 3,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Police Verification',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: 4,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Medical Certificate',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: 5,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Employee Photo',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: 6,
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
                                    ).requestFocus(new FocusNode());

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

  Future<void> approvePreOnboarding(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.preOnboardApproveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['id'] = idSendCheck.toString();
    request.fields['status'] = "APPROVED";

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
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> disApprovePreOnboarding(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.preOnboardApproveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['id'] = idSendCheck.toString();
    request.fields['status'] = "DISAPPROVED";

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
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static showDialgSucess(
    BuildContext buildContext,
    String result,
    String alert,
  ) {
    if (buildContext == null) {
      print("âš ï¸ Warning: buildContext is null, cannot show dialog.");
      return;
    }

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
          ],
          elevation: 24.0,
        );
      },
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
