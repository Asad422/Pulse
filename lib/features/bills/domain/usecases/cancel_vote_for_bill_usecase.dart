import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/repositories/bills_repository.dart';

@lazySingleton
class CancelVoteForBillUseCase {
  final BillsRepository _repo;
  CancelVoteForBillUseCase(this._repo);

  Future<Either<Failure, void>> call(int voteId) {
    return _repo.cancelVoteForBill(voteId);
  }
}
