class CategoriesModalClass {
  bool? billAllow;
  List<SubExpDataList>? subExpDataList;
  List<ExpenseDataList>? expenseDataList;
  List<CatDataList>? catDataList;

  CategoriesModalClass(
      {this.billAllow,
        this.subExpDataList,
        this.expenseDataList,
        this.catDataList});

  CategoriesModalClass.fromJson(Map<String, dynamic> json) {
    billAllow = json['billAllow'];
    if (json['subExpDataList'] != null) {
      subExpDataList = <SubExpDataList>[];
      json['subExpDataList'].forEach((v) {
        subExpDataList!.add(new SubExpDataList.fromJson(v));
      });
    }
    if (json['expenseDataList'] != null) {
      expenseDataList = <ExpenseDataList>[];
      json['expenseDataList'].forEach((v) {
        expenseDataList!.add(new ExpenseDataList.fromJson(v));
      });
    }
    if (json['catDataList'] != null) {
      catDataList = <CatDataList>[];
      json['catDataList'].forEach((v) {
        catDataList!.add(new CatDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billAllow'] = this.billAllow;
    if (this.subExpDataList != null) {
      data['subExpDataList'] =
          this.subExpDataList!.map((v) => v.toJson()).toList();
    }
    if (this.expenseDataList != null) {
      data['expenseDataList'] =
          this.expenseDataList!.map((v) => v.toJson()).toList();
    }
    if (this.catDataList != null) {
      data['catDataList'] = this.catDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubExpDataList {
  String? subExpName;
  bool? isPerkmAllowed;
  dynamic subExpId;
  dynamic expenseId;
  dynamic uptoValue;

  SubExpDataList(
      {this.subExpName,
        this.isPerkmAllowed,
        this.subExpId,
        this.expenseId,
        this.uptoValue});

  SubExpDataList.fromJson(Map<String, dynamic> json) {
    subExpName = json['subExpName'];
    isPerkmAllowed = json['isPerkmAllowed'];
    subExpId = json['subExpId'];
    expenseId = json['expenseId'];
    uptoValue = json['uptoValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subExpName'] = this.subExpName;
    data['isPerkmAllowed'] = this.isPerkmAllowed;
    data['subExpId'] = this.subExpId;
    data['expenseId'] = this.expenseId;
    data['uptoValue'] = this.uptoValue;
    return data;
  }
}

class ExpenseDataList {
  dynamic expenseId;
  dynamic isOtherAllowed;
  dynamic claimId;
  dynamic uptoValue;
  dynamic expenseName;

  ExpenseDataList(
      {this.expenseId,
        this.isOtherAllowed,
        this.claimId,
        this.uptoValue,
        this.expenseName});

  ExpenseDataList.fromJson(Map<String, dynamic> json) {
    expenseId = json['expenseId'];
    isOtherAllowed = json['isOtherAllowed'];
    claimId = json['claimId'];
    uptoValue = json['uptoValue'];
    expenseName = json['expenseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expenseId'] = this.expenseId;
    data['isOtherAllowed'] = this.isOtherAllowed;
    data['claimId'] = this.claimId;
    data['uptoValue'] = this.uptoValue;
    data['expenseName'] = this.expenseName;
    return data;
  }
}

class CatDataList {
  dynamic catId;
  dynamic isPerkmAllowed;
  dynamic catName;
  dynamic subExpId;
  dynamic uptoValue;

  CatDataList(
      {this.catId,
        this.isPerkmAllowed,
        this.catName,
        this.subExpId,
        this.uptoValue});

  CatDataList.fromJson(Map<String, dynamic> json) {
    catId = json['catId'];
    isPerkmAllowed = json['isPerkmAllowed'];
    catName = json['catName'];
    subExpId = json['subExpId'];
    uptoValue = json['uptoValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['isPerkmAllowed'] = this.isPerkmAllowed;
    data['catName'] = this.catName;
    data['subExpId'] = this.subExpId;
    data['uptoValue'] = this.uptoValue;
    return data;
  }
}
