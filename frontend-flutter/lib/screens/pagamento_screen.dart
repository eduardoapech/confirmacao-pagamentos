import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/api_service.dart';

class PagamentoScreen extends StatefulWidget {
  final Pessoa pessoa;

  PagamentoScreen({required this.pessoa});

  @override
  _PagamentoScreenState createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  Set<int> mesesPagos = {};
  int anoAtual = DateTime.now().year;
  bool loading = true;

  final List<String> nomesMeses = [
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

  @override
  void initState() {
    super.initState();

    _carregarPagamentos();
  }

  Future<void> _carregarPagamentos() async {
    setState(() => loading = true);
    try {
      final pagamentos =
          await ApiService.getPagamentosPorPessoa(widget.pessoa.id);
      print('Pagamentos recebidos: $pagamentos');

      setState(() {
        mesesPagos = pagamentos
            .where((p) => p.ano == anoAtual)
            .map((p) => p.mes)
            .toSet();
        loading = false;
      });
    } catch (e) {
      print('Erro ao carregar pagamentos: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _confirmarPagamento(int mes) async {
    setState(() => loading = true);
    await ApiService.confirmarPagamento(widget.pessoa.id, mes, anoAtual);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pagamento de ${nomesMeses[mes - 1]} confirmado')),
    );
    await _carregarPagamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagamentos - ${widget.pessoa.nome}')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                final mes = index + 1;
                final pago = mesesPagos.contains(mes);
                return ListTile(
                  title: Text(nomesMeses[index]),
                  trailing: ElevatedButton(
                    onPressed: pago ? null : () => _confirmarPagamento(mes),
                    child: Text(pago ? 'Pago' : 'Confirmar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pago ? Colors.grey : Colors.blue,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
