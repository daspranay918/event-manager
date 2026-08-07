import 'package:go_router/go_router.dart';
import 'package:next_meet/Screens/Profile/my_events_screen.dart';
// import 'package:next_meet/Screens/home_screen.dart';
import 'package:next_meet/Screens/main_navigation_screen.dart';

// import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/navigation',
      builder: (context, state) => const MainNavigationScreen(),
    ),

    GoRoute(
      path: '/my-events',
      builder: (context, state) => const MyEventsScreen(),
    ),

    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => const HomeScreen()
    // ),
  ],
);
