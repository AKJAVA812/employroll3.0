import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../ess/EssDashboarrddModel.dart';
import '../../ess/essDashboardNavigate.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../themes/empThemes.dart';

class ExitResignationL1ApprovalPage extends StatefulWidget {
  const ExitResignationL1ApprovalPage({Key? key}) : super(key: key);

  @override
  State<ExitResignationL1ApprovalPage> createState() =>
      _ExitResignationL1ApprovalPageState();
}

class _ExitResignationL1ApprovalPageState
    extends State<ExitResignationL1ApprovalPage> {
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController empRemarksController = TextEditingController();

  final TextEditingController registrationDate = TextEditingController();
  final TextEditingController lastWorkDate = TextEditingController();
  final TextEditingController leavingDate = TextEditingController();
  DateTime? resignDate;
  String? reasonForLeaving;

  List<String> reasons = [
    "Better Opportunity",
    "Relocation",
    "Career Change",
    "Health Issues",
    "Personal Reasons"
  ];

  /*Future<void> pickDate(bool isResign) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: isResign ? "Select Resignation Date" : "Select Last Working Date",
    );

    if (selected != null) {
      setState(() {
        if (isResign) {
          resignDate = selected;
        } else {
          lastWorkDate = selected;
        }
      });
    }
  }*/

  Widget formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Resignation Approval L1 - ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Mythemes.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Employee Name",
                      style: TextStyle(
                        color: Mythemes.whitish,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                formLabel("Reason for Leaving"),
                DropdownButtonFormField(
                  value: reasonForLeaving,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
                  items: reasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => reasonForLeaving = value as String);
                  },
                ),
                const SizedBox(height: 15),

                TextFormField(
                  onTap: () async {
                    DateTime? fromDate = DateTime.now();
                    FocusScope.of(context).requestFocus(FocusNode());
                    fromDate = await showDatePicker(
                      context: context,
                      initialDate: fromDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2060),
                    );
                    setState(() {
                      registrationDate.text = DateFormat("dd-MM-yyyy").format(fromDate!);
                    });
                  },
                  readOnly: true,
                  controller: registrationDate,
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (registrationDate.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, size: 18),
                            onPressed: () {
                              setState(() {
                                registrationDate.clear();
                              });
                            },
                          ),
                        Icon(Icons.calendar_month, size: 18),
                      ],
                    ),
                    labelText: "Resignation Date",
                    contentPadding: EdgeInsets.all(5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Mythemes.blackishade),
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Mythemes.blackish,
                    ),
                  ),
                ).p8(),
                const SizedBox(height: 15),

                formLabel("Notice Period (Official)"),
                TextFormField(
                  controller: noticePeriodController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Notice period in days",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode()); // to prevent keyboard
                    DateTime? fromDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1947),
                      lastDate: DateTime(2060),
                    );
                    if (fromDate != null) {
                      setState(() {
                        lastWorkDate.text = DateFormat("dd-MM-yyyy").format(fromDate);
                      });
                    }
                  },
                  readOnly: true,
                  controller: lastWorkDate,
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (lastWorkDate.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, size: 18),
                            onPressed: () {
                              setState(() {
                                lastWorkDate.clear();
                              });
                            },
                          ),
                        Icon(Icons.calendar_month, size: 18),
                      ],
                    ),
                    labelText: "Last Working Date",
                    contentPadding: EdgeInsets.all(5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Mythemes.blackishade),
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Mythemes.blackish,
                    ),
                  ),
                ).p8(),
                const SizedBox(height: 15),

                formLabel("Reason for Leaving"),
                TextFormField(
                  controller: empRemarksController,
                  readOnly: true,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                formLabel("My Remarks"),
                TextFormField(
                  controller: remarksController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Enter your remarks",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 5,
                        ),
                        child: const Text("Disapprove",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Mythemes.successColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 5,
                        ),
                        child: const Text("Approve",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
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
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel()))
            );
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
            icon: Icon(Icons.account_tree_outlined),
            label: 'My Requests',
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