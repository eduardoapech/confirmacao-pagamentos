import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CadastroScreen extends StatefulWidget {
  final VoidCallback? onCadastroSucesso;

  CadastroScreen({this.onCadastroSucesso});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  int idade = 0;
  String ramo = 'Lobinho';
  String? fotoUrl;

  void salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.adicionarPessoa(nome, idade, ramo, fotoUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário cadastrado com sucesso')),
        );

        await Future.delayed(Duration(seconds: 1));

        if (widget.onCadastroSucesso != null) {
          widget.onCadastroSucesso!(); // informa à tela principal
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome completo'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o nome' : null,
              onChanged: (value) => nome = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final n = int.tryParse(value ?? '');
                return (n == null || n <= 0) ? 'Idade inválida' : null;
              },
              onChanged: (value) => idade = int.tryParse(value) ?? 0,
            ),
            DropdownButtonFormField<String>(
              value: ramo,
              decoration: InputDecoration(labelText: 'Ramo Escoteiro'),
              items: ['Lobinho', 'Escoteiro']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) => setState(() => ramo = value!),
              validator: (value) => value == null ? 'Escolha um ramo' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'URL da Foto (opcional)'),
              onChanged: (value) => fotoUrl = value.isEmpty ? null : value,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: salvar, child: Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
