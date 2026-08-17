class SalarySlipDownloadModal {
  String? result;
  var empId;
  String? month;
  var salarySlip;
  String? status;

  SalarySlipDownloadModal(
      {this.result, this.empId, this.month, this.salarySlip, this.status});

  SalarySlipDownloadModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    empId = json['empId'];
    month = json['month'];
    salarySlip = json['salarySlip'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['empId'] = empId;
    data['month'] = month;
    data['salarySlip'] = salarySlip;
    data['status'] = status;
    return data;
  }
}
