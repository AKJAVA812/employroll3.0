import 'dart:convert';
import 'package:er_flutter_project/modules/claimAndReimbursement/mss/claimMssApprovalPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/ess/loan&Advance/modalClass/loanWiseSkipModal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../themes/empThemes.dart';
import '../myAllReports.dart';
import 'modalClass/loanLedgerModal.dart';
import 'modalClass/loanSummaryModal.dart';

class LoanSummaryPage extends StatefulWidget {
  const LoanSummaryPage({super.key});

  @override
  State<LoanSummaryPage> createState() => _LoanSummaryPageState();
}

Map<String, dynamic> mapResponse = {};
Map<String, dynamic> mapResponseLoanLedger = {};
Map<String, dynamic> mapResponseLoanWiseSkip = {};

SessionManager shared = SessionManager();

String? sessionId;

class _LoanSummaryPageState extends State<LoanSummaryPage> {
  final bool _isFirstBuild = true;
  bool _isBottomSheetOpen = false;
  bool isLoading = false;
  bool isLoadingCount = true;

  List<LoanSummary>? allUsernew = [];
  List<LoanSummary>? foundDataNew = [];
  List<EmpList>? loanLedgerNew = [];
  List<EmpList>? foundLoanLedgerData = [];

  List<Loandata>? loanWiseSkipNew = [];
  List<Loandata>? foundLoanWiseSkipData = [];

  LoanSummaryModal? myLoanSummaryLabel;
  LoanSummaryModal? myLoanSummaryLabeled;

  LoanLedgerModal? loanLedgerLabel;
  LoanLedgerModal? loanLedgerLabeled;

  LoanWiseSkipModal? loanWiseSkipLabel;
  LoanWiseSkipModal? loanWiseSkipLabeled;

  final List<Map<String, dynamic>> loanSummaries = [
    {
      "loanType": "Home Loan",
      "color": Mythemes.deepPurple,
      "appliedAmount": "500,000",
      "paidAmount": "200,000",
      "pendingInstallments": 6,
      "pendingAmount": "300,000",
    },
    {
      "loanType": "Vehicle Loan",
      "color": Mythemes.successColor,
      "appliedAmount": "300,000",
      "paidAmount": "150,000",
      "pendingInstallments": 3,
      "pendingAmount": "150,000",
    },
  ];

  List<Map<String, String>> breakupList = [
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "June-25",
      "amount": "93,000.00",
      "date": "Jul 15, 2025",
      "status": "Approved",
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending",
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending",
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending",
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending",
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending",
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSharedPrfanceList());

