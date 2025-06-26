import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pagamentos_app/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
  File? _imagemSelecionada;

  final picker = ImagePicker();

  Future<void> _selecionarImagem() async {
    final permitido = await _solicitarPermissoes();
    if (!permitido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão negada')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text('Tirar Foto'),
            onTap: () async {
              Navigator.pop(context);
              final imagem = await picker.pickImage(
                source: ImageSource.camera,
                maxWidth: 400,
                maxHeight: 400,
                imageQuality: 80,
              );
              if (imagem != null) {
                setState(() => _imagemSelecionada = File(imagem.path));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Escolher da Galeria'),
            onTap: () async {
              Navigator.pop(context);
              final imagem = await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 400,
                maxHeight: 400,
                imageQuality: 80,
              );
              if (imagem != null) {
                setState(() => _imagemSelecionada = File(imagem.path));
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _solicitarPermissoes() async {
    final statusCamera = await Permission.camera.request();
    final statusFotos = await Permission.photos.request(); // iOS
    final statusStorage = await Permission.storage.request(); // Android

    return statusCamera.isGranted &&
        (statusFotos.isGranted || statusStorage.isGranted);
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ApiService.adicionarPessoaComImagem(
        nome: nome,
        idade: idade,
        ramo: ramo,
        imagem: _imagemSelecionada,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário cadastrado com sucesso')),
      );

      await Future.delayed(Duration(seconds: 1));
      widget.onCadastroSucesso?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            GestureDetector(
              onTap: _selecionarImagem,
              child: Center(
                child: _imagemSelecionada != null
                    ? ClipOval(
                        child: Image.file(
                          _imagemSelecionada!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.camera_alt, size: 50),
                      ),
              ),
            ),
            SizedBox(height: 12),
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
            SizedBox(height: 20),
            ElevatedButton(onPressed: salvar, child: Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
