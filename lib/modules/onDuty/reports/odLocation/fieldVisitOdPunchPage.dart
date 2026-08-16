import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../commanScreen/routes.dart';
import '../../../../services/od_punch_api.dart';
import '../../../../themes/empThemes.dart';

class FieldVisitOdPunchPage extends StatefulWidget {
  const FieldVisitOdPunchPage({
    super.key,
    required this.selfie,
    required this.punchAction,
    required this.initialAddress,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  final File selfie;
  final String punchAction;
  final String initialAddress;
  final double initialLatitude;
  final double initialLongitude;

  @override
  State<FieldVisitOdPunchPage> createState() => _FieldVisitOdPunchPageState();
}

class _FieldVisitOdPunchPageState extends State<FieldVisitOdPunchPage> {
  final _formKey = GlobalKey<FormState>();
  final _remarks = TextEditingController();
  final _clientName = TextEditingController();
  final _clientContact = TextEditingController();
  final _picker = ImagePicker();
  final String _clientEventId = const Uuid().v4();

  File? _supportingDocument;
  late String _address;
  late double _latitude;
  late double _longitude;
  bool _refreshingLocation = false;
  bool _submitting = false;

  bool get _isOut => widget.punchAction.trim().toUpperCase() == 'OUT';

  @override
  void initState() {
    super.initState();
    _address = widget.initialAddress;
    _latitude = widget.initialLatitude;
    _longitude = widget.initialLongitude;
  }

  @override
  void dispose() {
    _remarks.dispose();
    _clientName.dispose();
    _clientContact.dispose();
    super.dispose();
  }

  Future<void> _refreshLocation() async {
    if (_refreshingLocation) return;
    setState(() => _refreshingLocation = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final place = placemarks.isEmpty ? null : placemarks.first;
      final address = place == null
          ? '${position.latitude}, ${position.longitude}'
          : [
              place.street,
              place.subLocality,
              place.locality,
              place.administrativeArea,
              place.country,
              place.postalCode,
            ]
              .whereType<String>()
              .where((value) => value.trim().isNotEmpty)
              .join(', ');
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _address = address;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to refresh location: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _refreshingLocation = false);
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      if (image != null && mounted) {
        setState(() => _supportingDocument = File(image.path));
      }
    } on PlatformException catch (error) {
      _showMessage(error.message ?? 'Camera is unavailable.');
    }
  }

  Future<void> _pickFromStorage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
    );
    final path = result?.files.single.path;
    if (path != null && mounted) {
      setState(() => _supportingDocument = File(path));
    }
  }

  Future<void> _submit() async {
    if (_submitting || !(_formKey.currentState?.validate() ?? false)) return;
    if (_supportingDocument == null) {
      _showMessage('Please attach a supporting document.');
      return;
    }
    if (_latitude == 0 && _longitude == 0) {
      _showMessage('Please refresh your current location.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final response = await OdPunchApi().punchFieldVisit(
        selfie: widget.selfie,
        supportingDocument: _supportingDocument!,
        punchAction: widget.punchAction,
        latitude: _latitude,
        longitude: _longitude,
        address: _address,
        remark: _remarks.text.trim(),
        clientName: _clientName.text,
        clientContact: _clientContact.text,
        clientEventId: _clientEventId,
      );
      final body = _decode(response.body);
      final success = response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['result']?.toString().toLowerCase() == 'success';
      if (!mounted) return;
      if (!success) {
        await _showSubmissionRejectedDialog(_failureMessage(body));
        return;
      }
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text('OD ${_isOut ? 'Check Out' : 'Check In'} submitted'),
          content: Text(
            body['reason']?.toString() ??
                'Your OD request has been submitted for approval.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MyRoutings.odLocationViewRoute,
          (route) => false,
        );
      }
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xfff6f7fb),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xff101828),
          elevation: 0.5,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OD ${_isOut ? 'Check Out' : 'Check In'}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Text(
                'Out-of-Duty Attendance',
                style: TextStyle(fontSize: 10, color: Color(0xff667085)),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffecfdf3),
                    border: Border.all(color: const Color(0xffabefc6)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _isOut ? 'OUT' : 'IN',
                    style: const TextStyle(
                      color: Color(0xff067647),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
            children: [
              _SelfieSummary(
                selfie: widget.selfie,
                address: _address,
              ),
              const SizedBox(height: 16),
              _SectionTitle(
                title: 'Location & Time',
                trailing: TextButton.icon(
                  onPressed: _refreshingLocation ? null : _refreshLocation,
                  icon: _refreshingLocation
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded, size: 15),
                  label: const Text('Refresh'),
                ),
              ),
              _InfoBox(
                icon: Icons.location_on_rounded,
                label: 'Current Location',
                value: _address.isEmpty ? 'Location unavailable' : _address,
              ),
              const SizedBox(height: 8),
              _InfoBox(
                icon: Icons.schedule_rounded,
                label: 'Punch Time',
                value: TimeOfDay.now().format(context),
              ),
              const SizedBox(height: 16),
              const _SectionTitle(title: 'Work Done'),
              _FormField(
                controller: _remarks,
                icon: Icons.playlist_add_check_rounded,
                hint: 'Remarks *',
                maxLines: 3,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Remarks are required.';
                  if (text.length < 7) return 'Enter at least 7 characters.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _SectionTitle(title: 'Client Details'),
              _FormField(
                controller: _clientName,
                icon: Icons.person_outline_rounded,
                hint: 'Client Name',
              ),
              const SizedBox(height: 8),
              _FormField(
                controller: _clientContact,
                icon: Icons.phone_outlined,
                hint: 'Client Contact No.',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isNotEmpty && text.replaceAll('+', '').length < 7) {
                    return 'Enter a valid contact number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _SectionTitle(title: 'Document Attachment *'),
              _DocumentPicker(
                file: _supportingDocument,
                onCamera: _pickFromCamera,
                onStorage: _pickFromStorage,
                onRemove: () => setState(() => _supportingDocument = null),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: Mythemes.lightBluishColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login_rounded),
                  label: Text(
                    _submitting
                        ? 'Submitting...'
                        : 'Submit OD ${_isOut ? 'Check Out' : 'Check In'}',
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 62,
          selectedIndex: 2,
          onDestinationSelected: (index) {
            final route = switch (index) {
              0 => MyRoutings.homePageRoute,
              1 => MyRoutings.punchInRoute,
              2 => MyRoutings.onDutyTypes,
              3 => MyRoutings.essDashboardNavigateRoute,
              _ => MyRoutings.profilePageHeadRoute,
            };
            if (index != 2) Navigator.pushReplacementNamed(context, route);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.manage_accounts_outlined), label: 'Workflow'),
            NavigationDestination(icon: Icon(Icons.outbond_outlined), label: 'OD'),
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
        ),
      );

  Map<String, dynamic> _decode(String body) {
    try {
      final value = jsonDecode(body);
      return value is Map ? Map<String, dynamic>.from(value) : const {};
    } catch (_) {
      return const {};
    }
  }

  String _failureMessage(Map<String, dynamic> body) {
    final error = body['error'];
    final rawMessage =
        body['reason'] ??
        body['message'] ??
        (error is Map ? error['message'] ?? error['code'] : null);
    final message = rawMessage?.toString().trim() ?? '';
    if (message.isEmpty) {
      return 'OD requisition could not be submitted. Please contact your administrator.';
    }
    return '${message[0].toUpperCase()}${message.substring(1)}';
  }

  Future<void> _showSubmissionRejectedDialog(String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('OD requisition not submitted'),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SelfieSummary extends StatelessWidget {
  const _SelfieSummary({required this.selfie, required this.address});
  final File selfie;
  final String address;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          CircleAvatar(radius: 32, backgroundImage: FileImage(selfie)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryChip(icon: Icons.schedule_rounded, text: TimeOfDay.now().format(context)),
                const SizedBox(height: 5),
                const _SummaryChip(icon: Icons.directions_car_outlined, text: 'Automobile Field Visit'),
                const SizedBox(height: 5),
                _SummaryChip(icon: Icons.my_location_rounded, text: address),
              ],
            ),
          ),
        ],
      );
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxWidth: 230),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xfff2f4f7),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Mythemes.lightBluishColor),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, color: Color(0xff667085)),
              ),
            ),
          ],
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});
  final String title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(width: 3, height: 16, color: Mythemes.lightBluishColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffe4e7ec)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _IconBox(icon: icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9, color: Color(0xff98a2b3))),
                  Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffe4e7ec)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: maxLines > 1 ? 13 : 0),
              child: _IconBox(icon: icon),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller,
                maxLines: maxLines,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(fontSize: 11),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      );
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffeff4ff),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Mythemes.lightBluishColor),
      );
}

class _DocumentPicker extends StatelessWidget {
  const _DocumentPicker({
    required this.file,
    required this.onCamera,
    required this.onStorage,
    required this.onRemove,
  });
  final File? file;
  final VoidCallback onCamera;
  final VoidCallback onStorage;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: file == null ? const Color(0xfff04438) : const Color(0xff12b76a),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              file == null ? Icons.upload_file_rounded : Icons.check_circle_rounded,
              color: file == null ? const Color(0xffd92d20) : const Color(0xff039855),
            ),
            const SizedBox(height: 7),
            Text(
              file == null ? 'Attach a Supporting Document' : file!.path.split(Platform.pathSeparator).last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const Text('Required - JPG, PNG or PDF', style: TextStyle(fontSize: 9, color: Color(0xffd92d20))),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCamera,
                    icon: const Icon(Icons.photo_camera_rounded, size: 17),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onStorage,
                    icon: const Icon(Icons.photo_library_outlined, size: 17),
                    label: const Text('Phone Storage'),
                  ),
                ),
              ],
            ),
            if (file != null)
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 16),
                label: const Text('Remove'),
              ),
          ],
        ),
      );
}
