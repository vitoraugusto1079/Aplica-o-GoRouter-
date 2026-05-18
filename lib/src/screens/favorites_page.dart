import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _favoritos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _buscarFavoritos();
  }

  // Busca no Supabase usando a tabela correta e o JOIN com a tabela de vídeos
  Future<void> _buscarFavoritos() async {
    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('favoritos') // Nome correto da tabela!
          .select('id, videos(*)') // Puxando os detalhes do vídeo
          .eq('user_id', userId);

      if (mounted) {
        setState(() {
          _favoritos = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar favoritos.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Remoção usando o ID inteiro correto
  Future<void> _removerFavorito(int idRegistro) async {
    try {
      await supabase.from('favoritos').delete().eq('id', idRegistro);
      
      setState(() {
        _favoritos.removeWhere((item) => item['id'] == idRegistro);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido dos favoritos!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao remover.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro do app
      appBar: AppBar(
        title: const Text('Meus Favoritos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : _favoritos.isEmpty
              ? const Center(
                  child: Text(
                    'Você ainda não favoritou nenhum conteúdo.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _favoritos.length,
                  itemBuilder: (context, index) {
                    final item = _favoritos[index];
                    final video = item['videos']; // Pega os dados do vídeo que vieram do banco

                    return Card(
                      color: Colors.grey[900], // Card escuro para combinar
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            video['url_imagem'] ?? 'https://via.placeholder.com/150',
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.movie, color: Colors.grey, size: 40),
                          ),
                        ),
                        title: Text(
                          video['titulo'] ?? 'Sem título',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          video['sinopse'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          // Passa o objeto do vídeo inteiro para a tela de detalhes!
                          context.pushNamed('details', extra: video);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _removerFavorito(item['id']),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}