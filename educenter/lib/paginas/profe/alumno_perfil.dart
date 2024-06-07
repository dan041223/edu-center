import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/examenes_alumno_bbdd.dart';
import 'package:educenter/bbdd/incidencia_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/incidencia_hijo.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/profe/agregar_incidencia.dart';
import 'package:educenter/paginas/profe/examenes_alumno.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AlumnoPerfil extends StatefulWidget {
  Usuario profesor;
  Asignatura asignatura;
  Alumno alumno;
  AlumnoPerfil(
      {super.key,
      required this.alumno,
      required this.asignatura,
      required this.profesor});

  @override
  State<AlumnoPerfil> createState() => _AlumnoPerfilState();
}

class _AlumnoPerfilState extends State<AlumnoPerfil> {
  bool loading = true;
  List<Asignatura> asignaturasHijoProfe = List.empty(growable: true);
  List<Usuario> padresAlumno = List.empty(growable: true);
  List<Incidencia> incidenciasAlumno = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () async {
        Usuario profesor = await usersBBDD().getUsuario();
        asignaturasHijoProfe =
            await AlumnosBBDD().getAsignaturasAlumno(widget.alumno.id_alumno);
        asignaturasHijoProfe.removeWhere(
            (element) => element.id_profesor != profesor.id_usuario);
        padresAlumno = await AlumnosBBDD().getPadresDeAlumno(widget.alumno);
        incidenciasAlumno =
            await IncidenciaBBDD().getIncidenciasAlumno(widget.alumno);
        setState(() {
          loading = false;
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: esOscuro ? Colors.white : Colors.black12,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          widget.alumno.url_foto_perfil?.toString() ??
                              widget.alumno.url_foto_perfil?.toString() ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                          "${widget.alumno.nombre} ${widget.alumno.apellido}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: esOscuro ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ExamenesAlumno(
                                alumno: widget.alumno,
                                asignatura: widget.asignatura,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_list_numbered_sharp),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Ver examenes de ${widget.alumno.nombre}...",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                "Incidencias:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 20,
              ),
              Card(
                color: Colors.red,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AgregarIncidencia(
                        alumno: widget.alumno,
                        profesor: widget.profesor,
                      ),
                    ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Agregar incidencia...",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : incidenciasAlumno.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: incidenciasAlumno.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => IncidenciaHijo(
                                        incidenciaSeleccionada:
                                            incidenciasAlumno[index]),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.crisis_alert),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        incidenciasAlumno[index]
                                            .titulo_incidencia,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                              "${widget.alumno.nombre} no tiene incidencias..."),
                        ),
              SizedBox(
                height: 10,
              ),
              const Text(
                "Asignaturas que le imparto:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 20,
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : asignaturasHijoProfe.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: asignaturasHijoProfe.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  "- ${asignaturasHijoProfe[index].nombre_asignatura}"),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              "No impartes asignaturas a ${widget.alumno.nombre}"),
                        ),
              const Text(
                "Padres:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 20,
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : padresAlumno.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: padresAlumno.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: 100,
                                      height: 100,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child:
                                          padresAlumno[index].url_foto_perfil !=
                                                      null &&
                                                  padresAlumno[index]
                                                          .url_foto_perfil !=
                                                      ""
                                              ? Image.network(
                                                  padresAlumno[index]
                                                      .url_foto_perfil!,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(
                                                  Icons.person,
                                                )),
                                  Text(
                                    padresAlumno[index].nombre,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              "${widget.alumno.nombre} no tiene padres registrados."),
                        ),
              SizedBox(
                height: 20,
              ),
              padresAlumno.any((element) => element.email_contacto != null)
                  ? Card(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Uri googleUrl = Uri.parse(
                              'mailto:${padresAlumno.map((e) => e.email_contacto).join(",")}');
                          launchUrl(googleUrl);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.mail_outline_outlined,
                                size: 25,
                              ),
                              Text(
                                "Enviar Email a los padres...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Text("Ningun padre/madre tiene un correo de contacto")
            ])),
      ),
    );
  }
}
