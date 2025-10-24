import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/commanNotificationPage.dart';
import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../main.dart';
import '../profiles/profilePageWithHead.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../themes/empThemes.dart';
import 'Model/employeeResignationListModal.dart';
import 'Model/reasonForLeavingModal.dart';
import 'dart:developer' as developer;
class ResignationRequisitionPage extends StatefulWidget {
  const ResignationRequisitionPage({super.key});

  @override
  State<ResignationRequisitionPage> createState() => _ResignationRequisitionPageState();
}
String? sessionId;
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
List<String?> reasonForLeavingList = [];
List<String?> employeeResignationList = [];
class _ResignationRequisitionPageState extends State<ResignationRequisitionPage> {
  final _formKey = GlobalKey<FormState>();
  ReasonForLeavingModal? reasonForLeavingModal;
  EmployeeResignationListModal? employeeResignationListModal;
var reasonForLeavingId = "";
String valuenew="listText";
  var dropdownNewvalueNew;
  final TextEditingController registrationDate = TextEditingController();
  final TextEditingController lastWorkDate = TextEditingController();
  final TextEditingController leavingDate = TextEditingController();
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    setState(() {
      getSharedPrfanceList();
      var listLength;

      print('listLength $listLength');
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    Future<ReasonForLeavingModal> getEmployeeList13 = getReasonforLeavingList(sessionId!);
    getEmployeeList13.then((value) {
      setState(() {
        reasonForLeavingModal=value;
      });

    });
    getEmployeeResignationList(sessionId!);
    /*Future<void> getEmpResigList = getEmployeeResignationList(sessionId!);
    getEmpResigList.then((value) {
      setState(() {
        employeeResignationListModal;
      });

    });*/
  }

  Future<ReasonForLeavingModal> getReasonforLeavingList(String sessionId) async {
    reasonForLeavingList=[];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.reasonForLeavingListApi;

    //print('employeeList11: ${SessionId}');
    ReasonForLeavingModal reasonForLeavingModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId");
    final response = await http.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);
    print('branch List ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['list'];
    print('responseemployeeList $getData');
    reasonForLeavingModal=ReasonForLeavingModal.fromJson(mapResponse);

    for(int i=0; i<mapResponse['list'].length;i++){
      reasonForLeavingList.add(mapResponse['list'][i]['name'].toString());
      reasonForLeavingId = mapResponse['list'][i]['id'].toString();

      print('ID -  $reasonForLeavingId');
      //print("HalfDayShow $halfDayRadioShow");
    }

    return reasonForLeavingModal;
  }

  Future<void> getEmployeeResignationList(String sessionId) async {
    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.employeeResignationList;

      var urlapi = Uri.parse("$conn$apiUrl?sessionId=$sessionId");
      final response = await http.post(urlapi);

      print('🔗 API: ${response.request}');
      var mapResponse = json.decode(response.body);

      if (mapResponse["result"] == "success" && mapResponse["exitlist"] != null) {
        setState(() {
          resignationHistory = List<Map<String, dynamic>>.from(mapResponse["exitlist"].map((e) => {
            "empName": e["empName"] ?? "",
            "empCode": e["empCode"] ?? "",
            "resignationDate": e["resignationDate"] ?? e["resignDate"] ?? "",
            "lastWorkingDate": e["lastWorkingDate"] ?? "",
            "noticePeriod": e["noticePeriod"] ?? "",
            "noticeDays": e["noticePeriodDays"] ?? "",
            "reason": e["resonForleaving"] ?? "",
            "attachment": e["attachment"] ?? "",
            "status": e["resignStatus"] ?? "",
          }));
        });
      } else {
        print("⚠️ No resignation history found.");
      }
    } catch (e) {
      print("🚨 Error fetching resignation list: $e");
    }
  }

// Helper function to make status user-friendly
  String _getReadableStatus(String? apiStatus) {
    switch (apiStatus) {
      case "LEVEL_ONE_PENDING":
        return "LEVEL_ONE_PENDING";
      case "LEVEL_TWO_PENDING":
        return "Pending";
      case "APPROVED":
        return "Approved";
      case "REJECTED":
        return "Rejected";
      default:
        return "Unknown";
    }
  }

  DateTime? resignationDate;
  DateTime? lastWorkingDate;
  bool noticeServing = false;
  var noticePeriod = "";
  String? reason;
  var remarks = "";
  File? uploadedFile;

  List<String> reasons = [
    "Better Opportunity",
    "Health Issues",
    "Relocation",
    "Career Change",
    "Personal Reasons"
  ];

