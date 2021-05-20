import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/io_client.dart';

import '../global/enviroment.dart';
import '../model/login_response.dart';

class AuthService with ChangeNotifier {
  final _storage = new FlutterSecureStorage();
  String name = "";
  IOClient _http = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? "";
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future<LoginResponse> login(String username, String password) async {
    try {
      var res = await _http.post(
        Uri.parse('${Enviroment.apiUrl}/Auth/Login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': username,
            'password': password,
          },
        ),
      );

      if (res.statusCode == 200) {
        var resp = loginResponseFromJson(res.body);
        this.name = resp.name ?? "sin nombre";
        await _guardarToken(resp.token!);
        return resp;
      } else {
        return LoginResponse(
          ok: false,
          mensaje: 'Credenciales incorrectas',
        );
      }
    } catch (e) {
      print(e);
      return LoginResponse(
        ok: false,
        mensaje: 'Error en autenticación',
      );
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final resp = await _http.post(
      Uri.parse('${Enviroment.apiUrl}/auth/renew'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.name = loginResponse.name ?? "sin nombre";
      await this._guardarToken(loginResponse.token!);

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future logout() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
}
