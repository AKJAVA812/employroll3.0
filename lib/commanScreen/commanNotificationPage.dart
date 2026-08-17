
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../employeePage/employeeListPage.dart';
import '../singUP/login_page.dart';
import '../themes/empThemes.dart';
class CommonNotificationPage{

  static showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Please Wait..." )),
        ],),
    );
    showDialog(barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  static showDialgError(BuildContext buildContext, result,reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            //Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            //Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: Text("Retry"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void showDialgSucess(BuildContext buildContext, String result, String alert) {
    if (!buildContext.mounted) {
      return;
    }

    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(
            children: [
              Expanded(child: Text(alert)),
            ],
          ),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                // ✅ Always close using original buildContext (not dialogContext)
                if (Navigator.of(buildContext, rootNavigator: true).canPop()) {
                  Navigator.of(buildContext, rootNavigator: true).pop();
                } else {
                }
              },
              child: const Text("Ok"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }


  static showDeleteMessage(BuildContext buildContext, result,alert) {
    var deletedialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      title: Row(
        children: [
          "Cancel Requisition".text.make(),
        ],
      ),
      content: Builder(
        builder: (context) {
          /* var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;*/
          return SizedBox(
            height:  15,
            width:  20,
            child: "Sure you want to cancel requisition?".text.make(),
          );
        },
      ),



      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(buildContext, rootNavigator: true).pop();
                  //Navigator.of(buildContext).pop();
                },
                child: Container(
                  // color: Mythemes.lightBluishColor,
                  child: "No".text.color(Mythemes.dangerColorOne).make(),
                )
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                },
                child: Container(
                  // color: Mythemes.lightBluishColor,
                  child: "Yes".text.make(),
                )
            ),
          ],
        )
      ],
    );
    showDialog(barrierDismissible: true,
      context:buildContext,
      builder:(BuildContext context){
        return deletedialog;
      },
    );
  }


  static showWorkDoneSuccess(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 18
          ),)),
        ],
      ),
      content: Text(result , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              child: Text("Ok"),
            )
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

 /* static showSuccessGo(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text(result , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(

            onPressed: ()=>Navigator.pushNamed(buildContext, MyRoutings.punchInRoute),
            *//* {
              Navigator.pushNamed(buildContext, MyRoutings.punchInRoute);
              //Navigator.pop(buildContext!);
            },*//*
            child: Text("Ok"),
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        barrierDismissible: true,
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }*/
  static showSuccessGo(BuildContext buildContext, result,alert) {
    showDialog(
      context: buildContext,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title:  Text(alert),
          content:  Text(result),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
                  onPressed: () {
                  Navigator.of(buildContext, rootNavigator: true).pop();
                  Navigator.pushNamed(buildContext, MyRoutings.punchInRoute);
                  //Navigator.of(buildContext).pop();
                  //Navigator.of(buildContext, rootNavigator: false).pop();

                  //Navigator.pop(buildContext, MyRoutings.punchInRoute);

                  //Navigator.of(buildContext).pop();
                  //Navigator.pop(buildContext!);
                }
              /*onPressed: () {

               //Navigator.pushNamed(buildContext, MyRoutings.punchInRoute);
                Navigator.of(buildContext).pop();
              },*/
            ),
          ],
        );
      },
    );

  }

  static showSuccessStay(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text(result , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(buildContext, rootNavigator: true).pop();
              //Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              child: Text("Ok"),
            )
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }



  /*static showLogoutPop(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert)),
        ],
      ),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(buildContext, MyRoutings.loginRoute);
          },
          child: Text("Ok"),
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }*/

  static showLogoutPopup(BuildContext buildContext, result,alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text(result , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () {
              shared.setSessionId("");
              shared.setAdminRole(0);
              shared.setEmpRoll(0);
              shared.setRoRoll(0);
              shared.setMobAction(0);

              Navigator.pushAndRemoveUntil(
                buildContext,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
              //Navigator.of(buildContext, rootNavigator: true).pop();
            },
            child: Container(
              child: Text("Yes", style: TextStyle(color: Mythemes.warningColor),),
            )
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
/*static showLogoutPop(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text(result , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: "Cancel".text.color(Mythemes.dangerColorOne).make(),
        ),
        TextButton(
          onPressed: () {
            shared.setSessionId("");
            Navigator.pushAndRemoveUntil(
              buildContext,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
            );

          },
          child: "Logout".text.color(Mythemes.warningColor).make(),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }*/

}

