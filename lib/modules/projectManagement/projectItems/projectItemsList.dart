import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';


class ProjectManageItems extends StatelessWidget {
  const ProjectManageItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Project Management".text.make(),
      ),
      body:  Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Hero(tag: 'taskManage',
              child: ItemsList(),

            ).h64(context)
          ],
        ),
      ) ,
    );
  }
}

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                //Navigator.pushNamed(context, MyRoutings.advanceRequisitionListRoute);
              }
            },
            leading:  Icon(
              Icons.add_task, size: 30,
            ),

            title: "Task Creation".text.make(),
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
                //Navigator.pushNamed(context, MyRoutings.pendingAdvanceReqListRoute);
              }
            },
            leading:  Icon(
              Icons.pending_actions_rounded, size: 30,
            ),

            title: "Pending Task List".text.make(),
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
                //Navigator.pushNamed(context, MyRoutings.expenseListRoute);
              }
            },
            leading:  Icon(
              Icons.task, size: 30,
            ),

            title: "Assigned Task List".text.make(),
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
                //Navigator.pushNamed(context, MyRoutings.pendingReimbursementRoute);
              }
            },
            leading:  Icon(
              Icons.format_list_numbered_rtl_rounded, size: 30,
            ),

            title: "Self Assigned Task List".text.make(),
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
                //Navigator.pushNamed(context, MyRoutings.approveDisReimbursementListRoute);
              }
            },
            leading:  Icon(
              Icons.playlist_add_check, size: 30,
            ),

            title: "Self Completed Task List".text.lg.overflow(TextOverflow.ellipsis).maxLines(1).make(),
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
                //Navigator.pushNamed(context, MyRoutings.approveDisAdvanceListRoute);
              }
            },
            leading:  Icon(
              Icons.format_list_numbered_rounded, size: 30,
            ),

            title: "Draft Task List".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
      ],
    );
  }
}
