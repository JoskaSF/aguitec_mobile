class Dispensador {
  final int idDispensador;
  final int idEdificio;
  final String planta;  // Cambiado de "nombre" a "planta"
  final String url;

  Dispensador({
    required this.idDispensador,
    required this.idEdificio,
    required this.planta,
    required this.url,
  });

  factory Dispensador.fromMap(Map<String, dynamic> map) {
    return Dispensador(
      idDispensador: map['id_dispensador'],
      idEdificio: map['id_edificio'],
      planta: map['planta'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_dispensador': idDispensador,
      'id_edificio': idEdificio,
      'planta': planta,
      'url': url,
    };
  }
}