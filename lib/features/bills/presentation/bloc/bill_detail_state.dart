part of 'bill_detail_bloc.dart';

enum BillDetailStatus { initial, loading, success, failure }
enum AmendmentsStatus { initial, loading, success, failure }
enum PollBreakdownStatus { initial, loading, success, failure }

class BillDetailState extends AppState {
  final BillDetailStatus status;
  final Bill? bill;
  final AmendmentsStatus amendmentsStatus;
  final List<BillAmendment> amendments;
  final PollBreakdownStatus pollBreakdownStatus;
  final PollBreakdown? pollBreakdown;

  const BillDetailState({
    required this.status,
    this.bill,
    super.failure,
    this.amendmentsStatus = AmendmentsStatus.initial,
    this.amendments = const [],
    this.pollBreakdownStatus = PollBreakdownStatus.initial,
    this.pollBreakdown,
  });

  const BillDetailState.initial()
      : status = BillDetailStatus.initial,
        bill = null,
        amendmentsStatus = AmendmentsStatus.initial,
        amendments = const [],
        pollBreakdownStatus = PollBreakdownStatus.initial,
        pollBreakdown = null,
        super(failure: null);

  BillDetailState copyWith({
    BillDetailStatus? status,
    Bill? bill,
    Failure? failure,
    bool clearFailure = false,
    AmendmentsStatus? amendmentsStatus,
    List<BillAmendment>? amendments,
    PollBreakdownStatus? pollBreakdownStatus,
    PollBreakdown? pollBreakdown,
  }) {
    return BillDetailState(
      status: status ?? this.status,
      bill: bill ?? this.bill,
      failure: clearFailure ? null : (failure ?? this.failure),
      amendmentsStatus: amendmentsStatus ?? this.amendmentsStatus,
      amendments: amendments ?? this.amendments,
      pollBreakdownStatus: pollBreakdownStatus ?? this.pollBreakdownStatus,
      pollBreakdown: pollBreakdown ?? this.pollBreakdown,
    );
  }

  @override
  List<Object?> get props => [...super.props, status, bill, amendmentsStatus, amendments, pollBreakdownStatus, pollBreakdown];
}
