// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/produto.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final produtosBox = Hive.box<Produto>('produtos');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos (Hive)'),
        backgroundColor: Colors.blueGrey,
      ),
      body: 
      // O ValueListenableBuilder atualiza a UI automaticamente ao salvar/deletar
      ValueListenableBuilder(
        valueListenable: produtosBox.listenable(),
        builder: (context, Box<Produto> box, _) {
          final produtos = box.values.toList();

          if (produtos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum produto cadastrado.\nClique no "+" para adicionar!', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: ListTile(
                  title: Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Preço: R\$ ${produto.preco.toStringAsFixed(2)} | Qtd: ${produto.quantidade}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Remove o item usando a chave (ou deleteAt() para o índice)
                      box.deleteAt(index); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produto ${produto.nome} removido!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}