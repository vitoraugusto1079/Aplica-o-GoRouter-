import 'package:supabase_flutter/supabase_flutter.dart';

// Esta variável global será o nosso "controle remoto" do banco de dados.
// Basta importar este arquivo em qualquer tela e usar a variável 'supabase'.
final supabase = Supabase.instance.client;