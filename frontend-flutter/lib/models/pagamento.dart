import 'pessoa.dart';

class Pagamento {
  int id;
  int pessoaId;
  Pessoa? pessoa;
  String? dataPagamento;
  int mes;
  int ano;

  Pagamento({
    required this.id,
    required this.pessoaId,
    this.pessoa,
    this.dataPagamento,
    required this.mes,
    required this.ano,
  });

  factory Pagamento.fromJson(Map<String, dynamic> json) {
    return Pagamento(
      id: json['id'],
      pessoaId: json['pessoaId'],
      pessoa: json['pessoa'] != null ? Pessoa.fromJson(json['pessoa']) : null,
      dataPagamento: json['dataPagamento']?.toString(),
      mes: json['mes'],
      ano: json['ano'],
    );
  }
}
