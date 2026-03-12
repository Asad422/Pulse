import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/bill_crs_report.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillCrsReportsUseCase {
  final BillsRepository _repository;
  GetBillCrsReportsUseCase(this._repository);

  Future<Either<Failure, List<BillCrsReport>>> call(int billId) {
    return _repository.getBillCrsReports(billId);
  }
}
