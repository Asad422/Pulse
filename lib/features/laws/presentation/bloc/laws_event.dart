part of 'laws_bloc.dart';

abstract class LawsEvent extends Equatable {
  const LawsEvent();
  @override
  List<Object?> get props => [];
}

class LawsRequested extends LawsEvent {
  final int? congress;
  final String? lawType;
  final String? lawNumber;
  final int? billId;

  const LawsRequested({this.congress, this.lawType, this.lawNumber, this.billId});
}
