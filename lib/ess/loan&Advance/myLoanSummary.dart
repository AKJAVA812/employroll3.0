import 'package:flutter/material.dart';

import '../../themes/empThemes.dart';

class LoanSummaryPage extends StatefulWidget {
  @override
  State<LoanSummaryPage> createState() => _LoanSummaryPageState();
}

class _LoanSummaryPageState extends State<LoanSummaryPage> {
  bool _isFirstBuild = true;
  bool _isBottomSheetOpen = false;

  final List<Map<String, dynamic>> loanSummaries = [
    {
      "loanType": "Home Loan",
      "color": Mythemes.deepPurple,
      "appliedAmount": "500,000",
      "paidAmount": "200,000",
      "pendingInstallments": 6,
      "pendingAmount": "300,000"
    },
    {
      "loanType": "Vehicle Loan",
      "color": Mythemes.successColor,
      "appliedAmount": "300,000",
      "paidAmount": "150,000",
      "pendingInstallments": 3,
      "pendingAmount": "150,000"
    }
  ];

    List<Map<String, String>> breakupList = [
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "June-25",
      "amount": "93,000.00",
      "date": "Jul 15, 2025",
      "status": "Approved"
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending"
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending"
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending"
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending"
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending"
    },
  ];

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(child: Text("$label:", style: TextStyle(color: Colors.black54))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // <--- Make sure this is true
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
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
                        'Loan 1',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),

                      /// 🛠 Make this scrollable within the scroll view
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // No nested scroll
                        itemCount: breakupList.length,
                        itemBuilder: (context, index) {
                          final item = breakupList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showSkipInstallmentPopup(context);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item['employee']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: item['status'] == 'Approved' ? Colors.green.shade100 : Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            item['status']!,
                                            style: TextStyle(
                                              color: item['status'] == 'Approved' ? Colors.green.shade800 : Colors.orange.shade800,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    infoRow(Icons.calendar_today, "Installment Months", item['months']!),
                                    infoRow(Icons.payments, "Installment Amount", "₹ ${item['amount']}"),
                                    infoRow(Icons.date_range, "Disbursement Date", item['date']!),
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
    ).whenComplete(() {
      _isBottomSheetOpen = false; // ✅ Reset when sheet is dismissed
    });
  }

  void showConfirmationPopup(BuildContext context) {
    showDialog(
      context: context, // ✅ This is still valid
      barrierDismissible: false,
      builder: (BuildContext confirmCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                child: const Text("OK"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showSkipInstallmentPopup(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    DateTime? selectedRepaymentDate;

    showDialog(
      context: context,
      builder: (BuildContext outerCtx) {
        return Builder( // 👈 This Builder captures a valid dialog context
          builder: (BuildContext dialogCtx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        controller: TextEditingController(text: "Home Loan"),
                        value: "Home Loan",
                      ),
                      const SizedBox(height: 12),
                      customReadOnlyInput(
                        icon: Icons.calendar_today,
                        label: "Skip Month",
                        value: "June 2025",
                        controller: TextEditingController(text: "June 2025"),
                      ),
                      const SizedBox(height: 12),
                      customDatePicker(
                        icon: Icons.event,
                        label: "Repayment Date",
                        selectedDate: selectedRepaymentDate,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: dialogCtx, // 👈 safe context
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            selectedRepaymentDate = picked;
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
                            Navigator.of(dialogCtx).pop(); // ✅ safely close popup
                            Future.delayed(const Duration(milliseconds: 100), () {
                              showConfirmationPopup(dialogCtx); // ✅ reuses valid context
                            });
                          },
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text("Request"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
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

  Widget customReadOnlyInput({required IconData icon, required TextEditingController controller, required String label, required String value}) {
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

  Widget customTextField({required IconData icon, required String label, required TextEditingController controller}) {
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

  Widget customDatePicker({
    required IconData icon,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        hintText: selectedDate != null
            ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
            : "Select date",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //filled: true,
        //fillColor: Colors.grey.shade100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text("Loan Summary"),
      ),
      body: Column(
        children: [
          Expanded(child:
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loanSummaries.length,
            itemBuilder: (context, index) {
              final loan = loanSummaries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  title: Text(
                    loan["loanType"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  loan["color"],
                    ),
                  ),
                  children: [
                    buildSummaryRow(
                      label: "Loan Applied For",
                      value: "₹ ${loan["appliedAmount"]}",
                      color: Colors.blue,
                      isAmount: true,
                    ),
                    buildSummaryRow(
                      label: "Loan Paid Up",
                      value: "₹ ${loan["paidAmount"]}",
                      color: Colors.green,
                      isAmount: true,
                    ),
                    buildSummaryRow(
                      label: "Pending Installments",
                      value: "${loan["pendingInstallments"]}",
                      color: Colors.orange,
                      isAmount: false,
                    ),
                    buildSummaryRow(
                      label: "Pending Amount",
                      value: "₹ ${loan["pendingAmount"]}",
                      color: Colors.red,
                      isAmount: true,
                    ),
                    buildSummaryRow(
                      label: "View Loan Ledger",
                      valueWidget: Icon(Icons.remove_red_eye, color: Colors.lightBlue, size: 24),
                      onTap: () {
                        // Handle navigation to loan ledger
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          _showFilterBottomSheet();
                        },
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text("Skip Request"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
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