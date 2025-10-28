import 'package:injectable/injectable.dart';
import '../entities/bill.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillUseCase {
  final BillsRepository _repo;
  GetBillUseCase(this._repo);

  Future<Bill> call(String billId) {
    return _repo.getBillDetail(billId);
  }
}
