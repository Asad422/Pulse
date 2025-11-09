part of 'bill_detail_bloc.dart';

enum BillDetailStatus { initial, loading, success, failure }

class BillDetailState extends Equatable {
  final BillDetailStatus status;
  final Bill? bill;
  final List<BillAmendment> amendments;
  final List<BillSponsor> sponsors;
  final BillText? billText;
  final List<BillCrsReport> crsReports;
  final String? error;

  const BillDetailState({
    required this.status,
    this.bill,
    this.amendments = const [],
    this.sponsors = const [],
    this.billText,
    this.crsReports = const [],
    this.error,
  });

  const BillDetailState.initial()
      : status = BillDetailStatus.initial,
        bill = null,
        amendments = const [],
        sponsors = const [],
        billText = null,
        crsReports = const [],
        error = null;

  BillDetailState copyWith({
    BillDetailStatus? status,
    Bill? bill,
    List<BillAmendment>? amendments,
    List<BillSponsor>? sponsors,
    BillText? billText,
    List<BillCrsReport>? crsReports,
    String? error,
  }) {
    return BillDetailState(
      status: status ?? this.status,
      bill: bill ?? this.bill,
      amendments: amendments ?? this.amendments,
      sponsors: sponsors ?? this.sponsors,
      billText: billText ?? this.billText,
      crsReports: crsReports ?? this.crsReports,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [status, bill, amendments, sponsors, billText, crsReports, error];
}
