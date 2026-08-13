import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/services/employee_profile_api.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:er_flutter_project/utils/profile_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProfilePageNew extends StatefulWidget {
  const ProfilePageNew({Key? key}) : super(key: key);

  @override
  State<ProfilePageNew> createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  final SessionManager _session = SessionManager();
  final EmployeeProfileApi _profileApi = EmployeeProfileApi();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankIfscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String _name = '';
  String _designation = '';
  String _emailId = '';
  String _mobileNo = '';
  String _department = '';
  String _branch = '';
  String _profileImage = '';
  bool _loading = true;
  bool _submitting = false;
  bool _editing = false;
  bool _profileImageFailed = false;
  String? _error;
  EmployeeProfileResult? _profile;
  int _currentIndex = 3;

  bool get _hasRealProfileImage {
    final uri = Uri.tryParse(_profileImage.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  bool get _canPreviewImage =>
      _hasRealProfileImage && !_profileImageFailed;

  bool get _hasPendingRequest => _profile?.pendingRequest != null;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _accountHolderController.dispose();
    _bankAccountController.dispose();
    _bankIfscController.dispose();
    _bankNameController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final sessionValues = await Future.wait<Object?>([
        _session.getempName(),
        _session.getDesignation(),
        _session.getEmailId(),
        _session.getMobileNo(),
        _session.getDept(),
        _session.getBranch(),
        _session.getProfileImage(),
      ]);
      final profile = await _profileApi.getDetails();
      if (!mounted) return;
      setState(() {
        _name = _text(sessionValues[0]);
        _designation = _text(sessionValues[1]);
        _emailId = _text(sessionValues[2]);
        _mobileNo = _text(sessionValues[3]);
        _department = _text(sessionValues[4]);
        _branch = _text(sessionValues[5]);
        _profileImage = _text(sessionValues[6]);
        _profileImageFailed = false;
        _profile = profile;
        _setControllers(profile.details);
        _editing = profile.pendingRequest == null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  void _setControllers(EmployeeProfileDetails details) {
    _dateOfBirthController.text = details.dateOfBirth;
    _accountHolderController.text = details.accountHolderName;
    _bankAccountController.text = details.bankAccountNo;
    _bankIfscController.text = details.bankIfsc;
    _bankNameController.text = details.bankName;
    _remarksController.clear();
  }

  void _beginEditing() {
    final profile = _profile;
    if (profile == null) return;
    final pending = profile.pendingRequest;
    setState(() {
      _setControllers(pending?.proposed ?? profile.details);
      _remarksController.text = pending?.employeeRemarks ?? '';
      _editing = true;
    });
  }

  void _cancelEditing() {
    final profile = _profile;
    if (profile == null) return;
    setState(() {
      _setControllers(profile.details);
      _editing = false;
    });
  }

  Future<void> _selectDateOfBirth() async {
    if (!_editing) return;
    final now = DateTime.now();
    final parsed = DateTime.tryParse(_dateOfBirthController.text.trim());
    final selected = await showDatePicker(
      context: context,
      initialDate: parsed ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (selected != null) {
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(selected);
    }
  }

  Future<void> _submitUpdate() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final current = _profile?.details;
    if (current == null) return;

    final update = EmployeeProfileUpdate(
      dateOfBirth: _dateOfBirthController.text.trim(),
      accountHolderName: _accountHolderController.text.trim(),
      bankAccountNo: _bankAccountController.text.trim(),
      bankIfsc: _bankIfscController.text.trim(),
      bankName: _bankNameController.text.trim(),
      remarks: _remarksController.text.trim(),
    );
    if (!_hasChanges(current, update)) {
      _showMessage('No profile changes were provided.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final message = await _profileApi.submitUpdate(update);
      if (!mounted) return;
      _showMessage(message);
      await _loadProfile();
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool _hasChanges(
    EmployeeProfileDetails current,
    EmployeeProfileUpdate update,
  ) {
    return current.dateOfBirth != update.dateOfBirth ||
        current.accountHolderName != update.accountHolderName ||
        current.bankAccountNo != update.bankAccountNo ||
        current.bankIfsc.toUpperCase() != update.bankIfsc.toUpperCase() ||
        current.bankName != update.bankName;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showProfileImage() {
    if (!_canPreviewImage) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(dialogContext).size.height * 0.72,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Image(
                  image: profileImageProvider(_profileImage),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.account_circle, size: 140),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text('My Profile'),
        actions: [
          if (!_loading && _profile != null)
            IconButton(
              tooltip: _editing ? 'Cancel editing' : 'Edit profile',
              icon: Icon(_editing ? Icons.close : Icons.edit_outlined),
              onPressed: _submitting
                  ? null
                  : (_editing ? _cancelEditing : _beginEditing),
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final details = _profile!.details;
    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: Form(
        key: _formKey,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            _buildHeader(),
            if (_hasPendingRequest) ...[
              const SizedBox(height: 20),
              _buildPendingBanner(_profile!.pendingRequest!),
            ],
            const SizedBox(height: 24),
            _sectionTitle('Employment Details', subdued: true),
            _infoRow(Icons.email_outlined, 'Email ID', _emailId),
            _infoRow(Icons.phone_outlined, 'Mobile No.', _mobileNo),
            _infoRow(Icons.work_outline, 'Department', _department),
            _infoRow(Icons.apartment_outlined, 'Branch', _branch),
            _infoRow(
              Icons.event_available_outlined,
              'Date Of Joining',
              _displayDate(details.dateOfJoining),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Statutory Details', subdued: true),
            _infoRow(
              Icons.badge_outlined,
              'Aadhar Card Number',
              details.aadharCardNumber,
            ),
            _infoRow(Icons.receipt_long_outlined, 'PF No.', details.pfNumber),
            _infoRow(Icons.numbers_outlined, 'UAN Number', details.uanNumber),
            _infoRow(
              Icons.health_and_safety_outlined,
              'ESIC Number',
              details.esicNumber,
            ),
            const SizedBox(height: 16),
            _sectionTitle('Editable Details'),
            _editableField(
              controller: _dateOfBirthController,
              label: 'Date Of Birth',
              icon: Icons.cake_outlined,
              readOnly: true,
              onTap: _selectDateOfBirth,
              suffixIcon: _editing ? Icons.calendar_month_outlined : null,
            ),
            _editableField(
              controller: _accountHolderController,
              label: 'Account Holder Name',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
            ),
            _editableField(
              controller: _bankAccountController,
              label: 'Bank A/C No.',
              icon: Icons.account_balance_wallet_outlined,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              ],
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isNotEmpty &&
                    !RegExp(r'^[A-Za-z0-9]{6,34}$').hasMatch(text)) {
                  return 'Enter a valid bank account number';
                }
                return null;
              },
            ),
            _editableField(
              controller: _bankIfscController,
              label: 'IFSC Code',
              icon: Icons.pin_outlined,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                final text = (value ?? '').trim().toUpperCase();
                if (text.isNotEmpty &&
                    !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(text)) {
                  return 'Enter a valid IFSC code';
                }
                return null;
              },
            ),
            _editableField(
              controller: _bankNameController,
              label: 'Bank Name',
              icon: Icons.account_balance_outlined,
              textCapitalization: TextCapitalization.words,
            ),
            if (_editing) ...[
              _editableField(
                controller: _remarksController,
                label: 'Remarks (optional)',
                icon: Icons.notes_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submitUpdate,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(_submitting
                      ? 'Saving...'
                      : _hasPendingRequest
                          ? 'Save Updated Request'
                          : 'Save & Raise Request'),
                ),
              ),
            ] else ...[
              const SizedBox(height: 4),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _beginEditing,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(_hasPendingRequest
                      ? 'Edit Pending Request'
                      : 'Edit Profile'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final avatar = Container(
      width: 132,
      height: 132,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
        border: Border.all(color: Mythemes.lightBluishColor, width: 3),
      ),
      child: ClipOval(child: _buildAvatarImage()),
    );
    return Column(
      children: [
        _canPreviewImage
            ? InkWell(
                customBorder: const CircleBorder(),
                onTap: _showProfileImage,
                child: avatar,
              )
            : avatar,
        const SizedBox(height: 10),
        Text(
          _value(_name),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (_designation.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            _designation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (!_hasRealProfileImage || _profileImageFailed) {
      return Image.asset(defaultProfileAsset, fit: BoxFit.cover);
    }
    return Image.network(
      _profileImage,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_profileImageFailed) {
            setState(() => _profileImageFailed = true);
          }
        });
        return Image.asset(defaultProfileAsset, fit: BoxFit.cover);
      },
    );
  }

  Widget _buildPendingBanner(EmployeeProfilePendingRequest request) {
    final approver = request.approverName.isEmpty
        ? ''
        : ' Approver: ${request.approverName}.';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.amber.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule_outlined, color: Colors.amber.shade900),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Profile update request #${request.requestId} is '
                  '${request.status.toLowerCase()}.$approver',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: () => _showPendingRequest(request),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('View Request'),
              ),
              TextButton.icon(
                onPressed: _beginEditing,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit / Override'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPendingRequest(EmployeeProfilePendingRequest request) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Request #${request.requestId}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _requestValue(
                'Date Of Birth',
                request.current.dateOfBirth,
                request.proposed.dateOfBirth,
              ),
              _requestValue(
                'Account Holder Name',
                request.current.accountHolderName,
                request.proposed.accountHolderName,
              ),
              _requestValue(
                'Bank A/C No.',
                request.current.bankAccountNo,
                request.proposed.bankAccountNo,
              ),
              _requestValue(
                'IFSC Code',
                request.current.bankIfsc,
                request.proposed.bankIfsc,
              ),
              _requestValue(
                'Bank Name',
                request.current.bankName,
                request.proposed.bankName,
              ),
              if (request.employeeRemarks.isNotEmpty)
                _requestValue('Remarks', '', request.employeeRemarks),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _beginEditing();
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit / Override'),
          ),
        ],
      ),
    );
  }

  Widget _requestValue(String label, String oldValue, String newValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (oldValue.isNotEmpty)
            Text(
              'Current: ${_value(oldValue)}',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          Text(
            'Requested: ${_value(newValue)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {bool subdued = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: subdued ? Colors.grey.shade500 : Mythemes.lightBluishColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey.shade400),
      title: Text(label, style: TextStyle(color: Colors.grey.shade500)),
      subtitle: Text(
        _value(value),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _editableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final enabled = _editing;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: true,
        readOnly: !enabled || readOnly,
        onTap: () {
          if (!enabled) {
            _beginEditing();
            return;
          }
          onTap?.call();
        },
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Mythemes.lightBluishColor),
          suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Mythemes.lightBluishColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: enabled
                  ? Mythemes.lightBluishColor
                  : Mythemes.lightBluishColor.withOpacity(0.55),
              width: enabled ? 1.4 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Mythemes.lightBluishColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Mythemes.lightBluishColor.withOpacity(
            enabled ? 0.08 : 0.035,
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      iconSize: 25,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PunchInOUtActivity()),
          );
        } else if (index == 1) {
          Navigator.pushNamed(context, MyRoutings.timeAttRoute);
        } else if (index == 2) {
          Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
        }
        if (mounted) setState(() => _currentIndex = index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.pending_actions),
          label: 'Attendance',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_customize),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }

  String _displayDate(String value) {
    final date = DateTime.tryParse(value);
    return date == null ? value : DateFormat('dd-MM-yyyy').format(date);
  }

  String _value(String value) => value.trim().isEmpty ? '-' : value.trim();
  String _text(Object? value) => value?.toString().trim() ?? '';
}
