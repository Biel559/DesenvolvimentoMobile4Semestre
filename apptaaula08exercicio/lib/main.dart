import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarrinhoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // CORREÇÃO

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S&M Hotel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(), // Adicionado const
      routes: {
        '/home': (context) => const Home(), // Adicionado const
        '/cadastro': (context) => const CadastroScreen(), // Adicionado const
        '/checkout': (context) => const CheckoutScreen(), // Adicionado const
      },
    );
  }
}

// Provider para gerenciar o carrinho
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

class ItemCarrinho {
  final String destino;
  final int diarias;
  final int pessoas;
  final double valorDiaria;
  final double valorPessoa;
  final double total;

  ItemCarrinho({
    required this.destino,
    required this.diarias,
    required this.pessoas,
    required this.valorDiaria,
    required this.valorPessoa,
    required this.total,
  });
}

// Tela de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // CORREÇÃO

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulação de login com JSON Server
      final response = await http.get(
        Uri.parse('http://localhost:3000/usuario'),
      );

      if (response.statusCode == 200) {
        final users = json.decode(response.body);
        bool userFound = false;

        for (var user in users) {
          if (user['email'] == _emailController.text &&
              user['password'] == _passwordController.text) {
            userFound = true;
            break;
          }
        }

        if (userFound) {
          if (mounted) Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showError('Credenciais inválidas');
        }
      } else {
        _showError('Erro no servidor');
      }
    } catch (e) {
      _showError('Erro de conexão');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - S&M Hotel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Entrar'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Cadastro
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key}); // CORREÇÃO

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _cadastrar() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/cadastro-usuario'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': _nomeController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } else {
        _showError('Erro ao cadastrar usuário');
      }
    } catch (e) {
      _showError('Erro de conexão');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro - S&M Hotel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _cadastrar,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}

// Tela Home (Stateless)
class Home extends StatelessWidget {
  const Home({super.key}); 

  final List<Map<String, dynamic>> destinos = const [
    {
      'nome': 'Angra dos Reis',
      'imagem': 'assets/images/angra.jpg', 
      'valorDiaria': 384.0,
      'valorPessoa': 70.0,
    },
    {
      'nome': 'Jericoacoara',
      'imagem': 'assets/images/jericoacoara.jpg', 
      'valorDiaria': 571.0,
      'valorPessoa': 75.0,
    },
    {
      'nome': 'Arraial do Cabo',
      'imagem': 'assets/images/arraial.jpg', 
      'valorDiaria': 534.0,
      'valorPessoa': 65.0,
    },
    {
      'nome': 'Florianópolis',
      'imagem': 'assets/images/florianopolis.jpg', 
      'valorDiaria': 348.0,
      'valorPessoa': 85.0,
    },
    {
      'nome': 'Madri',
      'imagem': 'assets/images/madri.jpg', 
      'valorDiaria': 401.0,
      'valorPessoa': 85.0,
    },
    {
      'nome': 'Paris',
      'imagem': 'assets/images/paris.jpg', 
      'valorDiaria': 546.0,
      'valorPessoa': 95.0,
    },
    {
      'nome': 'Orlando',
      'imagem': 'assets/images/orlando.jpg', 
      'valorDiaria': 616.0,
      'valorPessoa': 105.0,
    },
    {
      'nome': 'Las Vegas',
      'imagem': 'assets/images/lasvegas.jpg', 
      'valorDiaria': 504.0,
      'valorPessoa': 110.0,
    },
    {
      'nome': 'Roma',
      'imagem': 'assets/images/roma.jpg', 
      'valorDiaria': 478.0,
      'valorPessoa': 85.0,
    },
    {
      'nome': 'Chile',
      'imagem': 'assets/images/chile.jpg',
      'valorDiaria': 446.0,
      'valorPessoa': 95.0,
    },
  ];

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
        itemCount: destinos.length,
        itemBuilder: (context, index) {
          final destino = destinos[index];
          return Destino(
            nome: destino['nome'],
            imagem: destino['imagem'],
            valord: destino['valorDiaria'],
            valorp: destino['valorPessoa'],
          );
        },
      ),
    );
  }
}

// Classe Destino (Stateful)
// Classe Destino (Stateful) - VERSÃO CORRIGIDA
class Destino extends StatefulWidget {
  final String nome;
  final String imagem;
  final double valord;
  final double valorp;

  const Destino({
    super.key,
    required this.nome,
    required this.imagem,
    required this.valord,
    required this.valorp,
  });

  @override
  State<Destino> createState() => _DestinoState();
}

class _DestinoState extends State<Destino> {
  int n_diarias = 0;
  int n_pessoas = 0;
  double total = 0;

  void dias() {
    setState(() {
      n_diarias++;
    });
  }

  void n_pessoasFunc() {
    setState(() {
      n_pessoas++;
    });
  }

  void calctotal() {
    setState(() {
      total = (n_diarias * widget.valord) + (n_pessoas * widget.valorp);
    });

    // Adicionar ao carrinho usando Provider
    if (total > 0) {
      Provider.of<CarrinhoProvider>(context, listen: false).adicionarItem(
        widget.nome,
        n_diarias,
        n_pessoas,
        widget.valord,
        widget.valorp,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.nome} adicionado ao carrinho!')),
        );
      }
    }
  }

  void limpar() {
    setState(() {
      n_diarias = 0;
      n_pessoas = 0;
      total = 0;
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
          mainAxisSize:
              MainAxisSize.min, // ADICIONADO: Ajusta automaticamente o tamanho
          children: [
            // Imagem do destino
            SizedBox(
              width: double.infinity,
              height: 180, // REDUZIDO: de 200 para 180
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
              padding: const EdgeInsets.all(12.0), // AUMENTADO: de 8 para 12
              child: Column(
                mainAxisSize: MainAxisSize.min, // ADICIONADO
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
                  const SizedBox(height: 6), // AUMENTADO: de 4 para 6
                  // Valores
                  Text(
                    'Diária: R\$ ${widget.valord.toStringAsFixed(2)} | Pessoa: R\$ ${widget.valorp.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12), // AUMENTADO: de 8 para 12
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
                              'Diárias: $n_diarias',
                              style: const TextStyle(fontSize: 14),
                            ),
                            IconButton(
                              onPressed: dias,
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
                              'Pessoas: $n_pessoas',
                              style: const TextStyle(fontSize: 14),
                            ),
                            IconButton(
                              onPressed: n_pessoasFunc,
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
                  if (total > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Total: R\$ ${total.toStringAsFixed(2)}',
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
                          onPressed: calctotal,
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
                          onPressed: limpar,
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

// Tela de Checkout
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key}); // CORREÇÃO

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
