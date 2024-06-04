// ignore_for_file: unnecessary_import
import 'package:educenter/bbdd/citas_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/cita.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CitaPanel extends StatefulWidget {
  Cita citaSeleccionada;
  CitaPanel({super.key, required this.citaSeleccionada});

  @override
  State<CitaPanel> createState() => _CitaPanelState();
}

bool fechasSonIguales(DateTime? fecha_padre, DateTime? fecha_tutor) {
  if (fecha_padre == null || fecha_tutor == null) {
    return false;
  }
  return fecha_padre.isAtSameMomentAs(fecha_tutor);
}

class _CitaPanelState extends State<CitaPanel> {
  @override
  Widget build(BuildContext context) {
    bool acordado = fechasSonIguales(widget.citaSeleccionada?.fecha_padre,
        widget.citaSeleccionada.fecha_tutor);
    setState(() {});
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: esOscuro ? Colors.white : Colors.black12,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.citaSeleccionada.titulo,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: esOscuro ? Colors.black : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.citaSeleccionada.descripcion,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: esOscuro ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Horario de la cita:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  !acordado
                      ? GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Padres",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Card(
                                    child: InkWell(
                                      onTap: () async {
                                        Usuario user =
                                            await usersBBDD().getUsuario();
                                        if (user.tipo_usuario == "profesor") {
                                          return;
                                        }
                                        DatePicker.showDateTimePicker(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          showTitleActions: true,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime(
                                              DateTime.now().year + 2, 1, 1),
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.es,
                                          onConfirm: (time) async {
                                            await CitasBBDD()
                                                .updateFechaCitaPadre(
                                                    widget.citaSeleccionada,
                                                    time);
                                            setState(() {
                                              widget.citaSeleccionada
                                                  .fecha_padre = time;
                                            });
                                          },
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_outlined,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  widget.citaSeleccionada
                                                      .fecha_padre
                                                      .toString()
                                                      .split(" ")
                                                      .first,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.watch_later_outlined,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  Utils.formatTimeString(widget
                                                      .citaSeleccionada
                                                      .fecha_padre
                                                      .toString()
                                                      .split(" ")
                                                      .last),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Tutor",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Card(
                                    child: InkWell(
                                      onTap: () async {
                                        Usuario user =
                                            await usersBBDD().getUsuario();
                                        if (user.tipo_usuario ==
                                            "padre_madre") {
                                          return;
                                        }
                                        DatePicker.showDateTimePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime(
                                              DateTime.now().year + 2, 1, 1),
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.es,
                                          onConfirm: (time) async {
                                            await CitasBBDD()
                                                .updateFechaCitaTutor(
                                                    widget.citaSeleccionada,
                                                    time);
                                            setState(() {
                                              widget.citaSeleccionada
                                                  .fecha_tutor = time;
                                            });
                                          },
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_outlined,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.citaSeleccionada
                                                                .fecha_tutor !=
                                                            null
                                                        ? widget
                                                            .citaSeleccionada
                                                            .fecha_tutor
                                                            .toString()
                                                            .split(" ")
                                                            .first
                                                        : "Fecha no especificada",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.watch_later_outlined,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.citaSeleccionada
                                                                .fecha_tutor !=
                                                            null
                                                        ? Utils.formatTimeString(
                                                            widget
                                                                .citaSeleccionada
                                                                .fecha_tutor
                                                                .toString()
                                                                .split(" ")
                                                                .last)
                                                        : "Fecha aun no especificada",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Fecha y hora acordadas:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.citaSeleccionada
                                                  .fecha_tutor !=
                                              null
                                          ? widget.citaSeleccionada.fecha_tutor
                                                  .toString()
                                                  .split(" ")
                                                  .first +
                                              " - " +
                                              Utils.formatTimeString(widget
                                                  .citaSeleccionada.fecha_tutor
                                                  .toString()
                                                  .split(" ")
                                                  .last)
                                          : "Fecha aún no especificada")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Asistentes:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 20,
                  ),
                  GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    children: [
                      Column(
                        children: [
                          Text(
                            "Hijo",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 100,
                                        height: 100,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: widget.citaSeleccionada.alumno
                                                        .url_foto_perfil !=
                                                    null &&
                                                widget.citaSeleccionada.alumno
                                                        .url_foto_perfil !=
                                                    ""
                                            ? Image.network(
                                                widget.citaSeleccionada.alumno
                                                    .url_foto_perfil!,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.person,
                                              )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${widget.citaSeleccionada.alumno.nombre} ${widget.citaSeleccionada.alumno.apellido}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Tutor",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 100,
                                          height: 100,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: widget.citaSeleccionada.tutor
                                                          .url_foto_perfil !=
                                                      null &&
                                                  widget.citaSeleccionada.tutor
                                                          .url_foto_perfil !=
                                                      ""
                                              ? Image.network(
                                                  widget.citaSeleccionada.tutor
                                                      .url_foto_perfil!,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(
                                                  Icons.person,
                                                )),
                                      Flexible(
                                        child: Text(
                                          "${widget.citaSeleccionada.tutor.nombre} ${widget.citaSeleccionada.tutor.apellido}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
