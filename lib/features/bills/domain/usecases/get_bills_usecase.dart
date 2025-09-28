import 'package:injectable/injectable.dart';
import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

@lazySingleton
class GetBillsUseCase {
  final BillsRepository _repo;
  GetBillsUseCase(this._repo);

  Future<List<Bill>> call({int skip = 0, int limit = 20}) {
    return _repo.getBills(skip: skip, limit: limit);
  }
}
