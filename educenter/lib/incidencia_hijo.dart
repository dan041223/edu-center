import 'package:educenter/components/fecha_xs.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/paginas/padre/profesor_panel.dart';
import 'package:educenter/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';

class IncidenciaHijo extends StatefulWidget {
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
              "Profesores:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 20,
          ),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfesorPanel(
                    profesor: widget.incidenciaSeleccionada.profesor,
                    alumno: widget.incidenciaSeleccionada.alumno,
                  ),
                ));
              },
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
                      child: Image.network(
                        'https://st2.depositphotos.com/1025740/5398/i/950/depositphotos_53989307-stock-photo-profesora.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${widget.incidenciaSeleccionada.profesor.nombre} ${widget.incidenciaSeleccionada.profesor.apellido}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
