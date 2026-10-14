import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cadastro_screen.dart';
import 'splash_screen.dart';
import 'storage_service.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  final bool modoClaro;
  final ValueChanged<bool> mudarTema;

  const HomeScreen({
    super.key,
    required this.modoClaro,
    required this.mudarTema,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storageService = StorageService();
  List<Map<String, dynamic>> _pessoas = [];

  @override
  void initState() {
    super.initState();
    _carregarPessoas();
  }

  Future<void> _carregarPessoas() async {
    final pessoas = await _storageService.carregarPessoas();
    if (!mounted) return;
    setState(() => _pessoas = pessoas);
  }

  Future<void> _novaPessoa() async {
    final pessoa = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroScreen()),
    );
    if (pessoa == null) return;
    setState(() => _pessoas.insert(0, pessoa));
    await _storageService.salvarPessoas(_pessoas);
  }

  Future<void> _abrirSplash() async {
    Navigator.pop(context);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SplashScreen(
          fromMenu: true,
          modoClaro: widget.modoClaro,
          mudarTema: widget.mudarTema,
        ),
      ),
    );
  }

  void _sair() => SystemNavigator.pop();

  @override
  Widget build(BuildContext context) {
    final claro = Theme.of(context).brightness == Brightness.light;
    final corSecundaria = claro ? secundarioDia : textoSecundario;
    final corDestaque = claro ? destaqueEscuro : destaque;
    final corCartao = claro ? superficieDia : superficie;
    final corBotao = claro ? Colors.white : const Color(0xFF171512);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pessoas cadastradas',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                color: corDestaque,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.people_alt_rounded, color: superficie, size: 42),
                    SizedBox(height: 12),
                    Text(
                      'Cadastro',
                      style: TextStyle(
                        color: superficie,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(title: const Text('Splash'), onTap: _abrirSplash),
              SwitchListTile(
                secondary: Icon(claro ? Icons.light_mode : Icons.dark_mode),
                title: const Text('Modo claro'),
                value: claro,
                activeThumbColor: destaqueEscuro,
                onChanged: widget.mudarTema,
              ),
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: rosaEscuro),
                title: const Text('Sair'),
                onTap: _sair,
              ),
            ],
          ),
        ),
      ),
      body: _pessoas.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 76,
                      color: corDestaque,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhuma pessoa cadastrada.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Toque no + para adicionar uma pessoa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textoSecundario),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              itemCount: _pessoas.length,
              itemBuilder: (_, index) {
                final pessoa = _pessoas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 0,
                  color: corCartao,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pessoa['nome'] as String,
                          style: TextStyle(
                            color: corDestaque,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('${pessoa['rua']}, ${pessoa['numero']}'),
                        Text(
                          '${pessoa['bairro']} • ${pessoa['cidade']} - ${pessoa['estado']}',
                          style: TextStyle(color: corSecundaria),
                        ),
                        if ((pessoa['complemento'] as String).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Complemento: ${pessoa['complemento']}',
                              style: TextStyle(color: corSecundaria),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          'CEP: ${pessoa['cep']}',
                          style: TextStyle(color: corSecundaria, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _novaPessoa,
        backgroundColor: corDestaque,
        foregroundColor: corBotao,
        child: const Icon(Icons.add),
      ),
    );
  }
}
