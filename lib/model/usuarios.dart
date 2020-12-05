class Usuarios {
  String login;
  String senha;
  String id;

  Usuarios(this.login, this.senha, this.id);

  Usuarios.fromMap(Map<String, dynamic> map, String id) {
    this.login = map['login'];
    this.senha = map['senha'];
    this.id = id ?? '';
  }
}
