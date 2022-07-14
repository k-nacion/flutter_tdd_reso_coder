import 'package:flutter/material.dart';
import 'package:flutter_tdd_reso_coder/core/config/app_theme.dart';
import 'package:flutter_tdd_reso_coder/injection_container.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Trivia App',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: const NumberTriviaPage(),
    );
  }
}
