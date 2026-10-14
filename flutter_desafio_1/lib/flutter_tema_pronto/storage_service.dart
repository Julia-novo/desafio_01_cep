import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _chave = 'pessoas';

  Future<List<Map<String, dynamic>>> carregarPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString(_chave);
    if (dados == null) return [];
    final lista = jsonDecode(dados) as List;
    return lista.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> salvarPessoas(List<Map<String, dynamic>> pessoas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, jsonEncode(pessoas));
  }
}
