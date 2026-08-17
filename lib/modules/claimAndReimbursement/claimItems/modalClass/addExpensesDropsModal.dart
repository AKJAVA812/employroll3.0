class AddExpensesDrops {
  bool? billAllow;
  List<SubExpDataList>? subExpDataList;
  bool? isOtherAllowed;
  List<ExpenseDataList>? expenseDataList;
  List<CatDataList>? catDataList;

  AddExpensesDrops(
      {this.billAllow,
        this.subExpDataList,
        this.isOtherAllowed,
        this.expenseDataList,
        this.catDataList});

  AddExpensesDrops.fromJson(Map<String, dynamic> json) {
    billAllow = json['billAllow'];
    if (json['subExpDataList'] != null) {
      subExpDataList = <SubExpDataList>[];
      json['subExpDataList'].forEach((v) {
        subExpDataList!.add(SubExpDataList.fromJson(v));
      });
    }
    isOtherAllowed = json['isOtherAllowed'];
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
    data['isOtherAllowed'] = isOtherAllowed;
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
  var isPerkmAllowed;
  int? subExpId;
  int? expenseId;

  SubExpDataList(
      {this.subExpName, this.isPerkmAllowed, this.subExpId, this.expenseId});

  SubExpDataList.fromJson(Map<String, dynamic> json) {
    subExpName = json['subExpName'];
    isPerkmAllowed = json['isPerkmAllowed'];
    subExpId = json['subExpId'];
    expenseId = json['expenseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subExpName'] = subExpName;
    data['isPerkmAllowed'] = isPerkmAllowed;
    data['subExpId'] = subExpId;
    data['expenseId'] = expenseId;
    return data;
  }
}

class ExpenseDataList {
  int? expenseId;
  bool? isOtherAllowed;
  int? claimId;
  String? expenseName;

  ExpenseDataList(
      {this.expenseId, this.isOtherAllowed, this.claimId, this.expenseName});

  ExpenseDataList.fromJson(Map<String, dynamic> json) {
    expenseId = json['expenseId'];
    isOtherAllowed = json['isOtherAllowed'];
    claimId = json['claimId'];
    expenseName = json['expenseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expenseId'] = expenseId;
    data['isOtherAllowed'] = isOtherAllowed;
    data['claimId'] = claimId;
    data['expenseName'] = expenseName;
    return data;
  }
}

class CatDataList {
  int? catId;
  var isPerkmAllowed;
  String? catName;
  int? subExpId;

  CatDataList({this.catId, this.isPerkmAllowed, this.catName, this.subExpId});

  CatDataList.fromJson(Map<String, dynamic> json) {
    catId = json['catId'];
    isPerkmAllowed = json['isPerkmAllowed'];
    catName = json['catName'];
    subExpId = json['subExpId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catId'] = catId;
    data['isPerkmAllowed'] = isPerkmAllowed;
    data['catName'] = catName;
    data['subExpId'] = subExpId;
    return data;
  }
}
