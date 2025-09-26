import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
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