import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../commanScreen/allAPIList.dart';
import '../commanScreen/commanNotificationPage.dart';
import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../employeePage/liveMapView.dart';
import '../employeePage/mapView.dart';
import '../profiles/profilePageWithHead.dart';
import '../themes/empThemes.dart';
import 'FaceRecognitionHome.dart';
import 'RegistrationScreen.dart';
import 'faceEmpListModalClass.dart';

class EmpListFaceRegistered extends StatefulWidget {
  const EmpListFaceRegistered({Key? key}) : super(key: key);

  static const String _title = 'Employee List';

  @override
  State<EmpListFaceRegistered> createState() => _EmpListFaceRegisteredState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNew=[];
EmployeeListFaceModel? employeeListModelglobel;
EmployeeListFaceModel? employeeListModelglobeled;
var empName;
var empId;
class _EmpListFaceRegisteredState extends State<EmpListFaceRegistered> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNew!.length;
      print('listLength $listLength');
    });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<EmployeeListFaceModel> getEmployeeList11 = getEmployeeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        employeeListModelglobel=value;
        employeeListModelglobeled=employeeListModelglobel;
      });
      print('employeeList00${employeeListModelglobel!.data!.length}');
    });
  }

  Future<EmployeeListFaceModel> getEmployeeList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.getEmpFaceList;
    print('employeeList11: ${SessionId}');
    EmployeeListFaceModel employeeListModel;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');
    print("URL - ${response.request}");

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    employeeListModel=EmployeeListFaceModel.fromJson(mapResponse);
    allUsernew = employeeListModel.data;

    return employeeListModel;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>?  results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
      setState(() {
        results = allUsernew;
      });
    } else {
      /*results = allUsernew.where((user) =>
        user!.data!.contains(enteredKeyword.toLowerCase()))
          .toList();*/

      results = allUsernew?.where((element) =>
          element.empName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      /*for(int i=0; i<inductionListLabel!.data!.length;i++){
        if(inductionListLabel!.data![i].empName!.toLowerCase().contains(enteredKeyword.toLowerCase())){
          // Refresh the UI
          setState(() {
            inductionListLabeldd=inductionResult;
          });
        }*/
    }
    // we use the toLowerCase() method to make it case-insensitive
    setState(() {
      foundDataNew = results;
    });
  }
  TextEditingController searchType = TextEditingController();
  var titleName = "Reportees";
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, border: Border(
                  top: BorderSide.none
              ), boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.5,
                    spreadRadius: 0,
                    offset: Offset(0, 0.2))
              ]),
              child: AnimationSearchBar(
                  searchFieldDecoration: BoxDecoration(
                    color: Mythemes.greyishade,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backIcon: Icons.arrow_back_ios,
                  backIconColor: Mythemes.black,
                  textStyle: TextStyle(fontSize: 14),
                  onChanged: (value) {
                    _runFilter(value);
                  },
                  horizontalPadding: 8,
                  searchIconColor: Mythemes.black,
                  centerTitle: titleName,
                  verticalPadding: 3,
                  centerTitleStyle: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Mythemes.black),
                  searchTextEditingController: searchType),
            ),
          ),
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
                  MaterialPageRoute(builder: (context) => HomePage()));
              //Navigator.of(context, rootNavigator: true).pop();
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Workflow');
            }
            if(index==2){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const FaceRecognitinHome()));
              print('Face');
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
              icon: Icon(Icons.face_3),
              label: 'AI',
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

        body: Container(
          color: context.canvasColor,
          child: Column(
            children: [
              Expanded(child: employeeListModelglobeled == null ?
              Center(child: CircularProgressIndicator()): MyStatelessWidget(employeeListModelglobeled!)),
            ],
          ),
        )
    );
  }
}


class MyStatelessWidget extends StatefulWidget {
  final EmployeeListFaceModel employeeListModel;

  MyStatelessWidget(this.employeeListModel);
  @override
  State<MyStatelessWidget> createState() => _MyStatelessWidgetState(employeeListModel);
}


