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
  bool _isLoading = true;
  List<dynamic> _favoritesList = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

 
  Future<void> _fetchFavorites() async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        
        final response = await supabase
            .from('favorites')
            .select()
            .eq('user_id', user.id);

        setState(() {
          _favoritesList = response;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar favoritos: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  
  Future<void> _removeFavorite(String favoriteId) async {
    try {
      await supabase
          .from('favorites')
          .delete()
          .eq('id', favoriteId);

     
      setState(() {
        _favoritesList.removeWhere((item) => item['id'] == favoriteId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido dos favoritos!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoritesList.isEmpty
              ? const Center(
                  child: Text(
                    'Você ainda não favoritou nenhum conteúdo.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _favoritesList.length,
                  itemBuilder: (context, index) {
                    final item = _favoritesList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            item['image_url'] ?? 'https://via.placeholder.com/150',
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.movie, size: 40),
                          ),
                        ),
                        title: Text(
                          item['title'] ?? 'Sem título',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item['synopsis'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      
                        onTap: () {
                          context.pushNamed(
                            'details',
                            extra: {
                              'id': item['video_id'], 
                              'title': item['title'],
                              'synopsis': item['synopsis'],
                              'image_url': item['image_url'],
                            },
                          );
                        },
                      
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _removeFavorite(item['id']),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}