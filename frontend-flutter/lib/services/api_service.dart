import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pagamentos_app/models/pagamento_historico.dart';
import '../models/pessoa.dart';
import '../models/pagamento.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.2.134:5000/api'; // Altere para seu IP local

  static Future<List<Pessoa>> getPessoas() async {
    final url = Uri.parse("http://192.168.2.134:5000/api/pessoa");
    print('Buscando URL: $url');
    final response = await http.get(url);
    final List jsonData = json.decode(response.body);
    return jsonData.map((e) => Pessoa.fromJson(e)).toList();
  }

  static Future<void> confirmarPagamento(int pessoaId, int mes, int ano) async {
    await http.post(
      Uri.parse('$baseUrl/pagamento'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'pessoaId': pessoaId,
        'mes': mes,
        'ano': ano,
      }),
    );
  }

  static Future<List<Pagamento>> getPagamentosPorPessoa(int pessoaId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/pagamento/pessoa/$pessoaId'));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => Pagamento.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar pagamentos');
    }
  }

  static Future<void> adicionarPessoa(
      String nome, int idade, String ramo, String? fotoUrl) async {
    final url = Uri.parse('$baseUrl/pessoa');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'idade': idade,
        'ramo': ramo,
        'fotoUrl': fotoUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar pessoa: ${response.body}');
    }
  }

  static Future<List<PagamentoHistorico>> getHistoricoPagamentos() async {
    final response = await http.get(Uri.parse('$baseUrl/pagamento/historico'));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => PagamentoHistorico.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar histórico de pagamentos');
    }
  }
}
