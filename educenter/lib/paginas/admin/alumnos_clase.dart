import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/paginas/admin/alumno_perfil_admin.dart';
import 'package:educenter/paginas/admin/crear_alumno.dart';
import 'package:educenter/paginas/profe/alumno_perfil.dart';
import 'package:flutter/material.dart';

class AlumnosClase extends StatefulWidget {
  Centro centro;
  Clase clase;
  AlumnosClase({super.key, required this.clase, required this.centro});

  @override
  State<AlumnosClase> createState() => _AlumnosClaseState();
}

class _AlumnosClaseState extends State<AlumnosClase> {
  bool loading = true;
  List<Alumno> alumnosClase = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        alumnosClase = await AlumnosBBDD().getAlumnosClase(widget.clase);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CrearAlumno(
              clase: widget.clase,
            ),
          ));
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: alumnosClase.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AlumnoPerfilAdmin(
                                alumno: alumnosClase[index],
                                centro: widget.centro,
                              ),
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child:
                                        alumnosClase[index].url_foto_perfil !=
                                                    null &&
                                                alumnosClase[index]
                                                        .url_foto_perfil !=
                                                    ""
                                            ? Image.network(
                                                alumnosClase[index]
                                                    .url_foto_perfil!,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.person,
                                              )),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text(
                                  "${alumnosClase[index].nombre} ${alumnosClase[index].apellido}",
                                  style: TextStyle(
                                    color:
                                        esOscuro ? Colors.white : Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    if (await confirm(context,
                                        title: const Text(
                                            "¿Estas seguro de querer borrar este alumno?"),
                                        textCancel: const Text("Mantener"),
                                        textOK: const Text("Eliminar"),
                                        content: Container())) {
                                      try {
                                        await AlumnosBBDD().deleteAlumno(
                                            alumnosClase[index].id_alumno);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Alumno eliminado correctamente")));
                                      } catch (e) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "No se ha podido eliminar ya que posee datos asociados")));
                                      }
                                    } else {}
                                  },
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    size: 30,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
