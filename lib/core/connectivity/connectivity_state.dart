part of 'connectivity_bloc.dart';

enum ConnectivityStatus { unknown, connected, disconnected }

class ConnectivityState extends Equatable {
  const ConnectivityState._({
    required this.status,
    this.result,
  });

  const ConnectivityState.unknown()
      : this._(status: ConnectivityStatus.unknown, result: null);

  const ConnectivityState.connected(ConnectivityResult result)
      : this._(status: ConnectivityStatus.connected, result: result);

  const ConnectivityState.disconnected()
      : this._(status: ConnectivityStatus.disconnected, result: null);

  final ConnectivityStatus status;
  final ConnectivityResult? result;

  bool get isConnected => status == ConnectivityStatus.connected;
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  @override
  List<Object?> get props => [status, result];
}
