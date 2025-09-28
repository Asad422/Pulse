part of 'laws_bloc.dart';

enum LawsStatus { initial, loading, success, failure }

class LawsState extends Equatable {
  final LawsStatus status;
  final List<Law> items;
  final String? error;

  const LawsState({
    required this.status,
    this.items = const [],
    this.error,
  });

  const LawsState.initial()
      : status = LawsStatus.initial,
        items = const [],
        error = null;

  LawsState copyWith({
    LawsStatus? status,
    List<Law>? items,
    String? error,
  }) {
    return LawsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
