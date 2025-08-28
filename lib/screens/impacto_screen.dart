import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Biblioteca para gráficos

class ImpactoScreen extends StatelessWidget {
  const ImpactoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados sobre o impacto ambiental total do usuário
    final impacto = {
      'dispositivosReciclados': 12,
      'co2Evitado': 4.5, // em Kg de CO₂
      'energiaEconomizada': 8.2, // em kWh
    };

    // Dados simulados mensais para os gráficos
    final List<String> meses = ['Abr', 'Mai', 'Jun', 'Jul', 'Ago'];
    final List<double> dispositivosMensais = [2, 3, 1, 4, 2];
    final List<double> co2Mensal = [0.6, 0.9, 0.2, 2.1, 0.7];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impacto Ambiental'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção

              const SizedBox(height: 20),

              // Card 1: mostra a quantidade total de dispositivos reciclados
              Card(
                child: ListTile(
                  leading: const Icon(Icons.devices_other),
                  title: const Text('Dispositivos reciclados'),
                  trailing: Text('${impacto['dispositivosReciclados']}'),
                ),
              ),

              // Card 2: mostra o total de CO₂ evitado
              Card(
                child: ListTile(
                  leading: const Icon(Icons.eco),
                  title: const Text('CO₂ evitado'),
                  trailing: Text('${impacto['co2Evitado']} kg'),
                ),
              ),

              // Card 3: mostra a energia economizada
              Card(
                child: ListTile(
                  leading: const Icon(Icons.bolt),
                  title: const Text('Energia economizada'),
                  trailing: Text('${impacto['energiaEconomizada']} kWh'),
                ),
              ),

              const SizedBox(height: 20),

              // Subtítulo dos gráficos
              const Text(
                'Histórico de impacto (últimos meses):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              // Gráfico de barras: mostra os dispositivos reciclados por mês
              const Text('Dispositivos reciclados'),
              AspectRatio(
                aspectRatio: 1.7, // proporção para ocupar o espaço
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false), // remove borda
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true), // eixo Y
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true, // eixo X com meses
                          getTitlesWidget: (value, _) {
                            final index = value.toInt();
                            if (index >= 0 && index < meses.length) {
                              return Text(meses[index]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(meses.length, (i) {
                      return BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: dispositivosMensais[i], // altura da barra
                          color: Colors.green, // cor da barra
                          width: 14,
                        )
                      ]);
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Gráfico de linha: mostra a evolução de CO₂ evitado por mês
              const Text('CO₂ evitado por mês (kg)'),
              AspectRatio(
                aspectRatio: 1.6,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true), // eixo Y
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true, // eixo X com meses
                          getTitlesWidget: (value, _) {
                            final index = value.toInt();
                            if (index >= 0 && index < meses.length) {
                              return Text(meses[index]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(meses.length,
                                (i) => FlSpot(i.toDouble(), co2Mensal[i])),
                        isCurved: true, // curva suave
                        color: Colors.blue,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true), // bolinhas nos pontos
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
