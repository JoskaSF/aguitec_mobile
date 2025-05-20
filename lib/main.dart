import 'package:flutter/material.dart';
import 'package:aguitec_mobile/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGÜITEC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Parte superior semicircular con logo
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 236, 243, 244),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(220),
                bottomRight: Radius.circular(220),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/LogoAguitec.jpg', // Asegúrate de tener este archivo
                    width: 350,
                    height: 350,
                  ),
                  const SizedBox(height: 10),                
                ],
              ),
            ),
          ),

          const SizedBox(height: 80),

          const Text(
            'Bienvenido, inicia\nsesión para continuar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 60),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              elevation: 2,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
