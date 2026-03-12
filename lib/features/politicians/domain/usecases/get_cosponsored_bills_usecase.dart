import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import '../repositories/politicians_repository.dart';

@lazySingleton
class GetCosponsoredBillsUseCase {
  final PoliticiansRepository _repo;
  GetCosponsoredBillsUseCase(this._repo);

  Future<Either<Failure, List<Bill>>> call(String politicianId) {
    return _repo.getCosponsoredBills(politicianId);
  }
}
