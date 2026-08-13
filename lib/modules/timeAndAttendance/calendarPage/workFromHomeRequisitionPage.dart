import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../services/mobile_api_foundation.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import 'requisitionTypeTabs.dart';

class WorkFromHomeRequisitionPage extends StatefulWidget {
  const WorkFromHomeRequisitionPage({super.key});

  @override
  State<WorkFromHomeRequisitionPage> createState() =>
      _WorkFromHomeRequisitionPageState();
}

class _WorkFromHomeRequisitionPageState
    extends State<WorkFromHomeRequisitionPage> {
  final SessionManager _sessionManager = SessionManager();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String _employeeName = '';
  String _branchName = '';
  String _departmentName = '';
  int _selectedTab = 3;
  bool _singleDay = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadEmployeeDetails();
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployeeDetails() async {
    final empName = await _sessionManager.getempName();
    final branch = await _sessionManager.getBranch();
    final dept = await _sessionManager.getDept();
    if (!mounted) return;
    setState(() {
      _employeeName = empName ?? '';
      _branchName = branch ?? '';
      _departmentName = dept ?? '';
    });
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (selectedDate == null) return;
    controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  void _handleTabChange(int index) {
    setState(() => _selectedTab = index);
    if (index == 0) {
      Navigator.pushNamed(context, MyRoutings.attendanceReqCalendar);
    } else if (index == 1) {
      Navigator.pushNamed(context, MyRoutings.leaveRequisitionRoute);
    } else if (index == 2) {
      Navigator.pushNamed(context, MyRoutings.odLocationViewRoute);
    }
  }

  Future<void> _submitWorkFromHome() async {
    if (_isSubmitting) return;

    final fromDateText = _fromDateController.text.trim();
    final toDateText =
        _singleDay ? fromDateText : _toDateController.text.trim();
    final reason = _reasonController.text.trim();
    final fromDate = DateTime.tryParse(fromDateText);
    final toDate = DateTime.tryParse(toDateText);

    if (fromDate == null) {
      await _showResultDialog('Validation', 'Please select From Date.');
      return;
    }
    if (toDate == null) {
      await _showResultDialog('Validation', 'Please select To Date.');
      return;
    }
    if (toDate.isBefore(fromDate)) {
      await _showResultDialog(
        'Validation',
        'To Date cannot be before From Date.',
      );
      return;
    }
    if (reason.isEmpty) {
      await _showResultDialog('Validation', 'Please enter WFH reason.');
      return;
    }

    setState(() => _isSubmitting = true);
    final foundation = MobileApiFoundation.instance;
    final requestId = foundation.newRequestId();

    try {
      final response = await foundation.postJson(
        ApiDetails.mobileWorkFromHomeRequisition,
        body: <String, Object?>{
          'fromDate': fromDateText,
          'toDate': toDateText,
          'singleDay': _singleDay,
          'reason': reason,
        },
        headers: await foundation.authHeaders(
          requestId: requestId,
          json: true,
        ),
        tag: 'WFH_REQUISITION',
      );
      final body = foundation.decodeMap(response.body);
      final success = foundation.isSuccess(response);
      final message = _responseMessage(
        body,
        success
            ? 'WFH requisition submitted successfully.'
            : 'Unable to submit WFH requisition.',
      );
      final requestCode = body['requestCode']?.toString().trim();

      if (!mounted) return;
      if (success) {
        _fromDateController.clear();
        _toDateController.clear();
        _reasonController.clear();
      }
      await _showResultDialog(
        success ? 'Success' : 'Unable to Submit',
        success && requestCode != null && requestCode.isNotEmpty
            ? '$message\nRequest: $requestCode'
            : message,
      );
    } on MobileApiException catch (error) {
      if (!mounted) return;
      await _showResultDialog(
        'Unable to Submit',
        error.message ?? 'Unable to connect to the server.',
      );
    } catch (error) {
      if (!mounted) return;
      await _showResultDialog(
        'Unable to Submit',
        'Unexpected error while submitting WFH requisition.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _responseMessage(Map<String, dynamic> body, String fallback) {
    final direct = body['message'] ?? body['reason'] ?? body['detail'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString();
    }
    final error = body['error'];
    if (error is Map) {
      final nested =
          error['message'] ?? error['reason'] ?? error['detail'] ?? error['code'];
      if (nested != null && nested.toString().trim().isNotEmpty) {
        return nested.toString();
      }
    }
    return fallback;
  }

  Future<void> _showResultDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: 'WFH Requisition'.text.make(),
          elevation: 0.5,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              RequisitionTypeTabs(
                currentIndex: _selectedTab,
                onChanged: _handleTabChange,
              ),
              const SizedBox(height: 20),
              _readonlyField('Employee Name', _employeeName),
              Row(
                children: [
                  Expanded(child: _readonlyField('Branch Name', _branchName)),
                  Expanded(child: _readonlyField('Department', _departmentName)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        value: true,
                        groupValue: _singleDay,
                        onChanged: (value) {
                          setState(() {
                            _singleDay = value ?? true;
                            _toDateController.clear();
                          });
                        },
                        title: const Text('Single Day', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        value: false,
                        groupValue: _singleDay,
                        onChanged: (value) {
                          setState(() => _singleDay = value ?? false);
                        },
                        title: const Text('Multiple Day', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
              _dateField('From Date', _fromDateController),
              Visibility(
                visible: !_singleDay,
                child: _dateField('To Date', _toDateController),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8.0),
                    hintText: 'Add Reason',
                    labelText: 'Reason',
                    labelStyle: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitWorkFromHome,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _readonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 8.0),
          hintText: value,
          labelText: label,
          labelStyle: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(fontSize: 14),
        onTap: () => _pickDate(controller),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 8.0),
          hintText: label,
          labelText: label,
          labelStyle: const TextStyle(fontSize: 15),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
      ),
    );
  }
}

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
