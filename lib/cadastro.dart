import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _cadastrar() async {

    try {

      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário cadastrado!'),
          ),
        );

        Navigator.pop(context);
      }

    } on AuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _cadastrar,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}