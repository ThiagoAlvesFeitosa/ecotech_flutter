import 'package:flutter/material.dart';
import '../core/routes.dart';

// Serviço/modelos
import '../features/auth/auth_service.dart';
import '../models/auth_models.dart';

// Para mostrar mensagem amigável (ex.: 409 -> e-mail já cadastrado)
import '../core/app_error.dart';

/// Tela de CADASTRO:
/// - valida nome/e-mail/senha
/// - chama AuthService.register()
/// - se sucesso: token salvo e navega pra Home
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _auth = AuthService();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Faz o POST /auth/register.
  /// Se der certo, já recebo token e vou direto para a Home.
  Future<void> _doRegister() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final req = RegisterRequest(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      await _auth.register(req);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    // AppError com mensagens do AuthService (ex.: “E-mail já cadastrado.”)
    on AppError catch (e) {
      setState(() => _error = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
    catch (_) {
      setState(() => _error = 'Erro inesperado ao cadastrar.');
    }
    finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),

              // Nome
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) {
                  if ((v ?? '').trim().isEmpty) return 'Informe seu nome';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Informe seu e-mail';
                  if (!value.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Senha
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'Informe uma senha';
                  if ((v ?? '').length < 3) return 'Senha muito curta';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Cadastrar
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doRegister,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Cadastrar'),
                ),
              ),
              const SizedBox(height: 16),

              // Voltar pro Login
              TextButton(
                onPressed: _loading
                    ? null
                    : () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text('Já tenho conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
