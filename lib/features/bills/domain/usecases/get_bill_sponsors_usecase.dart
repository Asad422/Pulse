import 'package:injectable/injectable.dart';
import '../entities/bill_sponsor.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillSponsorsUseCase {
  final BillsRepository _repository;

  GetBillSponsorsUseCase(this._repository);

  Future<List<BillSponsor>> call(int billId) {
    return _repository.getBillSponsors(billId);
  }
}
