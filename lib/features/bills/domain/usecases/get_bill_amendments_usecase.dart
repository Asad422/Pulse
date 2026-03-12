import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/bill_amendment.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillAmendmentsUseCase {
  final BillsRepository _repository;
  GetBillAmendmentsUseCase(this._repository);

  Future<Either<Failure, List<BillAmendment>>> call(int billId) {
    return _repository.getBillAmendments(billId);
  }
}
