import '../entities/bill.dart';
import '../entities/bills_query.dart';
import '../entities/bill_amendment.dart';
import '../entities/bill_sponsor.dart';
import '../entities/bill_text.dart';
import '../entities/bill_crs_report.dart';

abstract class BillsRepository {
  /// Получение списка законопроектов
  Future<List<Bill>> getBills(BillsQuery query);

  /// Получение детальной информации по законопроекту
  Future<Bill> getBillDetail(String billId);

  /// Получение поправок к законопроекту
  Future<List<BillAmendment>> getBillAmendments(int billId);

  /// Получение спонсоров законопроекта
  Future<List<BillSponsor>> getBillSponsors(int billId);

  /// Получение текста законопроекта по ID версии
  Future<BillText> getBillText(int textId);

  /// Загрузка текста законопроекта (сырой контент или ссылка)
  Future<String> downloadBillText(int textId);

  /// Получение CRS-отчётов по законопроекту
  Future<List<BillCrsReport>> getBillCrsReports(int billId);
}
