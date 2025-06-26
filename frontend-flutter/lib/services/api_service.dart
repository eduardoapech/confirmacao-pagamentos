import 'dart:convert';
import 'dart:io';
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

  static Future<void> adicionarPessoaComImagem({
    required String nome,
    required int idade,
    required String ramo,
    File? imagem,
  }) async {
    final url = Uri.parse('$baseUrl/pessoa');

    final request = http.MultipartRequest('POST', url)
      ..fields['nome'] = nome
      ..fields['idade'] = idade.toString()
      ..fields['ramo'] = ramo;

    if (imagem != null) {
      final multipartFile = await http.MultipartFile.fromPath(
        'foto',
        imagem.path,
      );
      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

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

  static Future<void> atualizarPessoa({
    required int id,
    required String nome,
    required int idade,
    required String ramo,
    File? imagem,
  }) async {
    final uri = Uri.parse('$baseUrl/pessoa/$id');

    final request = http.MultipartRequest('PUT', uri)
      ..fields['nome'] = nome
      ..fields['idade'] = idade.toString()
      ..fields['ramo'] = ramo;

    if (imagem != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', imagem.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar pessoa: ${response.body}');
    }
  }

  static Future<void> deletarPessoa(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pessoa/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar pessoa');
    }
  }
}
