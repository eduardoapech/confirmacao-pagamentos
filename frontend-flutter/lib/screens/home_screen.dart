import 'package:flutter/material.dart';
import 'package:pagamentos_app/screens/editar_pessoa_screen.dart';
import '../services/api_service.dart';
import '../models/pessoa.dart';
import 'pagamento_screen.dart'; // certifique-se de que esse import exista

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Pessoa>> _pessoas;

  TextEditingController _searchController = TextEditingController();
  List<Pessoa> _pessoasOriginais = [];
  List<Pessoa> _pessoasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _pessoas = ApiService.getPessoas();
    _searchController.addListener(() {
      _filtrarPessoas(_searchController.text);
    });
    _carregarPessoas();
  }

  void _carregarPessoas() {
    ApiService.getPessoas().then((pessoas) {
      setState(() {
        _pessoasOriginais = pessoas;
        _pessoasFiltradas = pessoas;
      });
    });
  }

  void _filtrarPessoas(String query) {
    final filtradas = _pessoasOriginais.where((p) {
      return p.nome.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _pessoasFiltradas = filtradas;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filtrarPessoas('');
                        },
                      )
                    : null,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Pessoa>>(
                future: _pessoas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum usuário encontrado'));
                  } else {
                    return ListView.builder(
                      itemCount: _pessoasFiltradas.length,
                      itemBuilder: (context, index) {
                        final pessoa = _pessoasFiltradas[index];
                        return Dismissible(
                          key: ValueKey(pessoa.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirmar exclusão'),
                                content: Text(
                                    'Tem certeza que deseja excluir o usuário "${pessoa.nome}"?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: Text('Excluir'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) async {
                            try {
                              await ApiService.deletarPessoa(pessoa.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Usuário "${pessoa.nome}" excluído')),
                              );
                              _carregarPessoas();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao excluir: $e')),
                              );
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              leading: pessoa.fotoCompleta != null
                                  ? CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(pessoa.fotoCompleta!),
                                    )
                                  : CircleAvatar(
                                      radius: 25,
                                      child: Text(
                                        pessoa.nome.isNotEmpty
                                            ? pessoa.nome[0].toUpperCase()
                                            : '?',
                                      ),
                                    ),
                              title: Text(
                                pessoa.nome,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Idade: ${pessoa.idade} | Ramo: ${pessoa.ramo}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditarPessoaScreen(pessoa: pessoa),
                                    ),
                                  );
                                  _carregarPessoas();
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PagamentoScreen(pessoa: pessoa),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
