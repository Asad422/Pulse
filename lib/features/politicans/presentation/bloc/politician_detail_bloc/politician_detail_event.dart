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
