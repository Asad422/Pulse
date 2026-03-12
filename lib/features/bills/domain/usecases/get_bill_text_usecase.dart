import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/bill_text.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillTextUseCase {
  final BillsRepository _repository;
  GetBillTextUseCase(this._repository);

  Future<Either<Failure, BillText>> call(int textId) {
    return _repository.getBillText(textId);
  }
}
