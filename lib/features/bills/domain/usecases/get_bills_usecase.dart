import 'package:injectable/injectable.dart';
import '../entities/bill.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillsUseCase {
  final BillsRepository _repo;
  GetBillsUseCase(this._repo);

  Future<List<Bill>> call({
    int skip = 0,
    int limit = 20,
    String? status,
    String? level,
    bool? isFeatured,
    String? q,
    String? introducedFrom,
    String? introducedTo,
    String? subject,
    String? committee,
    String? sponsor,
    String? sortBy,
    String? order,
  }) {
    return _repo.getBills(
      skip: skip,
      limit: limit,
      status: status,
      level: level,
      isFeatured: isFeatured,
      q: q,
      introducedFrom: introducedFrom,
      introducedTo: introducedTo,
      subject: subject,
      committee: committee,
      sponsor: sponsor,
      sortBy: sortBy,
      order: order,
    );
  }
}
