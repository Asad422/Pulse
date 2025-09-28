import 'package:injectable/injectable.dart';
import '../../domain/entities/law.dart';
import '../../domain/repositories/laws_repository.dart';
import '../datasources/laws_remote_ds.dart';

@LazySingleton(as: LawsRepository)
class LawsRepositoryImpl implements LawsRepository {
  LawsRepositoryImpl(this._ds);
  final LawsRemoteDataSource _ds;

  @override
  Future<List<Law>> getLaws({
    int? congress,
    String? lawType,
    String? lawNumber,
    int? billId,
  }) {
    return _ds.getLaws(
      congress: congress,
      lawType: lawType,
      lawNumber: lawNumber,
      billId: billId,
    );
  }

  @override
  Future<Law> getLaw(int lawId) => _ds.getLaw(lawId);

  @override
  Future<Law> getLawByIdentity({
    required int congress,
    required String lawType,
    required String lawNumber,
  }) {
    return _ds.getLawByIdentity(
      congress: congress,
      lawType: lawType,
      lawNumber: lawNumber,
    );
  }
}
