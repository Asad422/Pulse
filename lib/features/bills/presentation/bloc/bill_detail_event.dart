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

/// Загрузка поправок
class BillAmendmentsRequested extends BillDetailEvent {
  final int billId;
  const BillAmendmentsRequested(this.billId);
  @override
  List<Object?> get props => [billId];
}

/// Загрузка спонсоров
class BillSponsorsRequested extends BillDetailEvent {
  final int billId;
  const BillSponsorsRequested(this.billId);
  @override
  List<Object?> get props => [billId];
}

/// Загрузка текста законопроекта
class BillTextRequested extends BillDetailEvent {
  final int textId;
  const BillTextRequested(this.textId);
  @override
  List<Object?> get props => [textId];
}

/// Загрузка CRS-отчётов
class BillCrsReportsRequested extends BillDetailEvent {
  final int billId;

  const BillCrsReportsRequested(this.billId);

  @override
  List<Object?> get props => [billId];
}