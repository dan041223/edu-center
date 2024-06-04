import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/profesor_panel.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CentroPanel extends StatefulWidget {
  Alumno? alumno;
  Centro centro;
  CentroPanel({super.key, required this.centro, this.alumno});

  @override
  State<CentroPanel> createState() => _CentroPanelState();
}

class _CentroPanelState extends State<CentroPanel> {
  Usuario profesor = Usuario("", "", "", "", 0, 0, "", "", "");

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      if (widget.alumno != null)
        profesor = await AlumnosBBDD().getTutorAlumno(widget.alumno!);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Utils.hexToColor(widget.centro.color),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(25),
                child: Stack(
                  children: [
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
                            child: widget.centro.url_imagen_centro != ""
                                ? Image.network(
                                    widget.centro.url_imagen_centro,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.business_outlined,
                                  )),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Text(
                            widget.centro.nombre_centro,
                            style: const TextStyle(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Horario:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          Utils.timeOfDayToString(
                            widget.centro.horario_centro_inicio.toString(),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Text(
                          "->",
                          style: TextStyle(fontSize: 18),
                        ),
                        const Icon(
                          Icons.watch_later_outlined,
                          size: 60,
                        ),
                        const Text(
                          "->",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          Utils.timeOfDayToString(
                              widget.centro.horario_centro_fin.toString()),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Contacto y Ubicación:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  GridView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    children: [
                      Card(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Uri googleUrl = Uri.parse(
                                'mailto:${widget.centro.email_centro}');
                            launchUrl(googleUrl);

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => AsignaturasHijo(
                            //           asignaturas: asignaturas,
                            //           alumnoElegido: widget.alumnoElegido,
                            //         )));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.mail_outline_outlined,
                                  size: 40,
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
                      ),
                      Card(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Uri googleUrl = Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=${widget.centro.direccion_centro}');
                            launchUrl(googleUrl);

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => AsignaturasHijo(
                            //           asignaturas: asignaturas,
                            //           alumnoElegido: widget.alumnoElegido,
                            //         )));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.map,
                                  size: 40,
                                ),
                                Text(
                                  "Ver ubicación en Maps...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.alumno != null
                      ? Text(
                          "Tutor/a de ${widget.alumno!.nombre}:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  widget.alumno != null
                      ? const Divider(
                          height: 20,
                        )
                      : Container(),
                  profesor.id_usuario.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 0.2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfesorPanel(
                                    profesor: profesor,
                                    alumno: widget.alumno,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        height: 100,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: profesor.url_foto_perfil !=
                                                    null &&
                                                profesor.url_foto_perfil != ""
                                            ? Image.network(
                                                profesor.url_foto_perfil!,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.person,
                                              )),
                                    Text(
                                      profesor.nombre,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
