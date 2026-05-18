import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/routes/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tgkhwbqccqpdqkuxepep.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRna2h3YnFjY3FwZHFrdXhlcGVwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMDkxNzYsImV4cCI6MjA5NDY4NTE3Nn0.oBZ2tdynweRmlle9TQ61HIJF6PD8wRKDVAvsWweB5jc',
  );

  runApp(const MeuAppStreaming());
}

class MeuAppStreaming extends StatelessWidget {
  const MeuAppStreaming({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'App Streaming SENAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter, 
    );
  }
}


