import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/alumnos_clase.dart';
import 'package:educenter/paginas/admin/editar_clase.dart';
import 'package:educenter/paginas/profe/asignaturas_clase_panel.dart';
import 'package:flutter/material.dart';

class ClasePanel extends StatefulWidget {
  Clase clase;
  Centro centro;
  ClasePanel({super.key, required this.clase, required this.centro});

  @override
  State<ClasePanel> createState() => _ClasePanelState();
}

class _ClasePanelState extends State<ClasePanel> {
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
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditarClase(
                    centro: widget.centro,
                    clase: widget.clase,
                  )));
        },
        child: Icon(Icons.edit),
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
                widget.clase.nombre_clase,
                style: TextStyle(
                  color: esOscuro ? Colors.black : Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                children: [
                  Card(
                    color: Colors.amber,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AlumnosClase(
                            clase: widget.clase,
                            centro: widget.centro,
                          ),
                        ));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => ProfesoresPanel(
                        //     centro: widget.centro,
                        //   ),
                        // ));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.person,
                            size: 75,
                          ),
                          Text(
                            "Alumnos",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.red,
                    child: InkWell(
                      onTap: () async {
                        await ClasesBBDD()
                            .getAsignaturasClase(widget.clase.id_clase)
                            .then((asignaturas) =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AsignaturasClase(
                                    user: user,
                                    centro: widget.centro,
                                    asignaturas: asignaturas,
                                    clase: widget.clase,
                                  ),
                                )));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.book,
                            size: 75,
                          ),
                          Text(
                            "Asignaturas",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => CentroPanel(
                        //     centro: centro,
                        //   ),
                        // ));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            size: 75,
                          ),
                          Text(
                            "Horario",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
