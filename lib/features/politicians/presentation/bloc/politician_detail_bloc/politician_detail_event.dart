part of 'politician_detail_bloc.dart';

abstract class PoliticianDetailEvent extends Equatable {
  const PoliticianDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Запросить детали по bioguideId
class PoliticianDetailRequested extends PoliticianDetailEvent {
  final String bioguideId;
  const PoliticianDetailRequested(this.bioguideId);

  @override
  List<Object?> get props => [bioguideId];
}

/// Обновить данные без показа загрузки (silent refresh)
class PoliticianDetailRefreshRequested extends PoliticianDetailEvent {
  final String bioguideId;
  const PoliticianDetailRefreshRequested(this.bioguideId);

  @override
  List<Object?> get props => [bioguideId];
}

/// Загрузить sponsored bills для политика
class PoliticianSponsoredBillsRequested extends PoliticianDetailEvent {
  final String politicianId;
  const PoliticianSponsoredBillsRequested(this.politicianId);

  @override
  List<Object?> get props => [politicianId];
}

/// Загрузить cosponsored bills для политика
class PoliticianCosponsoredBillsRequested extends PoliticianDetailEvent {
  final String politicianId;
  const PoliticianCosponsoredBillsRequested(this.politicianId);

  @override
  List<Object?> get props => [politicianId];
}

/// Загрузить демографическую статистику по голосованию
class PoliticianPollBreakDownRequested extends PoliticianDetailEvent {
  final int pollId;
  const PoliticianPollBreakDownRequested(this.pollId);

  @override
  List<Object?> get props => [pollId];
}
