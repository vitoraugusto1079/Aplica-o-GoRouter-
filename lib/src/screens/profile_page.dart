import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instância do Supabase para obter os dados do utilizador logado
    final supabase = Supabase.instance.client;
    
    // Obtém o e-mail do utilizador da sessão ativa do Supabase (Requisito do projeto)
    final userEmail = supabase.auth.currentUser?.email ?? 'E-mail não encontrado';

    // Função para encerrar a sessão com segurança (Requisito do projeto)
    Future<void> _fazerLogout(BuildContext context) async {
      try {
        await supabase.auth.signOut();
        if (context.mounted) {
          // Redireciona para a tela de login após o logout bem-sucedido
          context.go('/login');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao fazer logout.')),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro estilo streaming
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar decorativo para dar um charme visual de streaming
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Utilizador Autenticado:',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              
              // Exibição obrigatória do e-mail vindo do Supabase
              Text(
                userEmail,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Botão obrigatório de Fazer Logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _fazerLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Fazer Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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