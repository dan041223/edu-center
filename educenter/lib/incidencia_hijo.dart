import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/components/fecha_xs.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/padre/profesor_panel.dart';
import 'package:educenter/paginas/profe/alumno_perfil.dart';
import 'package:educenter/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';

class IncidenciaHijo extends StatefulWidget {
  Usuario? user;
  Incidencia incidenciaSeleccionada;

  IncidenciaHijo({super.key, required this.incidenciaSeleccionada});

  @override
  State<IncidenciaHijo> createState() => _IncidenciaHijoState();
}

class _IncidenciaHijoState extends State<IncidenciaHijo> {
  PlatformFile? file;
  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = result.files.first;
    }
  }

  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        widget.user = await usersBBDD().getUsuario();
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Utils.capitalize(Utils.tipoIncidenciaToString(
              widget.incidenciaSeleccionada.tipo_incidencia)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: esOscuro ? Colors.white : Colors.black,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          widget.incidenciaSeleccionada.titulo_incidencia,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: esOscuro ? Colors.black : Colors.white),
                        ),
                      ),
                      fechaXS(
                          widget.incidenciaSeleccionada.fecha_incidencia
                              .toString(),
                          esOscuro ? Colors.black : Colors.white),
                    ],
                  ),
                  widget.incidenciaSeleccionada.descripcion != ""
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Razón...",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      esOscuro ? Colors.black : Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.incidenciaSeleccionada.descripcion,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      esOscuro ? Colors.black : Colors.white),
                            ),
                          ],
                        )
                      : Container()
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Profesor y alumno:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: InkWell(
                  onTap: widget.user != null &&
                          widget.user!.tipo_usuario == "padre_madre"
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfesorPanel(
                              profesor: widget.incidenciaSeleccionada.profesor,
                              alumno: widget.incidenciaSeleccionada.alumno,
                            ),
                          ));
                        }
                      : () {},
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget.incidenciaSeleccionada.profesor
                                      .url_foto_perfil !=
                                  null
                              ? Image.network(
                                  widget.incidenciaSeleccionada.profesor
                                      .url_foto_perfil
                                      .toString(),
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.incidenciaSeleccionada.profesor.nombre} ${widget.incidenciaSeleccionada.profesor.apellido}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: widget.incidenciaSeleccionada.alumno
                                    .url_foto_perfil !=
                                null
                            ? Image.network(
                                widget.incidenciaSeleccionada.alumno
                                    .url_foto_perfil
                                    .toString(),
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.incidenciaSeleccionada.alumno.nombre} ${widget.incidenciaSeleccionada.alumno.apellido}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          // ElevatedButton.icon(
          //     onPressed: picksinglefile,
          //     style: const ButtonStyle(
          //         backgroundColor: MaterialStatePropertyAll(
          //             Color.fromARGB(255, 61, 186, 228))),
          //     icon: const Icon(Icons.insert_drive_file_sharp),
          //     label: const Text(
          //       'Pick File',
          //       style: TextStyle(fontSize: 25),
          //     ))
        ]),
      ),
    );
  }
}
