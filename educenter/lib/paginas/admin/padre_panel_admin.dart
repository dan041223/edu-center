import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/padres_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/editar_padre.dart';
import 'package:flutter/material.dart';

class PadrePanelAdmin extends StatefulWidget {
  Centro centro;
  Usuario padre;
  PadrePanelAdmin({super.key, required this.padre, required this.centro});

  @override
  State<PadrePanelAdmin> createState() => _PadrePanelAdminState();
}

class _PadrePanelAdminState extends State<PadrePanelAdmin> {
  List<Alumno> hijosPadre = List.empty(growable: true);
  bool loading = true;
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        hijosPadre = await padresBBDD().getHijosDePadre(widget.padre);
        if (!mounted) {
          return;
        }
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
            builder: (context) => EditarPadre(
              padre: widget.padre,
              centro: widget.centro,
            ),
          ));
        },
        child: Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
                            child: widget.padre.url_foto_perfil != null &&
                                    widget.padre.url_foto_perfil != ""
                                ? Image.network(
                                    widget.padre.url_foto_perfil!,
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
                            "${widget.padre.nombre} ${widget.padre.apellido}",
                            style: TextStyle(
                              color: esOscuro ? Colors.black : Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                "Hijos de este padre/madre:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 20,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : hijosPadre.isEmpty
                      ? Center(
                          child: Text(
                            "${widget.padre.nombre} no tiene hijos registrados",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: hijosPadre.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) => AlumnoPerfilAdmin(
                                  //     alumno: hijosPadre[index],
                                  //     centro: widget.centro,
                                  //   ),
                                  // ));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          child: hijosPadre[index]
                                                          .url_foto_perfil !=
                                                      null &&
                                                  hijosPadre[index]
                                                          .url_foto_perfil !=
                                                      ""
                                              ? Image.network(
                                                  hijosPadre[index]
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
                                        "${hijosPadre[index].nombre} ${hijosPadre[index].apellido}",
                                        style: TextStyle(
                                          color: esOscuro
                                              ? Colors.white
                                              : Colors.black,
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
                                              textCancel:
                                                  const Text("Mantener"),
                                              textOK: const Text("Eliminar"),
                                              content: Container())) {
                                            try {
                                              await AlumnosBBDD().deleteAlumno(
                                                  hijosPadre[index].id_alumno);
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
      ),
    );
  }
}
