import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pagamentos_app/models/pessoa.dart';
import 'package:pagamentos_app/services/api_service.dart';

class EditarPessoaScreen extends StatefulWidget {
  final Pessoa pessoa;

  const EditarPessoaScreen({required this.pessoa});

  @override
  _EditarPessoaScreenState createState() => _EditarPessoaScreenState();
}

class _EditarPessoaScreenState extends State<EditarPessoaScreen> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late int idade;
  late String ramo;
  File? novaImagem;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nome = widget.pessoa.nome;
    idade = widget.pessoa.idade;
    ramo = widget.pessoa.ramo;
  }

  Future<void> _selecionarImagem() async {
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() => novaImagem = File(imagem.path));
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ApiService.atualizarPessoa(
        id: widget.pessoa.id,
        nome: nome,
        idade: idade,
        ramo: ramo,
        imagem: novaImagem,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pessoa atualizada com sucesso')),
      );
      Navigator.pop(context); // volta para tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Pessoa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _selecionarImagem,
                child: Center(
                  child: novaImagem != null
                      ? ClipOval(
                          child: Image.file(novaImagem!,
                              width: 100, height: 100, fit: BoxFit.cover),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.pessoa.fotoCompleta != null
                              ? NetworkImage(widget.pessoa.fotoCompleta!)
                              : null,
                          child: widget.pessoa.fotoCompleta == null
                              ? Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: nome,
                decoration: InputDecoration(labelText: 'Nome completo'),
                onChanged: (value) => nome = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                initialValue: idade.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Idade'),
                onChanged: (value) => idade = int.tryParse(value) ?? 0,
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  return (n == null || n <= 0) ? 'Idade inválida' : null;
                },
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
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _salvar, child: Text('Salvar Alterações')),
            ],
          ),
        ),
      ),
    );
  }
}
