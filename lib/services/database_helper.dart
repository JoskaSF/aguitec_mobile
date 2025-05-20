import 'package:mysql1/mysql1.dart';
import '../utils/database_config.dart';

class DatabaseHelper {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port,
      user: DatabaseConfig.user,
      password: DatabaseConfig.password,
      db: DatabaseConfig.database
    );

    try {
      final conn = await MySqlConnection.connect(settings);
      return conn;
    } catch (e) {
      throw Exception('Error de conexión a la base de datos: $e');
    }
  }

  // Método genérico para ejecutar consultas
  static Future<List<Map<String, dynamic>>> ejecutarConsulta(String query, [List<dynamic>? params]) async {
    final conn = await getConnection();
    try {
      final Results results = params != null 
          ? await conn.query(query, params)
          : await conn.query(query);
          
      await conn.close();
      return results.map((row) => row.fields).toList();
    } catch (e) {
      await conn.close();
      throw Exception('Error al ejecutar la consulta: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerReportesPendientes() async {
    const String query = '''
      SELECT r.id_reporte, r.id_dispensador, d.planta as nombre_dispensador, 
        r.id_tipo, t.nombre as nombre_tipo, t.prioridad, r.estado, r.fecha,
        e.nombre as nombre_edificio
      FROM Reportes r
      JOIN Dispensador d ON r.id_dispensador = d.id_dispensador
      JOIN TiposReporte t ON r.id_tipo = t.id_tipo
      JOIN Edificios e ON d.id_edificio = e.id_edificio
      WHERE r.estado = 'Pendiente'
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
    
    return await ejecutarConsulta(query, []);
  }
}