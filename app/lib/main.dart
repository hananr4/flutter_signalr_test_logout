import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/home_page.dart';
import './pages/loading_page.dart';
import './pages/login_page.dart';

import './services/signalr_service.dart';
import './services/auth_service.dart';
import 'pages/Pagina2Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SignalrService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (_) => HomePage(),
          'loading': (_) => LoadingPage(),
          'login': (_) => LoginPage(),
          'pagina2': (_) => Pagina2Page(),
        },
        initialRoute: 'loading',
        title: 'Material App',
        navigatorKey: _navigatorKey,
      ),
    );
  }
}
