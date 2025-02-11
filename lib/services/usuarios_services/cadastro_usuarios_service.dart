import 'dart:convert';
import 'package:http/http.dart' as http;

class CadastroUsuarioService {
  Future<bool>? cadastroUsuario(String NomeUsuario, String EmailUsuario,
      String SenhaUsuario, String NomeCompletoUsuario) async {
    try {
      var response = await http.post(
          Uri.parse('http://localhost:8080/api/usuario/cadastro-usuario'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nome_usuario': NomeUsuario,
            'email_usuario': EmailUsuario,
            'senha_usuario': SenhaUsuario,
            'nomeCompleto_usuario': NomeCompletoUsuario,
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Network error  teste+ $e");
      return false;
    }
  }
}
