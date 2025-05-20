import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commanScreen/routes.dart';


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
    return SingleChildScrollView(
      child: Column(
        children: [
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
          ),
        ],
      ),
    );
  }
}
