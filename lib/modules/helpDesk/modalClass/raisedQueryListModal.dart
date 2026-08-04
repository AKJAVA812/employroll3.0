class RaisedQueryListModal {
  String? status;
  List<DataList>? dataList;

  RaisedQueryListModal({this.status, this.dataList});

  RaisedQueryListModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['dataList'] != null) {
      dataList = <DataList>[];
      json['dataList'].forEach((v) {
        dataList!.add(DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataList != null) {
      data['dataList'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  var level;
  String? queryStatus;
  int? empId;
  List<QueryStatusList>? queryStatusList;
  int? reOpenId;
  bool? isReOpend;
  String? ticketNo;
  String? creationDate;
  String? queryStatusName;
  String? status;
  String? timeAgo;
  int? pid;
  List<PriorityList>? priorityList;
  String? imagePath;
  String? tempStatus;
  int? ticketId;
  String? description;
  String? subject;
  String? priority;

  DataList(
      {this.level,
        this.queryStatus,
        this.empId,
        this.queryStatusList,
        this.reOpenId,
        this.isReOpend,
        this.ticketNo,
        this.creationDate,
        this.queryStatusName,
        this.status,
        this.timeAgo,
        this.pid,
        this.priorityList,
        this.imagePath,
        this.tempStatus,
        this.ticketId,
        this.description,
        this.subject,
        this.priority});

  DataList.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    queryStatus = json['queryStatus'];
    empId = json['empId'];
    if (json['queryStatusList'] != null) {
      queryStatusList = <QueryStatusList>[];
      json['queryStatusList'].forEach((v) {
        queryStatusList!.add(QueryStatusList.fromJson(v));
      });
    }
    reOpenId = json['reOpenId'];
    isReOpend = json['isReOpend'];
    ticketNo = json['ticketNo'];
    creationDate = json['creationDate'];
    queryStatusName = json['queryStatusName'];
    status = json['status'];
    timeAgo = json['timeAgo'];
    pid = json['pid'];
    if (json['priorityList'] != null) {
      priorityList = <PriorityList>[];
      json['priorityList'].forEach((v) {
        priorityList!.add(PriorityList.fromJson(v));
      });
    }
    imagePath = json['imagePath'];
    tempStatus = json['tempStatus'];
    ticketId = json['ticketId'];
    description = json['description'];
    subject = json['subject'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['level'] = this.level;
    data['queryStatus'] = this.queryStatus;
    data['empId'] = this.empId;
    if (this.queryStatusList != null) {
      data['queryStatusList'] =
          this.queryStatusList!.map((v) => v.toJson()).toList();
    }
    data['reOpenId'] = this.reOpenId;
    data['isReOpend'] = this.isReOpend;
    data['ticketNo'] = this.ticketNo;
    data['creationDate'] = this.creationDate;
    data['queryStatusName'] = this.queryStatusName;
    data['status'] = this.status;
    data['timeAgo'] = this.timeAgo;
    data['pid'] = this.pid;
    if (this.priorityList != null) {
      data['priorityList'] = this.priorityList!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = this.imagePath;
    data['tempStatus'] = this.tempStatus;
    data['ticketId'] = this.ticketId;
    data['description'] = this.description;
    data['subject'] = this.subject;
    data['priority'] = this.priority;
    return data;
  }
}

class PriorityList {
  String? name;
  int? id;

  PriorityList({this.name, this.id});

  PriorityList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class QueryStatusList {
  String? name;
  int? id;

  QueryStatusList({this.name, this.id});

  QueryStatusList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
