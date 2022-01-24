class Nota {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String hora;
  String boleano;
  String color;

  Nota(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.fecha,
      required this.hora,
      required this.boleano,
      required this.color});

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'hora': hora,
      'boleano': boleano,
      'color': color
    };
  }
}
