import 'package:go_router/go_router.dart';
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