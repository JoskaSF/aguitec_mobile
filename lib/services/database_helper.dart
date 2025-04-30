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
}