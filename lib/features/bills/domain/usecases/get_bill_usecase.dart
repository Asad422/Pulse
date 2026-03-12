import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/bill.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillUseCase {
  final BillsRepository _repo;
  GetBillUseCase(this._repo);

  Future<Either<Failure, Bill>> call(String billId) {
    return _repo.getBillDetail(billId);
  }
}
