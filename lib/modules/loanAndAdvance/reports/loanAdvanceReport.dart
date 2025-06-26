import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commanScreen/routes.dart';
import '../../../themes/empThemes.dart';


class LoanAdvanceReport extends StatelessWidget {
  const LoanAdvanceReport({Key? key}) : super(key: key);

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
