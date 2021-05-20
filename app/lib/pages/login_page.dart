import 'package:app/services/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final signalrService = Provider.of<SignalrService>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _controllerUsername,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _controllerPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var res = await authService.login(
                      _controllerUsername.text, _controllerPassword.text);

                  if (res.ok) {
                    signalrService.connect();
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(res.mensaje ?? ""),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Aceptar'),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: Text('Iniciar Sesion'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
