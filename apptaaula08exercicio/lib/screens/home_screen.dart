import 'package:flutter/material.dart';
import '../models/destino.dart';
import '../widgets/destino_card.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S&M Hotel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/checkout');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: AppConstants.destinos.length,
        itemBuilder: (context, index) {
          final destino = AppConstants.destinos[index];
          return DestinoCard(
            nome: destino.nome,
            imagem: destino.imagem,
            valorDiaria: destino.valorDiaria,
            valorPessoa: destino.valorPessoa,
          );
        },
      ),
    );
  }
}