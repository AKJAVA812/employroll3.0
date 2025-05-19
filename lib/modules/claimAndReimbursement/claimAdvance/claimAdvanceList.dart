import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/advanceRequisition/advanceRequisitionList.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../commanScreen/routes.dart';
import '../../../main.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../claimItems/modalClass/advanceRequisitionListModal.dart';


class ClaimAdvanceList extends StatefulWidget {
  const ClaimAdvanceList({Key? key}) : super(key: key);

  @override
  State<ClaimAdvanceList> createState() => _ClaimAdvanceListState();
}
SessionManager shared = SessionManager();
class _ClaimAdvanceListState extends State<ClaimAdvanceList> with RouteAware {
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // ✅ Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }
  Future getSharedPrfanceList() async{
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');

    if(empRole==1){
      showHide=true;
      showRo = false;
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
  }
  int pageIndex = 0;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Claim & Advance".text.make(),
      ),
      body:  Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Hero(tag: 'claim',
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: true,
                      child: Card(
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
                              Navigator.push(context,MaterialPageRoute (
                                builder: (BuildContext context) => AdvanceRequisitionList(AdvanceRequestedListModal()),
                              ),);
                            }
                          },
                          leading:  Icon(
                            Icons.currency_rupee, size: 30,
                          ),

                          title: "Advance Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Card(
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
                              Navigator.pushNamed(context, MyRoutings.pendingAdvanceReqListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.pending_actions_rounded, size: 30,
                          ),

                          title: "Pending Advance Requisition".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Card(
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
                              Navigator.pushNamed(context, MyRoutings.expenseListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.add_card, size: 30,
                          ),

                          title: "Add Expense".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Card(
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
                              Navigator.pushNamed(context, MyRoutings.pendingReimbursementRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.payments_outlined, size: 30,
                          ),

                          title: "Pending Reimbursement".text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Card(
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
                              Navigator.pushNamed(context, MyRoutings.approveDisReimbursementListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.playlist_add_check, size: 30,
                          ),

                          title: "Approved/Disapproved Reimbursement".text.xl.overflow(TextOverflow.ellipsis).maxLines(1).make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Card(
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
                              Navigator.pushNamed(context, MyRoutings.approveDisAdvanceListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.playlist_add_check, size: 30,
                          ),

                          title: "Approved/Disapproved Advance".text.xl.overflow(TextOverflow.ellipsis).maxLines(1).make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ).h64(context)
          ],
        ),
      ) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.add), // This makes the FAB circular
      ),
      bottomNavigationBar: BottomAppBar(
        color: Mythemes.whitish,
        elevation: 5,
        shadowColor: Mythemes.greyish,
        height: kBottomNavigationBarHeight,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() {
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  setState(() {
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () {
                  setState(() {
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
