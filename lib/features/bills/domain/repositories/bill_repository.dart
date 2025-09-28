import '../entities/bill.dart';

abstract class BillsRepository {
  Future<List<Bill>> getBills({
    int skip,
    int limit,
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
  });

  Future<Bill> getBillDetail(String billId);
}
