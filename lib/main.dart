import 'package:flutter/material.dart';
import 'package:lazyload/ui/widgets/app/my_app.dart';
import 'package:lazyload/ui/widgets/app/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkAuth();
  runApp(MyApp(model: model));
}
