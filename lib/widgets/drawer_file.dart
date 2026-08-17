import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import '../themes/empThemes.dart';
import '../utils/profile_image_provider.dart';
import '../services/mobile_profile_cache.dart';
import '../mss_profiles/global_profile.dart';
import '../mss_profiles/profileListModal.dart';

class DrawerFile extends StatefulWidget {
  const DrawerFile({super.key});

  @override
  State<DrawerFile> createState() => _DrawerFileState();
}

SessionManager shared = SessionManager();

class _DrawerFileState extends State<DrawerFile> {
  String urlImage = "";
  String emailid = "abc@gmail.com";
  String name = "Employee Name ";
  List<ProfileData> profileListGetter = <ProfileData>[];
  bool isLoadingProfiles = false;

  Future getUserNameImage() async {
    urlImage = await shared.getProfileImage();
    name = await shared.getempName();
    emailid = await shared.getEmailId();

    await getProfileList();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> getProfileList() async {
    setState(() {
      isLoadingProfiles = true;
    });
    try {
      final profileListModal = await MobileProfileCache.loadProfileList();
      profileListGetter = profileListModal.data ?? <ProfileData>[];
      if (profileListGetter.isNotEmpty) {
        final selectedId = await shared.getDefaultProfileId();
        final selectedName = await shared.getDefaultProfileName();
        selectedProfileIdNotifier.value = selectedId ?? 0;
        selectedProfileNameNotifier.value = selectedName ?? '';
      }
    } catch (e) {
    } finally {
      if (mounted) {
        setState(() {
          isLoadingProfiles = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    //getUserNameImage();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    MobileProfileCache.revision.addListener(_reloadProfiles);
    getUserNameImage();

    // TODO: implement initState


  }

  @override
  void dispose() {
    MobileProfileCache.revision.removeListener(_reloadProfiles);
    super.dispose();
  }

  void _reloadProfiles() {
    getUserNameImage();
  }

  @override
  void didUpdateWidget(covariant DrawerFile oldWidget) {
    //getUserNameImage();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(VoidCallback fn) {
    //getUserNameImage();
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.8;
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SingleChildScrollView(
              child: DrawerHeader(
                decoration: BoxDecoration(color: Mythemes.greyishade),
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Mythemes.greyishade),
                  accountName: Text(
                    name,
                    style: TextStyle(
                      color: Mythemes.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    emailid,
                    style: TextStyle(color: Mythemes.black),
                  ),
                  margin: EdgeInsets.zero,
                  /*   decoration: BoxDecoration(
                    color:Colors.red,
                  ),*/
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: profileImageProvider(urlImage),
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(CupertinoIcons.profile_circled),
              title: Text("Profile", textScaleFactor: 1.2),
              onTap: () {
                /*Fluttertoast.showToast(
                    msg: "Profile Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                Navigator.pushNamed(context, MyRoutings.profileRoute);
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.chart_bar_square),
              title: Text("Dashboard ", textScaleFactor: 1.2),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Dashboard Click",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
            ),

            ListTile(
              leading: Icon(CupertinoIcons.antenna_radiowaves_left_right),
              title: Text("Workflow ", textScaleFactor: 1.2),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            Hero(
              tag: 'animatedDrawer',
              child: ListTile(
                leading: Icon(CupertinoIcons.list_bullet_below_rectangle),
                title: Text("Employee List", textScaleFactor: 1.2),
                onTap: () async {
                  bool internetCheck =
                      await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content:
                            "Please check your internet connection".text.make(),
                      );
                      Fluttertoast.showToast(
                        msg: "Please check your Internet connection",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM_RIGHT,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Mythemes.black,
                        textColor: Colors.white,
                        fontSize: 17.0,
                      );
                    });
                  } else {
                    Navigator.pushNamed(context, MyRoutings.empListRoute);
                  }
                },
              ),
            ),

            if (profileListGetter.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                child: Text(
                  'Profiles',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: selectedProfileIdNotifier,
                builder: (context, currentSelectedId, _) {
                  return Column(
                    children:
                        profileListGetter.map((profile) {
                          final profileId = profile.profileId ?? 0;
                          final profileName = profile.profileName ?? '';
                          final isSelected = currentSelectedId == profileId;
                          return ListTile(
                            dense: true,
                            leading: Icon(CupertinoIcons.person_2_square_stack),
                            title: Text(profileName, textScaleFactor: 1.05),
                            subtitle: Text(
                              '${profile.profilePermission?.length ?? 0} permissions',
                            ),
                            trailing:
                                isSelected
                                    ? Icon(Icons.check, color: Colors.green)
                                    : null,
                            tileColor: isSelected ? Colors.grey.shade200 : null,
                            onTap: () async {
                              await shared.setDefaultProfileId(profileId);
                              await shared.setDefaultProfileName(profileName);
                              selectedProfileIdNotifier.value = profileId;
                              selectedProfileNameNotifier.value = profileName;
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                  );
                },
              ),
            ],
            ListTile(
              leading: Icon(CupertinoIcons.settings_solid),
              title: Text("Settings ", textScaleFactor: 1.2),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Settings Click",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.folder),
              title: Text("Reports ", textScaleFactor: 1.2),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Reports Click",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent_rounded),
              title: Text("Helpdesk ", textScaleFactor: 1.2),
              onTap: () {
                Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                /*Fluttertoast.showToast(
                    msg: "Helpdesk Click",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                Navigator.pop(context);
              },
            ),

            /*ExpansionTile(title: Text("Attendance",textScaleFactor: 1.2),
              leading: Icon(CupertinoIcons.barcode_viewfinder),
              children: <Widget>[
                ListTile(
                  title: Text("Attendance Requisitions",
                    style: TextStyle(
                    ),
                  ),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  //trailing: Icon(Icons.android),
                  leading: Icon(CupertinoIcons.add_circled),
                  onTap: ()  {
                    Fluttertoast.showToast(
                        msg: "This is Center Short Toast",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                ),
                ListTile(
                  title: Text("page two"),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(CupertinoIcons.add_circled),
                  //trailing: Icon(Icons.accessible),
                  onTap: () => {},
                ),
                Container(
                  height: 1.0,
                  color: Color(0xFFDDDDDD),
                ),
              ],
              initiallyExpanded: false,
            ),

            ExpansionTile(title: Text("Leave",textScaleFactor: 1.2),
              leading: Icon(CupertinoIcons.leaf_arrow_circlepath),
              children: <Widget>[
                ListTile(
                  title: Text("page one",
                    style: TextStyle(
                    ),
                  ),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  //trailing: Icon(Icons.android),
                  leading: Icon(CupertinoIcons.add_circled),

                  onTap: () => {},
                ),
                ListTile(
                  title: Text("page two"),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(CupertinoIcons.add_circled),
                  //trailing: Icon(Icons.accessible),
                  onTap: () => {},
                ),
                Container(
                  height: 1.0,
                  color: Color(0xFFDDDDDD),
                ),
              ],
              initiallyExpanded: false,
            ),

            ExpansionTile(title: Text("OD Report",textScaleFactor: 1.2),
              leading: Icon(CupertinoIcons.arrow_right),
              children: <Widget>[
                ListTile(
                  title: Text("page one",
                    style: TextStyle(
                    ),
                  ),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  //trailing: Icon(Icons.android),
                  leading: Icon(CupertinoIcons.add_circled),

                  onTap: () => {},
                ),
                ListTile(
                  title: Text("page two"),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(CupertinoIcons.add_circled),
                  //trailing: Icon(Icons.accessible),
                  onTap: () => {},
                ),
                Container(
                  height: 1.0,
                  color: Color(0xFFDDDDDD),
                ),
              ],
              initiallyExpanded: false,
            ),

            ExpansionTile(title: Text("Help Desk",textScaleFactor: 1.2),
              leading: Icon(CupertinoIcons.desktopcomputer),
              children: <Widget>[
                ListTile(
                  title: Text("page one",
                    style: TextStyle(
                    ),
                  ),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  //trailing: Icon(Icons.android),
                  leading: Icon(CupertinoIcons.add_circled),

                  onTap: () => {},
                ),
                ListTile(
                  title: Text("page two"),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(CupertinoIcons.add_circled),
                  //trailing: Icon(Icons.accessible),
                  onTap: () => {},
                ),
                Container(
                  height: 1.0,
                  color: Color(0xFFDDDDDD),
                ),
              ],
              initiallyExpanded: false,
            ),

            ExpansionTile(title: Text("Claim Reimbursement",textScaleFactor: 1.2),
              leading: Icon(CupertinoIcons.money_dollar_circle),
              children: <Widget>[
                ListTile(
                  title: Text("page one",
                    style: TextStyle(
                    ),
                  ),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  //trailing: Icon(Icons.android),
                  leading: Icon(CupertinoIcons.add_circled),

                  onTap: () => {},
                ),
                ListTile(
                  title: Text("page two"),
                  contentPadding:  EdgeInsets.symmetric(horizontal: 30.0),
                  leading: Icon(CupertinoIcons.add_circled),
                  //trailing: Icon(Icons.accessible),
                  onTap: () => {},
                ),
                Container(
                  height: 1.0,
                  color: Color(0xFFDDDDDD),
                ),
              ],
              initiallyExpanded: false,
            ),*/
          ],
        ),
      ),
    );
  }
}

class MyModule {
  String title;
  List<MyModule> myModule;

  MyModule(this.title, [this.myModule = const <MyModule>[]]);
}

List<MyModule> sideList = <MyModule>[
  MyModule('Attendance', <MyModule>[
    MyModule("Sub Contract", <MyModule>[
      MyModule("title"),
      MyModule("title"),
      MyModule("title"),
    ]),
  ]),
];

class MyListReturn extends StatelessWidget {
  final MyModule myModuleReturn;

  const MyListReturn(this.myModuleReturn, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTill(myModuleReturn);
  }
}

Widget _buildTill(MyModule myModule1) {
  if (myModule1.myModule.isEmpty) {
    return ListTile(
      dense: true,
      enabled: true,
      isThreeLine: false,
      selected: true,
      title: Text(myModule1.title),
    );
  }

  return ExpansionTile(
    key: PageStorageKey<int>(3),
    title: Text(myModule1.title),
    children: myModule1.myModule.map(_buildTill).toList(),
  );
}
