import 'package:injectable/injectable.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class DownloadBillTextUseCase {
  final BillsRepository _repository;

  DownloadBillTextUseCase(this._repository);

  Future<String> call(int textId) {
    return _repository.downloadBillText(textId);
  }
}
