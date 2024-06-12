import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/citas_panel.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/calendario.dart';
import 'package:educenter/paginas/profe/clases_profe.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainMenuProfe extends StatefulWidget {
  Usuario profe;
  MainMenuProfe({super.key, required this.profe});

  @override
  State<MainMenuProfe> createState() => _MainMenuProfeState();
}

class _MainMenuProfeState extends State<MainMenuProfe> {
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: widget.profe.url_foto_perfil != null &&
                              widget.profe.url_foto_perfil!.isNotEmpty
                          ? Image.network(
                              widget.profe.url_foto_perfil.toString(),
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 80,
                            )),
                  Text(
                    "${widget.profe.nombre} ${widget.profe.apellido}",
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
              const Divider(height: 20),
              GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  botonMenuProfe("Clases", Icons.abc, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ClasesProfe(profe: widget.profe)));
                  }, Colors.amber),
                  botonMenuProfe("Calendario", Icons.calendar_month_outlined,
                      () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Calendario(
                              profe: widget.profe,
                            )));
                  }, Colors.red),
                  botonMenuProfe("Citas", Icons.ballot_outlined, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CitasPanel(tutor: widget.profe)));
                  }, Colors.purple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Card botonMenuProfe(String texto, IconData icono, Function onClick,
    [Color? color]) {
  return Card(
    color: color,
    elevation: 0.2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: InkWell(
      onTap: () {
        onClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              icono,
              size: 40,
            ),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
