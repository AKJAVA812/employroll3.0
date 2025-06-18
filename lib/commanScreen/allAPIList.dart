
class ApiDetails{
   //Base Server Address
   //static var server="http://www.employroll.com/";

   static var serverTwo="http://super.employroll.com:8081/";
   //static var serverTwo="https://14368a81b89e.ngrok.app/";
   static var server="https://18cbf9695997.ngrok.app/";

   //Attendance Punch in and Punch out
   static String login="/restful/service/login";
   static String punchIn="/restful/service/attendance/via/mobile";
   static var getAttendance = "/restful/service/current/month/log/list/for/mobile/requisation";
   static var getOtherAttendance = "/restful/service/current/month/log/list/for/mobile/requisation";
   static var sendAttendanceReq = "/restful/service/att/requisiton/for/non/ess/employees";
   static var sendOthersAttendanceReq = "/restful/service/att/requisiton/for/non/ess/employees";
   static var selfAttRequisitionList = "/restful/service/own/attandace/request/list";
   static var getAttDetails = "/restful/service/ondate/log/for/attendance/req";
   static var getOtherAttDetails = "/restful/service/ondate/log/for/attendance/req/for/non/ess/employees";
   static var pendingReqListRo = "/restful/service/att/requisation/list/for/mobile";
   static var pendingReqListApprove = "/restful/service/att/requisation/list/approval";
   static var pendingReqListDisapprove = "/restful/service/att/requisiton/disapprove/one/leave/req";
   static var approvedAttReqList = "/restful/service/att/requisation/approved/list/for/mobile";
   static var disApprovedAttReqList = "/restful/service/attendance/requisition/cancel/disapproved";
   static var workDoneReport = "/restful/service/get/self/mobile/task/list";
   static var roWorkDoneReport = "restful/service/get/self/mobile/task/list/ro/wise";
   static var attendanceReport = "/restful/service/get/attendance/logs/multiple";
   //static var punchWithoutSelfie = "/restful/service/attendance/via/mobile/without/image";
   static var punchWithoutSelfie = "/restful/service/attendance/via/mobile/without/image/with/status";
   static var cancelSelfAttReqList = "/restful/service/own/attandace/request/cancellation";
   //OD Attendance
   static var odAttendanceReq = "/restful/service/att/requisiton/for/non/ess/employees";
   static var odInOtApi = "/restful/service/od/via/mobile";
   static var odPendingReqList = "/restful/service/odlist/ro/via/mobile";
   static var odPendingReqListNew = "/restful/service/odlist/ro/via/mobile/new";
   static var odReqApproveDisAp = "/restful/service/od/approval/mobile";
   static var selfOdReqList = "/restful/service/odlist/via/mobile";
   //HRIS employee list
   static var getEmpList = "/restful/service/employeelist";
   //QR based attendance
   static var qrBasedAttendance = "/restful/service/attendance/via/mobile/qr/code/scanner";
   //Leave management
   static var leaveApprovalApi = "/restful/service/requested/leave/approval";
   static var leaveApprovalLevel1Api = "/restful/service/requested/leave/approval/level/one";
   static var leaveApprovalLevel2Api = "/restful/service/requested/leave/approval/level/two";
   static var leaveBalanceApi = "/restful/service/leave/type/list";
   static var leaveBal = "/restful/service/get/leave/ledger/yearly";
   static var roApprovedReqList = "/restful/service/approved/leave/requisition/list";
   static var pendingLeaveReqList = "/restful/service/pending/leave/requisition/list";
   static var levelOneLeaveList = "/restful/service/level/one/pending/leave/requisition/list";
   static var levelTwoLeaveList = "/restful/service/level/two/pending/leave/requisition/list";
   static var requestedReqList = "/restful/service/employee/leave/requested/list";
   static var cancelReqRequisition = "/restful/service/cancel/requested/leave/with/policy";
   static var leaveRequisitionApi = "/restful/service/requisition/leave/policy/defines";
   static var othersReqEmpList = "/restful/service/att/requisation/non/ess/employees";
   //Claim n Advance
   static var advanceRequisitionList = "/restful/service/org/employee/advance/details/view";
   static var pendingAdvReqList = "/restful/service/org/employee/pending/advance/details/view";
   static var expensesList = "/restful/service/org/claim/requisition/list";
   static var pendingReimList = "/restful/service/org/claim/pending/requisition/list";
   static var appDisReimbList = "/restful/service/org/claim/approve/disapprove/list";
   static var appDisAdvList = "/restful/service/org/employee/pending/and/processed/advance/details/view";
   static var saveAdvRequisition = "/restful/service/org/employee/advance/amount/detail/save";
   static var saveExpenses = "/restful/service/claim/requisition/form/details/save";
   static var appDisAdvRequisition = "/restful/service/org/employee/approve/disapprove/status";
   static var deleteClaimRequisition = "/restful/service/self/claim/request/cancel";
   static var addExpenseDrops = "/restful/service/expense/list";
   static var addExpDropPolicy = "/restful/service/get/claim/list";
   static var approveDisapproveReimbReq = "/restful/service/claim/Requisition/approved";
   static var cancelAdvRequisition = "/restful/service/employee/self/advance/cancel";
   static var claimApprovalListDataApi = "/restful/service/employee/self/advance/cancel";


   //Admin dashboard API
   static var adminDashboardAPi = "restful/service/dashboard/present/absent/count";
   static var adminDashboardNewAPi = "restful/service/dashboard/present/absent/count/new";
   static var eventListModalApi = "restful/service/get/emp/event";
   static var eventListModalNewApi = "restful/service/get/emp/event/new";
   static var branchListApi = "restful/service/dashboard/branchlist";
   static var shiftListApi = "restful/service/dashboard/shiftlist";

