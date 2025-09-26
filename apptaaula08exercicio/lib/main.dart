import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/carrinho_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/checkout_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarrinhoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S&M Hotel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/checkout': (context) => const CheckoutScreen(),
      },
    );
  }
}