import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/bill_sponsor.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillSponsorsUseCase {
  final BillsRepository _repository;
  GetBillSponsorsUseCase(this._repository);

  Future<Either<Failure, List<BillSponsor>>> call(int billId) {
    return _repository.getBillSponsors(billId);
  }
}
