part of 'law_detail_bloc.dart';

abstract class LawDetailEvent extends Equatable {
  const LawDetailEvent();
  @override
  List<Object?> get props => [];
}

class LawDetailRequested extends LawDetailEvent {
  final int lawId;
  const LawDetailRequested(this.lawId);
  @override
  List<Object?> get props => [lawId];
}
