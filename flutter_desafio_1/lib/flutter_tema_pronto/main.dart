import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CadastroApp());
}

class CadastroApp extends StatefulWidget {
  const CadastroApp({super.key});

  @override
  State<CadastroApp> createState() => _CadastroAppState();
}

class _CadastroAppState extends State<CadastroApp> {
  ThemeMode _modoTema = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _modoTema = (prefs.getBool('modo_claro') ?? false)
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  Future<void> _mudarTema(bool claro) async {
    setState(() => _modoTema = claro ? ThemeMode.light : ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_claro', claro);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Pessoas',
      theme: appThemeLight,
      darkTheme: appTheme,
      themeMode: _modoTema,
      home: SplashScreen(
        modoClaro: _modoTema == ThemeMode.light,
        mudarTema: _mudarTema,
      ),
    );
  }
}
