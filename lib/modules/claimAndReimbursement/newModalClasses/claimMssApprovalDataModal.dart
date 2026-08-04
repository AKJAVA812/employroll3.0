class ClaimMssApprovalDataModal {
  List<Data>? data;

  ClaimMssApprovalDataModal({this.data});

  ClaimMssApprovalDataModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  dynamic fromPlace;
  dynamic subexpenseId;
  dynamic odoMeter;
  dynamic levelFiveAppAmt;
  dynamic categoryName;
  dynamic claimAMount;
  dynamic toPlace;
  dynamic levelOneappAmt;
  dynamic subExpname;
  dynamic levelTFourAppAmt;
  dynamic image;
  dynamic expName;
  dynamic levelFourRemarks;
  dynamic levelOneRemarks;
  dynamic startReading;
  dynamic merchant;
  dynamic claimId;
  dynamic isImage;
  dynamic levelTwoRemarks;
  dynamic isCheck;
  dynamic month;
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
        this.fromPlace,
        this.subexpenseId,
        this.odoMeter,
        this.levelFiveAppAmt,
        this.categoryName,
        this.claimAMount,
        this.toPlace,
        this.levelOneappAmt,
        this.subExpname,
        this.levelTFourAppAmt,
        this.image,
        this.expName,
        this.levelFourRemarks,
        this.levelOneRemarks,
        this.startReading,
        this.merchant,
        this.claimId,
        this.isImage,
        this.levelTwoRemarks,
        this.isCheck,
        this.month,
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
    fromPlace = json['fromPlace'];
    subexpenseId = json['subexpenseId'];
    odoMeter = json['odoMeter'];
    levelFiveAppAmt = json['levelFiveAppAmt'];
    categoryName = json['categoryName'];
    claimAMount = json['claimAMount'];
    toPlace = json['toPlace'];
    levelOneappAmt = json['levelOneappAmt'];
    subExpname = json['subExpname'];
    levelTFourAppAmt = json['levelTFourAppAmt'];
    image = json['image'];
    expName = json['expName'];
    levelFourRemarks = json['levelFourRemarks'];
    levelOneRemarks = json['levelOneRemarks'];
    startReading = json['startReading'];
    merchant = json['merchant'];
    claimId = json['claimId'];
    isImage = json['isImage'];
    levelTwoRemarks = json['levelTwoRemarks'];
    isCheck = json['isCheck'];
    month = json['month'];
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['claimNo'] = this.claimNo;
    data['levelThreeappAmt'] = this.levelThreeappAmt;
    data['reimburName'] = this.reimburName;
    data['endReading'] = this.endReading;
    data['fromPlace'] = this.fromPlace;
    data['subexpenseId'] = this.subexpenseId;
    data['odoMeter'] = this.odoMeter;
    data['levelFiveAppAmt'] = this.levelFiveAppAmt;
    data['categoryName'] = this.categoryName;
    data['claimAMount'] = this.claimAMount;
    data['toPlace'] = this.toPlace;
    data['levelOneappAmt'] = this.levelOneappAmt;
    data['subExpname'] = this.subExpname;
    data['levelTFourAppAmt'] = this.levelTFourAppAmt;
    data['image'] = this.image;
    data['expName'] = this.expName;
    data['levelFourRemarks'] = this.levelFourRemarks;
    data['levelOneRemarks'] = this.levelOneRemarks;
    data['startReading'] = this.startReading;
    data['merchant'] = this.merchant;
    data['claimId'] = this.claimId;
    data['isImage'] = this.isImage;
    data['levelTwoRemarks'] = this.levelTwoRemarks;
    data['isCheck'] = this.isCheck;
    data['month'] = this.month;
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
