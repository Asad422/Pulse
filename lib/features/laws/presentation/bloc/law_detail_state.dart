part of 'law_detail_bloc.dart';

enum LawDetailStatus { initial, loading, success, failure }
enum LawPollBreakdownStatus { initial, loading, success, failure }
enum LawRelatedBillsStatus { initial, loading, success, failure }

class LawDetailState extends AppState {
  final LawDetailStatus status;
  final Law? law;
  final LawPollBreakdownStatus pollBreakdownStatus;
  final PollBreakdown? pollBreakdown;
  final LawRelatedBillsStatus relatedBillsStatus;
  final List<Bill> relatedBills;

  const LawDetailState({
    required this.status,
    this.law,
    super.failure,
    this.pollBreakdownStatus = LawPollBreakdownStatus.initial,
    this.pollBreakdown,
    this.relatedBillsStatus = LawRelatedBillsStatus.initial,
    this.relatedBills = const [],
  });

  const LawDetailState.initial()
      : status = LawDetailStatus.initial,
        law = null,
        pollBreakdownStatus = LawPollBreakdownStatus.initial,
        pollBreakdown = null,
        relatedBillsStatus = LawRelatedBillsStatus.initial,
        relatedBills = const [],
        super(failure: null);

  LawDetailState copyWith({
    LawDetailStatus? status,
    Law? law,
    Failure? failure,
    bool clearFailure = false,
    LawPollBreakdownStatus? pollBreakdownStatus,
    PollBreakdown? pollBreakdown,
    LawRelatedBillsStatus? relatedBillsStatus,
    List<Bill>? relatedBills,
  }) {
    return LawDetailState(
      status: status ?? this.status,
      law: law ?? this.law,
      failure: clearFailure ? null : (failure ?? this.failure),
      pollBreakdownStatus: pollBreakdownStatus ?? this.pollBreakdownStatus,
      pollBreakdown: pollBreakdown ?? this.pollBreakdown,
      relatedBillsStatus: relatedBillsStatus ?? this.relatedBillsStatus,
      relatedBills: relatedBills ?? this.relatedBills,
    );
  }

  @override
  List<Object?> get props => [...super.props, status, law, pollBreakdownStatus, pollBreakdown, relatedBillsStatus, relatedBills];
}
