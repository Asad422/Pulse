import 'package:injectable/injectable.dart';

import '../../domain/entities/politician.dart';
import '../../domain/repositories/politicians_repository.dart';
import '../datasources/politicians_remote_ds.dart';

@LazySingleton(as: PoliticiansRepository)
class PoliticiansRepositoryImpl implements PoliticiansRepository {
  PoliticiansRepositoryImpl(this._ds);

  final PoliticiansRemoteDataSource _ds;

  @override
  Future<List<Politician>> getPoliticians(PoliticiansQuery query) {
    return _ds.getPoliticians(query);
  }

  @override
  Future<Politician> getPoliticianById(String bioguideId) => _ds.getPoliticianById(bioguideId);
}
