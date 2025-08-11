import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commanScreen/routes.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../../../themes/empThemes.dart';


class LoanAdvanceReport extends StatefulWidget {
  const LoanAdvanceReport({Key? key}) : super(key: key);

  @override
  State<LoanAdvanceReport> createState() => _LoanAdvanceReportState();
}
SessionManager shared = SessionManager();
int? empRole;
int? roRole;
int? adminRole;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;
String userPanelPermission = "COMPANY_EMPLOYEE";
String pendingLoanRequestMoL1Permission = "0";
String pendingLoanRequestMoL2Permission = "0";
String pendingLoanRequestMoL3Permission = "0";
String pendingLoanRequestMSSL1Permission = "0";
String pendingLoanRequestMSSL2Permission = "0";
String pendingLoanRequestMSSL3Permission = "0";
String pendingLoanRequestUISL1Permission = "0";
String pendingLoanRequestUISL2Permission = "0";
String pendingLoanRequestUISL3Permission = "0";

class _LoanAdvanceReportState extends State<LoanAdvanceReport> {

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async{
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    userPanelPermission= await shared.getUserPanel();
    pendingLoanRequestMoL1Permission = (await shared.getLoanApprovalL1MO())!;
    pendingLoanRequestMSSL1Permission= (await shared.getLoanApprovalL1MSS())!;
    pendingLoanRequestUISL1Permission= (await shared.getLoanApprovalL1UIS())!;
    pendingLoanRequestMoL2Permission = (await shared.getLoanApprovalL2MO())!;
    pendingLoanRequestMSSL2Permission= (await shared.getLoanApprovalL2MSS())!;
    pendingLoanRequestUISL2Permission= (await shared.getLoanApprovalL2UIS())!;
    pendingLoanRequestMoL3Permission = (await shared.getLoanApprovalL3MO())!;
    pendingLoanRequestMSSL3Permission= (await shared.getLoanApprovalL3MSS())!;
    pendingLoanRequestUISL3Permission= (await shared.getLoanApprovalL3UIS())!;
    print("Pending Attendance Request MSS MO- $pendingLoanRequestMoL1Permission");
    print("Pending Attendance Request MSS- $pendingLoanRequestMSSL1Permission");
    print("Pending Attendance Request UIS- $pendingLoanRequestUISL1Permission");
    print("User Panel - $userPanelPermission");
    adminRole= await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');


    setState(() {
      if(empRole==1){
        showHide=true;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRole==0){
        showHide=false;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Loan And Advance".text.make(),
      ),
      body:  Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Hero(tag: 'loanAdvanceReport',
              child: LoanAdvanceWidget(),

            ).h64(context)




          ],

        ),
      ) ,


    );
  }
}

class LoanAdvanceWidget extends StatefulWidget {
  const LoanAdvanceWidget({Key? key}) : super(key: key);

  @override
  State<LoanAdvanceWidget> createState() => _LoanAdvanceWidgetState();
}

class _LoanAdvanceWidgetState extends State<LoanAdvanceWidget> {


  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can use these values to determine the size of your widget
    double widgetWidth = screenWidth * 0.03; // 80% of the screen width
    double widgetHeight = screenHeight * 0.5; // 50% of the screen height
    double boxText = widgetWidth;

    List<Widget> generateGridViewItems() {
      List<Widget> items = [];

      if(userPanelPermission == "MSS" && pendingLoanRequestMSSL1Permission == "LOAN_APPROVAL_LEVEL_ONE_ADD" || pendingLoanRequestMSSL2Permission == "LOAN_APPROVAL_LEVEL_TWO_ADD" || pendingLoanRequestMSSL3Permission == "LOAN_APPROVAL_LEVEL_THREE_ADD"){
        //Pending Loan Request List
        items.add(
          Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, MyRoutings.pendingLoanRequestListRoute);
                /*Fluttertoast.showToast(
                  msg: "Not Activated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );*/
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      size: 50,
                      color: Colors.orange,
                    ),
                    /*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'Pending Loans',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if(userPanelPermission == "MSS_MO_ADMIN" && pendingLoanRequestMoL1Permission == "LOAN_APPROVAL_LEVEL_ONE_ADD" || pendingLoanRequestMoL2Permission == "LOAN_APPROVAL_LEVEL_TWO_ADD" || pendingLoanRequestMoL3Permission == "LOAN_APPROVAL_LEVEL_THREE_ADD"){
        //Pending Loan Request List
        items.add(
          Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, MyRoutings.pendingLoanListMO);
                /*Fluttertoast.showToast(
                  msg: "Not Activated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );*/
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      size: 50,
                      color: Colors.orange,
                    ),
                    /*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'Pending Loans',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if(userPanelPermission == "USER" && pendingLoanRequestUISL1Permission == "LOAN_APPROVAL_LEVEL_ONE_ADD" || pendingLoanRequestUISL2Permission == "LOAN_APPROVAL_LEVEL_TWO_ADD" || pendingLoanRequestUISL3Permission == "LOAN_APPROVAL_LEVEL_THREE_ADD"){
        //Pending Loan Request List
        items.add(
          Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, MyRoutings.pendingLoanRequestListRoute);
                /*Fluttertoast.showToast(
                  msg: "Not Activated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );*/
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      size: 50,
                      color: Colors.orange,
                    ),
                    /*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'Pending Loans',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }


      return items;
    }
    return Material(
      child: Scaffold(
        body: Column(
          children: [
            /*Card(
              elevation: 3,
              child:
              ListTile(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.loanAdvanceReqRoute);
                  }
                },
                leading:  Icon(
                  CupertinoIcons.doc_plaintext, size: 30,
                ),

                title: "Loan Request".text.make(),
                trailing:  Icon(
                    CupertinoIcons.chevron_forward
                ),

              ),
            ),
            Card(
              elevation: 3,
              child:
              ListTile(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.pendingLoanRequestedRoute);
                  }
                },
                leading:  Icon(
                  Icons.more_time, size: 30,
                ),

                title: "Loan Requested List".text.make(),
                trailing:  Icon(
                    CupertinoIcons.chevron_forward
                ),

              ),
            ),
            Card(
              elevation: 3,
              child:
              ListTile(
                onTap: () async {
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    Navigator.pushNamed(context, MyRoutings.loanApprovedReqRoute);
                  }
                },
                leading:  Icon(
                  Icons.more_time, size: 30,
                ),

                title: "Loan Approved List".text.make(),
                trailing:  Icon(
                    CupertinoIcons.chevron_forward
                ),

              ),
            ),*/
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: generateGridViewItems(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
