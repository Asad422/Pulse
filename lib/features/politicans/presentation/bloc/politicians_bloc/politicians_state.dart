part of 'politicians_bloc.dart';

enum PoliticiansStatus { initial, loading, success, failure, loadingMore }

class PoliticiansState extends Equatable {
  final PoliticiansStatus status;
  final List<Politician> items;
  final String? error;
  final bool hasReachedEnd;

  const PoliticiansState({
    required this.status,
    required this.items,
    this.error,
    this.hasReachedEnd = false,
  });

  const PoliticiansState.initial()
      : status = PoliticiansStatus.initial,
        items = const [],
        error = null,
        hasReachedEnd = false;

  PoliticiansState copyWith({
    PoliticiansStatus? status,
    List<Politician>? items,
    String? error,
    bool? hasReachedEnd,
  }) {
    return PoliticiansState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [status, items, error, hasReachedEnd];
}
