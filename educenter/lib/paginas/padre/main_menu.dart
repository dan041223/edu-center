// ignore_for_file: camel_case_types

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/padres_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/paginas/padre/child_profile.dart';
import 'package:educenter/models/alumno.dart';
import 'package:flutter/material.dart';

class main_menu extends StatefulWidget {
  final Widget body;
  const main_menu({
    super.key,
    required this.body,
  });

  @override
  State<main_menu> createState() => _main_menuState();
}

class _main_menuState extends State<main_menu> {
  Alumno? alumnoElegido;
  int numHijos = 0;
  List<Alumno> hijosPadre = List.empty(growable: true);
  bool loading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      hijosPadre = await padresBBDD().getHijosDePadre();
      numHijos = hijosPadre.length;
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Para volver atrás debes cerrar sesión.'),
                SizedBox(width: 10),
                Icon(
                  Icons.logout,
                  color: Colors.black,
                )
              ],
            ),
          ),
        );
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("EduCenter"),
            leading: Container(),
            actions: [
              IconButton(
                  onPressed: () {
                    usersBBDD().signOut(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 26,
                  ))
            ],
          ),
          body: loading
              ? Center(child: CircularProgressIndicator())
              : numHijos == 0
                  ? widget.body
                  : ListView.builder(
                      itemCount: hijosPadre.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: InkWell(
                            onTap: () {
                              AlumnosBBDD()
                                  .getAlumno(hijosPadre[index].id_alumno)
                                  .then((alumno) => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => childProfile(
                                              alumnoElegido: alumno))));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  hijosPadre[index].url_foto_perfil == null
                                      ? Icon(
                                          Icons.person,
                                          size: 80,
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            hijosPadre[index]
                                                .url_foto_perfil
                                                .toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  Text(
                                    "${hijosPadre[index].nombre} ${hijosPadre[index].apellido}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
    );
  }
}
