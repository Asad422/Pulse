

import 'package:pulse/core/network/domain/entities/poll.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/laws/domain/entities/law.dart';


class PollVote extends Vote {
  final Poll poll;
  PollVote({required super.choice, required super.id, required super.userId, required super.pollId, required super.votedAt, required this.poll});
}
class BillVote extends Vote {
  final Bill bill;
  BillVote({required super.choice, required super.id, required super.userId, required super.pollId, required super.votedAt, required this.bill});
}
class LawVote extends Vote {
  final Law law;
  LawVote({required super.choice, required super.id, required super.userId, required super.pollId, required super.votedAt, required this.law});
}