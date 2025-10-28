import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:er_flutter_project/MSS_Bundle/exitResignation/exitResignationReqList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../ess/EssDashboarrddModel.dart';
import '../../ess/essDashboardNavigate.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../themes/empThemes.dart';
import 'exitModalClasses/fetchResignationRequestModal.dart';

class ExitResignationL2ApprovalPage extends StatefulWidget {
  final dynamic requestId;
  const ExitResignationL2ApprovalPage(
      {super.key, required this.requestId});

  @override
  State<ExitResignationL2ApprovalPage> createState() =>
      _ExitResignationL2ApprovalPageState(requestId.toString());
}
Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
dynamic requestIdReceived;
bool isLoading = true;
bool isLoadingCount = true;
List<DataNew>? allUsernew=[];
List<DataNew>? foundDataNew=[];
class _ExitResignationL2ApprovalPageState
    extends State<ExitResignationL2ApprovalPage> {

  FetchSingleResignationRequestModal? fetchSingleResignationRequestLabel;
  FetchSingleResignationRequestModal? fetchSingleResignationRequestLabeled;

  final dynamic  requestIdReceive;
  _ExitResignationL2ApprovalPageState(this.requestIdReceive);
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController reasonForLeavingController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController l1remarksController = TextEditingController();
  final TextEditingController empRemarksController = TextEditingController();

  final TextEditingController registrationDate = TextEditingController();
  final TextEditingController lastWorkDate = TextEditingController();
  final TextEditingController leavingDate = TextEditingController();
  DateTime? resignDate;
  String? reasonForLeaving;
  String? exitEmployeeName;
  dynamic resignationAttachment = "";

  List<String> reasons = [
    "Better Opportunity",
    "Relocation",
    "Career Change",
    "Health Issues",
    "Personal Reasons"
  ];


  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    //Future<LoanDataShowApprovalModal> getEmployeeList11 = getLoanDataForApproval(sessionId!);
    isLoading = true;
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    Future<FetchSingleResignationRequestModal> getEmployeeList11 = getResignationDataForApproval(sessionId!);
    isLoading = true;

    getEmployeeList11.then((value) {
      setState(() {

        foundDataNew = allUsernew;
        fetchSingleResignationRequestLabel=value;
        fetchSingleResignationRequestLabeled=fetchSingleResignationRequestLabel;
        isLoading = false;
        print('Loan Data - ${foundDataNew!.length}');

        reasonForLeavingController.text = foundDataNew![0].seprationName.toString();
        registrationDate.text = foundDataNew![0].resignationDate.toString();
        noticePeriodController.text = foundDataNew![0].noticeperiod.toString();
        lastWorkDate.text = foundDataNew![0].lastWorkingDate.toString();
        empRemarksController.text = foundDataNew![0].remarks.toString();
        l1remarksController.text = foundDataNew![0].levelOneRemarks.toString();
        exitEmployeeName = foundDataNew![0].empNameCode.toString();
        resignationAttachment = foundDataNew![0].attachment.toString();
      });
    });

  }

  void showAttachmentBottomSheet(BuildContext context, String attachmentUrl) {
    final isPdf = attachmentUrl.toLowerCase().endsWith('.pdf');
    final isImage = attachmentUrl.toLowerCase().endsWith('.jpg') ||
        attachmentUrl.toLowerCase().endsWith('.jpeg') ||
        attachmentUrl.toLowerCase().endsWith('.png');
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
            // File content viewer
            Expanded(
              child: isPdf
                  ? SfPdfViewer.network(
                attachmentUrl,
                canShowScrollStatus: true,
                canShowPaginationDialog: true,
              )
                  : isImage
                  ? CachedNetworkImage(
                imageUrl: attachmentUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                const Center(child: Text("❌ Failed to load image")),
              )
                  : const Center(
                child: Text(
                  "⚠️ File not found !!",
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    requestIdReceived = requestIdSend;
    print("Request ID - $requestIdReceived");
    getSharedPrfanceList();
  }

  Future<FetchSingleResignationRequestModal> getResignationDataForApproval(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.fetchSingleEmployeeExitData;
    print('employeeList11: ${SessionId}');
    FetchSingleResignationRequestModal fetchSingleResignationRequestModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "Id=$requestIdReceived");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');
    setState(() {
      isLoadingCount = true;
      isLoading = true;
    });
    print('URL ${response.request}');
    mapResponse = json.decode(response.body);
    print('responseemployeeList $mapResponse');
    var getData = mapResponse.length;

    fetchSingleResignationRequestModal = FetchSingleResignationRequestModal.fromJson(mapResponse);

    allUsernew = fetchSingleResignationRequestModal.data;



    setState(() {
      isLoadingCount = false;
      isLoading = false;
    });


    return fetchSingleResignationRequestModal;
  }


  /*Future<void> pickDate(bool isResign) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: isResign ? "Select Resignation Date" : "Select Last Working Date",
    );

    if (selected != null) {
      setState(() {
        if (isResign) {
          resignDate = selected;
        } else {
          lastWorkDate = selected;
        }
      });
    }
  }*/

  Widget formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Resignation Approval L2 - ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Mythemes.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$exitEmployeeName",
                      style: TextStyle(
                        color: Mythemes.whitish,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*formLabel("Reason for Leaving"),
                DropdownButtonFormField(
                  value: reasonForLeaving,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
                  items: reasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => reasonForLeaving = value as String);
                  },
                ),*/
                formLabel("Reason for Leaving"),
                TextFormField(
                  controller: reasonForLeavingController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: "Reason for Leaving",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  onTap: () async {
                    DateTime? fromDate = DateTime.now();
                    FocusScope.of(context).requestFocus(FocusNode());
                    fromDate = await showDatePicker(
                      context: context,
                      initialDate: fromDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2060),
                    );
                    setState(() {
                      registrationDate.text = DateFormat("dd-MM-yyyy").format(fromDate!);
                    });
                  },
                  readOnly: true,
                  enabled: false,
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
                const SizedBox(height: 15),

                formLabel("Notice Period (Official)"),
                TextFormField(
                  controller: noticePeriodController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Notice period in days",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

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
                  enabled: false,
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

                formLabel("Reason for Leaving"),
                TextFormField(
                  controller: empRemarksController,
                  readOnly: true,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                formLabel("L1 Remarks"),
                TextFormField(
                  controller: l1remarksController,
                  maxLines: 2,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Enter your remarks",
                    border: OutlineInputBorder(),
                  ),
                ),

                formLabel("My Remarks"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        spreadRadius: 3,
                        offset: Offset(0, 3),
                        color: Colors.green.withOpacity(0.5), // ✅ Green shadow outside
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: remarksController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Enter your remarks",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // ✅ Remove inner border to show shadow clearly
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    "View Attachment".text.bold.make(),
                    IconButton(
                      onPressed: () {
                        if (resignationAttachment != null &&
                            resignationAttachment.toString().isNotEmpty) {
                          showAttachmentBottomSheet(context, resignationAttachment);
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          disApproveResignationRequest(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 5,
                        ),
                        child: const Text("Disapprove",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          approveResignationRequest(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Mythemes.successColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 5,
                        ),
                        child: const Text("Approve",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
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
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel()))
            );
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
            icon: Icon(Icons.account_tree_outlined),
            label: 'My Requests',
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

  Future<void> approveResignationRequest(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.approveResignationRequestL2;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

// Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['requestId'] = requestIdReceived.toString();
    request.fields['permission'] = "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD";
    request.fields['status'] = "LEVEL_TWO_APPROVED";
    request.fields['levelTwoRemarks'] = remarksController.text;
    request.fields['noticePeriod'] = noticePeriodController.text;

// Construct the API URL with parameters (for debugging)
    String apiWithParams = urlapi.toString() +
        '?' +
        request.fields.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
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

  Future<void> disApproveResignationRequest(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.disApproveResignationRequestL2;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

// Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['requestId'] = requestIdReceived.toString();
    request.fields['permission'] = "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE";
    request.fields['status'] = "LEVEL_TWO_DIS_APPROVED";
    request.fields['levelTwoRemarks'] = remarksController.text;
    request.fields['noticePeriod'] = noticePeriodController.text;

// Construct the API URL with parameters (for debugging)
    String apiWithParams = urlapi.toString() +
        '?' +
        request.fields.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
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
}