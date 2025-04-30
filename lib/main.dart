import 'package:flutter/material.dart';
import 'services/database_helper.dart';

import 'models/edificio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Edificio> _edificios = [];
  String _status = 'No conectado';

  Future<void> _cargarEdificios() async {
    try {
      final resultados = await DatabaseHelper.ejecutarConsulta('SELECT * FROM Edificios');
      setState(() {
        _edificios = resultados.map((map) => Edificio.fromMap(map)).toList();
        _status = 'Conexión exitosa: ${_edificios.length} edificios encontrados';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Estado de la conexión:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              _status,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (_edificios.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Edificios:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _edificios.length,
                  itemBuilder: (context, index) {
                    final edificio = _edificios[index];
                    return ListTile(
                      title: Text(edificio.nombre),
                      subtitle: Text('Cantidad: ${edificio.cantidad}'),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cargarEdificios,
        tooltip: 'Cargar Edificios',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