  List<Map<String, dynamic>> resignationHistory = [

  ];

  Future<void> pickDate(bool isResignationDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isResignationDate) {
          resignationDate = picked;
        } else {
          lastWorkingDate = picked;
        }
      });
    }
  }

  void openUploadDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
                child: Text("Upload Resignation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Use Camera"),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() => uploadedFile = File(image.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.teal),
              title: const Text("Upload from Files"),
              onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null && result.files.single.path != null) {
                  setState(() => uploadedFile = File(result.files.single.path!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  int currentIndex = 2;


  Future<void> saveResignationRequisition(BuildContext context) async {
    // ✅ Proceed with the API call if both checks pass
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.resignationRequisitionSaveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['resign_date'] = registrationDate.text;
    request.fields['last_working_date'] = lastWorkDate.text;
    request.fields['noticePeriodServing'] = noticeServing.toString();
    request.fields['noticePeriod'] = noticePeriod;
    request.fields['remarks'] = remarks;
    request.fields['separationMode'] = reasonForLeavingId;

    // ✅ Attach file if available
    if (uploadedFile != null && uploadedFile!.existsSync()) {
      String fileName = uploadedFile!.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'document',               // key name for backend
          uploadedFile!.path,       // local file path
          filename: fileName,
        ),
      );
    } else {
      // If no file uploaded, send empty field
      request.fields['document'] = "";
    }

    // Construct the API URL with parameters (for debugging)
    String apiWithParams = urlapi.toString() +
        '?' +
        request.fields.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
    print('API URL with Parameters: $apiWithParams');

    try {
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Status Code: ${httpResponse.statusCode}');
      print('Response: ${httpResponse.body}');

      Navigator.of(context, rootNavigator: true).pop();

      if (httpResponse.statusCode == 200) {
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      }
    } catch (e) {
      print('❌ Exception during API call: $e');
    }
  }

  static showDialgSucess(BuildContext buildContext, String result, String alert) {
    if (buildContext == null) {
      print("⚠️ Warning: buildContext is null, cannot show dialog.");
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
          title: Row(
            children: [
              Expanded(child: Text(alert)),
            ],
          ),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) { // ✅ Using `context` inside the builder
                  Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
                  Navigator.of(buildContext).maybePop();
                } else {
                  print("⚠️ Warning: No route to close.");
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

  void showAttachmentBottomSheet(BuildContext context, String attachmentUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("View Attachment",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            Expanded(
              child: PDF().cachedFromUrl(
                attachmentUrl,
                placeholder: (progress) =>
                    Center(child: Text("Loading... ${progress.toStringAsFixed(0)}%")),
                errorWidget: (error) =>
                const Center(child: Text("❌ Failed to load document")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAttachmentDialog(BuildContext context, String attachmentUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "View Attachment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),

              // PDF Viewer Area
              Expanded(
                child: attachmentUrl.isNotEmpty
                    ? PDF(
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageFling: true,
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to load PDF: $error")),
                    );
                  },
                  onPageError: (page, error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error on page $page: $error")),
                    );
                  },
                ).cachedFromUrl(
                  attachmentUrl,
                  placeholder: (progress) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 10),
                        Text("Loading... ${progress.toStringAsFixed(0)}%"),
                      ],
                    ),
                  ),
                  errorWidget: (error) => Center(
                    child: Text("❌ Failed to load document"),
                  ),
                )
                    : const Center(
                  child: Text(
                    "No attachment available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resignation Requisition",
            style: TextStyle(fontWeight: FontWeight.bold)),
        //backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form Section
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Resignation Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      const SizedBox(height: 15),

                      // Resignation Date
                      TextFormField(
                        onTap: () async {
                          DateTime? fromDate = DateTime.now();
                          FocusScope.of(context).requestFocus(FocusNode());
                          fromDate = await showDatePicker(
                            context: context,
                            initialDate: fromDate,
                            firstDate: DateTime(1947),
                            lastDate: DateTime(2060),
                          );
                          setState(() {
                            registrationDate.text = DateFormat("dd-MM-yyyy").format(fromDate!);
                          });
                        },
                        readOnly: true,
                        controller: registrationDate,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (registrationDate.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      registrationDate.clear();
                                    });
                                  },
                                ),
                              Icon(Icons.calendar_month, size: 18),
                            ],
                          ),
                          labelText: "Resignation Date",
                          contentPadding: EdgeInsets.all(5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Mythemes.blackishade),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Mythemes.blackish,
                          ),
                        ),
                      ).p8(),
                      const SizedBox(height: 10),

                      // Last Working Date
                      TextFormField(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode()); // to prevent keyboard
                          DateTime? fromDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1947),
                            lastDate: DateTime(2060),
                          );
                          if (fromDate != null) {
                            setState(() {
                              lastWorkDate.text = DateFormat("dd-MM-yyyy").format(fromDate);
                            });
                          }
                        },
                        readOnly: true,
                        controller: lastWorkDate,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (lastWorkDate.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      lastWorkDate.clear();
                                    });
                                  },
                                ),
                              Icon(Icons.calendar_month, size: 18),
                            ],
                          ),
                          labelText: "Last Working Date",
                          contentPadding: EdgeInsets.all(5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Mythemes.blackishade),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Mythemes.blackish,
                          ),
                        ),
                      ).p8(),
                      const SizedBox(height: 15),

                      // Notice Period Serving
                      const Text("Notice Period Serving?",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Radio<bool>(
                              value: true,
                              groupValue: noticeServing,
                              onChanged: (value) {
                                setState(() {
                                  noticeServing = value!;
                                  print("Notice Period - $noticeServing");
                                });
                              },
                          ),
                              //onChanged: (value) => setState(() => noticeServing = value!)),
                          const Text("Yes"),
                          Radio<bool>(
                              value: false,
                              groupValue: noticeServing,
                            onChanged: (value) {
                              setState(() {
                                noticeServing = value!;
                                print("Notice Period - $noticeServing");
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),

                      if (noticeServing)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Notice Period (To be served in Days)",
                          ),
                          controller: TextEditingController(text: noticePeriod),
                        ),
                      const SizedBox(height: 15),

                      // Reason
                      DropdownButtonFormField<String>(
                        isExpanded: true, // ✅ Important for avoiding overflow
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Mythemes.blackishade),
                          ),
                          hintText: "Reason for Leaving",
                          labelText: "Reason for Leaving",
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Mythemes.blackish,
                          ),
                        ),
                        items: reasonForLeavingList.map((String? value) {
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
                          for (int i = 0; i < reasonForLeavingModal!.list!.length; i++) {
                            if (reasonForLeavingModal!.list![i].name
                                .toString()
                                .compareToIgnoringCase(newVal.toString()) ==
                                0) {
                              reasonForLeavingId = reasonForLeavingModal!.list![i].id!.toString();
                              print("Branch Id $reasonForLeavingId");
                            }
                          }
                          setState(() {
                            dropdownNewvalueNew = newVal;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // Remarks
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Remarks"),
                        maxLines: 3,
                        controller: TextEditingController(text: remarks),
                        onChanged: (val) => remarks = val,
                      ),
                      const SizedBox(height: 15),

                      // Upload
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Upload Resignation",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: openUploadDialog,
                        ),
                      ),

                      if (uploadedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("📎 Selected: ${uploadedFile!.path.split('/').last}",
                              style: const TextStyle(color: Colors.green)),
                        ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            saveResignationRequisition(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text("Save",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Resignation History
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Resignation History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ),
            const SizedBox(height: 10),
            ...resignationHistory.map((item) {

              return Card(
                color: Colors.amber.shade100,
                elevation: 6,
                shadowColor: Colors.amberAccent.withOpacity(0.4),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Header Row — Employee Name + Status Chip
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${item["empName"]} (${item["empCode"]})",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              item["status"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 🔹 Job details section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "Resignation: ${item["resignationDate"]}",
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.work_history, size: 16, color: Colors.black54),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "Last Day: ${item["lastWorkingDate"]}",
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 🔹 Notice Period
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 16, color: Colors.black54),
                                const SizedBox(width: 6),
                                Text(
                                  "Notice Period: ${item["noticePeriod"]}",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 16, color: Colors.black54),
                                const SizedBox(width: 6),
                                Text(
                                  "Notice Days: ${item["noticeDays"]}",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),


                      const SizedBox(height: 8),

                      // 🔹 Reason and View Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: Colors.black54),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "Reason: ${item["reason"]}",
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (item["attachment"] != null &&
                                  item["attachment"].toString().isNotEmpty) {
                                showAttachmentBottomSheet(context, item["attachment"]);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No attachment available")),
                                );
                              }
                            },
                            icon: Icon(Icons.remove_red_eye,
                                color: Mythemes.lightBluishColor, size: 24),
                            tooltip: "View Attachment",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
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
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
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
            icon: Icon(Icons.pending_actions),
            label: 'Attendance',
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