import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CrearAsignatura extends StatefulWidget {
  Centro centro;
  Clase clase;
  CrearAsignatura({super.key, required this.clase, required this.centro});

  @override
  State<CrearAsignatura> createState() => _CrearAsignaturaState();
}

class _CrearAsignaturaState extends State<CrearAsignatura> {
  bool loading = true;
  List<Usuario> profesoresCentro = List.empty(growable: true);
  List<DropdownMenuItem> items = List.empty(growable: true);
  Usuario? profeSeleccionado;
  Color color = Colors.lightBlue;
  String colorSeleccionado = "";
  TextEditingController controllerNombreAsignatura = TextEditingController();
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        profesoresCentro =
            await CentroBBDD().getProfesoresCentro(widget.centro);
        print("AAAAAAAAAAAAAAAAAAA");
        profesoresCentro.forEach((profesor) {
          items.add(DropdownMenuItem(
            child: Text("${profesor.nombre} ${profesor.apellido}"),
            value: profesor,
          ));
        });
        print(items);
        setState(() {
          loading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Crear asignatura",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controllerNombreAsignatura,
                decoration: const InputDecoration(
                    label: Text(
                  "Nombre de la asignatura*",
                )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text(
                  "Profesor que la imparte:*",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              loading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: DropdownButton(
                          isExpanded: true,
                          hint: const Text("Profesores"),
                          value: profeSeleccionado,
                          items: items,
                          onChanged: (profe) {
                            setState(() {
                              profeSeleccionado = profe;
                            });
                          }),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text(
                  "Selector de color:*",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ColorPicker(
                    pickerColor: color,
                    onColorChanged: (value) {
                      setState(() {
                        color = value;
                        colorSeleccionado = Utils.colorToString(color);
                      });
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? Container()
                      : TextButton(
                          onPressed: () {
                            comprobarCampos(controllerNombreAsignatura.text,
                                profeSeleccionado, color, context);
                          },
                          child: const Text("Crear asignatura")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(String nombreAsignatura, Usuario? profesor,
      Color colorSeleccionado, BuildContext context) async {
    if (nombreAsignatura.isEmpty || profesor == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ClasesBBDD().crearAsignatura(nombreAsignatura, profesor,
          Utils.colorToString(colorSeleccionado), widget.clase);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Asignatura creada")));
    }
  }
}
