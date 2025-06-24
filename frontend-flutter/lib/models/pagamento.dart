import 'pessoa.dart';

class Pagamento {
  int id;
  int pessoaId;
  Pessoa? pessoa;
  String? dataPagamento;
  String Mes;

  Pagamento({
    required this.id,
    required this.pessoaId,
    this.pessoa,
    this.dataPagamento,
    required this.Mes,
  });

  factory Pagamento.fromJson(Map<String, dynamic> json) => Pagamento(
        id: json['id'],
        pessoaId: json['pessoaId'],
        pessoa: json['pessoa'] != null ? Pessoa.fromJson(json['pessoa']) : null,
        dataPagamento: json['dataPagamento'],
        Mes: json['Mes'],
      );
}
