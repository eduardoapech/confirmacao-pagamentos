import 'dart:io';

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/historico_screen.dart';
import 'screens/cadastro_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(),
      CadastroScreen(
        onCadastroSucesso: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      HistoricoScreen(),
    ]);
  }

  void _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); // fecha o menu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Controle de Pagamentos')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu', style: TextStyle(fontSize: 24))),
            ListTile(title: Text('Home'), onTap: () => _onSelectItem(0)),
            ListTile(
                title: Text('Cadastrar Usuário'),
                onTap: () => _onSelectItem(1)),
            ListTile(title: Text('Histórico'), onTap: () => _onSelectItem(2)),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Sair do aplicativo'),
                    content: Text('Tem certeza que deseja sair?'),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: Text('Sair'),
                        onPressed: () => exit(0), // Fecha o app
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
