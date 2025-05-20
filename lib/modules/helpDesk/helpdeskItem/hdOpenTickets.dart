import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';

class HDOpenTickets extends StatefulWidget {
  const HDOpenTickets({Key? key}) : super(key: key);

  @override
  State<HDOpenTickets> createState() => _HDOpenTicketsState();
}

class _HDOpenTicketsState extends State<HDOpenTickets> {
  @override
  Widget build(BuildContext context) {
    var titleName = "Open Tickets";
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),
      /*actions: [
        IconButton(
            onPressed: () {
              showSearch(
                context: context, delegate: SearchItems(),
              );

            }, icon: Icon(Icons.search))
      ],*/
      body: Material(
        color: Mythemes.whitish,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: DataTable2(
            columnSpacing: 2,
            horizontalMargin: 0,
            minWidth: 800,
            dataRowHeight: 60,
            columns: [
              DataColumn2(
                label: Center(
                  child: "Case No.".text.bold.center.make(),
                ),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Center(
                  child: "Case Title".text.bold.center.make(),
                ),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Center(
                  child: "Client".text.bold.center.make(),
                ),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Center(
                  child: "Created On".text.bold.center.make(),
                ),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Center(
                  child: "Closure Date".text.bold.center.make(),
                ),
                size: ColumnSize.L,
              ),

              DataColumn2(
                label: Center(
                  child: "Raised To".text.bold.center.make(),
                ),
                size: ColumnSize.L,
              ),
            ],
            rows: List<DataRow>.generate(
              20,
                  (index) => DataRow(cells: [
                DataCell(
                    Center(
                      child:  Text('627738'),
                    )
                ),
                DataCell(
                    Center(
                      child:  Text('Leave Management/Technical Query', overflow: TextOverflow.ellipsis, maxLines: 2,),
                    )
                ),
                DataCell(
                    Center(
                      child:  Text('Thumbmatic Solutions Private Limited.', overflow: TextOverflow.ellipsis, maxLines: 2,),
                    )
                ),
                DataCell(
                    Center(
                      child:  Text('2021-07-26',),
                    )
                ),
                DataCell(
                    Center(
                      child:  Text('-', overflow: TextOverflow.ellipsis, maxLines: 2,),
                    )
                ),

                DataCell(
                    Center(
                      child:  Text('Bharat Rajora (THM0057)', overflow: TextOverflow.ellipsis, maxLines: 2,),
                    )
                ),
              ]),

            ),
          ),
        ),
      )
    );

  }
}

class GetOpenTickets extends StatefulWidget {
  const GetOpenTickets({Key? key}) : super(key: key);

  @override
  State<GetOpenTickets> createState() => _GetOpenTicketsState();
}

class _GetOpenTicketsState extends State<GetOpenTickets> {
  bool isExpanded = false;
  var createdOn = "12-05-2022";
  void expandTile() {
    setState(() {
      isExpanded = true;
      // keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      isExpanded = false;
      // keyTile = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, itemCount) {
              return Card(
                child: ExpansionTile(
                  //key: keyTile,
                  initiallyExpanded: isExpanded,
                  childrenPadding: EdgeInsets.all(16).copyWith(top: 0),

                  title: "Android Mobile(Tracking)/Technical Query"
                      .text.maxLines(1).size(18)
                      .make(),
                  subtitle: "Created On - $createdOn"
                      .text
                      .make(),
                  children: [
                    Row(
                        children: [
                          "Case No.".text.make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  "627738".text.make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),
                    Row(
                        children: [
                          "Client : ".text.make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  "Thumbmatic Solutions Private Limited".text.make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),
                    Row(
                        children: [
                          "Closure Date : ".text.make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  "12-02-2022".text.make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),
                    Row(
                        children: [
                          "Status : ".text.make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  "Open".text.make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),
                    Row(
                        children: [
                          "Raised To : ".text.make(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  "Bharat Rajora (THUMB0057)".text.make().px8(),
                                ],
                              )

                          )
                        ]
                    ).pLTRB(0, 0, 0, 8.0),
                  ],
                ),
              ).p2();
            }
        )
    );
  }
}

class SearchItems extends SearchDelegate {

  List<String> searchTerms = [

  ];
  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}