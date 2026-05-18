import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState(); // CORREÇÃO AQUI: Substitua 'super.override manually;' por 'super.initState();'
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Aguarda 3 segundos na tela de Splash para exibir a identidade visual
    await Future.delayed(const Duration(seconds: 3));

    // Se o widget foi removido da árvore durante a espera, interrompe a execução
    if (!mounted) return;

    // Verifica se existe uma sessão ativa no Supabase
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // Usuário logado -> Vai direto para a Home
      context.go('/home');
    } else {
      // Usuário não logado -> Vai para a tela de Login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pegando a cor principal do tema definida no main.dart (deepPurple)
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro estilo streaming
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Área reservada para o logotipo solicitado na proposta
            // Se vocês tiverem uma imagem em assets, basta descomentar a linha abaixo:
            // Image.asset('assets/icons/icon_logo.png', width: 150, height: 150),
            
            // Enquanto não colocam o arquivo físico da imagem, deixamos um ícone temático lindo:
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 100,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 24),
            
            // Nome da Plataforma (Estilizado com base na cor semente do seu colega)
            Text(
              'SENAI PLAY',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Streaming Educacional & Entretenimento',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            
            // Indicador de carregamento sutil
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: themeColor,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}