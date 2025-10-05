part of 'politicians_bloc.dart';

enum PoliticiansStatus { initial, loading, success, failure, loadingMore }

class PoliticiansState extends Equatable {
  final PoliticiansStatus status;
  final List<Politician> items;
  final String? error;
  final bool hasReachedEnd;
  final PoliticiansQuery? query;

  const PoliticiansState({
    required this.status,
    required this.items,
    this.error,
    this.hasReachedEnd = false,
    this.query,
  });

  const PoliticiansState.initial()
      : status = PoliticiansStatus.initial,
        items = const [],
        error = null,
        hasReachedEnd = false,
        query = null;

  PoliticiansState copyWith({
    PoliticiansStatus? status,
    List<Politician>? items,
    String? error,
    bool? hasReachedEnd,
    PoliticiansQuery? query,
  }) {
    return PoliticiansState(
      status: status ?? this.status,
      // ✅ Всегда создаём новую копию списка
      items: items != null ? List<Politician>.from(items) : List<Politician>.from(this.items),
      error: error,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    error,
    hasReachedEnd,
    query, // ✅ теперь query участвует в сравнении
  ];
}
