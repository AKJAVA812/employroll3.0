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
        subExpDataList!.add(new SubExpDataList.fromJson(v));
      });
    }
    isOtherAllowed = json['isOtherAllowed'];
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
    data['isOtherAllowed'] = this.isOtherAllowed;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subExpName'] = this.subExpName;
    data['isPerkmAllowed'] = this.isPerkmAllowed;
    data['subExpId'] = this.subExpId;
    data['expenseId'] = this.expenseId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expenseId'] = this.expenseId;
    data['isOtherAllowed'] = this.isOtherAllowed;
    data['claimId'] = this.claimId;
    data['expenseName'] = this.expenseName;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['isPerkmAllowed'] = this.isPerkmAllowed;
    data['catName'] = this.catName;
    data['subExpId'] = this.subExpId;
    return data;
  }
}
