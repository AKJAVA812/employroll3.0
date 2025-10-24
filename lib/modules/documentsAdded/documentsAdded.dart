import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../sharedPrefancePage/ShardPre.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/homePage.dart';
import '../../themes/empThemes.dart';
import 'downloadLetter.dart';
import 'modalClass/documentListModal.dart';


class DocumentsAdded extends StatefulWidget {
  const DocumentsAdded({Key? key}) : super(key: key);

  @override
  State<DocumentsAdded> createState() => _DocumentsAddedState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
var docId;
var docName;
class _DocumentsAddedState extends State<DocumentsAdded> {
  List<MappedData>? allUsernew=[];
  List<MappedData>? foundDataNew=[];
  DocumentListModal? documentListGlobal;
  DocumentListModal? documentListGlobaled;

  @override
  void initState() {
    getSharedPrfanceList();
    setState(() {
    });
    // TODO: implement initState
    super.initState();
  }
  var empIdCheck;
  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    empIdCheck = await shared!.getEmpId();
    print("EMPID - $empIdCheck");
    Future<DocumentListModal> getEmployeeList11 = getDocuments(sessionId!);
    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        documentListGlobal=value;
        documentListGlobaled=documentListGlobal;
      });
      print('employeeList00${documentListGlobal!.mappedData!.length}');
    });

  }
  var titleName = 'My Documents';

  Future<DocumentListModal> getDocuments(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.documentListApi;
    print('employeeList11: ${SessionId}');
    DocumentListModal documentListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await http.post(urlapi);
    print('URL ${response.request}');

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['mappedData'];
    print('responseemployeeList $getData');
    documentListModal=DocumentListModal.fromJson(mapResponse);
    allUsernew = documentListModal.mappedData;

    return documentListModal;
  }
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<MappedData>?  results = [];

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
          element.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
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
  int pageIndex = 0;
  int currentIndex = 3;
  TextEditingController searchType = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body:
      documentListGlobaled == null ?
      Center(child: CircularProgressIndicator()):

      Container(
          padding: EdgeInsets.all(8.0),
          child:
          Hero(tag: 'e-doc', child:
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
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: foundDataNew!.length,
                    itemBuilder: (context, i) {
                      return   Card(
                        elevation: 3,
                        child:
                        ListTile(
                          onTap: (){
                            setState(() {
                              docId = foundDataNew![i].id.toString();
                              docName = foundDataNew![i].name.toString();
                              print("DOC ID - $docId");
                              // _isVisible = !_isVisible;
                            });
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                DownloadLetters(docId, docName)));
                          },
                          leading:  Icon(
                            CupertinoIcons.doc_text_search, size: 30,
                          ),

                          title: foundDataNew![i].name.toString().text.make(),
                          trailing:  Icon(
                              CupertinoIcons.chevron_forward
                          ),

                        ),
                      );
                    }
                ),

                /*Card(
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
                          CupertinoIcons.doc_append, size: 30,
                        ),

                        title: "ESIC Certificate".text.make(),
                        trailing:  Icon(
                            CupertinoIcons.chevron_forward
                        ),

                      ),
                    ),*/
              ],

            ),
          )
          )

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
            //Navigator.pushNamed(context, MyRoutings.projectListRoute);
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            print('Dashboard');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);
            print('Reports');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);
            print('e-Doc');
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
            icon: Icon(Icons.dashboard_customize),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_exploration_outlined),
            label: 'Reports',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text_search),
            label: 'e-Doc',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
