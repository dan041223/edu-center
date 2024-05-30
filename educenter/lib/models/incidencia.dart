class Incidencia {
  int id_incidencia;
  String tipo_incidencia;
  String titulo_incidencia;
  String descripcion;
  int id_alumno;
  String id_profesor;
  String? justificante_url;
  String? justificacion;
  String? justificante_nombre;
  DateTime fecha_incidencia;

  Incidencia(
      this.id_incidencia,
      this.tipo_incidencia,
      this.titulo_incidencia,
      this.descripcion,
      this.id_alumno,
      this.id_profesor,
      this.justificante_url,
      this.justificacion,
      this.justificante_nombre,
      this.fecha_incidencia);
}
