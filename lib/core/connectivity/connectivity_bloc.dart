import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(const ConnectivityState.unknown()) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>(_onChanged);
    on<ConnectivityCheckRequested>(_onCheckRequested);
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _onStarted(
    ConnectivityStarted event,
    Emitter<ConnectivityState> emit,
  ) async {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      add(ConnectivityChanged(results));
    });
    add(ConnectivityCheckRequested());
  }

  void _onChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(_mapResultsToState(event.results));
  }

  Future<void> _onCheckRequested(
    ConnectivityCheckRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    final results = await _connectivity.checkConnectivity();
    emit(_mapResultsToState(results));
  }

  ConnectivityState _mapResultsToState(List<ConnectivityResult> results) {
    if (results.isEmpty) return const ConnectivityState.disconnected();
    final connected = results.where((r) => r != ConnectivityResult.none).toList();
    if (connected.isEmpty) return const ConnectivityState.disconnected();
    return ConnectivityState.connected(connected.first);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
