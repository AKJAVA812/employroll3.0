import 'package:er_flutter_project/modules/leaveManagement/reports/modalClass/leaveBalModal.dart';
import 'package:er_flutter_project/modules/leaveManagement/reports/modalClass/leaveBalanceModel.dart';

class LeaveCombinedResponse {
  LeaveBalanceModel? leaveBalanceModel;
  LeaveBalModal? leaveBalModal;

  LeaveCombinedResponse({
    this.leaveBalanceModel,
    this.leaveBalModal,
  });
}
