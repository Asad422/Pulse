part of 'politicians_bloc.dart';

enum PoliticiansStatus { initial, loading, success, failure }

class PoliticiansState extends Equatable {
  final PoliticiansStatus status;
  final List<Politician> items;
  final String? error;

  const PoliticiansState({
    required this.status,
    required this.items,
    required this.error,
  });

  const PoliticiansState.initial()
      : status = PoliticiansStatus.initial,
        items = const [],
        error = null;

  PoliticiansState copyWith({
    PoliticiansStatus? status,
    List<Politician>? items,
    String? error,
  }) {
    return PoliticiansState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
