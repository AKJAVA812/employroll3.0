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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (dataList != null) {
      data['dataList'] = dataList!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['queryStatus'] = queryStatus;
    data['empId'] = empId;
    if (queryStatusList != null) {
      data['queryStatusList'] =
          queryStatusList!.map((v) => v.toJson()).toList();
    }
    data['reOpenId'] = reOpenId;
    data['isReOpend'] = isReOpend;
    data['ticketNo'] = ticketNo;
    data['creationDate'] = creationDate;
    data['queryStatusName'] = queryStatusName;
    data['status'] = status;
    data['timeAgo'] = timeAgo;
    data['pid'] = pid;
    if (priorityList != null) {
      data['priorityList'] = priorityList!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = imagePath;
    data['tempStatus'] = tempStatus;
    data['ticketId'] = ticketId;
    data['description'] = description;
    data['subject'] = subject;
    data['priority'] = priority;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
