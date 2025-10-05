part of 'laws_bloc.dart';

abstract class LawsEvent extends Equatable {
  const LawsEvent();
  @override
  List<Object?> get props => [];
}

class LawsRequested extends LawsEvent {
  final LawsQuery query; // ✅ теперь используем единый объект LawsQuery

  const LawsRequested(this.query);

  @override
  List<Object?> get props => [query];
}
