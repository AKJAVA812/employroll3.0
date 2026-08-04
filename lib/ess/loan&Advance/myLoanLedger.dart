import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import '../../themes/empThemes.dart';
import '../myAllReports.dart';

class MyLoanLedgerPage extends StatefulWidget {
  const MyLoanLedgerPage({super.key});

  @override
  State<MyLoanLedgerPage> createState() => _MyLoanLedgerPageState();
}

class _MyLoanLedgerPageState extends State<MyLoanLedgerPage> {
  final List<Map<String, dynamic>> ledgerEntries = [
    {
      'title': 'Personal Loan',
      'amount': 25000,
      'date': '10 Apr 2025',
      'type': 'Debited'
    },
    {
      'title': 'Loan Disbursed',
      'amount': 10000,
      'date': '09 Apr 2025',
      'type': 'Credited'
    },
    {
      'title': 'Loan Installment',
      'amount': 2500,
      'date': '29 Mar 2025',
      'type': 'Debited'
    },
    {
      'title': 'Loan Installment',
      'amount': 2500,
      'date': '20 Mar 2025',
      'type': 'Debited'
    },
    {
      'title': 'Loan Disbursed',
      'amount': 5000,
      'date': '18 Mar 2025',
      'type': 'Credited'
    },
  ];

  Icon getIcon(String type) {
    return type == 'Debited'
        ? Icon(CupertinoIcons.arrow_up_right, color: Colors.white, size: 26)
        : Icon(CupertinoIcons.arrow_down_left, color: Colors.white, size: 26);
  }
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Loan Ledger'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ledgerEntries.length,
              itemBuilder: (context, index) {
                final entry = ledgerEntries[index];
                return Card(
                  color: Mythemes.whitish,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: getIcon(entry['type']),
                    ),
                    title: Text(
                      entry['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['date'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        "${entry['type']}, from Account".text.xs.gray500.make(),
                      ],
                    ),
                    trailing: Text(
                      '₹${entry['amount']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: entry['type'] == 'Debited'
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GetAttendanceDet(showAppBar: true,)));
            print('My Requests');
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('My Reports');
          }
          if(index==4){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);

            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Dashboard');
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
            icon: Icon(CupertinoIcons.app_badge_fill),
            label: 'My Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'My Reports',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
