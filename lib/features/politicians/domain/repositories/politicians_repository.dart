import 'package:dartz/dartz.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';
import '../entities/politician.dart';
import '../entities/politican_detail.dart';
import '../entities/politicians_query.dart';

abstract class PoliticiansRepository {
  Future<Either<Failure, List<Politician>>> getPoliticians(PoliticiansQuery query);
  Future<Either<Failure, PoliticianDetail>> getPoliticianById(String bioguideId);
  Future<Either<Failure, List<Bill>>> getSponsoredBills(String politicianId);
  Future<Either<Failure, List<Bill>>> getCosponsoredBills(String politicianId);
  Future<Either<Failure, PollBreakdown>> getPollBreakDown(int pollId);
}
