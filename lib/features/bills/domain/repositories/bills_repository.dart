import '../entities/bill.dart';
import '../entities/bills_query.dart';

abstract class BillsRepository {
  Future<List<Bill>> getBills(BillsQuery query);
  Future<Bill> getBillDetail(String billId);
}
