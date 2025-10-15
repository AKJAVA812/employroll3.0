import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../profiles/profilePageWithHead.dart';

class ResignationRequisitionPage extends StatefulWidget {
  const ResignationRequisitionPage({super.key});

  @override
  State<ResignationRequisitionPage> createState() => _ResignationRequisitionPageState();
}

class _ResignationRequisitionPageState extends State<ResignationRequisitionPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? resignationDate;
  DateTime? lastWorkingDate;
  bool noticeServing = false;
  String? reason;
  String? remarks;
  File? uploadedFile;

  List<String> reasons = [
    "Better Opportunity",
    "Health Issues",
    "Relocation",
    "Career Change",
    "Personal Reasons"
  ];

  List<Map<String, dynamic>> resignationHistory = [
   /* {
      "resignationDate": "10-Oct-2024",
      "lastWorkingDate": "10-Nov-2024",
      "noticePeriod": "30 Days",
      "reason": "Better Opportunity",
      "status": "Approved"
    },*/
    {
      "resignationDate": "15-Jan-2025",
      "lastWorkingDate": "15-Feb-2025",
      "noticePeriod": "30 Days",
      "reason": "Relocation",
      "status": "Pending"
    },
  ];

  Future<void> pickDate(bool isResignationDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isResignationDate) {
          resignationDate = picked;
        } else {
          lastWorkingDate = picked;
        }
      });
    }
  }

  void openUploadDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
                child: Text("Upload Resignation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Use Camera"),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() => uploadedFile = File(image.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.teal),
              title: const Text("Upload from Files"),
              onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null && result.files.single.path != null) {
                  setState(() => uploadedFile = File(result.files.single.path!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resignation Requisition",
            style: TextStyle(fontWeight: FontWeight.bold)),
        //backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form Section
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Resignation Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      const SizedBox(height: 15),

                      // Resignation Date
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Resignation Date",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => pickDate(true),
                          ),
                        ),
                        controller: TextEditingController(
                            text: resignationDate == null
                                ? ""
                                : "${resignationDate!.day}-${resignationDate!.month}-${resignationDate!.year}"),
                      ),
                      const SizedBox(height: 10),

                      // Last Working Date
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Last Working Date",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () => pickDate(false),
                          ),
                        ),
                        controller: TextEditingController(
                            text: lastWorkingDate == null
                                ? ""
                                : "${lastWorkingDate!.day}-${lastWorkingDate!.month}-${lastWorkingDate!.year}"),
                      ),
                      const SizedBox(height: 15),

                      // Notice Period Serving
                      const Text("Notice Period Serving?",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Radio<bool>(
                              value: true,
                              groupValue: noticeServing,
                              onChanged: (value) => setState(() => noticeServing = value!)),
                          const Text("Yes"),
                          Radio<bool>(
                              value: false,
                              groupValue: noticeServing,
                              onChanged: (value) => setState(() => noticeServing = value!)),
                          const Text("No"),
                        ],
                      ),

                      if (noticeServing)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Notice Period (To be served in Days)",
                          ),
                        ),
                      const SizedBox(height: 15),

                      // Reason
                      DropdownButtonFormField<String>(
                        value: reason,
                        items: reasons
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) => setState(() => reason = value),
                        decoration: const InputDecoration(labelText: "Reason for Leaving"),
                      ),
                      const SizedBox(height: 10),

                      // Remarks
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Remarks"),
                        maxLines: 3,
                        onChanged: (val) => remarks = val,
                      ),
                      const SizedBox(height: 15),

                      // Upload
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Upload Resignation",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: openUploadDialog,
                        ),
                      ),

                      if (uploadedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("📎 Selected: ${uploadedFile!.path.split('/').last}",
                              style: const TextStyle(color: Colors.green)),
                        ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text("Save",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Resignation History
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Resignation History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ),
            const SizedBox(height: 10),
            ...resignationHistory.map((item) {
              Color cardColor;
              switch (item["status"]) {
                case "Approved":
                  cardColor = Colors.green.shade100;
                  break;
                case "Pending":
                  cardColor = Colors.amber.shade100;
                  break;
                default:
                  cardColor = Colors.red.shade100;
              }
              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Resignation Date: ${item["resignationDate"]}",
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(item["status"],
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ]),
                        const SizedBox(height: 8),
                        Text("Last Working Day: ${item["lastWorkingDate"]}"),
                        Text("Notice Period: ${item["noticePeriod"]}"),
                        Text("Reason: ${item["reason"]}"),
                      ]),
                ),
              );
            }),
          ],
        ),
      ),

      bottomNavigationBar:
      BottomNavigationBar (
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        onTap: (index) {

          if(index==0){

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage()));
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if(index==4){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Profile');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}