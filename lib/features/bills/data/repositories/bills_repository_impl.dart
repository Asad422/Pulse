import 'package:injectable/injectable.dart';

import '../../domain/entities/bill.dart';
import '../../domain/repositories/bills_repository.dart';
import '../datasources/bills_remote_ds.dart';

@LazySingleton(as: BillsRepository)
class BillsRepositoryImpl implements BillsRepository {
  BillsRepositoryImpl(this._ds);
  final BillsRemoteDataSource _ds;

  @override
  Future<List<Bill>> getBills({
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
    return _ds.getBills(
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

  @override
  Future<Bill> getBillDetail(String billId) {
    return _ds.getBillDetail(billId);
  }
}
