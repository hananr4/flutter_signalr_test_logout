import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.ok,
    this.token,
    this.mensaje,
    this.name,
  });

  bool ok;
  String? token;
  String? mensaje;
  String? name;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        token: json["token"],
        mensaje: json["mensaje"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "token": token,
        "mensaje": mensaje,
        "name": name,
      };
}
