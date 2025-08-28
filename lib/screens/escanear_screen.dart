import 'package:flutter/material.dart';

class EscanearScreen extends StatelessWidget {
  const EscanearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar é a barra superior com o título da tela
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
      ),

      // O corpo da tela
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de QR Code como se fosse uma ilustração
            const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            // Texto explicando o que seria feito aqui
            const Text(
              'Aponte a câmera para o QR Code da coleta',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 40),

            // Botão simulado para representar o escaneamento
            ElevatedButton(
              onPressed: () {
                // Aqui futuramente chamaremos a câmera para escanear
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code escaneado com sucesso!')),
                );
              },
              child: const Text('Simular Escaneamento'),
            ),
          ],
        ),
      ),
    );
  }
}
