# 🌱 EcoTech

**EcoTech** é um aplicativo mobile desenvolvido em Flutter como parte do projeto interdisciplinar da FIAP. Seu objetivo é incentivar o descarte correto de lixo eletrônico (e-lixo), promovendo consciência ambiental, recompensas e engajamento social — com base nos princípios da Sociedade 5.0.

> 📌 Este repositório corresponde à **primeira entrega**, com foco na estrutura, telas e dados simulados. A segunda entrega incluirá integração com IA e melhorias técnicas.

---

## 📲 Funcionalidades (MVP)

### 👤 Autenticação
- Tela de login
- Tela de cadastro

### 🏠 Tela Inicial
- Acesso aos módulos principais via cards:
  - Escanear QR Code
  - Registrar coleta
  - Visualizar pontos
  - Recompensas
  - Impacto ambiental
  - Perfil do usuário
  - Assistente virtual (ManageEngine)

### 🧾 Módulos Simulados
- **Escanear QR Code:** interface pronta para futura integração com câmera.
- **Registrar Coleta:** simulação do descarte de e-lixo com formulário.
- **Pontuação:** histórico de ações + total em destaque.
- **Recompensas:** catálogo de prêmios trocáveis por pontos.
- **Impacto Ambiental:** estatísticas visuais sobre o impacto do usuário (com gráficos).
- **Perfil:** informações do usuário e botão "Sair".
- **Assistente Virtual:** espaço reservado para integração com IA e relatórios automáticos (ManageEngine ESM).

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Uso |
|------------|-----|
| [Flutter](https://flutter.dev/) | Interface e lógica de navegação |
| [Dart](https://dart.dev/) | Linguagem principal |
| [Charts (recharts)](https://pub.dev/packages/charts_flutter) | Gráficos simulados na tela de impacto |
| [Material Icons](https://fonts.google.com/icons) | Ícones nas interfaces |
| Estrutura MVC simples | Separação por `screens/`, `models/`, `core/`, `widgets/` |

---

## 📁 Estrutura do Projeto

