part of 'bill_detail_bloc.dart';

abstract class BillDetailEvent extends Equatable {
  const BillDetailEvent();
  @override
  List<Object?> get props => [];
}

/// Загрузка деталей законопроекта
class BillDetailRequested extends BillDetailEvent {
  final String billId;
  const BillDetailRequested(this.billId);
  @override
  List<Object?> get props => [billId];
}
/// Обновление данных билла без показа прогресс-индикатора (для обновления после голосования)
class BillDetailRefreshRequested extends BillDetailEvent {
  final String billId;
  const BillDetailRefreshRequested(this.billId);
  @override
  List<Object?> get props => [billId];
}

/// Загрузка поправок к законопроекту
class BillDetailAmendmentsRequested extends BillDetailEvent {
  final int billId;
  const BillDetailAmendmentsRequested(this.billId);
  @override
  List<Object?> get props => [billId];
}

class PollBreakDownRequested extends BillDetailEvent {
  final int pollId;
  const PollBreakDownRequested(this.pollId);
}