import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../commanScreen/routes.dart';
import '../../../ess/EssDashboarrddModel.dart';
import '../../../ess/essDashboardNavigate.dart';
import '../../../main.dart';
import '../../../profiles/profilePageWithHead.dart';
import '../../../sharedPrefancePage/ShardPre.dart';


class ClaimItemsList extends StatefulWidget {
  const ClaimItemsList({Key? key}) : super(key: key);

  @override
  State<ClaimItemsList> createState() => _ClaimItemsListState();
}
SessionManager shared = SessionManager();
class _ClaimItemsListState extends State<ClaimItemsList> with RouteAware{
  int? empRole;
  int? roRole;
  int? adminRole;
  bool showHide = false;
  bool showAdmin = false;
  bool showRo = false;
  String userPanelPermission = "COMPANY_EMPLOYEE";
  String? claimLevelOneMO;
  String? claimLevelTwoMO;
  String? claimLevelThreeMO;
  String? claimLevelOneMSS;
  String? claimLevelTwoMSS;
  String? claimLevelThreeMSS;
  String? claimLevelOneUIS;
  String? claimLevelTwoUIS;
  String? claimLevelThreeUIS;

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
    claimLevelOneMSS = await shared.getClaimLevelOne();
    claimLevelTwoMSS = await shared.getClaimLevelTwo();
    claimLevelThreeMSS = await shared.getClaimLevelThree();
    claimLevelOneMO = await shared.getClaimLevelOneMO();
    claimLevelTwoMO = await shared.getClaimLevelTwoMO();
    claimLevelThreeMO = await shared.getClaimLevelThreeMO();
    claimLevelOneUIS = await shared.getClaimLevelOneUIS();
    claimLevelTwoUIS = await shared.getClaimLevelTwoUIS();
    claimLevelThreeUIS = await shared.getClaimLevelThreeUIS();

    userPanelPermission= await shared.getUserPanel();
    print("User Panel - $userPanelPermission");
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');

    print('Claim L1 $claimLevelOneMO');
    print('Claim L2 $claimLevelTwoMO');
    print('Claim L3 $claimLevelThreeMO');

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
  int currentIndex = 2;
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
      
      if(userPanelPermission == "MSS") {
        //Pending Requisition List MSS
        if(claimLevelOneMSS == "1" || claimLevelTwoMSS == "1" || claimLevelThreeMSS == "1") {
          items.add(
            Hero(
              tag: 'myTeamPendingReq',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () async{
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
                      Navigator.pushNamed(context, MyRoutings.mssClaimItemRoute);
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.pending,
                          size: 50,
                          color: Mythemes.warningColor,
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
                              'Pending Claims',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
      if(userPanelPermission == "MSS_MO_ADMIN") {
        //Pending Requisition List MSS MO
        if(claimLevelOneMO == "1" || claimLevelTwoMO == "1" || claimLevelThreeMO == "1") {
          items.add(
            Hero(
              tag: 'myTeamPendingReq',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () async{
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
                      Navigator.pushNamed(context, MyRoutings.mssMoClaimItemRoute);
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.pending,
                          size: 50,
                          color: Mythemes.warningColor,
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
                              'Pending Claims',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

      }
      if(userPanelPermission == "USER") {
        //Pending Requisition List USER
        if(claimLevelOneMO == "1" || claimLevelTwoMO == "1" || claimLevelThreeMO == "1") {
          items.add(
            Hero(
              tag: 'myTeamPendingReq',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () async{
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
                      Navigator.pushNamed(context, MyRoutings.uisClaimItemRoute);
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.pending,
                          size: 50,
                          color: Mythemes.warningColor,
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
                              'Pending Claims',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

      }
      return items;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: "Claim & Reimbursement".text.make(),
      ),
      body:  Container(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: generateGridViewItems(),
        ),
        /*ListView(
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
                              Navigator.pushNamed(context, MyRoutings.claimReqListRoute);
                            }
                          },
                          leading:  Icon(
                            Icons.currency_rupee, size: 30,color: Mythemes.blackish,
                          ),

                          title: "Raise Claim".text.xl.overflow(TextOverflow.ellipsis).maxLines(1).make(),
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
                          leading:  "L1".text.letterSpacing(1.5).size(22).color(Mythemes.blackish).bold.make().px8(),

                          title: "Claim Approval L1".text.xl.overflow(TextOverflow.ellipsis).maxLines(1).make(),
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
                          leading:  "L2".text.letterSpacing(1.5).size(22).color(Mythemes.blackish).bold.make().px8(),

                          title: "Claim Approval L2".text.xl.overflow(TextOverflow.ellipsis).maxLines(1).make(),
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
                          leading:  "L3".text.letterSpacing(1.5).size(22).color(Mythemes.blackish).bold.make().px8(),

                          title: "Claim Approval L3".text.xl.overflow(TextOverflow.ellipsis).maxLines(1).make(),
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
        ),*/
      ) ,


      /*floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Ensures circular shape
        ),
        mini: false,
        onPressed: () async {
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
            Navigator.pushNamed(context, MyRoutings.claimReqListRoute);
          }
        },
        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(Icons.add, color: Mythemes.whitish,),
      ),*/

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
            Navigator.pushNamed(context, MyRoutings.claimItemsListRoute);
            print('Claim Items');
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
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Claims',
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
