import 'package:injectable/injectable.dart';
import '../entities/bill_amendment.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillAmendmentsUseCase {
  final BillsRepository _repository;

  GetBillAmendmentsUseCase(this._repository);

  Future<List<BillAmendment>> call(int billId) {
    return _repository.getBillAmendments(billId);
  }
}
