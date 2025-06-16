import 'package:flutter/material.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../themes/empThemes.dart';
import 'incidentReportingPage.dart';

class IncidentListPage extends StatelessWidget {
  final List<Map<String, String>> incidentReports = [
    {
      'employee': 'Alice',
      'type': 'Mistake',
      'date': '2025-06-10',
      'location': 'Site A',
      'desc': 'Done Mistake',
    },
    {
      'employee': 'Bob',
      'type': 'Blunder',
      'date': '2025-06-11',
      'location': 'Head Office',
      'desc': 'Forget to fill timesheet',
    },
    {
      'employee': 'Bharat',
      'type': 'Appreciation',
      'date': '2025-06-11',
      'location': 'Head Office',
      'desc': 'Created UF Designs',
    },
  ];
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Reports'),
        //backgroundColor: Colors.deepPurple,
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
                MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0,)));
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
            //Navigator.pushNamed(context, MyRoutings.preOnboardItemRoute);
            print('Incident');
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
          //setState(() => currentIndex = index);
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
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Incident',
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
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: incidentReports.length,
        itemBuilder: (context, index) {
          final report = incidentReports[index];
          final color = report['type'] == 'Blunder' || report['type'] == 'Mistake'
              ? Colors.red.shade200
              : Colors.green.shade300;
          final leadingIcon = report['type'] == 'Blunder' || report['type'] == 'Mistake' ? Icon(Icons.warning_amber_rounded,
            color: Colors.deepOrange,size: 35,) :
          Icon(Icons.check_circle,
            color: Mythemes.successColor,size: 35,);
          return Card(
            //color: color,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leadingIcon
                ],
              ),

              title: Text(
                '${report['employee']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type: ${report['type']} • Date: ${report['date']}\nLocation: ${report['location']}',
                  ),
                  Text(
                    'Description: ${report['desc']}',
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => IncidentFormPage()));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(
          Icons.add, color: Mythemes.whitish, size: 28,
        ),
      ),
    );
  }
}