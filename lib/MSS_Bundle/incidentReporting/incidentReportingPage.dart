import 'package:flutter/material.dart';

class IncidentFormPage extends StatefulWidget {
  const IncidentFormPage({super.key});

  @override
  State<IncidentFormPage> createState() => _IncidentFormPageState();
}

class _IncidentFormPageState extends State<IncidentFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? employee, department, incidentType;
  DateTime? incidentDate;
  TimeOfDay? incidentTime;

  final locationController = TextEditingController();
  final causesController = TextEditingController();
  final recommendationController = TextEditingController();
  final descriptionController = TextEditingController();

  final employees = ['Alice', 'Bob', 'Charlie'];
  final departmentsMap = {'Alice': 'HR', 'Bob': 'IT', 'Charlie': 'Finance'};
  final incidentTypes = [
    'Mistake',
    'Error',
    'Fetal Error',
    'Blunder',
    'Appreciation'
  ];

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => incidentDate = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => incidentTime = picked);
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Save logic here
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Incident Saved')));
      Navigator.pop(context);
    }
  }

  Widget _formField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    String? value,
    bool isDropdown = false,
    List<String>? dropdownItems,
    Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: isDropdown
          ? DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        items: dropdownItems!
            .map((item) =>
            DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (val) =>
        val == null ? 'Please select $label' : null,
      )
          : TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        validator: (val) =>
        val == null || val.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Incident'),
        //backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _formField(
                label: 'Select Employee',
                icon: Icons.person,
                value: employee,
                isDropdown: true,
                dropdownItems: employees,
                onChanged: (val) {
                  setState(() {
                    employee = val;
                    department = departmentsMap[val!]!;
                  });
                },
              ),
              _formField(
                label: 'Department',
                icon: Icons.business,
                controller: TextEditingController(text: department),
                readOnly: true,
              ),
              _formField(
                label: 'Incident Type',
                icon: Icons.report_problem,
                value: incidentType,
                isDropdown: true,
                dropdownItems: incidentTypes,
                onChanged: (val) => setState(() => incidentType = val),
              ),
              _formField(
                label: 'Location',
                icon: Icons.location_on,
                controller: locationController,
              ),
              _formField(
                label: 'Incident Date',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: _pickDate,
                controller: TextEditingController(
                  text: incidentDate == null
                      ? ''
                      : '${incidentDate!.day}/${incidentDate!.month}/${incidentDate!.year}',
                ),
              ),
              _formField(
                label: 'Time of Incident',
                icon: Icons.access_time,
                readOnly: true,
                onTap: _pickTime,
                controller: TextEditingController(
                  text: incidentTime?.format(context) ?? '',
                ),
              ),
              _formField(
                label: 'Incident Causes',
                icon: Icons.info,
                controller: causesController,
                maxLines: 3,
              ),
              _formField(
                label: 'Follow-up Recommendations',
                icon: Icons.tips_and_updates,
                controller: recommendationController,
                maxLines: 3,
              ),
              _formField(
                label: 'Incident Description',
                icon: Icons.description,
                controller: descriptionController,
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveForm,
                icon: Icon(Icons.save),
                label: Text("Save Report"),
                style: ElevatedButton.styleFrom(
                  //backgroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}