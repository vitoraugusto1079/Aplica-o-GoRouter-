import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _historico = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _buscarHistorico();
  }

  // Função para buscar o histórico em ordem cronológica 
  Future<void> _buscarHistorico() async {
    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Puxa o histórico e faz o JOIN com a tabela de vídeos
      // O .order garante a exibição cronológica exigida 
      final response = await supabase
          .from('historico')
          .select('id, assistido_em, videos(*)')
          .eq('user_id', userId)
          .order('assistido_em', ascending: false);

      if (mounted) {
        setState(() {
          _historico = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar o histórico.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Função para deletar um item individual do histórico 
  Future<void> _deletarDoHistorico(int idRegistro) async {
    try {
      await supabase.from('historico').delete().eq('id', idRegistro);
      
      // Atualiza a lista na tela após deletar
      _buscarHistorico();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido do histórico.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao remover o item.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Histórico de Assistidos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : _historico.isEmpty
              ? const Center(
                  child: Text(
                    'Você ainda não assistiu a nenhum vídeo.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _historico.length,
                  itemBuilder: (context, index) {
                    final item = _historico[index];
                    final video = item['videos']; // Dados do vídeo vindos do JOIN
                    
                    // Formatando a data que vem do banco
                    final dataAssistido = DateTime.parse(item['assistido_em']);
                    final dataFormatada = "${dataAssistido.day}/${dataAssistido.month}/${dataAssistido.year}";

                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            video['url_imagem'] ?? 'https://via.placeholder.com/150',
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                        title: Text(
                          video['titulo'] ?? 'Sem título',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Assistido em: $dataFormatada',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        // Botão de deletar exigido no escopo 
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _deletarDoHistorico(item['id']),
                          tooltip: 'Remover do Histórico',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}