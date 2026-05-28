// core/services/connectivity_service.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService(this._connectivity);

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result[0] != ConnectivityResult.none;
  }

  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map(
      (result) => result[0] != ConnectivityResult.none,
    );
  }
}
