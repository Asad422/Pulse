import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/bill_poll_query.dart';
import 'package:pulse/features/bills/domain/repositories/bills_repository.dart';

@lazySingleton
class VoteForBillUseCase {
  final BillsRepository _repo;
  VoteForBillUseCase(this._repo);

  Future<Either<Failure, void>> call(BillPollQuery query) {
    return _repo.voteForBill(query);
  }
}
