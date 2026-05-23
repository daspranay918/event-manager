import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/core/router.dart';
import 'package:next_meet/core/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qntywykojewrlaevdggf.supabase.co',
    anonKey: 'sb_publishable_dGgiDl4nouyzX1qtbHTVpg_bDcw0zF1',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Eventora',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
