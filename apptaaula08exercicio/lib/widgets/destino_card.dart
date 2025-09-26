import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrinho_provider.dart';

class DestinoCard extends StatefulWidget {
  final String nome;
  final String imagem;
  final double valorDiaria;
  final double valorPessoa;

  const DestinoCard({
    super.key,
    required this.nome,
    required this.imagem,
    required this.valorDiaria,
    required this.valorPessoa,
  });

  @override
  State<DestinoCard> createState() => _DestinoCardState();
}

class _DestinoCardState extends State<DestinoCard> {
  int _nDiarias = 0;
  int _nPessoas = 0;
  double _total = 0;

  void _incrementarDias() {
    setState(() {
      _nDiarias++;
    });
  }

  void _incrementarPessoas() {
    setState(() {
      _nPessoas++;
    });
  }

  void _calcularTotal() {
    setState(() {
      _total = (_nDiarias * widget.valorDiaria) + (_nPessoas * widget.valorPessoa);
    });

    if (_total > 0) {
      Provider.of<CarrinhoProvider>(context, listen: false).adicionarItem(
        widget.nome,
        _nDiarias,
        _nPessoas,
        widget.valorDiaria,
        widget.valorPessoa,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.nome} adicionado ao carrinho!')),
        );
      }
    }
  }

  void _limpar() {
    setState(() {
      _nDiarias = 0;
      _nPessoas = 0;
      _total = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagem do destino
            SizedBox(
              width: double.infinity,
              height: 180,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.asset(
                  widget.imagem,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Conteúdo do card
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nome do destino
                  Text(
                    widget.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  // Valores
                  Text(
                    'Diária: R\$ ${widget.valorDiaria.toStringAsFixed(2)} | Pessoa: R\$ ${widget.valorPessoa.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Botões de quantidade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Diárias
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Diárias: $_nDiarias',
                              style: const TextStyle(fontSize: 14),
                            ),
                            IconButton(
                              onPressed: _incrementarDias,
                              icon: const Icon(Icons.add),
                              color: Colors.blue,
                              constraints: const BoxConstraints(
                                minHeight: 36,
                                minWidth: 36,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Pessoas
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pessoas: $_nPessoas',
                              style: const TextStyle(fontSize: 14),
                            ),
                            IconButton(
                              onPressed: _incrementarPessoas,
                              icon: const Icon(Icons.add),
                              color: Colors.green,
                              constraints: const BoxConstraints(
                                minHeight: 36,
                                minWidth: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Total (se calculado)
                  if (_total > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Total: R\$ ${_total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Botões de ação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: _calcularTotal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Calcular'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: _limpar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Limpar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}