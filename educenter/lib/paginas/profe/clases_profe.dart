import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/paginas/profe/asignaturas_clase_panel.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class ClasesProfe extends StatefulWidget {
  Usuario profe;
  ClasesProfe({super.key, required this.profe});

  @override
  State<ClasesProfe> createState() => _ClasesProfeState();
}

class _ClasesProfeState extends State<ClasesProfe> {
  // lista de asignaturas que imparte este profe
  List<Clase>? clases;
  List<Asignatura>? asignaturas;
  bool loading = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      clases = await ProfesoresBBDD().getClasesProfesor(widget.profe);
      if (clases == null) return;
      asignaturas = List.empty(growable: true);
      for (Clase clase in clases!) {
        List<Asignatura> asignaturasPorClase;
        asignaturasPorClase =
            await ClasesBBDD().getAsignaturasClase(clase.id_clase);
        asignaturas!.addAll(asignaturasPorClase.where(
            (element) => element.id_profesor == widget.profe.id_usuario));
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clases")),
      body: clases == null
          ? const Center(child: CircularProgressIndicator())
          : clases!.isEmpty
              ? const Center(child: Text("No tienes clases asignadas"))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clases!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AsignaturasClase(
                                    clase: clases![index],
                                    asignaturas: asignaturas!
                                        .where((element) =>
                                            element.id_clase ==
                                            clases![index].id_clase)
                                        .toList())));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  clases![index].nombre_clase,
                                  style: const TextStyle(fontSize: 35),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
