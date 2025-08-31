import 'package:flutter/material.dart';

// Serviço que conversa com a API de coletas (POST /collects)
import '../features/collects/collect_service.dart';

// Modelos de request/response (para tipagem forte)
import '../models/collect_models.dart';

// Minha exceção amigável para mensagens de erro legíveis
import '../core/app_error.dart';


/// Tela: "Agendar Coleta de E-lixo"
/// O objetivo AQUI é **registrar** uma coleta no backend de forma simples.
/// - Eu pedi ao usuário apenas o TIPO de e-lixo e o PESO em kg,
///   porque são os campos que sua API realmente usa (eWasteType, weightKg).
/// - Data/Horário podem ser adicionados no futuro; hoje a API não os consome.
///
/// Fluxo:
/// 1) Preenche o formulário (tipo + peso)
/// 2) Valida
/// 3) Envia POST /collects
/// 4) Mostra sucesso (+ pontos, se a API informar) e limpa os campos
/// 5) O total de pontos já aumenta do outro lado; na tela de Pontos você pode dar refresh
class ColetaScreen extends StatefulWidget {
  const ColetaScreen({super.key});

  @override
  State<ColetaScreen> createState() => _ColetaScreenState();
}

class _ColetaScreenState extends State<ColetaScreen> {
  // Chave para validar o Form
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final _typeCtrl = TextEditingController();   // guarda o texto com o tipo (ex.: "bateria")
  final _weightCtrl = TextEditingController(); // guarda o texto com o peso (ex.: "1.2")

  // Serviço que vai fazer o POST /collects
  final _service = CollectService();

  // Estado de UI
  bool _loading = false;           // true enquanto aguardo a API
  String? _error;                  // mensagem de erro no topo
  CollectResponse? _lastResponse;  // guardo a última resposta para feedback

  // Sugestão de tipos para facilitar e padronizar (evitar digitar errado)
  final List<String> _suggestedTypes = const [
    'bateria',
    'celular',
    'notebook',
    'carregador',
    'tablet',
    'fone de ouvido',
  ];

  @override
  void dispose() {
    _typeCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  /// Converte o texto do peso para double com tolerância (vírgula/ponto).
  /// - Aceita "1,2" ou "1.2" -> 1.2
  /// - Retorna null se não fizer sentido (ex.: "abc").
  double? _parseWeight(String raw) {
    final normalized = raw.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  /// Envia de fato a coleta para o backend.
  Future<void> _submit() async {
    // 1) valida os campos
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _loading = true;
      _error = null;
      _lastResponse = null;
    });

    // 2) prepara os dados do request (tipados)
    final type = _typeCtrl.text.trim();
    final weight = _parseWeight(_weightCtrl.text)!; // seguro porque validei antes

    try {
      // 3) chama a API (POST /collects)
      final res = await _service.createCollect(
        eWasteType: type,
        weightKg: weight,
      );

      // 4) guarda resposta p/ mostrar ao usuário
      setState(() => _lastResponse = res);

      // 5) feedback: se a API informou pontos, mostro com “+X pts”
      final pts = res.awardedPoints;
      final baseMsg = 'Coleta registrada com sucesso!';
      final msg = (pts != null) ? '$baseMsg (+$pts pts)' : baseMsg;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }

      // 6) limpa campos p/ nova coleta
      _typeCtrl.clear();
      _weightCtrl.clear();
      _formKey.currentState?.reset();
    }
    // Erros “bonitos” (AppError) já mapeados pelo service
    on AppError catch (e) {
      setState(() => _error = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
    // fallback genérico
    catch (_) {
      setState(() => _error = 'Erro inesperado ao registrar a coleta.');
    }
    // 7) encerra loading
    finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Componente reutilizável: rótulo sutil acima dos campos
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Coleta de E-lixo'),
        centerTitle: true,
        actions: [
          // Atalho opcional: ir para a tela de pontos para ver o total subir
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/pontos'),
            icon: const Icon(Icons.scoreboard_outlined),
            tooltip: 'Ver pontos',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // amarra os validators
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de erro (aparece apenas se _error != null)
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),

              // ---------- Campo: Tipo do e-lixo ----------
              _label('Tipo de eletrônico'),
              // Aqui eu ofereço um Dropdown com opções comuns e também um TextField fallback.
              // Para simplicidade, vou de TextField com sugestões por enquanto:
              TextFormField(
                controller: _typeCtrl,
                decoration: InputDecoration(
                  hintText: 'Ex.: bateria, celular, notebook...',
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    tooltip: 'Sugestões',
                    onSelected: (val) => _typeCtrl.text = val,
                    itemBuilder: (context) => _suggestedTypes
                        .map((t) => PopupMenuItem(value: t, child: Text(t)))
                        .toList(),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Informe o tipo de e-lixo';
                  if (value.length < 3) return 'Digite pelo menos 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------- Campo: Peso em kg ----------
              _label('Peso (kg)'),
              TextFormField(
                controller: _weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Ex.: 1.2',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Informe o peso (em kg)';
                  final parsed = _parseWeight(value);
                  if (parsed == null) return 'Digite um número válido (ex.: 1.2)';
                  if (parsed <= 0) return 'O peso deve ser maior que zero';
                  // (opcional) limite superior para evitar absurdos digitados por engano:
                  if (parsed > 200) return 'Peso muito alto; verifique';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ---------- Botão: Registrar ----------
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.check),
                  label: Text(_loading ? 'Enviando...' : 'Registrar Coleta'),
                ),
              ),

              // ---------- Feedback adicional (última resposta) ----------
              if (_lastResponse != null) ...[
                const SizedBox(height: 24),
                _LastResponseCard(response: _lastResponse!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Cartão com detalhes da última coleta registrada.
/// Não é obrigatório, mas ajuda a dar “confiança” ao usuário depois do POST.
class _LastResponseCard extends StatelessWidget {
  final CollectResponse response;
  const _LastResponseCard({required this.response});

  @override
  Widget build(BuildContext context) {
    final lines = <String>[];
    if (response.id != null) lines.add('ID: ${response.id}');
    if (response.eWasteType != null) lines.add('Tipo: ${response.eWasteType}');
    if (response.weightKg != null) lines.add('Peso: ${response.weightKg} kg');
    if (response.createdAt != null) lines.add('Quando: ${response.createdAt}');
    if (response.awardedPoints != null) lines.add('Pontos: +${response.awardedPoints}');

    if (lines.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Última coleta registrada', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...lines.map((t) => Text(t)),
        ],
      ),
    );
  }
}
