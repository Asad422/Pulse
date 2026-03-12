import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';
import 'package:pulse/features/bills/domain/repositories/bills_repository.dart';

@lazySingleton
class GetPollBreakdown {
  final BillsRepository _repository;
  GetPollBreakdown(this._repository);

  Future<Either<Failure, PollBreakdown>> call(int pollId) {
    return _repository.getPollBreakDown(pollId);
  }
}
