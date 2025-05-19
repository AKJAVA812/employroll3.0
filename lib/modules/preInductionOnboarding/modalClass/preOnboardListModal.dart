class PreOnboardListModal {
  String? result;
  String? reason;
  List<PreOnboardListData>? list;

  PreOnboardListModal({this.result, this.reason, this.list});

  PreOnboardListModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    reason = json['reason'];
    if (json['list'] != null) {
      list = <PreOnboardListData>[];
      json['list'].forEach((v) {
        list!.add(new PreOnboardListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['reason'] = this.reason;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PreOnboardListData {
  String? nomineeAadhar;
  String? branchName;
  String? ifscCode;
  String? reqStatus;
  int? id;
  String? department;
  String? designationName;
  String? nomineeRelation;
  String? branch;
  String? aadharDocumentFront;
  int? inHandSalary;
  String? aadharDocumentBack;
  String? dateOfJoining;
  String? nomineeName;
  String? status;
  String? panDocument;
  String? departmentName;
  String? contact;
  String? accountNo;
  String? typeOfHire;
  String? designation;
  String? fullName;
  String? empPhoto;
  String? aadharDocument;
  String? dob;
  String? bankName;
  String? aadharNumber;
  bool? withAccomodation;

  PreOnboardListData(
      {this.nomineeAadhar,
        this.branchName,
        this.ifscCode,
        this.reqStatus,
        this.id,
        this.department,
        this.designationName,
        this.nomineeRelation,
        this.branch,
        this.aadharDocumentFront,
        this.inHandSalary,
        this.aadharDocumentBack,
        this.dateOfJoining,
        this.nomineeName,
        this.status,
        this.panDocument,
        this.departmentName,
        this.contact,
        this.accountNo,
        this.typeOfHire,
        this.designation,
        this.fullName,
        this.empPhoto,
        this.aadharDocument,
        this.dob,
        this.bankName,
        this.aadharNumber,
        this.withAccomodation});

  PreOnboardListData.fromJson(Map<String, dynamic> json) {
    nomineeAadhar = json['nomineeAadhar'];
    branchName = json['branchName'];
    ifscCode = json['ifscCode'];
    reqStatus = json['reqStatus'];
    id = json['id'];
    department = json['department'];
    designationName = json['designationName'];
    nomineeRelation = json['nomineeRelation'];
    branch = json['branch'];
    aadharDocumentFront = json['aadharDocumentFront'];
    inHandSalary = json['inHandSalary'];
    aadharDocumentBack = json['aadharDocumentBack'];
    dateOfJoining = json['dateOfJoining'];
    nomineeName = json['nomineeName'];
    status = json['status'];
    panDocument = json['panDocument'];
    departmentName = json['departmentName'];
    contact = json['contact'];
    accountNo = json['accountNo'];
    typeOfHire = json['typeOfHire'];
    designation = json['designation'];
    fullName = json['fullName'];
    empPhoto = json['empPhoto'];
    aadharDocument = json['aadharDocument'];
    dob = json['dob'];
    bankName = json['bankName'];
    aadharNumber = json['aadharNumber'];
    withAccomodation = json['withAccomodation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomineeAadhar'] = this.nomineeAadhar;
    data['branchName'] = this.branchName;
    data['ifscCode'] = this.ifscCode;
    data['reqStatus'] = this.reqStatus;
    data['id'] = this.id;
    data['department'] = this.department;
    data['designationName'] = this.designationName;
    data['nomineeRelation'] = this.nomineeRelation;
    data['branch'] = this.branch;
    data['aadharDocumentFront'] = this.aadharDocumentFront;
    data['inHandSalary'] = this.inHandSalary;
    data['aadharDocumentBack'] = this.aadharDocumentBack;
    data['dateOfJoining'] = this.dateOfJoining;
    data['nomineeName'] = this.nomineeName;
    data['status'] = this.status;
    data['panDocument'] = this.panDocument;
    data['departmentName'] = this.departmentName;
    data['contact'] = this.contact;
    data['accountNo'] = this.accountNo;
    data['typeOfHire'] = this.typeOfHire;
    data['designation'] = this.designation;
    data['fullName'] = this.fullName;
    data['empPhoto'] = this.empPhoto;
    data['aadharDocument'] = this.aadharDocument;
    data['dob'] = this.dob;
    data['bankName'] = this.bankName;
    data['aadharNumber'] = this.aadharNumber;
    data['withAccomodation'] = this.withAccomodation;
    return data;
  }
}
