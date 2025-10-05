import 'package:injectable/injectable.dart';
import '../../domain/entities/law.dart';
import '../../domain/entities/laws_query.dart';
import '../../domain/repositories/laws_repository.dart';
import '../datasources/laws_remote_ds.dart';

@LazySingleton(as: LawsRepository)
class LawsRepositoryImpl implements LawsRepository {
  LawsRepositoryImpl(this._ds);
  final LawsRemoteDataSource _ds;

  @override
  Future<List<Law>> getLaws(LawsQuery query) => _ds.getLaws(query);

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
