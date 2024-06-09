import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/clases_panel.dart';
import 'package:educenter/paginas/admin/padres_centro_panel.dart';
import 'package:educenter/paginas/admin/profesores_panel.dart';
import 'package:educenter/paginas/padre/centro_panel.dart';
import 'package:flutter/material.dart';

class MainMenuAdmin extends StatefulWidget {
  const MainMenuAdmin({super.key});

  @override
  State<MainMenuAdmin> createState() => _MainMenuAdminState();
}

class _MainMenuAdminState extends State<MainMenuAdmin> {
  Usuario? user;
  bool loading = true;
  late Centro centro;
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        user = await usersBBDD().getUsuario();
        centro = await CentroBBDD().getMiCentro();
        setState(() {
          loading = false;
        });
      },
    );
    super.initState();
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
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                            builder: (context) => ProfesoresPanel(
                              centro: centro,
                            ),
                          ));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.person,
                              size: 75,
                            ),
                            Text(
                              "Profesores",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PadresCentroPanel(
                              centro: centro,
                            ),
                          ));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.person,
                              size: 75,
                            ),
                            Text(
                              "Padres",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ClasesPanel(
                              centro: centro,
                            ),
                          ));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.abc,
                              size: 75,
                            ),
                            Text(
                              "Clases",
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CentroPanel(
                              user: user,
                              centro: centro,
                            ),
                          ));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 75,
                            ),
                            Text(
                              "Centro",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
