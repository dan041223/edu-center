// ignore_for_file: must_be_immutable

import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/editar_profesor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfesorPanel extends StatefulWidget {
  Centro? centro;
  Usuario? admin;
  Usuario profesor;
  Alumno? alumno;
  ProfesorPanel(
      {super.key,
      required this.profesor,
      this.alumno,
      this.admin,
      this.centro});

  @override
  State<ProfesorPanel> createState() => _ProfesorPanelState();
}

class _ProfesorPanelState extends State<ProfesorPanel> {
  bool loading = true;
  List<Asignatura> asignaturasCentro = List.empty(growable: true);
  List<Clase> clasesCentro = List.empty(growable: true);
  bool esTutor = false;
  List<Asignatura> asignaturasProfeDeAlumno = List.empty(growable: true);
  List<Asignatura> asignaturasProfe = List.empty(growable: true);
  // PARA HACER UN MULTISELECTDROPDOWN DE
  // bool modoEdicionAsignaturas = false;
  // List<Asignatura> listaAsignaturasSeleccionadas = List.empty(growable: true);
  // List<ValueItem> listaAsignaturasDropdown = List.empty(growable: true);
  // List<ValueItem> listaAsignaturasDropdownSeleccionadas =
  //     List.empty(growable: true);
  // @override
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      widget.alumno != null
          ? {
              esTutor = await ProfesoresBBDD()
                  .profesorEsTutorDeAlumno(widget.profesor, widget.alumno!),
              asignaturasProfeDeAlumno = await ProfesoresBBDD()
                  .getAsignaturasProfeDeAlumno(widget.alumno!, widget.profesor)
            }
          : esTutor = false;
      loading = false;
      // widget.centro != null
      //     ? asignaturasCentro =
      //         await CentroBBDD().getAsignaturasCentro(widget.centro!)
      //     : null;
      // widget.centro != null
      //     ? asignaturasCentro.forEach((asignatura) {
      //         if (asignatura.id_profesor == null) {
      //           listaAsignaturasDropdown.add(ValueItem(
      //               label:
      //                   "${asignatura.clase!.nombre_clase} ${asignatura.nombre_asignatura}",
      //               value: asignatura));
      //         }
      //       })
      //     : null;
      asignaturasProfe =
          await ProfesoresBBDD().getAsignaturasProfesor(widget.profesor);
      // PARA OPCIONES PRESELECCIONADAS
      // asignaturasProfe.forEach((asignatura) {
      //   listaAsignaturasDropdownSeleccionadas.add(ValueItem(
      //       label: asignatura.clase!.nombre_clase.toString(),
      //       value: asignatura));
      // });

      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: widget.admin != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditarProfesor(
                    profesor: widget.profesor,
                    centro: widget.centro!,
                  ),
                ));
              },
              child: const Icon(Icons.edit),
            )
          : Container(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: esOscuro ? Colors.white : Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(25),
            child: Stack(
              children: [
                esTutor == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Tutor",
                            style: TextStyle(
                              color: esOscuro ? Colors.black : Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          )
                        ],
                      )
                    : const Row(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: widget.profesor.url_foto_perfil != null &&
                                widget.profesor.url_foto_perfil!.isNotEmpty
                            ? Image.network(
                                widget.profesor.url_foto_perfil!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 80,
                              )),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        "${widget.profesor.nombre} ${widget.profesor.apellido}",
                        style: TextStyle(
                          color: esOscuro ? Colors.black : Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Asignaturas que imparte:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : asignaturasProfe.isEmpty
                              ? const Center(
                                  child: Text("No imparte asignaturas"),
                                )
                              : asignaturasProfeDeAlumno.isEmpty
                                  ? Center(
                                      child: Text(
                                          "No le imparte asignaturas al hijo"),
                                    )
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: widget.alumno != null
                                          ? (asignaturasProfeDeAlumno.isEmpty
                                              ? 1
                                              : asignaturasProfeDeAlumno.length)
                                          : asignaturasProfe.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                            title: Text(widget.alumno != null
                                                ? (asignaturasProfeDeAlumno
                                                        .isNotEmpty
                                                    ? "- ${asignaturasProfeDeAlumno[index].nombre_asignatura}"
                                                    : "No imparte asignaturas a ${widget.alumno!.nombre}")
                                                : asignaturasProfe[index]
                                                                .clase !=
                                                            null &&
                                                        asignaturasProfe
                                                            .isNotEmpty
                                                    ? "- ${asignaturasProfe[index].clase!.nombre_clase} ${asignaturasProfe[index].nombre_asignatura}"
                                                    : "No imparte asignaturas"));
                                      },
                                    ),
                    ),
                  ),
                  const Text(
                    "Contacto:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  widget.profesor.email_contacto != null &&
                          widget.profesor.email_contacto != ""
                      ? Card(
                          elevation: 0.2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Uri googleUrl = Uri.parse(
                                  'mailto:${widget.profesor.email_contacto}');
                              launchUrl(googleUrl);

                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => AsignaturasHijo(
                              //           asignaturas: asignaturas,
                              //           alumnoElegido: widget.alumnoElegido,
                              //         )));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.mail_outline_outlined,
                                    size: 25,
                                  ),
                                  Text(
                                    "Enviar Email...",
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
                      : const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Sin Email de contacto",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
