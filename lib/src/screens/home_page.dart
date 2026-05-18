import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchVideos() async {
    final response = await supabase.from('videos').select();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('SENAI Play', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.favorite, color: Colors.white), onPressed: () => context.push('/favorites')),
          IconButton(icon: const Icon(Icons.history, color: Colors.white), onPressed: () => context.push('/history')),
          IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () => context.push('/profile')),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
          }
          final videos = snapshot.data ?? [];
          if (videos.isEmpty) return const Center(child: Text('Nenhum vídeo disponível.', style: TextStyle(color: Colors.white)));

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Reduzimos o tamanho das capas aqui
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return GestureDetector(
                onTap: () => context.pushNamed('details', extra: video),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(video['url_imagem'], fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['titulo'],
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}