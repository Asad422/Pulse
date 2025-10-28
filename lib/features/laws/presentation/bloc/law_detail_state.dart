part of 'law_detail_bloc.dart';

enum LawDetailStatus { initial, loading, success, failure }

class LawDetailState extends Equatable {
  final LawDetailStatus status;
  final Law? law;
  final String? error;

  const LawDetailState({
    required this.status,
    this.law,
    this.error,
  });

  const LawDetailState.initial()
      : status = LawDetailStatus.initial,
        law = null,
        error = null;

  LawDetailState copyWith({
    LawDetailStatus? status,
    Law? law,
    String? error,
  }) {
    return LawDetailState(
      status: status ?? this.status,
      law: law ?? this.law,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, law, error];
}
