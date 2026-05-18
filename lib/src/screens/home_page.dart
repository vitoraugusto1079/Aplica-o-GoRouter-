import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instância para conversar com o banco
  final supabase = Supabase.instance.client;

  // Função assíncrona que busca a lista de vídeos na tabela do Supabase
  Future<List<Map<String, dynamic>>> _fetchVideos() async {
    final response = await supabase.from('videos').select();
    // Converte a resposta em uma lista de mapas para o Flutter entender fácil
    return List<Map<String, dynamic>>.from(response); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro
      appBar: AppBar(
        title: const Text('SENAI Play', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Ícones de navegação para as outras telas do projeto
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/favorites'),
            tooltip: 'Favoritos',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
            tooltip: 'Histórico',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: 'Perfil',
          ),
        ],
      ),
      // O FutureBuilder é a mágica: ele mostra um "carregando" até os vídeos chegarem do banco
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchVideos(),
        builder: (context, snapshot) {
          // Se estiver carregando...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }
          // Se der erro...
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar vídeos.', style: TextStyle(color: Colors.white)));
          }
          
          final videos = snapshot.data ?? [];
          
          // Se o banco estiver vazio...
          if (videos.isEmpty) {
            return const Center(child: Text('Nenhum vídeo no banco de dados.', style: TextStyle(color: Colors.white)));
          }

          // A grade exigida no documento!
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 vídeos por linha
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7, // Formato vertical (capa de filme)
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return GestureDetector(
                onTap: () {
                  // REQUISITO CUMPRIDO: Navegação passando os parâmetros nomeados via 'extra'
                  context.pushNamed('details', extra: video);
                },
                child: Card(
                  color: Colors.grey[900],
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Imagem da capa
                      Expanded(
                        child: Image.network(
                          video['url_imagem'] ?? 'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          // Se o link da imagem estiver quebrado, mostra um ícone de erro
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        ),
                      ),
                      // Título do filme/série
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          video['titulo'] ?? 'Sem título',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}