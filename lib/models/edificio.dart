class Edificio {
  final int idEdificio;
  final String nombre;
  final int cantidad;

  Edificio({
    required this.idEdificio,
    required this.nombre,
    required this.cantidad,
  });

  factory Edificio.fromMap(Map<String, dynamic> map) {
    return Edificio(
      idEdificio: map['id_edificio'],
      nombre: map['nombre'],
      cantidad: map['cantidad'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_edificio': idEdificio,
      'nombre': nombre,
      'cantidad': cantidad,
    };
  }
}