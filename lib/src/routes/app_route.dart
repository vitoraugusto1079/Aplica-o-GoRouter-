import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importação do Supabase adicionada aqui!

import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../screens/splash_screen.dart';
import '../screens/home_page.dart';
import '../screens/details_page.dart';
import '../screens/favorites_page.dart';
import '../screens/history_page.dart';
import '../screens/profile_page.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  
  // NOVO: O "Guarda-Costas" do seu aplicativo!
  redirect: (context, state) {
    // 1. Verifica se o usuário tem uma sessão ativa no momento
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    
    // 2. Verifica para qual página ele está tentando ir
    final rotaAtual = state.uri.toString();
    final indoParaAuth = rotaAtual == '/login' || rotaAtual == '/register';
    final indoParaSplash = rotaAtual == '/splash';

    // 3. REGRA DE SEGURANÇA:
    // Se ele NÃO estiver logado, e tentar ir para as páginas internas (como dar 'Voltar' no navegador)
    if (!isLoggedIn && !indoParaAuth && !indoParaSplash) {
      return '/login'; // Chuta ele de volta pro login!
    }

    // Se ele JÁ ESTIVER logado e tentar voltar pra tela de login, manda de volta pra Home
    if (isLoggedIn && indoParaAuth) {
      return '/home';
    }

    // Se estiver tudo certo, permite a navegação (retorna null)
    return null;
  },

  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: 'details', 
      path: '/details',
      builder: (context, state) {
        final videoData = state.extra as Map<String, dynamic>? ?? {};
        return DetailsPage(videoData: videoData);
      },
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesPage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);