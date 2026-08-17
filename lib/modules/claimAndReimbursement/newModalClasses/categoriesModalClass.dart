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
        subExpDataList!.add(SubExpDataList.fromJson(v));
      });
    }
    if (json['expenseDataList'] != null) {
      expenseDataList = <ExpenseDataList>[];
      json['expenseDataList'].forEach((v) {
        expenseDataList!.add(ExpenseDataList.fromJson(v));
      });
    }
    if (json['catDataList'] != null) {
      catDataList = <CatDataList>[];
      json['catDataList'].forEach((v) {
        catDataList!.add(CatDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billAllow'] = billAllow;
    if (subExpDataList != null) {
      data['subExpDataList'] =
          subExpDataList!.map((v) => v.toJson()).toList();
    }
    if (expenseDataList != null) {
      data['expenseDataList'] =
          expenseDataList!.map((v) => v.toJson()).toList();
    }
    if (catDataList != null) {
      data['catDataList'] = catDataList!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subExpName'] = subExpName;
    data['isPerkmAllowed'] = isPerkmAllowed;
    data['subExpId'] = subExpId;
    data['expenseId'] = expenseId;
    data['uptoValue'] = uptoValue;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expenseId'] = expenseId;
    data['isOtherAllowed'] = isOtherAllowed;
    data['claimId'] = claimId;
    data['uptoValue'] = uptoValue;
    data['expenseName'] = expenseName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catId'] = catId;
    data['isPerkmAllowed'] = isPerkmAllowed;
    data['catName'] = catName;
    data['subExpId'] = subExpId;
    data['uptoValue'] = uptoValue;
    return data;
  }
}
