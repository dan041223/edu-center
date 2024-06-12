import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/paginas/admin/clase_panel.dart';
import 'package:educenter/paginas/admin/crear_clase.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
      const Duration(milliseconds: 1),
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
      appBar: AppBar(
        title: const Text('Panel de Clases'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CrearClase(centro: widget.centro),
          ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: esOscuro ? Colors.white : Colors.blue.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(25),
              child: Text(
                "Clases del centro",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: esOscuro ? Colors.black : Colors.blue,
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clasesCentro.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ClasePanel(
                                  clase: clasesCentro[index],
                                  centro: widget.centro,
                                ),
                              ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  clasesCentro[index].nombre_clase,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (await confirm(
                                      context,
                                      title: const Text(
                                          "¿Estas seguro de querer borrar esta clase?"),
                                      textCancel: const Text("Mantener"),
                                      textOK: const Text("Eliminar"),
                                      content: Container(),
                                    )) {
                                      try {
                                        await ClasesBBDD()
                                            .deleteClase(clasesCentro[index]);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Clase eliminada correctamente"),
                                          ),
                                        );
                                        setState(() {
                                          clasesCentro.removeAt(index);
                                        });
                                      } catch (e) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "No se ha podido eliminar ya que posee datos asociados"),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
