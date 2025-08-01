import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../themes/empThemes.dart';

class LoanApprovalPage extends StatefulWidget {
  @override
  _LoanApprovalPageState createState() => _LoanApprovalPageState();
}

class _LoanApprovalPageState extends State<LoanApprovalPage> {

  final TextEditingController _deductionDateController = TextEditingController();
  final TextEditingController _totalLoanRequestedController = TextEditingController();
  final TextEditingController _installmentsApprovedController = TextEditingController();
  List<Map<String, String>> monthlyStatus = [];
  final double totalLoan = 340000.0; // Total loan amount from previous context
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deductionDateController.text = DateFormat('MMMM-yyyy').format(picked);
        _updateMonthlyStatus();
      });
    }
  }

  void _updateMonthlyStatus() {
    monthlyStatus.clear();
    final int installments = int.tryParse(_installmentsApprovedController.text) ?? 0;
    if (installments > 0 && _deductionDateController.text.isNotEmpty) {
      DateTime startDate = DateFormat('MMMM-yyyy').parse(_deductionDateController.text);
      double monthlyAmount = totalLoan / installments;

      for (int i = 0; i < installments; i++) {
        String monthYear = DateFormat('MMMM-yyyy').format(startDate.add(Duration(days: 30 * i)));
        monthlyStatus.add({
          'month': monthYear,
          'amount': monthlyAmount.toStringAsFixed(2),
        });
      }
    }
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _deductionDateController.text = ''; // Default empty
    _installmentsApprovedController.text = '0'; // Default value from image
    _totalLoanRequestedController.text = "20000";
    _updateMonthlyStatus();
  }

  int valueChange = 0;
  var statusChange = "LEVEL_ONE_PENDING";
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedToggleSwitch<int>.size(
                    height: 30,
                    current: min(valueChange, 3),
                    style: ToggleStyle(
                      backgroundColor: Mythemes.greyishade,
                      indicatorColor: Mythemes.lightBluishColor,
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      indicatorBorderRadius: BorderRadius.zero,
                    ),
                    values: const [0, 1, 2],
                    iconOpacity: 1.0,
                    selectedIconScale: 1.0,
                    indicatorSize: const Size.fromWidth(65),
                    iconAnimationType: AnimationType.onHover,
                    styleAnimationType: AnimationType.onHover,
                    spacing: 4.0,
                    customSeparatorBuilder: (context, local, global) {
                      final opacity =
                      ((global.position - local.position).abs() - 0.5).clamp(0.0, 1.0);
                      return VerticalDivider(
                          indent: 10.0,
                          endIndent: 10.0,
                          color: Colors.white38.withOpacity(opacity));
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['L1', 'L2', 'L3'][local.index];
                      return Center(
                          child: Text(text,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.lerp(Colors.black, Colors.white,
                                      local.animationValue))));
                    },
                    borderWidth: 0.0,
                    onChanged: (i) async {
                      setState(() {
                        valueChange = i;
                      });

                      // Set the appropriate status
                      switch (valueChange) {
                        case 0:
                          statusChange = "LEVEL_ONE_PENDING";
                          break;
                        case 1:
                          statusChange = "LEVEL_TWO_PENDING";
                          break;
                        case 2:
                          statusChange = "LEVEL_THREE_PENDING";
                          break;
                      }
                    },
                  )
                ],
              ).pLTRB(6, 6, 6, 6),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableRow('Total Loan Requested', _totalLoanRequestedController, false),
                      _buildLoanDetailRow('Loan Type', 'Home Loan', null),
                      _buildLoanDetailRow('Interest Rate', '0', null),
                      _buildLoanDetailRow('Principle Balance', '340000', null),
                      _buildLoanDetailRow('Interest Balance', '', null),
                      _buildLoanDetailRow('Installments Requested', '6', null),
                      _buildEditableRow('Deduction Date', _deductionDateController, true),
                      _buildEditableRow('Instalments Approved L1', _installmentsApprovedController, false),
                      SizedBox(height: 20),
                      Text(
                        'Monthly Status',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      // Use ListView to handle scrolling within the card if content overflows
                      Container(
                        constraints: BoxConstraints(maxHeight: 200), // Adjust max height as needed
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // Let SingleChildScrollView handle scrolling
                          itemCount: monthlyStatus.length,
                          itemBuilder: (context, index) {
                            return _buildStatusRow(monthlyStatus[index]['month']!, monthlyStatus[index]['amount']!);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // Fixed buttons at the bottom
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Disapprove',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Approve',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
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
      ),
    );
  }

  Widget _buildStatusRow(String month, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            '₹ $amount', // Assuming Naira symbol, adjust as needed
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller, bool isDate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          isDate?
          Expanded(
            child: TextField(
              onTap: () {
                _selectDate(context);
              },
              controller: controller,
              readOnly: isDate,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: isDate
                    ? IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                )
                    : null,
              ),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              keyboardType: isDate ? null : TextInputType.number,
            ),
          ) :
          Expanded(
            child: TextField(
              onTapOutside: (event) {
                _updateMonthlyStatus();
              },
              controller: controller,
              readOnly: isDate,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              keyboardType: isDate ? null : TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}