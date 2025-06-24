import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pessoa.dart';
import 'pagamento_screen.dart'; // certifique-se de que esse import exista

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Pessoa>> _pessoas;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarPessoas();
  }

  void _carregarPessoas() {
    setState(() {
      _pessoas = ApiService.getPessoas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              final pessoas = snapshot.data!;
              return ListView.builder(
                itemCount: pessoas.length,
                itemBuilder: (context, index) {
                  final pessoa = pessoas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      leading: pessoa.fotoUrl != null &&
                              pessoa.fotoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                pessoa.fotoUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.person),
                              ),
                            )
                          : CircleAvatar(
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PagamentoScreen(pessoa: pessoa),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
