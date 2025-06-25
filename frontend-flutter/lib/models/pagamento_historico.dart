class PagamentoHistorico {
  final String nome;
  final String ramo;
  final String dataPagamento;
  final String status;

  PagamentoHistorico({
    required this.nome,
    required this.ramo,
    required this.dataPagamento,
    required this.status,
  });

  factory PagamentoHistorico.fromJson(Map<String, dynamic> json) {
    return PagamentoHistorico(
      nome: json['nome'],
      ramo: json['ramo'],
      dataPagamento: json['dataPagamento'] ?? '',
      status: json['status'],
    );
  }
}
