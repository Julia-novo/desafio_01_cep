import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'theme.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});
  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  bool _buscandoCep = false;

  @override
  void dispose() {
    for (final controller in [
      _nomeController, _cepController, _numeroController,
      _complementoController, _ruaController, _bairroController,
      _cidadeController, _estadoController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _buscarCep(String valor) async {
    final cep = valor.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) return;

    setState(() => _buscandoCep = true);

    try {
      final resposta = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (!mounted) return;
      if (resposta.statusCode != 200) {
        _mensagem('Não foi possível consultar o CEP.');
        return;
      }

      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      if (dados['erro'] == true) {
        _mensagem('CEP não encontrado.');
        return;
      }

      setState(() {
        _ruaController.text = dados['logradouro'] ?? '';
        _bairroController.text = dados['bairro'] ?? '';
        _cidadeController.text = dados['localidade'] ?? '';
        _estadoController.text = dados['uf'] ?? '';
      });
    } catch (_) {
      if (mounted) _mensagem('Erro ao consultar o CEP.');
    } finally {
      if (mounted) setState(() => _buscandoCep = false);
    }
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'nome': _nomeController.text.trim(),
      'cep': _cepController.text.trim(),
      'numero': _numeroController.text.trim(),
      'complemento': _complementoController.text.trim(),
      'rua': _ruaController.text.trim(),
      'bairro': _bairroController.text.trim(),
      'cidade': _cidadeController.text.trim(),
      'estado': _estadoController.text.trim(),
    });
  }

  InputDecoration _decoracao(String label) =>
      InputDecoration(labelText: label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo cadastro',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: _decoracao('Nome'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Informe o nome.' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: _decoracao('CEP').copyWith(
                counterText: '',
                suffixIcon: _buscandoCep
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.search),
              ),
              onChanged: _buscarCep,
              validator: (v) {
                final cep = v?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
                return cep.length == 8 ? null : 'Informe um CEP válido.';
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _numeroController,
              keyboardType: TextInputType.number,
              decoration: _decoracao('Número'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Informe o número.' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _complementoController,
              decoration: _decoracao('Complemento'),
            ),
            const SizedBox(height: 22),
            const Text('Endereço',
                style: TextStyle(
                  color: destaque, fontSize: 18, fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 14),
            TextFormField(
              controller: _ruaController,
              readOnly: true,
              decoration: _decoracao('Rua'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _bairroController,
              readOnly: true,
              decoration: _decoracao('Bairro'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _cidadeController,
              readOnly: true,
              decoration: _decoracao('Cidade'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _estadoController,
              readOnly: true,
              decoration: _decoracao('Estado'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save_outlined),
                label: const Text('SALVAR CADASTRO',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(
                  backgroundColor: rosa,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
