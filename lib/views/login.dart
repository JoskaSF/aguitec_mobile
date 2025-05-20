import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import './home.dart';  // Importar la vista de Home

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LloginPageState();
}

class LloginPageState extends State<LoginPage> {
  // Controladores para los campos de texto
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Estado para mostrar indicador de carga
  bool _isLoading = false;
  
  // Método para verificar credenciales
  Future<bool> _verificarCredenciales(String usuario, String password) async {
    try {
      // Consulta SQL para verificar las credenciales
      const String query = 'SELECT * FROM Usuarios WHERE nombre_usuario = ? AND password = ?';
      final List<Map<String, dynamic>> resultado = 
          await DatabaseHelper.ejecutarConsulta(query, [usuario, password]);
      
      // Si hay resultados, las credenciales son correctas
      return resultado.isNotEmpty;
    } catch (e) {
      // Mostrar error en caso de fallo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
      return false;
    }
  }

  @override
  void dispose() {
    // Limpieza de controladores
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true, // Oculta el texto para contraseñas
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: () async {
                  // Obtener valores de los campos
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  
                  // Validar que los campos no estén vacíos
                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, complete todos los campos')),
                    );
                    return;
                  }
                  
                  // Mostrar indicador de carga
                  setState(() {
                    _isLoading = true;
                  });
                  
                  // Verificar credenciales
                  final bool esValido = await _verificarCredenciales(username, password);
                  
                  // Ocultar indicador de carga
                  setState(() {
                    _isLoading = false;
                  });
                  
                  // Si las credenciales son válidas, navegar a home
                  if (esValido) {
                    // Navegar a la pantalla de inicio
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    // Mostrar mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario o contraseña incorrectos')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
      )
    );
  }
}