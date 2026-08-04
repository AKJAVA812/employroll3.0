import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/mss/claimMssItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../../MSS_Bundle/travelAndExpense/claimMssItems.dart';
import '../../../MSS_MO_Bundle/travelAndExpense/claimMssItems.dart';
import '../../../UIS_Bundle/travelAndExpense/claimMssItems.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../commanScreen/commanNotificationPage.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../newModalClasses/claimMssApprovalDataModal.dart';

class ClaimMssApproval extends StatefulWidget {
  //const ClaimMssApproval({super.key});
  final String levelStatus;
  final String empId;

  const ClaimMssApproval({
    Key? key,
    required this.levelStatus,
    required this.empId,
  }) : super(key: key);
  @override
  State<ClaimMssApproval> createState() =>
      _ClaimMssApprovalState(levelStatus, empId);
}

List<bool> _expansionStates = [];
bool isExpanded = false;
bool isExpandedDefault = true;
SessionManager sessionManager = SessionManager();
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
dynamic empId;
var userPanel;

dynamic claimRaiseId;
dynamic levelStatusChecked;
dynamic empIdReceived;
dynamic permissionCode;
var titleName = "Claim Approval";
List<Data>? allUsernew = [];
List<Data>? foundDataNew = [];
ClaimMssApprovalDataModal? claimMssApprovalDataModalGlobal;
ClaimMssApprovalDataModal? claimMssApprovalDataModalGlobaled;

//Fields
TextEditingController reimbursementTypeController = TextEditingController();
TextEditingController expenseTypeController = TextEditingController();
TextEditingController subExpTypeController = TextEditingController();
TextEditingController subSubExpTypeController = TextEditingController();
TextEditingController travelFromController = TextEditingController();
TextEditingController travelToController = TextEditingController();
TextEditingController merchantController = TextEditingController();
TextEditingController kmController = TextEditingController();
TextEditingController claimAmtController = TextEditingController();
TextEditingController monthController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController odoStartController = TextEditingController();
TextEditingController odoEndController = TextEditingController();
TextEditingController remarksController = TextEditingController();

class _ClaimMssApprovalState extends State<ClaimMssApproval> {
  final String levelStatus;
  final String empIdReceive;

  _ClaimMssApprovalState(this.levelStatus, this.empIdReceive);
  bool isLoading = true;
  bool isLoadingNew = true;

  void expandTile() {
    setState(() {
      isExpanded = true;
      // keyTile = UniqueKey();
    });
  }

  String? selectedDate;
  void shrinkTile() {
    setState(() {
      isExpanded = false;
      // keyTile = UniqueKey();
    });
  }

