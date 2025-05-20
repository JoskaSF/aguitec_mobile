class Reporte {
  final int idReporte;
  final int idDispensador;
  final String nombreDispensador;
  final int idTipo;
  final String nombreTipo;
  final String prioridad;
  final String estado;
  final DateTime fecha;
  final String nombreEdificio;

  Reporte({
    required this.idReporte,
    required this.idDispensador,
    required this.nombreDispensador,
    required this.idTipo,
    required this.nombreTipo,
    required this.prioridad,
    required this.estado,
    required this.fecha,
    required this.nombreEdificio,
  });

  factory Reporte.fromMap(Map<String, dynamic> map) {
    return Reporte(
      idReporte: map['id_reporte'],
      idDispensador: map['id_dispensador'],
      nombreDispensador: map['nombre_dispensador'] ?? 'Sin nombre',
      idTipo: map['id_tipo'],
      nombreTipo: map['nombre_tipo'] ?? 'Sin tipo',
      prioridad: map['prioridad'] ?? 'Media',
      estado: map['estado'],
      fecha: map['fecha'] is String 
          ? DateTime.parse(map['fecha']) 
          : map['fecha'] as DateTime,
      nombreEdificio: map['nombre_edificio'] ?? 'Sin edificio',
    );
  }
}