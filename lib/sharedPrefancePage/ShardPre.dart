import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  late SharedPreferences sharedPreferences;

  late Context context;

  /* SessionManager(Context context) async {
    this.context = context;
    sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.

  }*/

  /*  setSessionId(sessionId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('sessionId', sessionId);
  }*/

  setSessionId(sessionId) async {
    // Obtain shared preferences.
    sharedPreferences = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await sharedPreferences.setString('sessionId', sessionId);
  }

  /* getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sessionId = prefs.getString('sessionId');
    return sessionId;
  }
*/
  getSessionId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? sessionId = sharedPreferences.getString('sessionId');
    return sessionId;
  }

  setName(empName) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('empName', empName);
  }

  getempName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empName = prefs.getString('empName');
    return empName;
  }

  setEmpId(empId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setInt('empId', empId);
  }

  getEmpId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? empId = prefs.getInt('empId');
    return empId;
  }
  setUserType(userType) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('userType', userType);
  }

  getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userType = prefs.getString('userType');
    return userType;
  }

  setEmpCode(empCode) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('empCode', empCode);
  }

  getEmpCode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empCode = prefs.getString('empCode');
    return empCode;
  }

  setOrgId(orgId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setInt('orgId', orgId);
  }

  getOrgId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? orgId = prefs.getInt('orgId');
    return orgId;
  }

  setShowPayroll(showPayroll) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setBool('showPayroll', showPayroll);
  }

  getShowPayroll() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? showPayroll = prefs.getBool('showPayroll');
    return showPayroll;
  }
  setOrgName(orgName) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('orgName', orgName);
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? orgName = prefs.getString('orgName');
    return orgName;
  }
  setDept(department) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('department', department);
  }

  getDept() async {
    final prefs = await SharedPreferences.getInstance();
    final String? department = prefs.getString('department');
    return department;
  }

  setProfileImage(proImage) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('proImage', proImage);
  }

  getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? proImage = prefs.getString('proImage');
    return proImage;
  }

  setDob(dateOfBirth) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('dateOfBirth', dateOfBirth);
  }

  getDob() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dateOfBirth = prefs.getString('dateOfBirth');
    return dateOfBirth;
  }
  setEmailid(emailId) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailId', emailId);
  }

  getEmailId() async{
    final prefs = await SharedPreferences.getInstance();
    final String? emailId=prefs.getString('emailId');
    return emailId;
  }
  setMobileNo(mobileNo) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileNO', mobileNo);
  }
  getMobileNo() async{
    final prefs = await SharedPreferences.getInstance();
    final String? mobileNo=prefs.getString('mobileNO');
    return mobileNo;
  }

  setAttAction(attAction) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('attAction', attAction);
  }
  getAttAction() async{
    final prefs = await SharedPreferences.getInstance();
    final String? attAction=prefs.getString('attAction');
    return attAction;
  }

  setMobAttAction(mobAttActions) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobAction', mobAttActions);
  }
  getMobAttAction() async{
    final prefs = await SharedPreferences.getInstance();
    final String? mobAttActions=prefs.getString('mobAction');
    return mobAttActions;
  }
  setMobTrackTime(time) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('time', time);
  }
  getMobTrackTime() async{
    final prefs = await SharedPreferences.getInstance();
    final String? time=prefs.getString('time');
    return time;
  }

  setDesignation(designation) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('designation', designation);
  }
  getDesignation() async{
    final prefs = await SharedPreferences.getInstance();
    final String? designation=prefs.getString('designation');
    return designation;
  }
  setBranch(branch) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('branch', branch);
  }
  getBranch() async{
    final prefs = await SharedPreferences.getInstance();
    final String? branch=prefs.getString('branch');
    return branch;
  }
  setAadhar(aadharNo) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadharNo', aadharNo);
  }
  getAadhar() async{
    final prefs = await SharedPreferences.getInstance();
    final String? aadharNo=prefs.getString('aadharNo');
    return aadharNo;
  }
  setPfNo(pfNo) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pfNo', pfNo);
  }
  getPfNo() async{
    final prefs = await SharedPreferences.getInstance();
    final String? pfNo=prefs.getString('pfNo');
    return pfNo;
  }
  setEsicNo(esicNo) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('esicNo', esicNo);
  }
  getEsicNo() async{
    final prefs = await SharedPreferences.getInstance();
    final String? esicNo=prefs.getString('esicNo');
    return esicNo;
  }
  setBankName(bankName) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bankName', bankName);
  }
  getBankName() async{
    final prefs = await SharedPreferences.getInstance();
    final String? bankName=prefs.getString('bankName');
    return bankName;
  }
  setBankAcc(bankAccNo) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bankAccNo', bankAccNo);
  }
  getBankAcc() async{
    final prefs = await SharedPreferences.getInstance();
    final String? bankAccNo=prefs.getString('bankAccNo');
    return bankAccNo;
  }
  setIfscCode(ifscCode) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ifscCode', ifscCode);
  }
  getIfscCode() async{
    final prefs = await SharedPreferences.getInstance();
    final String? ifscCode=prefs.getString('ifscCode');
    return ifscCode;
  }
  setLatitude(latitude) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
  }
  getLatitude() async{
    final prefs = await SharedPreferences.getInstance();
    final double? latitude=prefs.getDouble('latitude');
    return latitude;
  }

  setLongitude(Longitude) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('Longitude', Longitude);
  }

  getLongitude() async{
    final prefs = await SharedPreferences.getInstance();
    final double? Longitude=prefs.getDouble('Longitude');
    return Longitude;
  }

  setFirebaseTokenId(firebaseTokenId) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebaseTokenId', firebaseTokenId);
  }

  getfirebaseTokenId() async{
    final prefs = await SharedPreferences.getInstance();
    final String? firebaseTokenId=prefs.getString('firebaseTokenId');
    return firebaseTokenId;
  }

  setDataClear() async {
    final prefs = await SharedPreferences.getInstance();
  }

  setEmpRoll(empRole) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('empRole', empRole);
  }
  getEmpRoll() async{
    final prefs = await SharedPreferences.getInstance();
    final int? empRole=prefs.getInt('empRole');
    return empRole;
  }
  setRoRoll(roRole) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('roRole', roRole);
  }
  getRoRole() async{
    final prefs = await SharedPreferences.getInstance();
    final int? roRole=prefs.getInt('roRole');
    return roRole;
  }

  setAdminRole(adminrole) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('adminrole', adminrole);
  }
  getAdminRole() async{
    final prefs = await SharedPreferences.getInstance();
    final int? adminrole=prefs.getInt('adminrole');
    return adminrole;
  }

  setMobAction(mobAction) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mobAction', mobAction);
  }
  getMobAction() async{
    final prefs = await SharedPreferences.getInstance();
    final int? mobAction=prefs.getInt('mobAction');
    return mobAction;
  }

  setDoj(doj) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('doj', doj);
  }
  getDoj() async{
    final prefs = await SharedPreferences.getInstance();
    final String? doj=prefs.getString('doj');
    return doj;
  }


  setUserRoles(userRoles) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRoles',userRoles);
  }

  getUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userRoles = prefs.getString('userRoles');
    return userRoles;
  }

  setLevelOne(levelOne) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('levelOne', levelOne);
  }

  getLevelOne() async {
    final prefs = await SharedPreferences.getInstance();
    final String? levelOne = prefs.getString('levelOne');
    return levelOne;
  }

  setLevelTwo(levelTwo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('levelTwo', levelTwo);
  }

  getLevelTwo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? levelTwo = prefs.getString('levelTwo');
    return levelTwo;
  }

  setClaimLevelOne(claimLevelOne) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelOne', claimLevelOne);
  }

  getClaimLevelOne() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelOne = prefs.getString('claimLevelOne');
    return claimLevelOne;
  }

  setClaimLevelTwo(claimLevelTwo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelTwo', claimLevelTwo);
  }

  getClaimLevelTwo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelTwo = prefs.getString('claimLevelTwo');
    return claimLevelTwo;
  }

  setClaimLevelThree(claimLevelThree) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelThree', claimLevelThree);
  }

  getClaimLevelThree() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelThree = prefs.getString('claimLevelThree');
    return claimLevelThree;
  }
  setPendingLeaveReq(pendingLeaveRequisitions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pendingLeaveRequisitions', pendingLeaveRequisitions);
  }

  getPendingLeaveReq() async {
    final prefs = await SharedPreferences.getInstance();
    final String? pendingLeaveRequisitions = prefs.getString('pendingLeaveRequisitions');
    return pendingLeaveRequisitions;
  }

  setPreOnboardShow(preOnboardShow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preOnboardShow', preOnboardShow);
  }

  getPreOnboardShow() async {
    final prefs = await SharedPreferences.getInstance();
    final String? preOnboardShow = prefs.getString('preOnboardShow');
    return preOnboardShow;
  }
  setExitShow(exitShow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitShow', exitShow);
  }

  getExitShow() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitShow = prefs.getString('exitShow');
    return exitShow;
  }

  setUserPanel(userPanel) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('userPanel', userPanel);
  }

  getUserPanel() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userPanel = prefs.getString('userPanel');
    return userPanel;
  }

  setDefaultProfileName(profileNameNew) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('profileNameNew', profileNameNew);
  }

  getDefaultProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileNameNew = prefs.getString('profileNameNew');
    return profileNameNew;
  }
  setDefaultProfileId(profileIdNew) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('profileIdNew', profileIdNew);
  }

  getDefaultProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileIdNew = prefs.getString('profileIdNew');
    return profileIdNew;
  }
}
