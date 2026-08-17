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
        list!.add(PreOnboardListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['reason'] = reason;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomineeAadhar'] = nomineeAadhar;
    data['branchName'] = branchName;
    data['ifscCode'] = ifscCode;
    data['reqStatus'] = reqStatus;
    data['id'] = id;
    data['department'] = department;
    data['designationName'] = designationName;
    data['nomineeRelation'] = nomineeRelation;
    data['branch'] = branch;
    data['aadharDocumentFront'] = aadharDocumentFront;
    data['inHandSalary'] = inHandSalary;
    data['aadharDocumentBack'] = aadharDocumentBack;
    data['dateOfJoining'] = dateOfJoining;
    data['nomineeName'] = nomineeName;
    data['status'] = status;
    data['panDocument'] = panDocument;
    data['departmentName'] = departmentName;
    data['contact'] = contact;
    data['accountNo'] = accountNo;
    data['typeOfHire'] = typeOfHire;
    data['designation'] = designation;
    data['fullName'] = fullName;
    data['empPhoto'] = empPhoto;
    data['aadharDocument'] = aadharDocument;
    data['dob'] = dob;
    data['bankName'] = bankName;
    data['aadharNumber'] = aadharNumber;
    data['withAccomodation'] = withAccomodation;
    return data;
  }
}
