import 'package:equatable/equatable.dart';

import '../failure/failure.dart';

/// Базовый класс для всех состояний BLoC. Содержит опциональный [failure].
abstract class AppState extends Equatable {
  const AppState({this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}
