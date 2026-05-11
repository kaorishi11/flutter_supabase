import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lhdravlannxuycjsjdgh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoZHJhdmxhbm54dXljanNqZGdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg0NzYyMzAsImV4cCI6MjA5NDA1MjIzMH0.RioOi795SJq113OZodp4E_U5LvA4TEc7sWdg24JpA5E',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),      
      home: const MyHomePage(title: 'Inventário Página'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String texto = '';
  int quantidade = 0;
  double preco = 0.0;

  Color corPreco(double precoProduto) {
    return precoProduto > 100 ? Colors.green : Colors.red;
  }

  Future<List<dynamic>> _buscarProdutos() async {
    final response = await Supabase.instance.client
      .from('produtos')
      .select();
    return response as List<dynamic>;
  }

  Future<void> _adicionarProduto() async {
    final response = await Supabase.instance.client
      .from('produtos')
      .insert({
        'nome': texto,
        'quantidade': quantidade,
        'preco': preco,
      });
  }

  Future<void> _atualizarProduto(int id, int quantidadeAtual,) async {
    try {
      await Supabase.instance.client
        .from('produtos')
        .update({
          'quantidade': quantidadeAtual + 1,
        })
        .eq('id', id);
    } catch (e) {
      debugPrint('Erro ao atualizar produto: $e');
    }
  }

  Future<void> _deletarProduto(int id) async {
    try {
      await Supabase.instance.client
        .from('produtos')
        .delete()
        .eq('id', id);
    } catch (e) {
      debugPrint('Erro ao deletar produto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),

      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              onChanged: (value) => texto = value,
              decoration: InputDecoration(
                labelText: 'Digite o nome do Produto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              onChanged: (value) => quantidade = int.tryParse(value) ?? 0,
              decoration: InputDecoration(
                labelText: 'Digite a quantidade do Produto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              onChanged: (value) => preco = double.tryParse(value) ?? 0.0,
              decoration: InputDecoration(
                labelText: 'Digite o preço do Produto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async{
                await _adicionarProduto();
                setState(() {});
              },
              child: const Text('Adicionar Produto'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _buscarProdutos(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum produto encontrado.'));
                  } else {
                    final produtos = snapshot.data!;
                    
                    return ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        final produto = produtos[index];
                        
                        return ListTile(
                          title: Text(produto['nome']),

                          subtitle: Text(
                            'Quantidade: ${produto['quantidade']} - '
                            'Preço: R\$${produto['preco']}',

                            style: TextStyle(
                              color: corPreco(
                                produto['preco'].toDouble(),
                              ),
                            ),
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  await _atualizarProduto(produto['id'], produto['quantidade']);
                                  setState(() {});
                                },                                                                      
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await _deletarProduto(produto['id']);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
