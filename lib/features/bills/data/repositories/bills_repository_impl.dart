import 'package:injectable/injectable.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bills_query.dart';
import '../../domain/repositories/bills_repository.dart';
import '../datasources/bills_remote_ds.dart';

@LazySingleton(as: BillsRepository)
class BillsRepositoryImpl implements BillsRepository {
  BillsRepositoryImpl(this._ds);
  final BillsRemoteDataSource _ds;

  @override
  Future<List<Bill>> getBills(BillsQuery query) => _ds.getBills(query);

  @override
  Future<Bill> getBillDetail(String billId) => _ds.getBillDetail(billId);
}
