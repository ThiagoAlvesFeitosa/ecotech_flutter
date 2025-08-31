import 'package:flutter/material.dart';

import '../features/rewards/rewards_service.dart';
import '../models/reward_models.dart';
import '../core/app_error.dart';

/// Tela de Recompensas conectada.
/// - Carrega a lista com GET /rewards.
/// - Permite resgatar com POST /rewards/{id}/redeem.
/// - Exibe mensagens amigáveis de sucesso/erro.
/// - Comentários explicando cada passo para você aprender revisando o código.
class RecompensasScreen extends StatefulWidget {
  const RecompensasScreen({super.key});

  @override
  State<RecompensasScreen> createState() => _RecompensasScreenState();
}

class _RecompensasScreenState extends State<RecompensasScreen> {
  final RewardsService _service = RewardsService();

  bool _loading = true;
  String? _error;
  List<RewardModel> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  /// Busca a lista de recompensas no backend.
  Future<void> _loadRewards() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _service.getRewards();
      setState(() => _items = list);
    } on AppError catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Erro inesperado ao carregar recompensas.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Tenta resgatar uma recompensa específica.
  Future<void> _redeem(RewardModel r) async {
    // Confirmação simples antes de chamar a API:
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar resgate'),
        content: Text(
          'Deseja resgatar "${r.title}" por ${r.costPoints} pontos?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Resgatar')),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final resp = await _service.redeemReward(r.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message ?? 'Recompensa resgatada com sucesso!')),
        );
      }
      // Após resgatar, recarrego a lista (às vezes o backend já pode atualizar algo).
      await _loadRewards();
    } on AppError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro inesperado ao resgatar.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recompensas'),
        actions: [
          IconButton(
            onPressed: _loadRewards,
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? _ErrorBox(message: _error!, onRetry: _loadRewards)
            : _items.isEmpty
            ? const Center(child: Text('Nenhuma recompensa disponível.'))
            : ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final r = _items[index];
            return Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: Text(r.title),
                subtitle: Text('${r.costPoints} pts'),
                trailing: ElevatedButton(
                  onPressed: () => _redeem(r),
                  child: const Text('Resgatar'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Caixinha de erro com botão "Tentar novamente".
class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
