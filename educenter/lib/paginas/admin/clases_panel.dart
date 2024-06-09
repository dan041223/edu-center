import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';

class ClasesPanel extends StatefulWidget {
  Centro centro;
  ClasesPanel({super.key, required this.centro});

  @override
  State<ClasesPanel> createState() => _ClasesPanelState();
}

class _ClasesPanelState extends State<ClasesPanel> {
  bool loading = true;
  List<Clase> clasesCentro = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        clasesCentro = await CentroBBDD().getClasesCentro(widget.centro);
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
        onPressed: () {},
        child: Icon(Icons.add),
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
              "Clases del centro",
              style: TextStyle(
                color: esOscuro ? Colors.black : Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: clasesCentro.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(clasesCentro[index].nombre_clase),
                            IconButton(
                                onPressed: () async {
                                  if (await confirm(context,
                                      title: const Text(
                                          "¿Estas seguro de querer borrar esta clase?"),
                                      textCancel: const Text("Mantener"),
                                      textOK: const Text("Eliminar"),
                                      content: Container())) {
                                    try {} catch (e) {
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      )),
    );
  }
}
