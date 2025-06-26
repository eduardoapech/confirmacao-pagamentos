import 'package:flutter/material.dart';
import 'package:pagamentos_app/models/pagamento.dart';
import '../models/pagamento_historico.dart';
import '../services/api_service.dart';

class HistoricoScreen extends StatefulWidget {
  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  late Future<List<PagamentoHistorico>> _historico;
  final List<String> nomesMeses = Pagamento.nomesMeses;

  @override
  void initState() {
    super.initState();

    _historico = ApiService.getHistoricoPagamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Pagamentos')),
      body: FutureBuilder<List<PagamentoHistorico>>(
        future: _historico,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Erro: ${snapshot.error}'));

          final pagamentos = snapshot.data!;
          if (pagamentos.isEmpty)
            return Center(child: Text('Nenhum pagamento encontrado'));

          return ListView.builder(
            itemCount: pagamentos.length,
            itemBuilder: (context, index) {
              final p = pagamentos[index];
              return ListTile(
                title: Text('${p.ramo} ${p.nome}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pagamento do mês de ${p.mesFormatado}'),
                    Text('Confirmado em ${p.dataPagamento}'),
                    SizedBox(height: 4),
                    Text('✅ ${p.status}',
                        style: TextStyle(color: Colors.green)),
                    Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
