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
  List<PagamentoHistorico> _historicoCompleto = [];
  List<PagamentoHistorico> _historicoFiltrado = [];

  final List<String> nomesMeses = Pagamento.nomesMeses;
  String? _mesSelecionado;
  String _filtroNome = '';

  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _historico = _carregarHistorico();
  }

  Future<List<PagamentoHistorico>> _carregarHistorico() async {
    final data = await ApiService.getHistoricoPagamentos();
    setState(() {
      _historicoCompleto = data;
      _historicoFiltrado = data;
    });
    return data;
  }

  void _filtrar() {
    final filtrado = _historicoCompleto.where((p) {
      final nomeOk = p.nome.toLowerCase().contains(_filtroNome.toLowerCase());
      final mesOk =
          _mesSelecionado == null || p.mesFormatado == _mesSelecionado;
      return nomeOk && mesOk;
    }).toList();

    setState(() {
      _historicoFiltrado = filtrado;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Campo de filtro por nome
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar por nome',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _nomeController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _nomeController.clear();
                              _filtroNome = '';
                              _filtrar();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    _filtroNome = value;
                    _filtrar();
                  },
                ),
                SizedBox(height: 10),
                // Dropdown de mês
                DropdownButtonFormField<String>(
                  value: _mesSelecionado,
                  decoration: InputDecoration(
                    labelText: 'Filtrar por mês',
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                  items: [null, ...nomesMeses].map((mes) {
                    return DropdownMenuItem(
                      value: mes,
                      child: Text(mes ?? 'Todos os meses'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _mesSelecionado = value);
                    _filtrar();
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _historicoFiltrado.isEmpty
                      ? Center(child: Text('Nenhum pagamento encontrado'))
                      : ListView.builder(
                          itemCount: _historicoFiltrado.length,
                          itemBuilder: (context, index) {
                            final p = _historicoFiltrado[index];
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
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
