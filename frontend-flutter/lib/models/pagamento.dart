import 'package:pagamentos_app/models/pessoa.dart';

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

  /// Lista estática de nomes de meses (acessível de qualquer lugar)
  static const List<String> nomesMeses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  /// Método utilitário para retornar o nome do mês a partir do número
  static String nomeMes(int numeroMes) {
    if (numeroMes >= 1 && numeroMes <= 12) {
      return nomesMeses[numeroMes - 1];
    }
    return 'Mês Inválido';
  }
}
