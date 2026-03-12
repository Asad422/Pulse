import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class DownloadBillTextUseCase {
  final BillsRepository _repository;
  DownloadBillTextUseCase(this._repository);

  Future<Either<Failure, String>> call(int textId) {
    return _repository.downloadBillText(textId);
  }
}
