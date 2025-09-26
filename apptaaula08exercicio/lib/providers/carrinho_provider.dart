import 'package:flutter/foundation.dart';
import '../models/item_carrinho.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => _itens;

  double get total {
    return _itens.fold(0, (sum, item) => sum + item.total);
  }

  void adicionarItem(
    String destino,
    int diarias,
    int pessoas,
    double valorDiaria,
    double valorPessoa,
  ) {
    double totalItem = (diarias * valorDiaria) + (pessoas * valorPessoa);
    _itens.add(
      ItemCarrinho(
        destino: destino,
        diarias: diarias,
        pessoas: pessoas,
        valorDiaria: valorDiaria,
        valorPessoa: valorPessoa,
        total: totalItem,
      ),
    );
    notifyListeners();
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}