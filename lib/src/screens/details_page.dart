import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> videoData;

  const DetailsPage({super.key, required this.videoData});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final supabase = Supabase.instance.client;
  bool _isProcessing = false;

  // Função para salvar na tabela de Favoritos
  Future<void> _favoritar() async {
    setState(() => _isProcessing = true);
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('favoritos').insert({
        'user_id': userId,
        'video_id': widget.videoData['id'],
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionado aos favoritos! ❤️')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao favoritar. O filme já pode estar na lista.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // Função para salvar na tabela de Histórico
  Future<void> _assistir() async {
    setState(() => _isProcessing = true);
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('historico').insert({
        'user_id': userId,
        'video_id': widget.videoData['id'],
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionado ao histórico de assistidos! 🍿')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao registrar no histórico.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.videoData;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(video['titulo'] ?? 'Detalhes', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Capa do vídeo
            Image.network(
              video['url_imagem'] ?? 'https://via.placeholder.com/600x400',
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                  const SizedBox(height: 300, child: Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50))),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    video['titulo'] ?? 'Sem Título',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Categoria
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      video['categoria'] ?? 'Sem Categoria',
                      style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botões de Ação
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isProcessing ? null : _assistir,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Assistir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isProcessing ? null : _favoritar,
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Favoritar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Sinopse',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Descrição
                  Text(
                    video['sinopse'] ?? 'Descrição não disponível.',
                    style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}