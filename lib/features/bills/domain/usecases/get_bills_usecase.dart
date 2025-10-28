import 'package:injectable/injectable.dart';
import '../entities/bill.dart';
import '../entities/bills_query.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillsUseCase {
  final BillsRepository _repo;
  GetBillsUseCase(this._repo);

  Future<List<Bill>> call(BillsQuery query) {
    return _repo.getBills(query);
  }
}
