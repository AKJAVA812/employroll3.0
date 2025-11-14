import 'dart:ffi';

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

  setAppVersion(sessionId) async {
    // Obtain shared preferences.
    sharedPreferences = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await sharedPreferences.setString('appVersion', sessionId);
  }

  getAppVersion() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? appVersion = sharedPreferences.getString('appVersion');
    return appVersion;
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

  setEnrollId(enrollId) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('enrollId', enrollId);
  }

  getEnrollId() async{
    final prefs = await SharedPreferences.getInstance();
    final String? enrollId=prefs.getString('enrollId');
    return enrollId;
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

  setGeofenceActive(geofenceActive) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('geofenceActive', geofenceActive);
  }
  getGeofenceActive() async{
    final prefs = await SharedPreferences.getInstance();
    final bool? geofenceActive=prefs.getBool('geofenceActive');
    return geofenceActive;
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

  //MSS MO Claim
  setClaimLevelOneMO(claimLevelOne) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelOne', claimLevelOne);
  }

  getClaimLevelOneMO() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelOne = prefs.getString('claimLevelOne');
    return claimLevelOne;
  }

  setClaimLevelTwoMO(claimLevelTwo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelTwo', claimLevelTwo);
  }

  getClaimLevelTwoMO() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelTwo = prefs.getString('claimLevelTwo');
    return claimLevelTwo;
  }

  setClaimLevelThreeMO(claimLevelThree) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelThree', claimLevelThree);
  }

  getClaimLevelThreeMO() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelThree = prefs.getString('claimLevelThree');
    return claimLevelThree;
  }

  //UIS Claim
  setClaimLevelOneUIS(claimLevelOne) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelOne', claimLevelOne);
  }

  getClaimLevelOneUIS() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelOne = prefs.getString('claimLevelOne');
    return claimLevelOne;
  }

  setClaimLevelTwoUIS(claimLevelTwo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelTwo', claimLevelTwo);
  }

  getClaimLevelTwoUIS() async {
    final prefs = await SharedPreferences.getInstance();
    final String? claimLevelTwo = prefs.getString('claimLevelTwo');
    return claimLevelTwo;
  }

  setClaimLevelThreeUIS(claimLevelThree) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claimLevelThree', claimLevelThree);
  }

  getClaimLevelThreeUIS() async {
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
  setMyTeamShow(myTeamShow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('myTeamShow', myTeamShow);
  }

  getMyTeamShow() async {
    final prefs = await SharedPreferences.getInstance();
    final String? myTeamShow = prefs.getString('myTeamShow');
    return myTeamShow;
  }

  setExitResignationListShow(exitResignationListShow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationListShow', exitResignationListShow);
  }

  getExitResignationListShow() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationListShow = prefs.getString('exitResignationListShow');
    return exitResignationListShow;
  }
  setExitResignationListView(exitResignationListViewCheck) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationListViewCheck', exitResignationListViewCheck);
  }

  getExitResignationListView() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationListViewCheck = prefs.getString('exitResignationListViewCheck');
    return exitResignationListViewCheck;
  }
  setExitResignationApproveL1Show(exitResignationApproveL1Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationApproveL1Show', exitResignationApproveL1Show);
  }

  getExitResignationApproveL1Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationApproveL1Show = prefs.getString('exitResignationApproveL1Show');
    return exitResignationApproveL1Show;
  }

  setExitResignationApproveL1View(exitResignationApproveL1View) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationApproveL1View', exitResignationApproveL1View);
  }

  getExitResignationApproveL1View() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationApproveL1View = prefs.getString('exitResignationApproveL1View');
    return exitResignationApproveL1View;
  }

  setExitResignationApproveL2View(exitResignationApproveL2View) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationApproveL2View', exitResignationApproveL2View);
  }

  getExitResignationApproveL2View() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationApproveL2View = prefs.getString('exitResignationApproveL2View');
    return exitResignationApproveL2View;
  }

  setExitResignationDisApproveL1View(exitResignationDisApproveL1View) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationDisApproveL1View', exitResignationDisApproveL1View);
  }

  getExitResignationDisApproveL1View() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationDisApproveL1View = prefs.getString('exitResignationDisApproveL1View');
    return exitResignationDisApproveL1View;
  }

  setExitResignationDisApproveL2View(exitResignationDisApproveL2View) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationDisApproveL2View', exitResignationDisApproveL2View);
  }

  getExitResignationDisApproveL2View() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationDisApproveL2View = prefs.getString('exitResignationDisApproveL2View');
    return exitResignationDisApproveL2View;
  }

  setExitResignationApproveL2Show(exitResignationApproveL2Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationApproveL2Show', exitResignationApproveL2Show);
  }

  getExitResignationApproveL2Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationApproveL2Show = prefs.getString('exitResignationApproveL2Show');
    return exitResignationApproveL2Show;
  }

  setExitResignationDisApproveL1Show(exitResignationDisApproveL1Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationDisApproveL1Show', exitResignationDisApproveL1Show);
  }

  getExitResignationDisApproveL1Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationDisApproveL1Show = prefs.getString('exitResignationDisApproveL1Show');
    return exitResignationDisApproveL1Show;
  }

  setExitResignationDisApproveL2Show(exitResignationDisApproveL2Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exitResignationDisApproveL2Show', exitResignationDisApproveL2Show);
  }

  getExitResignationDisApproveL2Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exitResignationDisApproveL2Show = prefs.getString('exitResignationDisApproveL2Show');
    return exitResignationDisApproveL2Show;
  }
  setLoanApprovalL1Show(loanApprovalL1Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loanApprovalL1Show', loanApprovalL1Show);
  }

  getLoanApprovalL1Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loanApprovalL1Show = prefs.getString('loanApprovalL1Show');
    return loanApprovalL1Show;
  }
  setLoanApprovalL2Show(loanApprovalL2Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loanApprovalL2Show', loanApprovalL2Show);
  }

  getLoanApprovalL2Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loanApprovalL2Show = prefs.getString('loanApprovalL2Show');
    return loanApprovalL2Show;
  }

  setLoanApprovalL3Show(loanApprovalL3Show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loanApprovalL3Show', loanApprovalL3Show);
  }

  getLoanApprovalL3Show() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loanApprovalL3Show = prefs.getString('loanApprovalL3Show');
    return loanApprovalL3Show;
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
    await prefs.setInt('profileIdNew', profileIdNew);
  }

  getDefaultProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? profileIdNew = prefs.getInt('profileIdNew');
    return profileIdNew;
  }

  //MSS MO Permissions
  //Pending Attendance Request Permission & Others Attendance Request Permission
  Future<void> setPendingAttendanceReqMSSMOPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_attendance_req_mss_mo_permission', value);
  }

  Future<String?> getPendingAttendanceReqMSSMOPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_attendance_req_mss_mo_permission');
  }
  //Pending Leave Request Permission
  Future<void> setPendingLeaveReqMSSMOPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_mss_mo_permission', value);
  }

  Future<String?> getPendingLeaveReqMSSMOPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_mss_mo_permission');
  }
  //Pending Leave Request L1 Permission
  Future<void> setPendingLeaveReqL1MSSMOPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_l1_mss_mo_permission', value);
  }

  Future<String?> getPendingLeaveReqL1MSSMOPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_l1_mss_mo_permission');
  }

  //Pending Leave Request L2 Permission
  Future<void> setPendingLeaveReqL2MSSMOPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_l2_mss_mo_permission', value);
  }

  Future<String?> getPendingLeaveReqL2MSSMOPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_l2_mss_mo_permission');
  }
  //Others Leave Request Permission
  Future<void> setOthersLeaveReqMSSMOPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('others_leave_req_mss_mo_permission', value);
  }

  Future<String?> getOthersLeaveReqMSSMOPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('others_leave_req_mss_mo_permission');
  }

  //OD Activate Permission
  Future<void> setODActivateMO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('od_activate_mo_permission', value);
  }

  Future<String?> getODActivateMO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('od_activate_mo_permission');
  }
  //OD Pending List Permission
  Future<void> setODPendingListMO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('od_pending_mo_permission', value);
  }

  Future<String?> getODPendingListMO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('od_pending_mo_permission');
  }

  //Loan Pending List Permission
  Future<void> setLoanPendingListMO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_pending_mo_permission', value);
  }

  Future<String?> getLoanPendingListMO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_pending_mo_permission');
  }
  Future<void> setLoanApprovalL1MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l1_mo_permission', value);
  }

  Future<String?> getLoanApprovalL1MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l1_mo_permission');
  }
  Future<void> setLoanApprovalDeleteL1MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l1_delete_mo_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL1MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l1_delete_mo_permission');
  }
  Future<void> setLoanApprovalL2MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l2_mo_permission', value);
  }

  Future<String?> getLoanApprovalL2MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l2_mo_permission');
  }
  Future<void> setLoanApprovalDeleteL2MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l2_delete_mo_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL2MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l2_delete_mo_permission');
  }
  Future<void> setLoanApprovalL3MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l3_mo_permission', value);
  }

  Future<String?> getLoanApprovalL3MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l3_mo_permission');
  }
  Future<void> setLoanApprovalDeleteL3MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l3_delete_mo_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL3MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l3_delete_mo_permission');
  }

  //Pending Attendance L1
  Future<void> setPendingAttendanceReqL1MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_att_mo_l1_permission', value);
  }

  Future<String?> getPendingAttendanceReqL1MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_att_mo_l1_permission');
  }

  //Pending Attendance L2
  Future<void> setPendingAttendanceReqL2MO(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_att_mo_l2_permission', value);
  }

  Future<String?> getPendingAttendanceReqL2MO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_att_mo_l2_permission');
  }


  //MSS Permissions
  //Pending Attendance Request Permission & Others Attendance Request Permission
  Future<void> setPendingAttendanceReqMSSPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_attendance_req_mss_permission', value);
  }

  Future<String?> getPendingAttendanceReqMSSPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_attendance_req_mss_permission');
  }
  //Pending Leave Request Permission
  Future<void> setPendingLeaveReqMSSPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_mss_permission', value);
  }

  Future<String?> getPendingLeaveReqMSSPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_mss_permission');
  }
  //Pending Leave Request L1 Permission
  Future<void> setPendingLeaveReqL1MSSPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_l1_mss_permission', value);
  }

  Future<String?> getPendingLeaveReqL1MSSPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_l1_mss_permission');
  }

  //Pending Leave Request L2 Permission
  Future<void> setPendingLeaveReqL2MSSPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_l2_mss_permission', value);
  }

  Future<String?> getPendingLeaveReqL2MSSPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_l2_mss_permission');
  }
  //Others Leave Request Permission
  Future<void> setOthersLeaveReqMSSPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('others_leave_req_mss_permission', value);
  }

  Future<String?> getOthersLeaveReqMSSPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('others_leave_req_mss_permission');
  }

  //OD Activate Permission
  Future<void> setODActivate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('od_activate_permission', value);
  }

  Future<String?> getODActivate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('od_activate_permission');
  }
  //OD Pending List Permission
  Future<void> setODPendingList(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('od_pending_permission', value);
  }

  Future<String?> getODPendingList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('od_pending_permission');
  }
  //OD Pending List Permission
  Future<void> setLoanPendingList(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_pending_permission', value);
  }

  Future<String?> getLoanPendingList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_pending_permission');
  }

  Future<void> setLoanApprovalL1MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l1_mss_permission', value);
  }

  Future<String?> getLoanApprovalL1MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l1_mss_permission');
  }
  Future<void> setLoanApprovalDeleteL1MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l1_delete_mss_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL1MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l1_delete_mss_permission');
  }
  Future<void> setLoanApprovalL2MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l2_mss_permission', value);
  }

  Future<String?> getLoanApprovalL2MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l2_mss_permission');
  }
  Future<void> setLoanApprovalDeleteL2MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l2_delete_mss_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL2MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l2_delete_mss_permission');
  }
  Future<void> setLoanApprovalL3MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l3_mss_permission', value);
  }

  Future<String?> getLoanApprovalL3MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l3_mss_permission');
  }
  Future<void> setLoanApprovalDeleteL3MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l3_delete_mss_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL3MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l3_delete_mss_permission');
  }


  //Pending Attendance L1
  Future<void> setPendingAttendanceReqL1MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_att_mss_l1_permission', value);
  }

  Future<String?> getPendingAttendanceReqL1MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_att_mss_l1_permission');
  }

  //Pending Attendance L2
  Future<void> setPendingAttendanceReqL2MSS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_att_mss_l2_permission', value);
  }

  Future<String?> getPendingAttendanceReqL2MSS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_att_mss_l2_permission');
  }



  //UIS Permissions
  //Pending Attendance Request Permission & Others Attendance Request Permission
  Future<void> setPendingAttendanceReqUISPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_attendance_req_uis_permission', value);
  }

  Future<String?> getPendingAttendanceReqUISPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_attendance_req_uis_permission');
  }
  //Pending Leave Request Permission
  Future<void> setPendingLeaveReqUISPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_uis_permission', value);
  }

  Future<String?> getPendingLeaveReqUISPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_uis_permission');
  }
  //Pending Leave Request L1 Permission
  Future<void> setPendingLeaveReqL1UISPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_l1_uis_permission', value);
  }

  Future<String?> getPendingLeaveReqL1UISPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_l1_uis_permission');
  }

  //Pending Leave Request L2 Permission
  Future<void> setPendingLeaveReqL2UISPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_leave_req_l2_uis_permission', value);
  }

  Future<String?> getPendingLeaveReqL2UISPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_leave_req_l2_uis_permission');
  }
  //Others Leave Request Permission
  Future<void> setOthersLeaveReqUISPermission(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('others_leave_req_uis_permission', value);
  }

  Future<String?> getOthersLeaveReqUISPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('others_leave_req_uis_permission');
  }

  //OD Activate Permission
  Future<void> setODActivateUIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('od_activate_uis_permission', value);
  }

  Future<String?> getODActivateUIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('od_activate_uis_permission');
  }
  //OD Pending List Permission
  Future<void> setODPendingListUIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('od_pending_uis_permission', value);
  }

  Future<String?> getODPendingListUIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('od_pending_uis_permission');
  }
  //OD Pending List Permission
  Future<void> setLoanPendingListUIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_pending_uis_permission', value);
  }

  Future<String?> getLoanPendingListUIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_pending_uis_permission');
  }

  Future<void> setLoanApprovalL1UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l1_uis_permission', value);
  }

  Future<String?> getLoanApprovalL1UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l1_uis_permission');
  }
  Future<void> setLoanApprovalDeleteL1UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l1_delete_uis_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL1UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l1_delete_uis_permission');
  }
  Future<void> setLoanApprovalL2UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l2_uis_permission', value);
  }

  Future<String?> getLoanApprovalL2UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l2_uis_permission');
  }
  Future<void> setLoanApprovalDeleteL2UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l2_delete_uis_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL2UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l2_delete_uis_permission');
  }
  Future<void> setLoanApprovalL3UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l3_uis_permission', value);
  }

  Future<String?> getLoanApprovalL3UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l3_uis_permission');
  }
  Future<void> setLoanApprovalDeleteL3UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loan_approval_l3_delete_uis_permission', value);
  }

  Future<String?> getLoanApprovalDeleteL3UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loan_approval_l3_delete_uis_permission');
  }


  //Pending Attendance L1
  Future<void> setPendingAttendanceReqL1UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_att_uis_l1_permission', value);
  }

  Future<String?> getPendingAttendanceReqL1UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_att_uis_l1_permission');
  }

  //Pending Attendance L2
  Future<void> setPendingAttendanceReqL2UIS(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_att_uis_l2_permission', value);
  }

  Future<String?> getPendingAttendanceReqL2UIS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_att_uis_l2_permission');
  }

  //MY Team Show
  Future<void> setMyTeamPageShow(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_team_permission', value);
  }

  Future<String?> getMyTeamPageShow() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('my_team_permission');
  }
}
