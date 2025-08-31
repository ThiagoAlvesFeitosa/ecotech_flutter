import 'package:flutter/material.dart';
import '../features/points/points_service.dart';
import '../models/point_models.dart';
import '../core/app_error.dart';

/// Tela "Meus Pontos":
/// 1) Mostra um CARD grande com o TOTAL de pontos (agradável visualmente)
/// 2) Abaixo, exibe o HISTÓRICO (lista vinda do backend)
class PontosScreen extends StatefulWidget {
  const PontosScreen({super.key});

  @override
  State<PontosScreen> createState() => _PontosScreenState();
}

class _PontosScreenState extends State<PontosScreen> {
  final _service = PointsService();

  bool _loading = true;
  String? _error;

  int _total = 0;
  List<PointEntry> _history = const [];

  @override
  void initState() {
    super.initState();
    _load(); // carrega total + histórico quando a tela abre
  }

  /// Carrega TOTAL e HISTÓRICO em paralelo.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // roda as duas chamadas ao mesmo tempo
      final results = await Future.wait([
        _service.getTotal(),
        _service.getHistory(),
      ]);

      final total = results[0] as int;
      final history = results[1] as List<PointEntry>;

      setState(() {
        _total = total;
        _history = history;
      });
    } on AppError catch (e) {
      setState(() => _error = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      setState(() => _error = 'Erro inesperado ao carregar seus pontos.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Apenas formata uma data "bonitinha" (dd/mm/aaaa hh:mm)
  String _fmtDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pontos'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _load, // permite dar refresh manual
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _ErrorView(message: _error!, onRetry: _load)
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------- CARTÃO DO TOTAL ----------
            _TotalCard(total: _total),

            const SizedBox(height: 16),

            // ---------- TÍTULO DO HISTÓRICO ----------
            Row(
              children: const [
                Icon(Icons.history),
                SizedBox(width: 8),
                Text(
                  'Histórico de Pontuação',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ---------- LISTA DO HISTÓRICO ----------
            Expanded(
              child: _history.isEmpty
                  ? const Center(
                child: Text('Você ainda não ganhou pontos. Faça sua primeira coleta!'),
              )
                  : ListView.separated(
                itemCount: _history.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return ListTile(
                    leading: const Icon(Icons.electric_bolt_outlined),
                    title: Text(item.title),
                    subtitle: Text(_fmtDate(item.createdAt)),
                    trailing: Text(
                      '+${item.points} pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card grande do TOTAL de pontos.
/// Só visual – para dar um impacto logo de cara.
class _TotalCard extends StatelessWidget {
  final int total;
  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Total de Pontos',
            style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '$total',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// View de erro com botão de tentar novamente (UX básica)
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
