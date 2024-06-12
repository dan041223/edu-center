import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/agregar_padre.dart';
import 'package:educenter/paginas/admin/padre_panel_admin.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PadresCentroPanel extends StatefulWidget {
  Centro centro;
  PadresCentroPanel({super.key, required this.centro});

  @override
  State<PadresCentroPanel> createState() => _PadresCentroPanelState();
}

class _PadresCentroPanelState extends State<PadresCentroPanel> {
  bool loading = true;
  List<Usuario> listaPadresCentro = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () async {
        listaPadresCentro = await CentroBBDD().getPadresCentro(widget.centro);
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
            builder: (context) => AgregarPadre(centro: widget.centro),
          ));
        },
        child: const Icon(Icons.add),
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
                "Padres del centro",
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
                : listaPadresCentro.isEmpty
                    ? const Center(
                        child: Text("El centro no posee padres registrados"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listaPadresCentro.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PadrePanelAdmin(
                                    padre: listaPadresCentro[index],
                                    centro: widget.centro,
                                  ),
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
                                        child: listaPadresCentro[index]
                                                        .url_foto_perfil !=
                                                    null &&
                                                listaPadresCentro[index]
                                                        .url_foto_perfil !=
                                                    ""
                                            ? Image.network(
                                                listaPadresCentro[index]
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
                                      "${listaPadresCentro[index].nombre} ${listaPadresCentro[index].apellido}",
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
                                            await usersBBDD().deleteUser(
                                                listaPadresCentro[index]
                                                    .id_usuario);
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Usuario eliminado correctamente")));
                                          } catch (e) {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "No se ha podido eliminar ya que posee datos asociados")));
                                          }
                                        } else {}
                                      },
                                      icon: const Icon(
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
