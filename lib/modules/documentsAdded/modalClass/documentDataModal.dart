class DocumentDataModal {
  List<Data>? data;

  DocumentDataModal({this.data});

  DocumentDataModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['code'] = code;
    data['document'] = document;
    data['dept'] = dept;
    data['branch'] = branch;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['letter'] = letter;
    data['name'] = name;
    data['id'] = id;
    data['designation'] = designation;
    data['department'] = department;
    data['doj'] = doj;
    return data;
  }
}
