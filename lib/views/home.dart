import 'package:flutter/material.dart';
import '../models/reporte.dart';
import '../services/database_helper.dart';
import './history.dart';
import './stats.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reporte> _reportes = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final reportesData = await DatabaseHelper.obtenerReportesPendientes();
      final reportes = reportesData.map((data) => Reporte.fromMap(data)).toList();

      setState(() {
        _reportes = reportes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar reportes: $e';
        _isLoading = false;
      });
    }
  }

  // Función para marcar un reporte como completado
  Future<void> _marcarComoCompletado(int idReporte) async {
    try {
      setState(() {
        _isLoading = true;
      });

      const String query = 'UPDATE Reportes SET estado = "completado" WHERE id_reporte = ?';
      await DatabaseHelper.ejecutarConsulta(query, [idReporte]);

      // Recargar los reportes para actualizar la lista
      await _cargarReportes();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte marcado como completado')),
      );
    } catch (e) {
      setState(() {
        _error = 'Error al actualizar el reporte: $e';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Función para mostrar el diálogo de confirmación
  void _mostrarDialogoConfirmacion(Reporte reporte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar acción'),
          content: const Text('¿Desea marcar este reporte como completado?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _marcarComoCompletado(reporte.idReporte); // Marcar como completado
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificacions'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarReportes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : _reportes.isEmpty
                  ? const Center(child: Text('No hay reportes pendientes'))
                  : RefreshIndicator(
                      onRefresh: _cargarReportes,
                      child: ListView.builder(
                        itemCount: _reportes.length,
                        itemBuilder: (context, index) {
                          final reporte = _reportes[index];

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

                          return GestureDetector(
                            onTap: () => _mostrarDialogoConfirmacion(reporte),
                            child: Container(
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Ya estamos en Home, no hacemos nada
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
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