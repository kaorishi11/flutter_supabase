import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';
import 'cadastro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _fazerLogin() async {

    try {

      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const InventarioPagina(),
          ),
        );
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
        title: const Text('Login'),
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
              onPressed: _fazerLogin,
              child: const Text('Login'),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CadastroPage(),
                  ),
                );
              },
              child: const Text('Criar conta'),
            )
          ],
        ),
      ),
    );
  }
}