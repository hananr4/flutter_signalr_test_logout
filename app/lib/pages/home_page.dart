import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/signalr_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final signalrService = Provider.of<SignalrService>(context);

    signalrService.connection!.on('metodo-en-telefono-logout', (arguments) {
      print('Forzando logout');
      authService.logout();
      Navigator.pushReplacementNamed(context, 'login');
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(authService.name),
              (signalrService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.circle, color: Colors.green, size: 50)
                  : Icon(Icons.offline_bolt, color: Colors.red, size: 50),
              ElevatedButton(
                  onPressed: () async {
                    signalrService.disconnect();
                    authService.logout();
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: Text('Logout')),
            ],
          ),
        ));
  }
}
