import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/api_service.dart';

class PagamentoScreen extends StatelessWidget {
  final Pessoa pessoa;

  PagamentoScreen({required this.pessoa});

  final List<String> meses = [
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

  final int anoAtual = DateTime.now().year;

  void confirmarPagamento(BuildContext context, int pessoaId, int mes) async {
    try {
      await ApiService.confirmarPagamento(pessoaId, mes.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pagamento de $mes/$anoAtual confirmado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao confirmar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagamentos - ${pessoa.nome}')),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          final nomeMes = meses[index];
          final numeroMes = index + 1;
          return ListTile(
            title: Text('$nomeMes/$anoAtual'),
            trailing: ElevatedButton(
              child: Text('Confirmar'),
              onPressed: () =>
                  confirmarPagamento(context, pessoa.id, numeroMes),
            ),
          );
        },
      ),
    );
  }
}
