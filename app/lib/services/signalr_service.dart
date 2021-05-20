import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';

import '../global/enviroment.dart';
import 'auth_service.dart';

enum ServerStatus { Connecting, Online, Offline }

class SignalrService with ChangeNotifier {
  ServerStatus serverStatus = ServerStatus.Connecting;

  HubConnection? _connection;

  HubConnection? get connection => this._connection;

  void connect() async {
    _connection = HubConnectionBuilder()
        .withUrl(
          '${Enviroment.socketUrl}',
          HttpConnectionOptions(
            client: IOClient(
              (HttpClient()
                ..badCertificateCallback =
                    (X509Certificate cert, String host, int port) => true)
                ..idleTimeout = Duration(seconds: 1)
                ..connectionTimeout = Duration(seconds: 1),
            ),
            //logging: (level, message) => print(message),
            accessTokenFactory: () async {
              return await AuthService.getToken();
            },
          ),
        )
        .withAutomaticReconnect()
        // .withAutomaticReconnect(CustomReconnectPolicy())
        .build();
    await _connection!.start();

    this.serverStatus = ServerStatus.Online;
    notifyListeners();

    this._connection!.onreconnected((connectionId) {
      print('reconnected >>>>');
      this.serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._connection!.onreconnecting((connectionId) {
      print('reconnecting <<<<');
      this.serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._connection!.onclose((Exception? e) {
      print("EXCEPTION on close: $e");
      this.serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() async {
    await this._connection!.stop();
    this.serverStatus = ServerStatus.Offline;
    notifyListeners();
  }
}

// const CustomRetryDelaysInMilliseconds = [500, 2000, 10000, 30000, null];

// class CustomReconnectPolicy extends RetryPolicy {
//   CustomReconnectPolicy({
//     this.retryDelays = CustomRetryDelaysInMilliseconds,
//   });
//   final List<int?> retryDelays;

//   @override
//   int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
//     print('${DateTime.now()} aqui');
//     print('${retryContext.previousRetryCount!}');
//     return retryDelays[retryContext.previousRetryCount!];
//   }
// }
