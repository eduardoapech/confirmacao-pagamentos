import 'package:pagamentos_app/models/pagamento.dart';

class PagamentoHistorico {
  final String nome;
  final String ramo;
  final String dataPagamento;
  final String status;
  final int mes; // agora diretamente aqui

  PagamentoHistorico({
    required this.nome,
    required this.ramo,
    required this.dataPagamento,
    required this.status,
    required this.mes,
  });

  factory PagamentoHistorico.fromJson(Map<String, dynamic> json) {
    return PagamentoHistorico(
      nome: json['nome'],
      ramo: json['ramo'],
      dataPagamento: json['dataPagamento'] ?? '',
      status: json['status'],
      mes: json['mes'] ?? 0, // pegar direto do JSON
    );
  }

  String get mesFormatado {
    if (mes >= 1 && mes <= 12) {
      return Pagamento.nomeMes(mes);
    }
    return 'Mês inválido';
  }
}