    setState(() {
      getSharedPrfanceList();
      int listLength;
      int loanLedgerList;
      listLength = foundDataNew!.length;
      loanLedgerList = foundLoanLedgerData!.length;
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<LoanSummaryModal> getEmployeeList11 = getLoanSummary(sessionId!);
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
        myLoanSummaryLabel = value;
        myLoanSummaryLabeled = myLoanSummaryLabel;
      });
    });
  }

  showNodata(BuildContext buildContext, result, reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            Navigator.pop(buildContext);
            setState(() {});
          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Future<LoanSummaryModal> getLoanSummary(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanSummaryApi;
    LoanSummaryModal loanSummaryModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);

    setState(() {
      isLoadingCount = true;
    });
    mapResponse = json.decode(response.body);
    var getData = mapResponse.length;
    if (getData == 0) {
      showNodata(context, "Oops", "There is no any requisition.");
    }
    loanSummaryModal = LoanSummaryModal.fromJson(mapResponse);
    allUsernew = loanSummaryModal.loanSummary;
    /* for (int i = 0; i < claimRequisitionModal.claimRequisitionPendinglist!.length; i++) {
      empName = mapResponse['claimRequisitionPendinglist'][i]['empName'];
      print("EMP NAME - $empName");
    }*/
    // globalListParameter = claimRequisitionModal.claimRequisitionApprovedlist;
    //totalDraftAmt = selfLoanRequestModal.totaDraftAmount;

    /*if(valueChange == 3) {
      allUsernewDisapproved = claimRequisitionModal.claimRequisitionDisapprovelist!;
    }*/
    setState(() {
      isLoadingCount = false;
    });

    _expandedTiles = List.generate(foundDataNew!.length, (index) => index == 0);

    return loanSummaryModal;
  }

  var openingCreditBalance;
  var currentCreditBalance;
  var currentDebitBalance;
  var netCreditBalance;
  var netDebitBalance;

  Future<LoanLedgerModal> getLoanLedger(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanLedgerApi;
    LoanLedgerModal loanLedgerModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "loanId=$loanId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    setState(() {
      isLoadingCount = true;
    });
    mapResponseLoanLedger = json.decode(response.body);
    var getData = mapResponseLoanLedger.length;
    if (getData == 0) {
      showNodata(context, "Oops", "There is no any requisition.");
    }
    loanLedgerModal = LoanLedgerModal.fromJson(mapResponseLoanLedger);
    loanLedgerNew = loanLedgerModal.empList;
    openingCreditBalance = loanLedgerModal.openingCreditBal;
    currentCreditBalance = loanLedgerModal.currentCreditBal;
    currentDebitBalance = loanLedgerModal.currentDebitBal;
    netCreditBalance = loanLedgerModal.netCreditBal;
    netDebitBalance = loanLedgerModal.netDebitBal;

    setState(() {
      isLoadingCount = false;
    });


    return loanLedgerModal;
  }

  Future<LoanWiseSkipModal> getLoanSkipList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanSkipListApi;
    LoanWiseSkipModal loanWiseSkipModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "groupId=$loanId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    setState(() {
      isLoadingCount = true;
    });
    mapResponseLoanWiseSkip = json.decode(response.body);
    var getData = mapResponseLoanWiseSkip.length;
    if (getData == 0) {
      showNodata(context, "Oops", "There is no any requisition.");
    }
    loanWiseSkipModal = LoanWiseSkipModal.fromJson(mapResponseLoanWiseSkip);
    loanWiseSkipNew = loanWiseSkipModal.loandata;

    setState(() {
      isLoadingCount = false;
    });


    return loanWiseSkipModal;
  }

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text("$label:", style: TextStyle(color: Colors.black54)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> requestSkipInstalment(BuildContext context) async {
    // âœ… Proceed with the API call if both checks pass
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.requestSkipInstalmentApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['skipMonth'] = skipMonth;
    request.fields['remarks'] = reasonController.text;
    request.fields['monthlyLoanId'] = loanId.toString();
    request.fields['effectiveDate'] = dateController.text;

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

  List<bool> _expandedTiles = [];

  void showConfirmationPopup(BuildContext context) {
    showDialog(
      context: context, // âœ… This is still valid
      barrierDismissible: false,
      builder: (BuildContext confirmCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text(
                "Request Sent Successfully!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(confirmCtx).pop(); // Close the success popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  final TextEditingController reasonController = TextEditingController();
  void showSkipInstallmentPopup(BuildContext context) {
    DateTime? selectedRepaymentDate;

    showDialog(
      context: context,
      builder: (BuildContext outerCtx) {
        return Builder(
          // ðŸ‘ˆ This Builder captures a valid dialog context
          builder: (BuildContext dialogCtx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Skip Installment",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customReadOnlyInput(
                        icon: Icons.menu,
                        label: "Loan Type",
                        controller: TextEditingController(text: "$loanType"),
                        value: "$loanType",
                      ),
                      const SizedBox(height: 12),
                      customReadOnlyInput(
                        icon: Icons.calendar_today,
                        label: "Skip Month",
                        value: "$skipMonth",
                        controller: TextEditingController(text: "$skipMonth"),
                      ),
                      const SizedBox(height: 12),
                      customDatePicker(
                        icon: Icons.calendar_today,
                        label: 'Start Date',
                        selectedDate: selectedDate,
                        controller: dateController,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                              dateController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      customTextField(
                        icon: Icons.comment,
                        label: "Reason for Skip",
                        controller: reasonController,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(
                              dialogCtx,
                            ).pop(); // âœ… safely close popup
                            requestSkipInstalment(context);
                          },
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text("Request"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget customReadOnlyInput({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    required String value,
  }) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //filled: true,
        //fillColor: Colors.grey.shade100,
        hintText: value,
      ),
    );
  }

  Widget customTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      maxLines: 2,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //filled: true,
        //fillColor: Colors.grey.shade100,
      ),
    );
  }

  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  Widget customDatePicker({
    required IconData icon,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required TextEditingController controller, // Added controller
  }) {
    controller.text =
        selectedDate != null
            ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
            : '';

    return TextField(
      readOnly: true,
      controller: controller, // Use the controller
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        hintText: "Select date",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  var loanId;
  var loanType;
  var skipMonth;

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // <--- Make sure this is true
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            maxChildSize: 0.95,
            minChildSize: 0.6,
            builder: (_, controller) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: EdgeInsets.all(16),
                  child: StatefulBuilder(
                    builder: (context, setModalState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // allow shrink
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Text(
                              '$loanType',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Click to skip instalment',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 16),

                            /// ðŸ›  Make this scrollable within the scroll view
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // No nested scroll
                              itemCount: foundLoanWiseSkipData!.length,
                              itemBuilder: (context, index) {
                                final item = foundLoanWiseSkipData![index];
                                return InkWell(
                                  onTap: () {
                                    if (item.status == "Paid") {
                                      Fluttertoast.showToast(
                                        msg:
                                            "This instalment is already paid !!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                    if (item.skipStatus == "Request") {
                                      Fluttertoast.showToast(
                                        msg:
                                            "This instalment is already requested !!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      loanId = item.ledgerId;
                                      skipMonth = item.monthName;
                                      dateController.text = "";
                                      remarksController.text = "";
                                      showSkipInstallmentPopup(context);
                                    }
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.empName!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      item.status == 'Paid'
                                                          ? Colors
                                                              .green
                                                              .shade100
                                                          : Colors
                                                              .orange
                                                              .shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  item.status!,
                                                  style: TextStyle(
                                                    color:
                                                        item.status == 'Paid'
                                                            ? Colors
                                                                .green
                                                                .shade800
                                                            : Colors
                                                                .orange
                                                                .shade800,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          infoRow(
                                            Icons.calendar_today,
                                            "Installment Months",
                                            item.monthName!,
                                          ),
                                          infoRow(
                                            Icons.payments,
                                            "Installment Amount",
                                            "â‚¹ ${item.monthlyAmt}",
                                          ),
                                          infoRow(
                                            Icons.verified_user_outlined,
                                            "Requested Status",
                                            "${item.skipStatus}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
    ).whenComplete(() {
      _isBottomSheetOpen = false; // âœ… Reset when sheet is dismissed
    });
  }

  void showTransactionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            maxChildSize: 0.95,
            minChildSize: 0.6,
            builder: (_, controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Opening Balance
                    Text(
                      'Opening Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'â‚¹ $openingCreditBalance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Scrollable Transaction List
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: foundLoanLedgerData!.length,
                        itemBuilder: (_, index) {
                          final item = foundLoanLedgerData![index];
                          final isCredit = item.eventType == "Credit";

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.eventName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.loanType,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          'Date: ${item.date}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          '${item.eventDesc}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      isCredit
                                          ? '+ â‚¹ ${item.creditValue}'
                                          : '- â‚¹ ${item.debitValue}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color:
                                            isCredit
                                                ? Colors.green
                                                : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Fixed Bottom Balance Summary
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        //border: Border(top: BorderSide(color: Colors.grey[300]!)),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Credit:',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'â‚¹ $currentCreditBalance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Debit:',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'â‚¹ $currentDebitBalance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Mythemes.dangerColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Net Balance:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'â‚¹ $netCreditBalance',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Mythemes.successColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  final List<Map<String, dynamic>> getColor = [
    {"color": Mythemes.deepPurple},
    {"color": Mythemes.successColor},
    {"color": Mythemes.lightBluishColor},
    {"color": Mythemes.dangerColor},
  ];

  var isFirstExpended;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 4, title: const Text("Loan Summary")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: foundDataNew!.length,
              itemBuilder: (context, index) {
                //final loan = foundDataNew![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    key: Key(index.toString()),
                    shape: Border.all(color: Colors.transparent),
                    initiallyExpanded: _expandedTiles[index],
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        _expandedTiles[index] = expanded;
                      });
                    },
                    title: Text(
                      foundDataNew![index].loanType.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: getColor[index]['color'],
                      ),
                    ),
                    children: [
                      buildSummaryRow(
                        label: "Loan Applied For",
                        value:
                            "â‚¹ ${foundDataNew![index].loanAppliedFor.toString()}",
                        color: Colors.blue,
                        isAmount: true,
                      ),
                      buildSummaryRow(
                        label: "Loan Paid Up",
                        value:
                            "â‚¹ ${foundDataNew![index].loanPaidUp.toString()}",
                        color: Colors.green,
                        isAmount: true,
                      ),
                      buildSummaryRow(
                        label: "Pending Installments",
                        value:
                            foundDataNew![index].pendingInstallments.toString(),
                        color: Colors.orange,
                        isAmount: false,
                      ),
                      buildSummaryRow(
                        label: "Pending Amount",
                        value:
                            "â‚¹ ${foundDataNew![index].totalPendingAmt.toString()}",
                        color: Colors.red,
                        isAmount: true,
                      ),
                      buildSummaryRow(
                        label: "View Loan Ledger",
                        valueWidget: Icon(
                          Icons.remove_red_eye,
                          color: Colors.lightBlue,
                          size: 24,
                        ),
                        onTap: () {
                          loanId = foundDataNew![index].loanReqId.toString();
                          Future<LoanLedgerModal> getEmployeeList11 =
                              getLoanLedger(sessionId!);
                          final loading = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text(" Login ... Please wait"),
                            ],
                          );

                          getEmployeeList11.then((value) {
                            setState(() {
                              foundLoanLedgerData = loanLedgerNew;
                              loanLedgerLabel = value;
                              loanLedgerLabeled = loanLedgerLabel;
                              if (foundLoanLedgerData!.isNotEmpty) {
                                showTransactionBottomSheet(context);
                              } else {
                                Fluttertoast.showToast(
                                  msg: "There is no ledger available !!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            });
                          });
                          // Handle navigation to loan ledger
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            loanId = foundDataNew![index].loanReqId.toString();
                            loanType = foundDataNew![index].loanType.toString();
                            Future<LoanWiseSkipModal> getEmployeeList11 =
                                getLoanSkipList(sessionId!);
                            final loading = Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Text(" Login ... Please wait"),
                              ],
                            );

                            getEmployeeList11.then((value) {
                              setState(() {
                                foundLoanWiseSkipData = loanWiseSkipNew;
                                loanWiseSkipLabel = value;
                                loanWiseSkipLabeled = loanWiseSkipLabel;
                                if (foundLoanWiseSkipData!.isNotEmpty) {
                                  _showFilterBottomSheet(context);
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "There is no instalment skip available !!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              });
                            });
                          },
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text("Skip Request"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 0),
              ),
            );
            //Navigator.pop(context);
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 1),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetAttendanceDet(showAppBar: true),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAllReportsPage(showAppBar: true),
              ),
            );

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if (index == 4) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);

            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.app_badge_fill),
            label: 'My Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'My Reports',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget buildSummaryRow({
    required String label,
    String? value,
    Widget? valueWidget,
    Color color = Colors.black,
    bool isAmount = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            valueWidget ??
                Text(
                  value ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
