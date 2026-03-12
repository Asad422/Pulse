import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/data/mapper.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';
import '../../domain/entities/politician.dart';
import '../../domain/entities/politican_detail.dart';
import '../../domain/entities/politicians_query.dart';
import '../../domain/repositories/politicians_repository.dart';
import '../datasources/politicians_remote_ds.dart';

@LazySingleton(as: PoliticiansRepository)
class PoliticiansRepositoryImpl implements PoliticiansRepository {
  PoliticiansRepositoryImpl(this._ds);
  final PoliticiansRemoteDataSource _ds;

  @override
  Future<Either<Failure, List<Politician>>> getPoliticians(PoliticiansQuery query) =>
      safeCall(() => _ds.getPoliticians(query));

  @override
  Future<Either<Failure, PoliticianDetail>> getPoliticianById(String bioguideId) =>
      safeCall(() => _ds.getPoliticianById(bioguideId));

  @override
  Future<Either<Failure, List<Bill>>> getSponsoredBills(String politicianId) =>
      safeCall(() => _ds.getSponsoredBills(politicianId));

  @override
  Future<Either<Failure, List<Bill>>> getCosponsoredBills(String politicianId) =>
      safeCall(() => _ds.getCosponsoredBills(politicianId));

  @override
  Future<Either<Failure, PollBreakdown>> getPollBreakDown(int pollId) =>
      safeCall(() => _ds.getPollBreakDown(pollId));
}
