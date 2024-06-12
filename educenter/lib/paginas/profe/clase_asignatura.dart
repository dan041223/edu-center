import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/alumno_perfil_admin.dart';
import 'package:educenter/paginas/admin/editar_asignatura.dart';
import 'package:educenter/paginas/profe/alumno_perfil.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClaseAsignatura extends StatefulWidget {
  Centro? centro;
  Usuario? usuario;
  Clase clase;
  Asignatura asignatura;
  ClaseAsignatura(
      {super.key,
      required this.clase,
      required this.asignatura,
      this.usuario,
      required this.centro});

  @override
  State<ClaseAsignatura> createState() => _ClaseAsignaturaState();
}

class _ClaseAsignaturaState extends State<ClaseAsignatura> {
  List<Alumno> alumnos = List.empty(growable: true);
  bool loading = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      loading = true;

      alumnos = await AlumnosBBDD().getAlumnosClase(widget.clase);

      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: loading
            ? Container()
            : widget.usuario != null &&
                    widget.usuario!.tipo_usuario == "administrador"
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditarAsignatura(
                            asignatura: widget.asignatura,
                            centro: widget.centro!),
                      ));
                    },
                    child: const Icon(Icons.edit),
                  )
                : Container(),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Utils.hexToColor(widget.asignatura.color_codigo),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.asignatura.nombre_asignatura,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.clase.nombre_clase,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  alumnos.isEmpty
                      ? Center(
                          child: Text("Esta asignatura no tiene alumnos"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: alumnos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  widget.usuario != null &&
                                          widget.usuario!.tipo_usuario ==
                                              "administrador"
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                          builder: (context) =>
                                              AlumnoPerfilAdmin(
                                            alumno: alumnos[index],
                                            centro: widget.centro!,
                                          ),
                                        ))
                                      : AlumnosBBDD()
                                          .getAlumno(alumnos[index].id_alumno)
                                          .then((alumno) => Navigator
                                                  .of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      AlumnoPerfil(
                                                          profesor: widget
                                                              .asignatura
                                                              .profesor,
                                                          alumno: alumno,
                                                          asignatura: widget
                                                              .asignatura))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: alumnos[index].url_foto_perfil !=
                                                null
                                            ? Image.network(
                                                alumnos[index]
                                                    .url_foto_perfil
                                                    .toString(),
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.person),
                                      ),
                                      Text(
                                        "${alumnos[index].nombre} ${alumnos[index].apellido}",
                                        style: const TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                ],
              ));
  }
}
