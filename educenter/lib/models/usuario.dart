class Usuario {
  String id_usuario;
  String nombre;
  String apellido;
  String dni;
  int? id_clase;
  int? id_centro;
  String tipo_usuario;
  String? url_foto_perfil;
  String? email_contacto;

  Usuario(
      this.id_usuario,
      this.nombre,
      this.apellido,
      this.dni,
      this.id_clase,
      this.id_centro,
      this.tipo_usuario,
      this.url_foto_perfil,
      this.email_contacto);
}
