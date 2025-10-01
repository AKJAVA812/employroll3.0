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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['empId'] = this.empId;
    data['month'] = this.month;
    data['salarySlip'] = this.salarySlip;
    data['status'] = this.status;
    return data;
  }
}
