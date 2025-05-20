import 'package:flutter/material.dart';
import '../models/reporte.dart';
import '../services/database_helper.dart';
import './home.dart';
import './stats.dart';
import '../main.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Reporte> _historialReportes = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Modificamos para obtener solo reportes pendientes
      const String query = '''
        SELECT r.id_reporte, r.id_dispensador, d.planta as nombre_dispensador, 
          r.id_tipo, t.nombre as nombre_tipo, t.prioridad, r.estado, r.fecha,
          e.nombre as nombre_edificio
        FROM Reportes r
        JOIN Dispensador d ON r.id_dispensador = d.id_dispensador
        JOIN TiposReporte t ON r.id_tipo = t.id_tipo
        JOIN Edificios e ON d.id_edificio = e.id_edificio
        WHERE r.estado = 'Completado'
        ORDER BY 
          CASE 
            WHEN t.prioridad = 'Crítica' THEN 1
            WHEN t.prioridad = 'Alta' THEN 2
            WHEN t.prioridad = 'Media' THEN 3
            WHEN t.prioridad = 'Baja' THEN 4
            ELSE 5
          END,
          r.fecha
      ''';
      
      final reportesData = await DatabaseHelper.ejecutarConsulta(query, []);
      final reportes = reportesData.map((data) => Reporte.fromMap(data)).toList();

      setState(() {
        _historialReportes = reportes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar historial: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Elimina el botón de retroceso
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarHistorial,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : _historialReportes.isEmpty
                  ? const Center(child: Text('No hay reportes en el historial'))
                  : RefreshIndicator(
                      onRefresh: _cargarHistorial,
                      child: ListView.builder(
                        itemCount: _historialReportes.length,
                        itemBuilder: (context, index) {
                          final reporte = _historialReportes[index];
                          
                          // Definimos los colores y textos según la prioridad
                          Color headerColor;
                          String headerText;
                          String imagePath;

                          switch (reporte.prioridad) {
                            case 'Crítica':
                              headerColor = Colors.red[300]!;
                              headerText = 'Urgencia Critica';
                              imagePath = 'images/critical.png';
                              break;
                            case 'Alta':
                              headerColor = Colors.orange[300]!;
                              headerText = 'Urgencia Alta';
                              imagePath = 'images/high.png';
                              break;
                            case 'Media':
                              headerColor = Colors.yellow[300]!;
                              headerText = 'Urgencia media';
                              imagePath = 'images/medium.png';
                              break;
                            case 'Baja':
                              headerColor = Colors.lightGreen[300]!;
                              headerText = 'Urgencia baja';
                              imagePath = 'images/low.png';
                              break;
                            default:
                              headerColor = Colors.grey;
                              headerText = 'Sin prioridad';
                              imagePath = 'images/unknown.png';
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            height: 180, // Aumentando la altura de la tarjeta
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Encabezado de prioridad
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: headerColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    headerText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Imagen en lugar de ícono
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset(
                                              imagePath,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Text(
                                                      'Sin imagen',
                                                      style: TextStyle(fontSize: 10),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                reporte.nombreTipo,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Edificio ${reporte.nombreEdificio}',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                'Dispensador ${reporte.nombreDispensador}',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                'Fecha: ${reporte.fecha.day}/${reporte.fecha.month}/${reporte.fecha.year} ${reporte.fecha.hour}:${reporte.fecha.minute.toString().padLeft(2, '0')}',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            // Ya estamos en History, no hacemos nada
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StatsPage()),
            );
          } else if (index == 3) {
            // Cerrar sesión y volver a la página principal
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false,
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar Sesión',
          ),
        ],
      ),
    );
  }
}