   //ESS Dashboard
   static var essDashboardAPi = "restful/service/dashboard/present/absent/count/ess";
   static var eventListModalESSApi = "restful/service/get/emp/event/ess";

   //Customer workDone API
   static var skyWorkDoneClientApi = "restful/service/get/mobile/task/client/details";
   static var customWorkDoneApi = "restful/service/task/via/mobile";

   //Employee Tracking API
   static var historyTracking = "restful/service/return/mobile/tracking/new";
   static var timeLineApi = "restful/service/return/mobile/tracking/timeline";

   //Payroll
   //static var salarySlipDownload = "restful/service/get/employee/salary/slip";
   static var salarySlipDownload = "employroll/api/third/party/get/employee/salary/slip";

   //Loan Advance
   static var loanAdvanceReqList = "restful/service/org/loan/and/advance/requested/list";
   static var cancelLoanAdvReqList = "restful/service/org/loan/and/advance/pending/request/delete";
   static var loanApprovedReq = "restful/service/org/loan/approved/list/detail";
   static var loanRequest = "restful/service/get/loan/master/list";
   static var advanceRequest = "restful/service/get/advance/master/list";
   static var loanAdvReqSend = "restful/service/org/loan/and/advance/request/data/save";


   //Helpdesk API's
   static var departmentListApi = "employroll/api/third/party/query/policy/all/mobile/departments";
   static var queryTypeListApi = "employroll/api/third/party/get/ticket/type/list/new/mobile";
   static var subQueryTypeListApi = "employroll/api/third/party/get/sub/query/type/list/new/mobile";
   static var querySendApi = "employroll/api/third/party/org/raised/query/details/saved/mobile";
   static var queryRaisedList = "employroll/api/third/party/mobile/org/emp/raised/ticket/list";

   //Documents
   static var documentListApi = "employroll/api/third/party/get/org/Doc/type/master/list";
   static var documentDetApi = "employroll/api/third/party/org/get/employee/on/filter/base/document/list";

   static var logoutAPi = "restful/service/employee/logout";

   static var tourRequisitionApi = "/restful/service/requisition/tour";


   //HR_IS Update API
   static var updateHRISApi = "/restful/service/hris/detail/update/request";

   //Saved Offline Attendance
   static var savedOfflineAtt = "/restful/service/attendance/via/mobile/offline";

   //ESS Calendar API
   static var calendarApi = "/restful/service/get/emp/calendar/ess";

   //Travel & Expense
   static var selfClaimRequestListApi = "restful/service/get/employee/self/claim/policy/list";
   static var reimbursementTypeListApi = "restful/service/employee/get/claim/policy/map/list";
   static var reimburseDefaultApiCheck = "restful/service/claim/policy/policy/check";
   static var categoriesApi = "restful/service/party/get/expense/list";
   static var finalRaiseClaimApi = "restful/service/self/claim/raise/save";
   static var claimApproveListApi = "restful/service/get/claims/approval/list";
   static var claimApproveDataApi = "restful/service/get/employee/self/claim/policy/list/level/one";
   static var claimApproveApi = "restful/service/claim/approver/level/wise/claim/approved";
   static var claimDisApproveApi = "restful/service/claim/approver/level/wise/claim/delete";

   //Induction APIs
   static var onboardingList = "restful/service/onboard/details/list";
   static var onboardingSave = "restful/service/onboard/details/save";
   static var onboardBranchList = "restful/service/get/org/mapped/branch/list";
   static var onboardDeptList = "restful/service/fetch/department/list";
   static var onboardDesignationList = "restful/service/fetch/designation/list";
   static var onboardUserTypeList = "restful/service/fetch/userType/list";
   static var onboardDocTypeList = "restful/service/get/doc/type/list";


   //Holiday ESS
   static var holidayListEss = "restful/service/get/emp/holiday/ess";

   //Out Punch Check API
   static var outPunchStatusCheck = "restful/service/first/shift/det";

   //Face Registered
   static var faceRegistered = "restful/service/face/recognize/data/save";
   static var faceRecognizeOther = "restful/service/attendance/via/face/recognize/mobile/other";
   static var faceRecognizeOtherMss = "restful/service/attendance/via/face/recognize/mobile/other/emp/wise";
   static var faceRecognizeSelf = "restful/service/attendance/via/face/recognize/mobile/self";
   static var getEmpFaceList = "restful/service/employeelist/face/reco/det";


   //Tracking
   static var saveTrackingData = "restful/service/new/mobile/tracking/new";

   //Reporting Officer List
   static var reportingOfficerList = "restful/service/get/ro/list/of/an/emp";

   //Forget Password OTP Send API
   static var otpSendApi = "restful/service/password/forget";

   //Exit Process APIs
   static var exitSeparationListApi = "restful/service/workflow/base/sepration/mode/list";
   static var exitFormalitySaveApi = "restful/service/exit/formality/save";
   static var initiateExitApi = "restful/service/exit/initiate/details/save";
   static var exitEmpListApi = "restful/service/exit/employeelist";

   //Pre-Onboarding APIs
   static var preOnboardListApi = "restful/service/get/pre/onboard/mobile/list";
   static var preOnboardSaveApi = "restful/service/pre/onboard/mobile/details/save";
   static var preOnboardApproveApi = "restful/service/pre/onboard/mobile/details/approve";
   static var preOnboardAadharVerifyApi = "restful/service/pre/onboard/mobile/aadhar/verification";

   //profile list
   static var profileListApi = "restful/service/get/user/all/mapped/profile/list";

   //Organisation List
   static var orgListApi = "restful/service/org/details/master/list";

}
