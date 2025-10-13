// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/produto.dart';
import 'screens/home_screen.dart';

void main() async {
  // Garante que o Flutter esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Obtém o diretório de documentos para salvar o Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  
  // Inicializa o Hive
  await Hive.initFlutter(appDocumentDir.path);
  
  // Registra o Adapter do Produto (gerado pelo build_runner)
  Hive.registerAdapter(ProdutoAdapter());
  
  // Abre a Box onde os dados do Produto serão armazenados
  await Hive.openBox<Produto>('produtos');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}