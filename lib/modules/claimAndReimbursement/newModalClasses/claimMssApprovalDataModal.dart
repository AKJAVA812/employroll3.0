class ClaimMssApprovalDataModal {
  List<Data>? data;

  ClaimMssApprovalDataModal({this.data});

  ClaimMssApprovalDataModal.fromJson(Map<String, dynamic> json) {
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
  dynamic date;
  dynamic claimNo;
  dynamic levelThreeappAmt;
  dynamic reimburName;
  dynamic endReading;
  dynamic subexpenseId;
  dynamic odoMeter;
  dynamic levelFiveAppAmt;
  dynamic categoryName;
  dynamic claimAMount;
  dynamic levelOneappAmt;
  dynamic subExpname;
  dynamic levelTFourAppAmt;
  dynamic image;
  dynamic expName;
  dynamic levelFourRemarks;
  dynamic levelOneRemarks;
  dynamic startReading;
  dynamic claimId;
  bool? isImage;
  dynamic levelTwoRemarks;
  bool? isCheck;
  dynamic levelFiveRemarks;
  dynamic expenseId;
  dynamic kilometer;
  dynamic reimbId;
  dynamic levelTwoappAmt;
  dynamic levelThreeRemarks;
  dynamic categoryId;
  dynamic remarks;

  Data(
      {this.date,
        this.claimNo,
        this.levelThreeappAmt,
        this.reimburName,
        this.endReading,
        this.subexpenseId,
        this.odoMeter,
        this.levelFiveAppAmt,
        this.categoryName,
        this.claimAMount,
        this.levelOneappAmt,
        this.subExpname,
        this.levelTFourAppAmt,
        this.image,
        this.expName,
        this.levelFourRemarks,
        this.levelOneRemarks,
        this.startReading,
        this.claimId,
        this.isImage,
        this.levelTwoRemarks,
        this.isCheck,
        this.levelFiveRemarks,
        this.expenseId,
        this.kilometer,
        this.reimbId,
        this.levelTwoappAmt,
        this.levelThreeRemarks,
        this.categoryId,
        this.remarks});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    claimNo = json['claimNo'];
    levelThreeappAmt = json['levelThreeappAmt'];
    reimburName = json['reimburName'];
    endReading = json['endReading'];
    subexpenseId = json['subexpenseId'];
    odoMeter = json['odoMeter'];
    levelFiveAppAmt = json['levelFiveAppAmt'];
    categoryName = json['categoryName'];
    claimAMount = json['claimAMount'];
    levelOneappAmt = json['levelOneappAmt'];
    subExpname = json['subExpname'];
    levelTFourAppAmt = json['levelTFourAppAmt'];
    image = json['image'];
    expName = json['expName'];
    levelFourRemarks = json['levelFourRemarks'];
    levelOneRemarks = json['levelOneRemarks'];
    startReading = json['startReading'];
    claimId = json['claimId'];
    isImage = json['isImage'];
    levelTwoRemarks = json['levelTwoRemarks'];
    isCheck = json['isCheck'];
    levelFiveRemarks = json['levelFiveRemarks'];
    expenseId = json['expenseId'];
    kilometer = json['kilometer'];
    reimbId = json['reimbId'];
    levelTwoappAmt = json['levelTwoappAmt'];
    levelThreeRemarks = json['levelThreeRemarks'];
    categoryId = json['categoryId'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['claimNo'] = this.claimNo;
    data['levelThreeappAmt'] = this.levelThreeappAmt;
    data['reimburName'] = this.reimburName;
    data['endReading'] = this.endReading;
    data['subexpenseId'] = this.subexpenseId;
    data['odoMeter'] = this.odoMeter;
    data['levelFiveAppAmt'] = this.levelFiveAppAmt;
    data['categoryName'] = this.categoryName;
    data['claimAMount'] = this.claimAMount;
    data['levelOneappAmt'] = this.levelOneappAmt;
    data['subExpname'] = this.subExpname;
    data['levelTFourAppAmt'] = this.levelTFourAppAmt;
    data['image'] = this.image;
    data['expName'] = this.expName;
    data['levelFourRemarks'] = this.levelFourRemarks;
    data['levelOneRemarks'] = this.levelOneRemarks;
    data['startReading'] = this.startReading;
    data['claimId'] = this.claimId;
    data['isImage'] = this.isImage;
    data['levelTwoRemarks'] = this.levelTwoRemarks;
    data['isCheck'] = this.isCheck;
    data['levelFiveRemarks'] = this.levelFiveRemarks;
    data['expenseId'] = this.expenseId;
    data['kilometer'] = this.kilometer;
    data['reimbId'] = this.reimbId;
    data['levelTwoappAmt'] = this.levelTwoappAmt;
    data['levelThreeRemarks'] = this.levelThreeRemarks;
    data['categoryId'] = this.categoryId;
    data['remarks'] = this.remarks;
    return data;
  }
}
