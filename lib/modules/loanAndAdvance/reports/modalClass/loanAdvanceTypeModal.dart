class LoanTypeListModal {
  List<Loandata>? loandata;

  LoanTypeListModal({this.loandata});

  LoanTypeListModal.fromJson(Map<String, dynamic> json) {
    if (json['loandata'] != null) {
      loandata = <Loandata>[];
      json['loandata'].forEach((v) {
        loandata!.add(Loandata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loandata != null) {
      data['loandata'] = loandata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Loandata {
  String? loanName;
  String? loanId;
  String? status;

  Loandata({this.loanName, this.loanId, this.status});

  Loandata.fromJson(Map<String, dynamic> json) {
    loanName = json['loanName'];
    loanId = json['loanId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loanName'] = loanName;
    data['loanId'] = loanId;
    data['status'] = status;
    return data;
  }
}
