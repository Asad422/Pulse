import 'package:pulse/core/network/data/models/poll_model.dart';
import 'package:pulse/core/network/data/models/vote_model.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import 'package:pulse/features/bills/data/models/bill_model.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/laws/data/models/law_model.dart';
import 'package:pulse/features/laws/domain/entities/law.dart';
import 'package:pulse/features/profile/domain/entities/vote.dart';

class VoteHistoryModel extends VoteModel {
  final PollModel? poll;
  final BillModel? bill;
  final LawModel? law;

  VoteHistoryModel({
    required super.id,
    required super.pollId,
    required super.userId,
    required super.choice,
    required super.votedAt,
    this.poll,
    this.bill,
    this.law,
  });

  factory VoteHistoryModel.fromJson(Map<String, dynamic> json) {
    return VoteHistoryModel(
      id: json['id'] as int,
      pollId: json['poll_id'] as int,
      userId: json['user_id'] as int,
      choice: json['choice'] as bool,
      votedAt: DateTime.parse(json['voted_at'] as String),
      poll: json['poll'] != null
          ? PollModel.fromJson(json['poll'] as Map<String, dynamic>)
          : null,
      bill: json['bill'] != null
          ? BillModel.fromJson(json['bill'] as Map<String, dynamic>)
          : null,
      law: json['law'] != null
          ? LawModel.fromJson(json['law'] as Map<String, dynamic>)
          : null,
    );
  }

  Vote toEntity() {
    if (bill != null) {
      final billEntity = Bill(
        congressBillId: bill!.congressBillId,
        congress: bill!.congress,
        billNumber: bill!.billNumber,
        title: bill!.title,
        summary: bill!.summary,
        introducedDate: bill!.introducedDate,
        status: bill!.status,
        level: bill!.level,
        isFeatured: bill!.isFeatured,
        classification: bill!.classification,
        sessionId: bill!.sessionId,
        fromOrganizationId: bill!.fromOrganizationId,
        source: bill!.source,
        sourceId: bill!.sourceId,
        countryCode: bill!.countryCode,
        jurisdictionCode: bill!.jurisdictionCode,
        externalUrl: bill!.externalUrl,
        id: bill!.id,
        lastUpdated: bill!.lastUpdated,
        amendments: bill!.amendments,
        summaries: bill!.summaries,
        actions: bill!.actions,
        texts: bill!.texts,
        crsReports: bill!.crsReports,
        laws: bill!.laws,
        pollStats: poll,
        userVote: bill!.userVote,
      );
      return BillVote(
        id: id,
        pollId: pollId,
        userId: userId,
        choice: choice,
        votedAt: votedAt,
        bill: billEntity,
      );
    } else if (law != null) {
      final lawEntity = Law(
        id: law!.id,
        congress: law!.congress,
        lawType: law!.lawType,
        lawNumber: law!.lawNumber,
        title: law!.title,
        url: law!.url,
        enactedDate: law!.enactedDate,
        pollStats: poll,
        userVote: law!.userVote,
      );
      return LawVote(
        id: id,
        pollId: pollId,
        userId: userId,
        choice: choice,
        votedAt: votedAt,
        law: lawEntity,
      );
    } else if (poll != null) {
      return PollVote(
        id: id,
        pollId: pollId,
        userId: userId,
        choice: choice,
        votedAt: votedAt,
        poll: poll!,
      );
    } else {
      throw StateError(
        'VoteHistoryModel must have at least one of poll, bill, or law',
      );
    }
  }
}
