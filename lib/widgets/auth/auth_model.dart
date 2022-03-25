import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lazyload/ui/navigation/main_navigation.dart';

import '../../domain/api_client/api_client.dart';
import '../../domain/data_providers/session_data_provider.dart';

class AuthModel extends ChangeNotifier {
  final _apiClinet = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    try {
       sessionId =
          await _apiClinet.auth(username: login, password: password);
    } catch (e) {
      _errorMessage = 'Неправильный логин или пароль!';
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null) {
      _errorMessage = 'Неизвестная ошибка, повторите попытку';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId) ;
    unawaited(Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen));
    
  }
}

// class AuthProvider extends InheritedNotifier {
//   final AuthModel model;
//   const AuthProvider({Key? key, required Widget child, required this.model})
//       : super(key: key, child: child, notifier: model);

//   static AuthProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }

//   static AuthProvider? read(BuildContext context) {
//     final widget =
//         context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
//     return widget is AuthProvider ? widget : null;
//   }
// }



