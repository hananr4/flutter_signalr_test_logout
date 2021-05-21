import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/signalr_service.dart';

class Pagina2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signalrService = Provider.of<SignalrService>(context);
    signalrService.configurarCierreAutomatico(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina 2'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Pagina 2',
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'home');
                },
                child: Text('Regresar a Home'))
          ],
        ),
      ),
    );
  }
}
