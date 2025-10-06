import 'package:flutter/material.dart';

class ItemMenu {
  final int id;
  final String nome;
  final double preco;

  const ItemMenu({
    required this.id,
    required this.nome,
    required this.preco,
  });
}

class ItemPedido {
  final ItemMenu item;
  int quantidade;

  ItemPedido({
    required this.item,
    this.quantidade = 1,
  });

  // Getter para calcular o subtotal
  double get subtotal => item.preco * quantidade;
}

// --- Lista de dados de exemplo ---
const List<ItemMenu> menuItens = [
  ItemMenu(id: 1, nome: 'Pizza Margherita', preco: 45.00),
  ItemMenu(id: 2, nome: 'Hambúrguer Clássico', preco: 32.50),
  ItemMenu(id: 3, nome: 'Porção de Batata Frita', preco: 18.00),
  ItemMenu(id: 4, nome: 'Refrigerante 350ml', preco: 6.00),
];

// --- Aplicação Principal (substitua seu main.dart) ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Pedidos',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const MenuScreen(),
    );
  }
}

// --- Tela que gerencia o estado do Pedido ---

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Onde o estado do carrinho é armazenado
  final List<ItemPedido> _carrinho = [];

  // Função para adicionar/atualizar um item no carrinho
  void _adicionarItem(ItemMenu item) {
    setState(() {
      // 1. Tenta encontrar o item no carrinho
      final index = _carrinho.indexWhere((p) => p.item.id == item.id);

      if (index >= 0) {
        // 2. Se o item já existe, apenas incrementa a quantidade
        _carrinho[index].quantidade++;
      } else {
        // 3. Se não existe, adiciona um novo ItemPedido (com quantidade = 1)
        _carrinho.add(ItemPedido(item: item));
      }
    });
  }

  // Função para remover um item do carrinho
  void _removerItem(ItemPedido itemPedido) {
    setState(() {
      if (itemPedido.quantidade > 1) {
        // 1. Se a quantidade for maior que 1, apenas decrementa
        itemPedido.quantidade--;
      } else {
        // 2. Se a quantidade for 1, remove o item da lista
        _carrinho.remove(itemPedido);
      }
    });
  }

  // Calcula o valor total do pedido
  double get _totalPedido {
    return _carrinho.fold(0.0, (total, item) => total + item.subtotal);
  }

  // Exibe o carrinho como um modal (Bottom Sheet)
  void _mostrarCarrinho(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CarrinhoModal(
          carrinho: _carrinho,
          onAdicionar: _adicionarItem,
          onRemover: _removerItem,
          total: _totalPedido,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu do Restaurante'),
        backgroundColor: Colors.deepOrange,
      ),

      // 3. Exibe o menu com a opção de adicionar ao carrinho
      body: ListView.builder(
        itemCount: menuItens.length,
        itemBuilder: (context, index) {
          final item = menuItens[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(item.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('R\$ ${item.preco.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart,
                    color: Colors.deepOrange),
                onPressed: () => _adicionarItem(item),
              ),
            ),
          );
        },
      ),

      // 4. Botão flutuante que exibe o total e abre o carrinho
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarCarrinho(context),
        label: Text('Ver Carrinho (R\$ ${_totalPedido.toStringAsFixed(2)})',
            style: const TextStyle(fontSize: 16)),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// --- Widget do Carrinho (Modal) ---

class CarrinhoModal extends StatelessWidget {
  final List<ItemPedido> carrinho;
  final Function(ItemMenu) onAdicionar;
  final Function(ItemPedido) onRemover;
  final double total;

  const CarrinhoModal({
    super.key,
    required this.carrinho,
    required this.onAdicionar,
    required this.onRemover,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7, // 70% da altura
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Seu Pedido',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Divider(),

          // Lista de itens do carrinho
          Expanded(
            child: carrinho.isEmpty
                ? const Center(
                    child: Text('Carrinho vazio! Adicione itens do menu.',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: carrinho.length,
                    itemBuilder: (context, index) {
                      final itemPedido = carrinho[index];
                      return ListTile(
                        title: Text(
                            '${itemPedido.item.nome} x${itemPedido.quantidade}'),
                        subtitle: Text(
                            'Subtotal: R\$ ${itemPedido.subtotal.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botão de remover (decrementa ou remove)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () => onRemover(itemPedido),
                            ),
                            // Botão de adicionar (incrementa)
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                              onPressed: () => onAdicionar(itemPedido.item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const Divider(),

          // Total e botão de Finalizar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: carrinho.isEmpty
                    ? null
                    : () {
                        // Lógica para enviar o pedido (para uma API ou banco de dados)
                        Navigator.pop(context); // Fecha o modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Pedido Finalizado! (Lógica de envio aqui)')),
                        );
                      },
                child: const Text('Finalizar Pedido',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
