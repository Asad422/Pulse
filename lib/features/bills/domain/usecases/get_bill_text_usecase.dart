import 'package:injectable/injectable.dart';
import '../entities/bill_text.dart';
import '../repositories/bills_repository.dart';

@lazySingleton
class GetBillTextUseCase {
  final BillsRepository _repository;

  GetBillTextUseCase(this._repository);

  Future<BillText> call(int textId) {
    return _repository.getBillText(textId);
  }
}
