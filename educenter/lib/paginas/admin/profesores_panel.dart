import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/padre/profesor_panel.dart';
import 'package:educenter/paginas/profe/crear_profesor.dart';
import 'package:flutter/material.dart';

class ProfesoresPanel extends StatefulWidget {
  Centro centro;
  ProfesoresPanel({super.key, required this.centro});

  @override
  State<ProfesoresPanel> createState() => _ProfesoresPanelState();
}

class _ProfesoresPanelState extends State<ProfesoresPanel> {
  Usuario? admin;
  bool loading = true;
  List<Usuario> profesoresCentro = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        admin = await usersBBDD().getUsuario();
        profesoresCentro =
            await CentroBBDD().getProfesoresCentro(widget.centro);
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
            builder: (context) => CrearProfesor(
              centro: widget.centro,
            ),
          ));
        },
        child: Icon(Icons.person_add_alt_1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: esOscuro ? Colors.white : Colors.black12,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(25),
              child: Text(
                "Profesores del centro",
                style: TextStyle(
                  color: esOscuro ? Colors.black : Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : profesoresCentro.isEmpty
                    ? Center(
                        child: Text("El centro no posee profesores"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: profesoresCentro.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfesorPanel(
                                      centro: widget.centro,
                                      admin: admin,
                                      profesor: profesoresCentro[index]),
                                ));
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
                                        child: profesoresCentro[index]
                                                        .url_foto_perfil !=
                                                    null &&
                                                profesoresCentro[index]
                                                        .url_foto_perfil !=
                                                    ""
                                            ? Image.network(
                                                profesoresCentro[index]
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
                                      "${profesoresCentro[index].nombre} ${profesoresCentro[index].apellido}",
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
                                                "¿Estas seguro de querer borrar este usuario?"),
                                            textCancel: const Text("Mantener"),
                                            textOK: const Text("Eliminar"),
                                            content: Container())) {
                                          try {
                                            print("HOLAA");
                                            await usersBBDD().deleteUser(
                                                profesoresCentro[index]
                                                    .id_usuario);
                                            print("ADIOS");
                                          } catch (e) {
                                            print("ERROR: " + e.toString());
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
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