class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final EmployeeListFaceModel employeeListModel;
  _MyStatelessWidgetState(this.employeeListModel);




  @override
  Widget build(BuildContext context) {
    showTrackDialog(BuildContext buildContext, result,alert) {
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
                /*for(int i=0; i<employeeListModel!.data!.length;i++){
                  setState(() {
                    empId;
                    empName;

                    print('id $empId');
                    print('name $empName');
                  });

                }*/
                //print('emPI $empId');
                //print('emName $empName');
                print("Emp list clicked");
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    HistoryMapView(empName,empId)));

                //Navigator.of(buildContext, rootNavigator: true).pop();
              },
              child: Container(
                child: Text("History"
                  ,style: TextStyle(color: Mythemes.dangerColor),
                ),
              )
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    LiveMapView(empName,empId)));
              },
              child: Container(
                child: Text("Live",
                    style: TextStyle(color: Mythemes.lightBluishColor)
                ),
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
    return ListView.builder(
      padding: EdgeInsets.only(top: 4, bottom: 4,left: 4, right: 4),
      itemCount: foundDataNew!.length,
      itemBuilder: (context, i) {
        return InkWell(
            onTap: () {
              setState(() {
                empId = foundDataNew![i].empId;
                empName = foundDataNew![i].empName;
                print('emID $empId');
                print('name $empName');
                print("Emp list clicked");
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=> RegistrationScreen(
                  empId: empId
              )));
              //Navigator.pushNamed(context, MyRoutings.hdRaisedTicketReplyRoute);

            },
            child: Card(
              elevation: 2,
              child: ListTile(
                isThreeLine: true,
                contentPadding: EdgeInsets.all(12.0),
                leading: CircleAvatar(
                  backgroundColor: Mythemes.greyish,
                  radius: 25,
                  backgroundImage: NetworkImage(foundDataNew![i].empPhoto!),
                ),
                title: "${foundDataNew![i].empName.toString()}".text.make().py8(),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        foundDataNew![i].empCode.toString()
                            .text
                            .make()
                            .py4(),
                      ],
                    ),
                   /* Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: foundDataNew![i].empEmail.toString()
                              .text.size(10).overflow(TextOverflow.ellipsis).maxLines(2)
                              .make()
                              .py4(),

                        )

                      ],
                    ),*/
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {

                    /*showTrackDialog(
                        context, "How do you want to see tracking?".toString() + " " , "Tracking Location");*/
                  },
                  icon: Icon(
                    Icons.face_retouching_natural_sharp,
                    size: 28.0, color: foundDataNew![i].face == false ? Mythemes.dangerColor : Mythemes.successColor,
                  ),
                ),
              ),
            )

          /* Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Mythemes.greyish,
                          maxRadius: 40,
                          minRadius: 40,
                          backgroundImage: NetworkImage(employeeListModel.data![i].empPhoto!),
                        ),
                        employeeListModel.data![i].empName.toString()
                            .text
                            .make()
                            .px8()
                            .py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {

                                    print("Emp list clicked");
                                    showTrackDialog(
                                        context, "How do you want to see tracking?".toString() + " " , "Tracking Location");
                                  },
                                  icon: Icon(
                                    Icons.map_sharp,
                                    size: 28.0, color: Mythemes.lightBluishColor,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        employeeListModel.data![i].empContactNo.toString()
                            .text
                            .make()
                            .px8(),

                       *//* Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                "1 Year Ago"
                                    .text
                                    .textStyle(
                                    context.captionStyle)
                                    .make().px8(),
                              ],
                            ))*//*

                      ],
                    ).py2(),
                    Row(
                      children: [
                        employeeListModel.data![i].empEmail.toString().text.make().px8(),

                      ],
                    ).py2(),
                  ],
                ),
              )),*/
        );
      },
    );

    /*ListView.builder(
      padding: EdgeInsets.all(6.0),
      itemCount: employeeListModel!.data!.length,
      itemBuilder: (context,i) {
        return SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  empId = employeeListModel!.data![i].empId;
                  print('emPID $empId');
                },
                child: Card(
                  child: CustomListItemTwo(
                    thumbnail: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 9),
                        child: CircleAvatar(
                          backgroundColor: Mythemes.greyish,
                          maxRadius: 40,
                          minRadius: 40,
                          backgroundImage: NetworkImage(employeeListModel.data![i].empPhoto!),
                        ),
                      ),
                    ),

                    title: employeeListModel.data![i].empName as String,
                    subtitle: employeeListModel.data![i].empContactNo as String,
                    author: employeeListModel.data![i].empEmail as String,
                  ),
                ),
              ),
            ],
          ),
        );
      },

    );*/
  }
}
