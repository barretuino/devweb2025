import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const CadastroProdutoScreen(),
    );
  }
}

// --- Estrutura de Dados (Model) ---
class Produto {
  final String nome;
  final double preco;

  Produto({required this.nome, required this.preco});

  @override
  String toString() {
    return 'Produto: {Nome: $nome, Preço: R\$ ${preco.toStringAsFixed(2)}}';
  }
}

// --- Tela de Cadastro ---

class CadastroProdutoScreen extends StatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  // Chave global para identificar e validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar o texto dos campos
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  @override
  void dispose() {
    // É importante liberar os controladores para evitar vazamentos de memória
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  // Lógica de "salvar" o produto
  void _salvarProduto() {
    // 1. Valida o formulário usando a chave
    if (_formKey.currentState!.validate()) {
      // 2. Se a validação for bem-sucedida, processa os dados

      try {
        final nome = _nomeController.text;
        final preco = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;

        // Cria o objeto Produto
        final novoProduto = Produto(nome: nome, preco: preco);

        // Ação de salvamento (Aqui você enviaria para um banco de dados ou API)
        
        // Exibe o resultado no console e na tela
        print('Produto Cadastrado: $novoProduto');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto Salvo: ${novoProduto.nome}')),
        );

        // Opcional: Limpa os campos após o sucesso
        _nomeController.clear();
        _precoController.clear();
        
      } catch (e) {
        // Lida com erros de conversão, se necessário
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao processar dados.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produto'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // O Form encapsula os campos para permitir a validação em massa
        child: Form(
          key: _formKey, // Liga a chave global ao formulário
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo Nome do Produto
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  hintText: 'Ex: Café Especial',
                ),
                // Função de validação
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto.';
                  }
                  return null; // Retorna null se for válido
                },
              ),
              
              const SizedBox(height: 20),

              // Campo Preço
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$)',
                  hintText: 'Ex: 15.50',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // Função de validação
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O preço é obrigatório.';
                  }
                  // Tenta converter o valor para número
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Insira um valor numérico válido.';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 30),

              // Botão de Salvar
              ElevatedButton(
                onPressed: _salvarProduto,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Salvar Produto',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}