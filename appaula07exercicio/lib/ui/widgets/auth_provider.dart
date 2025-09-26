import 'package:flutter/material.dart';
import '../../model/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void register(String email, String password) {
    if (_users.any((user) => user.email == email)) {
      throw Exception('Usuário já existe');
    }

    final newUser = User(email: email, password: password);
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
  }

  bool login(String email, String password) {
    final user = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Credenciais inválidas'),
    );

    _currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
