class Evento {
  int id_evento;
  String nombre_evento;
  String descripcion_evento;
  String tipo_evento;
  DateTime fecha_inicio;
  DateTime fecha_fin;
  String ubicacion;

  Evento(this.id_evento, this.nombre_evento, this.descripcion_evento,
      this.tipo_evento, this.fecha_inicio, this.fecha_fin, this.ubicacion);
}
