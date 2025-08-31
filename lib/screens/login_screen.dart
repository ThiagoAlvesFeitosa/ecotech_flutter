import 'package:flutter/material.dart';
import '../core/routes.dart';

// Serviço e modelos de autenticação
import '../features/auth/auth_service.dart';
import '../models/auth_models.dart';

// Minha exceção “amigável” (AuthService lança AppError com textos prontos)
import '../core/app_error.dart';

/// Tela de LOGIN:
/// - valida e-mail/senha com Form
/// - chama AuthService.login()
/// - se sucesso: AuthService salva o token -> navega pra Home
/// - se erro 401: mostra “E-mail ou senha incorretos.”
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Chave do Form para rodar os validators
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Instância do serviço (poderia ser injetado via provider/get_it)
  final _auth = AuthService();

  // Estado de UI
  bool _loading = false;
  String? _error; // mensagem para o banner vermelho

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Faz o POST /auth/login.
  /// Se der certo, AuthService salva o token e eu navego pra Home.
  Future<void> _doLogin() async {
    // 1) valida o formulário (obriga a preencher certinho)
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _loading = true;
      _error = null; // limpa mensagem do topo
    });

    try {
      // 2) cria o payload no formato que a API espera
      final req = LoginRequest(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      // 3) chama o backend
      await _auth.login(req);

      // 4) se chegou aqui: sucesso (token salvo). Vai pra Home.
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    // AppError vem mapeado pelo AuthService (401 -> “E-mail ou senha incorretos.”)
    on AppError catch (e) {
      setState(() => _error = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
    // “cinto de segurança” se algo inesperado aconteceu
    catch (_) {
      setState(() => _error = 'Erro inesperado ao fazer login.');
    }
    // 5) encerra o loading em qualquer caso
    finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Form + GlobalKey rodará os validators dos TextFormFields
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // banner de erro (quando _error != null)
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

              // Campo e-mail
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'seu@email.com',
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Informe seu e-mail';
                  if (!value.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo senha
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'Informe sua senha';
                  if ((v ?? '').length < 3) return 'Senha muito curta';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Entrar
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doLogin,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 16),

              // Link para Cadastro
              TextButton(
                onPressed: _loading
                    ? null
                    : () => Navigator.pushNamed(context, AppRoutes.cadastro),
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
