import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:velocity_x/velocity_x.dart';



class PayrollItems extends StatefulWidget {
  const PayrollItems({Key? key}) : super(key: key);

  @override
  State<PayrollItems> createState() => _PayrollItemsState();
}

class _PayrollItemsState extends State<PayrollItems> {
  var titleName = 'Payroll';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
    Hero(tag: 'payrollItem', child:
    SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 3,
            child:
            ListTile(
              onTap: (){
                setState(() {
                  // _isVisible = !_isVisible;
                });
                Navigator.pushNamed(context, MyRoutings.testPdfDownload);
                //Navigator.pushNamed(context, MyRoutings.pdfDownloadRoute);
              },
              leading:  Icon(
                CupertinoIcons.doc_plaintext, size: 30,
              ),

              title: "Salary Slip".text.make(),
              trailing:  Icon(
                  CupertinoIcons.chevron_forward
              ),

            ),
          ),
        ],

      ),
    ))
          ],

        ),
      ),
    );
  }
}
