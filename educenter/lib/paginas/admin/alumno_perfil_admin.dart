import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/admin/editar_alumno.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AlumnoPerfilAdmin extends StatefulWidget {
  Alumno alumno;
  Centro centro;
  AlumnoPerfilAdmin({super.key, required this.alumno, required this.centro});

  @override
  State<AlumnoPerfilAdmin> createState() => _AlumnoPerfilAdminState();
}

class _AlumnoPerfilAdminState extends State<AlumnoPerfilAdmin> {
  List<ValueItem> listaItems = List.empty(growable: true);
  List<Usuario> padresCentroNoDeAlumno = List.empty(growable: true);
  List<Usuario> padresSeleccionados = List.empty(growable: true);
  bool modoAgregarPadres = false;
  Usuario? user;
  List<Usuario> padresAlumno = List.empty(growable: true);
  bool loading = true;
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        user = await usersBBDD().getUsuario();
        padresAlumno = await AlumnosBBDD().getPadresDeAlumno(widget.alumno);
        padresCentroNoDeAlumno =
            await CentroBBDD().getPadresCentro(widget.centro);

        padresCentroNoDeAlumno.removeWhere((element) => padresAlumno
            .map((padre) => padre.id_usuario)
            .contains(element.id_usuario));

        padresCentroNoDeAlumno.forEach((padre) {
          listaItems.add(ValueItem(
              value: padre, label: "${padre.nombre} ${padre.apellido}"));
        });
        setState(() {
          loading = false;
        });
        print("object");
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
            builder: (context) => EditarAlumno(
              alumno: widget.alumno,
              centro: widget.centro,
            ),
          ));
        },
        child: Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: esOscuro ? Colors.white : Colors.black12,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget.alumno.url_foto_perfil != null
                              ? Image.network(
                                  widget.alumno.url_foto_perfil!.toString(),
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.person,
                                  color: Colors.black, size: 80)),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                          "${widget.alumno.nombre} ${widget.alumno.apellido}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: esOscuro ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Padres del alumno",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    modoAgregarPadres
                                        ? modoAgregarPadres = false
                                        : modoAgregarPadres = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.person_add,
                                  color: Colors.green,
                                ))
                      ],
                    ),
                    Divider(
                      height: 10,
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : !modoAgregarPadres
                            ? padresAlumno.isEmpty
                                ? Text(
                                    "Este alumno no tiene padres registrados")
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: padresAlumno.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: padresAlumno[index]
                                                                .url_foto_perfil !=
                                                            null &&
                                                        padresAlumno[index]
                                                                .url_foto_perfil !=
                                                            ""
                                                    ? Image.network(
                                                        padresAlumno[index]
                                                            .url_foto_perfil!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const Icon(
                                                        Icons.person,
                                                      )),
                                            Text(
                                              padresAlumno[index].nombre,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                            : Column(
                                children: [
                                  Text(
                                    "Agregar padres a ${widget.alumno.nombre}:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  padresCentroNoDeAlumno.isEmpty
                                      ? Center(
                                          child: Text(
                                              "No quedan más padres que no sean los de ${widget.alumno.nombre}"),
                                        )
                                      : MultiSelectDropDown(
                                          hint: "Padres...",
                                          fieldBackgroundColor:
                                              Utils.hexToColor("#1c272b"),
                                          dropdownBackgroundColor:
                                              Utils.hexToColor("#1c272b"),
                                          optionsBackgroundColor:
                                              Utils.hexToColor("#1c272b"),
                                          options: listaItems,
                                          onOptionSelected: (value) {
                                            listaItems = value;
                                            padresSeleccionados = value
                                                .map((e) => e.value as Usuario)
                                                .toList();
                                          },
                                        ),
                                  padresCentroNoDeAlumno.isEmpty
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  padresSeleccionados.isEmpty
                                                      ? ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Sin nuevos padres seleccionados")))
                                                      : AlumnosBBDD()
                                                          .agregarPadres(
                                                              padresSeleccionados,
                                                              widget.alumno);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Padres agregados")),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                    Text(" Confirmar cambios")
                                                  ],
                                                ))
                                          ],
                                        )
                                ],
                              )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
