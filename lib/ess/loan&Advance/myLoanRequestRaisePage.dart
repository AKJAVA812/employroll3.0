import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanRequestPage extends StatefulWidget {
  @override
  _LoanRequestPageState createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  String loanTypeSelected = 'Loan';
  String? selectedLoanType;
  DateTime? startDate;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController installmentController = TextEditingController();

  List<String> loanTypes = ['Home Loan', 'Vehicle Loan', 'Education Loan'];

/*  List<Map<String, String>> breakupList = [
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
    }
  ];*/
  List<Map<String, String>> breakupList = [];
  bool isLoading = false;
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
  bool isFormExpanded = true;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Raise Loan Request'),
          //backgroundColor: Colors.green.shade700,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Loan / Advance Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'Loan',
                    groupValue: loanTypeSelected,
                    onChanged: (val) {
                      setState(() {
                        loanTypeSelected = val!;
                      });
                    },
                  ),
                  const Text('Loan'),
                  Radio<String>(
                    value: 'Advance',
                    groupValue: loanTypeSelected,
                    onChanged: (val) {
                      setState(() {
                        loanTypeSelected = val!;
                      });
                    },
                  ),
                  const Text('Advance'),
                ],
              ),
              const SizedBox(height: 16),

              // 🔽 Expand/Collapse Toggle Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Raise Loan Request",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(isFormExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        isFormExpanded = !isFormExpanded;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              Visibility(
                  visible: isFormExpanded,
                  child: Column(
                children: [
                  // Department & Branch Name (Row)
                  Row(
                    children: [
                      Expanded(
                        child: customReadOnlyInput(
                          icon: Icons.apartment,
                          label: "Department Name",
                          value: "Finance Department",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: customReadOnlyInput(
                          icon: Icons.location_city,
                          label: "Branch Name",
                          value: "Mumbai HQ",
                        ),
                      ),
                    ],
                  ),

                  // Employee Name
                  customReadOnlyInput(
                    icon: Icons.person,
                    label: "Employee Name",
                    value: "Bharat Rajora",
                  ),

                  // Loan Type Dropdown
                  customDropdown(
                    icon: Icons.menu,
                    label: "Loan Type",
                    value: selectedLoanType,
                    items: loanTypes,
                    onChanged: (val) {
                      setState(() => selectedLoanType = val);
                    },
                  ),

                  // Amount
                  customTextField(
                    icon: Icons.currency_rupee,
                    label: "Amount",
                    controller: amountController,
                    keyboardType: TextInputType.number,
                  ),

                  // Loan Start Date & Requested Installments (Row)
                  Row(
                    children: [
                      Expanded(
                        child: customDatePicker(
                          icon: Icons.date_range,
                          label: "Loan Start Date",
                          selectedDate: startDate,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => startDate = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: customTextField(
                          icon: Icons.format_list_numbered,
                          label: "Installments",
                          controller: installmentController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  // Remark
                  customTextField(
                    icon: Icons.comment,
                    label: "Remark",
                    controller: remarkController,
                  ),

                  const SizedBox(height: 15),
                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final totalAmount = double.tryParse(amountController.text) ?? 0.0;
                      final totalInstallments = int.tryParse(installmentController.text) ?? 1;
                      final employeeName = "Bharat Rajora (EMP-1024)";

                      if (startDate != null && totalAmount > 0 && totalInstallments > 0) {
                        setState(() {
                          isLoading = true;
                        });

                        // Simulate delay (e.g., API call)
                        await Future.delayed(Duration(seconds: 2));

                        final monthlyAmount = (totalAmount / totalInstallments).toStringAsFixed(2);

                        List<Map<String, String>> generatedList = [];

                        for (int i = 0; i < totalInstallments; i++) {
                          final installmentDate = DateTime(startDate!.year, startDate!.month + i, startDate!.day);
                          generatedList.add({
                            "employee": employeeName,
                            "months": DateFormat('MMMM yyyy').format(installmentDate),
                            "amount": monthlyAmount,
                            "date": DateFormat('MMM dd, yyyy').format(installmentDate),
                            "status": "Pending"
                          });
                        }

                        setState(() {
                          breakupList = generatedList;
                          isLoading = false;
                          isFormExpanded = false; // Collapse form
                        });
                      } else {
                        // Optionally show error if fields are missing
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all required fields')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.send),
                    label: const Text(
                      "Request",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )),

              //const SizedBox(height: 32),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (breakupList.isNotEmpty) ...[
                const Divider(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Loan Breakup Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: breakupList.length,
                  itemBuilder: (context, index) {
                    final item = breakupList[index];
                    return Card(
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
                    );
                  },
                ),
              ],



            ],
          ),
        ),
      ),
    );
  }

  Widget customReadOnlyInput({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          //filled: true,
          //fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget customDropdown({
    required IconData icon,
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.indigo),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          //filled: true,
          //fillColor: Colors.grey.shade100,
        ),
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget customTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          //filled: true,
          //fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget customDatePicker({
    required IconData icon,
    required String label,
    required DateTime? selectedDate,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.deepOrange),
              labelText: label,
              //filled: true,
              //fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            controller: TextEditingController(
              text: selectedDate != null ? DateFormat('MMM dd, yyyy').format(selectedDate) : '',
            ),
          ),
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