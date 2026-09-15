import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/splash/splash_screen.dart';
import 'views/auth/reset_password_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ucfjsliozhxuionzyyja.supabase.co',
    anonKey: 'sb_publishable_ENBUfCcqrggHpy6jVI4hLw_k5LtucwS',
  );

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    }
  });

  runApp(const AurumApp());
}

class AurumApp extends StatelessWidget {
  const AurumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Aurum',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF28C28)),
      ),

      home: const SplashScreen(),
    );
  }
}
