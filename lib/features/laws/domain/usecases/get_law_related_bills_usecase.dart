import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawRelatedBillsUseCase {
  final LawsRepository _repo;
  GetLawRelatedBillsUseCase(this._repo);

  Future<Either<Failure, List<Bill>>> call(List<int> billIds) {
    return _repo.getBillsByIds(billIds);
  }
}
