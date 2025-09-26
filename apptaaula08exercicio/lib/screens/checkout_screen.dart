import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrinho_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _formaPagamento = 'cartao';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout - S&M Hotel')),
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.itens.isEmpty) {
            return const Center(
              child: Text('Carrinho vazio', style: TextStyle(fontSize: 18)),
            );
          }

          double totalComDesconto = carrinho.total;
          if (_formaPagamento == 'pix') {
            totalComDesconto = carrinho.total * 0.9; // 10% desconto
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: carrinho.itens.length,
                  itemBuilder: (context, index) {
                    final item = carrinho.itens[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(item.destino),
                        subtitle: Text(
                          '${item.diarias} diárias, ${item.pessoas} pessoas',
                        ),
                        trailing: Text(
                          'R\$ ${item.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Forma de Pagamento:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Cartão'),
                      value: 'cartao',
                      groupValue: _formaPagamento,
                      onChanged: (String? value) {
                        setState(() {
                          _formaPagamento = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('PIX (10% desconto)'),
                      value: 'pix',
                      groupValue: _formaPagamento,
                      onChanged: (String? value) {
                        setState(() {
                          _formaPagamento = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_formaPagamento == 'pix')
                      Text(
                        'Total original: R\$ ${carrinho.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    Text(
                      'Total: R\$ ${totalComDesconto.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              carrinho.limparCarrinho();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Compra finalizada!'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(0, 50),
                            ),
                            child: const Text('Finalizar Compra'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              carrinho.limparCarrinho();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(0, 50),
                            ),
                            child: const Text('Limpar Carrinho'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}