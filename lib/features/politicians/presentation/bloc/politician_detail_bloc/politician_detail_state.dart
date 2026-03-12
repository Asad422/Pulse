part of 'politician_detail_bloc.dart';

enum PoliticianDetailStatus { initial, loading, success, failure }
enum BillsLoadStatus { initial, loading, success, failure }
enum PoliticianPollBreakdownStatus { initial, loading, success, failure }

class PoliticianDetailState extends AppState {
  final PoliticianDetailStatus status;
  final dom.PoliticianDetail? data;
  
  // Sponsored bills
  final BillsLoadStatus sponsoredBillsStatus;
  final List<Bill> sponsoredBills;
  
  // Cosponsored bills
  final BillsLoadStatus cosponsoredBillsStatus;
  final List<Bill> cosponsoredBills;

  // Poll breakdown
  final PoliticianPollBreakdownStatus pollBreakdownStatus;
  final PollBreakdown? pollBreakdown;

  const PoliticianDetailState({
    required this.status,
    this.data,
    super.failure,
    this.sponsoredBillsStatus = BillsLoadStatus.initial,
    this.sponsoredBills = const [],
    this.cosponsoredBillsStatus = BillsLoadStatus.initial,
    this.cosponsoredBills = const [],
    this.pollBreakdownStatus = PoliticianPollBreakdownStatus.initial,
    this.pollBreakdown,
  });

  const PoliticianDetailState.initial()
      : status = PoliticianDetailStatus.initial,
        data = null,
        sponsoredBillsStatus = BillsLoadStatus.initial,
        sponsoredBills = const [],
        cosponsoredBillsStatus = BillsLoadStatus.initial,
        cosponsoredBills = const [],
        pollBreakdownStatus = PoliticianPollBreakdownStatus.initial,
        pollBreakdown = null,
        super(failure: null);

  PoliticianDetailState copyWith({
    PoliticianDetailStatus? status,
    dom.PoliticianDetail? data,
    Failure? failure,
    bool clearFailure = false,
    BillsLoadStatus? sponsoredBillsStatus,
    List<Bill>? sponsoredBills,
    BillsLoadStatus? cosponsoredBillsStatus,
    List<Bill>? cosponsoredBills,
    PoliticianPollBreakdownStatus? pollBreakdownStatus,
    PollBreakdown? pollBreakdown,
  }) {
    return PoliticianDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      failure: clearFailure ? null : (failure ?? this.failure),
      sponsoredBillsStatus: sponsoredBillsStatus ?? this.sponsoredBillsStatus,
      sponsoredBills: sponsoredBills ?? this.sponsoredBills,
      cosponsoredBillsStatus: cosponsoredBillsStatus ?? this.cosponsoredBillsStatus,
      cosponsoredBills: cosponsoredBills ?? this.cosponsoredBills,
      pollBreakdownStatus: pollBreakdownStatus ?? this.pollBreakdownStatus,
      pollBreakdown: pollBreakdown ?? this.pollBreakdown,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    status, 
    data, 
    sponsoredBillsStatus, 
    sponsoredBills,
    cosponsoredBillsStatus,
    cosponsoredBills,
    pollBreakdownStatus,
    pollBreakdown,
  ];
}
