import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanApprovalPage extends StatefulWidget {
  @override
  _LoanApprovalPageState createState() => _LoanApprovalPageState();
}

class _LoanApprovalPageState extends State<LoanApprovalPage> {
  DateTime? selectedDate;
  final TextEditingController installmentController = TextEditingController();
  TextEditingController totalLoanController = TextEditingController(text: '120000');
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget _buildRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          trailing ?? Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Loan Approval', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Loan Requested", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                       // SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child:
                          Text("120000", style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    Divider(),
                    _buildRow("Loan Type", "Personal Loan"),
                    _buildRow("Interest Rate", "0"),
                    _buildRow("Principle Balance", "120000"),
                    _buildRow("Interest Balance", "0"),
                    _buildRow("Installments Requested", "5"),
                    _buildRow(
                      "Deduction Date",
                      selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : "Date",
                      trailing: GestureDetector(
                        onTap: () => _pickDate(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, size: 18, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : "Date",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildRow(
                      "Installments Approved L1",
                      "",
                      trailing: Container(
                        width: 80,
                        child: TextField(
                          controller: installmentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "0",
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Disapprove"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Approve"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}