  @override
  void initState() {
    getSharedPrfanceList();

    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empId = await shared.getEmpId();
    userPanel = await shared.getUserPanel();
    levelStatusChecked = levelStatusCheck;
    if (userPanel == "MSS") {
      empIdReceived = empIdSendMSS;
      levelStatusChecked = levelStatusCheckMSS;
    }
    if (userPanel == "MSS_MO_ADMIN") {
      empIdReceived = empIdSendMO;
      levelStatusChecked = levelStatusCheckMO;
    }
    if (userPanel == "USER") {
      empIdReceived = empIdSendUIS;
      levelStatusChecked = levelStatusCheckUIS;
    }
    print("EMP ID REC - $empIdReceive");

    if (levelStatusChecked == "LEVEL_ONE_PENDING") {
      permissionCode = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
    }
    if (levelStatusChecked == "LEVEL_TWO_PENDING") {
      permissionCode = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
    }
    if (levelStatusChecked == "LEVEL_THREE_PENDING") {
      permissionCode = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
    }

    // await Future.delayed(Duration(seconds: 5));
    Future<ClaimMssApprovalDataModal> getEmployeeList11 = getEmployeeList(
      sessionId!,
    );
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        claimMssApprovalDataModalGlobal = value;
        claimMssApprovalDataModalGlobaled = claimMssApprovalDataModalGlobal;
        isLoading = false;
      });
      print('employeeList00${claimMssApprovalDataModalGlobal!.data!.length}');
    });
  }

  Future<ClaimMssApprovalDataModal> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.claimApproveDataApi;
    print('employeeList11: ${SessionId}');
    ClaimMssApprovalDataModal claimMssApprovalDataModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "levelStatus=$levelStatusChecked&"
      "empId=$empIdReceived",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    setState(() {
      isLoading = true; // Start loading
      isLoadingNew = true; // Start loading
    });
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    claimMssApprovalDataModal = ClaimMssApprovalDataModal.fromJson(mapResponse);
    allUsernew = claimMssApprovalDataModal.data;
    setState(() {
      isLoadingNew = false;
    });
    return claimMssApprovalDataModal;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>? results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
      setState(() {
        results = allUsernew;
      });
    } else {
      /*results = allUsernew.where((user) =>
        user!.data!.contains(enteredKeyword.toLowerCase()))
          .toList();*/

      results =
          allUsernew
              ?.where(
                (element) => element.reimburName!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
      /*for(int i=0; i<inductionListLabel!.data!.length;i++){
        if(inductionListLabel!.data![i].empName!.toLowerCase().contains(enteredKeyword.toLowerCase())){
          // Refresh the UI
          setState(() {
            inductionListLabeldd=inductionResult;
          });
        }*/
    }
    // we use the toLowerCase() method to make it case-insensitive
    setState(() {
      foundDataNew = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: titleName.text.make()),

        body: Container(
          child: Column(
            children: [
              Expanded(
                child:
                    isLoadingNew
                        ? Center(
                          child: CircularProgressIndicator(),
                        ) // Show loader
                        : claimMssApprovalDataModalGlobaled == null
                        ? Center(child: CircularProgressIndicator())
                        : MyStatelessWidget(claimMssApprovalDataModalGlobaled!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyStatelessWidget extends StatefulWidget {
  final ClaimMssApprovalDataModal employeeListModel;

  MyStatelessWidget(this.employeeListModel);
  @override
  State<MyStatelessWidget> createState() =>
      _MyStatelessWidgetState(employeeListModel);
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final ClaimMssApprovalDataModal employeeListModel;
  _MyStatelessWidgetState(this.employeeListModel);

  var status;
  var stepOne;
  var stepTwo;
  var stepThree;
  var stepFour;
  var stepFive;
  void showApprovalDialog(
    BuildContext context,
    String action,
    dynamic claimRaiseId,
  ) {
    TextEditingController remarksController = TextEditingController();
    TextEditingController approveAmtController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$action Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please provide your remarks for $action."),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: approveAmtController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Enter $action Amount...",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter remarks...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String remarks = remarksController.text.trim();
                String approverAmt = approveAmtController.text.trim();
                if (remarks.isNotEmpty) {
                  // Process the remarks (e.g., send to API)
                  print("Remarks for $action: $remarks");
                  if (action == "Approve") {
                    approveClaim(context, remarks, claimRaiseId, approverAmt);
                  } else {
                    disApproveClaim(
                      context,
                      remarks,
                      claimRaiseId,
                      approverAmt,
                    );
                  }

                  Navigator.of(context).pop(); // Close pop-up after submission
                } else {
                  // Show validation message
                  Fluttertoast.showToast(
                    msg: "Please enter remarks before submitting.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _expansionStates = List<bool>.filled(foundDataNew!.length, false);

    // TODO: implement initState
    super.initState();
  }

  Future<ClaimMssApprovalDataModal> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.claimApproveDataApi;
    print('employeeList11: ${SessionId}');
    ClaimMssApprovalDataModal claimMssApprovalDataModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "levelStatus=$levelStatusChecked&"
      "empId=$empIdReceived",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    claimMssApprovalDataModal = ClaimMssApprovalDataModal.fromJson(mapResponse);
    allUsernew = claimMssApprovalDataModal.data;

    return claimMssApprovalDataModal;
  }

  Future<void> approvedClaim(
    String remarks,
    dynamic claimRaiseId,
    dynamic approveAmt,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.claimApproveApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "permissionCode=$permissionCode&"
      "remarks=$remarks&"
      "amount=$approveAmt&"
      "claimRaiseId=$claimRaiseId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String result = mapResponse['result']['result'];
      String reason = mapResponse['result']['reason'];
      print('result both $result $reason');
      print('result${result}');
      if (result.compareToIgnoringCase("success") == 0) {
        //showDialgSucess1(context,reason.upperCamelCase+" ","Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        //showDialgSucess1(context,reason.upperCamelCase, " Error ");
      } else if (result.compareToIgnoringCase("warning") == 0) {
        //showDialgSucess1(context,reason.upperCamelCase, " Warning ");
      }
    }
  }

  Future<void> approveClaim(
    BuildContext buildContext,
    String remarks,
    dynamic claimRaiseId,
    dynamic approveAmt,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.claimApproveApi;

    // Show Loader (Using Future.delayed to ensure UI update)
    Future.delayed(Duration.zero, () {
      showDialog(
        context: buildContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Processing, please wait..."),
              ],
            ),
          );
        },
      );
    });

    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "permissionCode=$permissionCode&"
      "remarks=$remarks&"
      "amount=$approveAmt&"
      "claimRaiseId=$claimRaiseId",
    );

    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');

    // Close the loader once API response is received
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (response.statusCode == 200) {
      var responseResult = json.decode(response.body);
      print('Response: $responseResult');

      String status = responseResult['status'].toLowerCase();
      String reason = responseResult['reason'];

      // Define dialog properties based on result type
      String title = "Success";
      IconData icon = Icons.check_circle;
      Color iconColor = Colors.green;

      if (status == "error") {
        title = "Error";
        icon = Icons.error;
        iconColor = Colors.red;
      } else if (status == "warning") {
        title = "Warning";
        icon = Icons.warning;
        iconColor = Colors.orange;
      }

      // Show Success/Error/Warning Dialog
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: 8),
                Text(title),
              ],
            ),
            content: Text(reason),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // close the result dialog

                  // âœ… Pop 2 screens back using `buildContext`
                  Future.delayed(Duration(milliseconds: 100), () {
                    int count = 0;
                    Navigator.of(context).popUntil((route) {
                      return count++ == 1;
                    });
                  });
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> disApproveClaim(
    BuildContext buildContext,
    String remarks,
    dynamic claimRaiseId,
    dynamic approveAmt,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.claimDisApproveApi;

    // Show Loader (Using Future.delayed to ensure UI update)
    Future.delayed(Duration.zero, () {
      showDialog(
        context: buildContext,
        barrierDismissible: false, // Prevent closing while loading
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Processing, please wait..."),
              ],
            ),
          );
        },
      );
    });

    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "permissionCode=$permissionCode&"
      "remarks=$remarks&"
      "amount=$approveAmt&"
      "claimRaiseId=$claimRaiseId",
    );

    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');

    // Close the loader once API response is received
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (response.statusCode == 200) {
      var responseResult = json.decode(response.body);
      print('Response: $responseResult');

      String status = responseResult['status'].toLowerCase();
      String reason = responseResult['reason'];

      // Define dialog properties based on result type
      String title = "Success";
      IconData icon = Icons.check_circle;
      Color iconColor = Colors.green;

      if (status == "error") {
        title = "Error";
        icon = Icons.error;
        iconColor = Colors.red;
      } else if (status == "warning") {
        title = "Warning";
        icon = Icons.warning;
        iconColor = Colors.orange;
      }
      // Show Success/Error/Warning Dialog
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: 8),
                Text(title),
              ],
            ),
            content: Text(reason),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // close the result dialog

                  // âœ… Pop 2 screens back using `buildContext`
                  Future.delayed(Duration(milliseconds: 100), () {
                    int count = 0;
                    Navigator.of(context).popUntil((route) {
                      return count++ == 1;
                    });
                  });
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (a, b, c) => ClaimMssApproval(
                    levelStatus: levelStatusChecked,
                    empId: empIdReceived,
                  ),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ),
          );
          return Future.value(false);
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: foundDataNew!.length,
          itemBuilder: (context, index) {
            reimbursementTypeController.text =
                foundDataNew![index].reimburName.toString();
            print("Reimbursement Type - ${reimbursementTypeController.text}");
            expenseTypeController.text =
                foundDataNew![index].expName.toString();
            subExpTypeController.text =
                foundDataNew![index].subExpname.toString();
            subSubExpTypeController.text =
                foundDataNew![index].categoryName.toString();
            travelFromController.text =
                foundDataNew![index].fromPlace.toString();
            travelToController.text = foundDataNew![index].toPlace.toString();
            merchantController.text = foundDataNew![index].merchant.toString();
            dateController.text = foundDataNew![index].date;
            monthController.text = foundDataNew![index].month;
            odoStartController.text = foundDataNew![index].startReading;
            odoEndController.text = foundDataNew![index].endReading;
            kmController.text = foundDataNew![index].kilometer;
            claimAmtController.text =
                foundDataNew![index].claimAMount.toString();
            print("Claim Amt. - ${claimAmtController.text}");
            remarksController.text = foundDataNew![index].remarks;
            //final cardData = cardList[index];
            return Card(
              elevation: 2,
              child: ExpansionTile(
                initiallyExpanded: _expansionStates[index],
                childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
                title: "Claim ${index + 1}".text.make(),
                trailing: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "â‚¹${claimAmtController.text}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Mythemes.successColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Replace with actual file URL or local path
                              if (foundDataNew![index].image == "") {
                                Fluttertoast.showToast(
                                  msg: "There is no document added !",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                String fileUrl = foundDataNew![index].image;
                                bool isPdf = fileUrl.toLowerCase().endsWith(
                                  '.pdf',
                                );

                                showDocumentDialog(context, fileUrl, isPdf);
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.doc_text_search,
                              size: 30,
                              color: Mythemes.lightBluishColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: ["Approve Claim".text.bold.size(16).make()],
                      ),
                      //Reimbursement Type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].reimburName
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.text_snippet_rounded,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Reimbursement Type",
                                    labelText: "Reimbursement Type",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //Expense Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].expName.toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.textsms_outlined),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Expense Category",
                                    labelText: "Expense Category",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].subExpname
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.textsms_outlined),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Sub Exp. Category",
                                    labelText: "Sub Exp. Category",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //Sub Sub Expense Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].categoryName
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.subject),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Sub Sub Exp. Category",
                                    labelText: "Sub Sub Exp. Category",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //Travel from & to
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].fromPlace
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.airplanemode_active),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Travel From",
                                    labelText: "Travel From",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].toPlace.toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.airplanemode_active),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Travel To",
                                    labelText: "Travel To",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //odometer readings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].startReading
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.electric_meter),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Odometer Start",
                                    labelText: "Odometer Start",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].endReading
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.electric_meter),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Odometer End",
                                    labelText: "Odometer End",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //merchant & km
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].merchant
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.business_center),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Merchant",
                                    labelText: "Merchant",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].kilometer
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      CupertinoIcons.speedometer,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Kilometers",
                                    labelText: "Kilometers",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //month & date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text: foundDataNew![index].month.toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_month),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Month",
                                    labelText: "Month",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                                  controller: TextEditingController(
                                    text: foundDataNew![index].date.toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.date_range),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Date",
                                    labelText: "Date",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].claimAMount
                                            .toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.currency_rupee),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Claimed Amount",
                                    labelText: "Claimed Amount",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                      //Remarks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                TextFormField(
                                  controller: TextEditingController(
                                    text:
                                        foundDataNew![index].remarks.toString(),
                                  ),
                                  readOnly: true,
                                  // initialValue: "Head Office",
                                  //maxLines: 3,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.text_snippet_outlined,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Mythemes.blackishade,
                                      ),
                                    ),
                                    //labelText: "Select Department",
                                    hintText: "Remarks",
                                    labelText: "Remarks",
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  claimRaiseId = foundDataNew![index].claimId;
                                  print("$claimRaiseId");
                                  showApprovalDialog(
                                    context,
                                    "Disapprove",
                                    claimRaiseId,
                                  );
                                  setState(() {});
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Mythemes.dangerColor,
                                  ),
                                ),
                                child: Text("Disapprove"),
                              ).wh(130, 40).py12(),

                              ElevatedButton(
                                onPressed: () {
                                  claimRaiseId = foundDataNew![index].claimId;
                                  print("$claimRaiseId");
                                  showApprovalDialog(
                                    context,
                                    "Approve",
                                    claimRaiseId,
                                  );
                                  setState(() {});
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Mythemes.successColor,
                                  ),
                                ),
                                child: Text("Approve"),
                              ).wh(130, 40).py12(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ).pLTRB(8, 0, 8, 5);
          },
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
