// ignore_for_file: prefer_const_constructors

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/crear_asignatura.dart';
import 'package:educenter/paginas/profe/clase_asignatura.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AsignaturasClase extends StatefulWidget {
  Centro? centro;
  Usuario? user;
  Clase clase;
  List<Asignatura> asignaturas;
  AsignaturasClase(
      {super.key,
      required this.clase,
      required this.asignaturas,
      this.user,
      this.centro});

  @override
  State<AsignaturasClase> createState() => AasignaturasClaseState();
}

class AasignaturasClaseState extends State<AsignaturasClase> {
  bool loading = true;
  Usuario? user;
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        user = await usersBBDD().getUsuario();
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
      appBar: AppBar(
        title: const Text("Asignaturas"),
      ),
      floatingActionButton: loading
          ? Container()
          : user!.tipo_usuario == "administrador"
              ? FloatingActionButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CrearAsignatura(
                        clase: widget.clase,
                        centro: widget.centro!,
                      ),
                    ));
                  },
                  child: Icon(Icons.add),
                )
              : Container(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Asignaturas de ${widget.clase.nombre_clase}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Divider(
            color: Colors.black,
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Scrollbar(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.asignaturas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Utils.hexToColor(
                          widget.asignaturas[index].color_codigo),
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ClaseAsignatura(
                                      centro: widget.centro,
                                      usuario: widget.user,
                                      asignatura: widget.asignaturas[index],
                                      clase: widget.clase,
                                    )));
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    widget.asignaturas[index].nombre_asignatura,
                                    style: const TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                user != null
                                    ? user!.tipo_usuario == "administrador"
                                        ? IconButton(
                                            onPressed: () async {
                                              if (await confirm(context,
                                                  title: const Text(
                                                      "¿Estas seguro de querer borrar esta asignatura?"),
                                                  textCancel:
                                                      const Text("Mantener"),
                                                  textOK:
                                                      const Text("Eliminar"),
                                                  content: Container())) {
                                                try {
                                                  await ClasesBBDD()
                                                      .deleteAsignatura(widget
                                                          .asignaturas[index]);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Asignatura eliminada correctamente")));
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
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                        : Container()
                                    : Container()
                              ])),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
