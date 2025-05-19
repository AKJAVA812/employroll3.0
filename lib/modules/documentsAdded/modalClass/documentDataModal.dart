class DocumentDataModal {
  List<Data>? data;

  DocumentDataModal({this.data});

  DocumentDataModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? empId;
  String? code;
  String? document;
  String? dept;
  String? branch;
  String? empCode;
  String? empName;
  String? letter;
  String? name;
  String? id;
  String? designation;
  String? department;
  String? doj;

  Data(
      {this.empId,
        this.code,
        this.document,
        this.dept,
        this.branch,
        this.empCode,
        this.empName,
        this.letter,
        this.name,
        this.id,
        this.designation,
        this.department,
        this.doj});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    code = json['code'];
    document = json['document'];
    dept = json['dept'];
    branch = json['branch'];
    empCode = json['empCode'];
    empName = json['empName'];
    letter = json['letter'];
    name = json['name'];
    id = json['id'];
    designation = json['designation'];
    department = json['department'];
    doj = json['doj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['code'] = this.code;
    data['document'] = this.document;
    data['dept'] = this.dept;
    data['branch'] = this.branch;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['letter'] = this.letter;
    data['name'] = this.name;
    data['id'] = this.id;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['doj'] = this.doj;
    return data;
  }
}
