part of 'law_detail_bloc.dart';

abstract class LawDetailEvent extends Equatable {
  const LawDetailEvent();
  @override
  List<Object?> get props => [];
}

class LawDetailRequested extends LawDetailEvent {
  final int lawId;
  const LawDetailRequested(this.lawId);
  @override
  List<Object?> get props => [lawId];
}

/// Обновление данных закона без показа loading (после голосования)
class LawDetailRefreshRequested extends LawDetailEvent {
  final int lawId;
  const LawDetailRefreshRequested(this.lawId);
  @override
  List<Object?> get props => [lawId];
}

class LawPollBreakDownRequested extends LawDetailEvent {
  final int pollId;
  const LawPollBreakDownRequested(this.pollId);
  @override
  List<Object?> get props => [pollId];
}

class LawRelatedBillsRequested extends LawDetailEvent {
  final List<int> billIds;
  const LawRelatedBillsRequested(this.billIds);
  @override
  List<Object?> get props => [billIds];
}
