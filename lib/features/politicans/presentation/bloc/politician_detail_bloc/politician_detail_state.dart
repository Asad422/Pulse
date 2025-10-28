part of 'politician_detail_bloc.dart';

enum PoliticianDetailStatus { initial, loading, success, failure }

class PoliticianDetailState extends Equatable {
  final PoliticianDetailStatus status;
  final dom.PoliticianDetail? data;
  final String? error;

  const PoliticianDetailState({
    required this.status,
    this.data,
    this.error,
  });

  const PoliticianDetailState.initial()
      : status = PoliticianDetailStatus.initial,
        data = null,
        error = null;

  PoliticianDetailState copyWith({
    PoliticianDetailStatus? status,
    dom.PoliticianDetail? data,
    String? error,
  }) {
    return PoliticianDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, data, error];
}
