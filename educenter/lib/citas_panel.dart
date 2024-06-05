import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/cita_panel.dart';
import 'package:educenter/crear_cita.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/cita.dart';
import 'package:flutter/material.dart';

class CitasPanel extends StatefulWidget {
  Alumno alumno;
  CitasPanel({super.key, required this.alumno});

  @override
  State<CitasPanel> createState() => _CitasPanelState();
}

List<Cita> getCitasProximas(List<Cita> citasHijo) {
  List<Cita> listaCitasProximas = List.empty(growable: true);

  for (var cita in citasHijo) {
    if (cita.fecha_padre != null &&
        cita.fecha_padre == cita.fecha_tutor &&
        cita.fecha_padre!.isAfter(DateTime.now())) {
      listaCitasProximas.add(cita);
    }
  }
  return listaCitasProximas;
}

List<Cita> getCitasPasadas(List<Cita> citasHijo) {
  List<Cita> listaCitasPasadas = List.empty(growable: true);

  for (var cita in citasHijo) {
    if (cita.fecha_padre != null &&
        cita.fecha_padre == cita.fecha_tutor &&
        cita.fecha_padre!.isBefore(DateTime.now())) {
      listaCitasPasadas.add(cita);
    }
  }
  return listaCitasPasadas;
}

List<Cita> getCitasNoConfirmadas(List<Cita> citasHijo) {
  List<Cita> listaCitasNoConfirmadas = List.empty(growable: true);

  for (var cita in citasHijo) {
    if (cita.fecha_padre != cita.fecha_tutor && cita.fecha_padre == null ||
        cita.fecha_tutor == null) {
      listaCitasNoConfirmadas.add(cita);
    }
  }
  return listaCitasNoConfirmadas;
}

class _CitasPanelState extends State<CitasPanel> {
  List<Cita> citasHijo = List.empty(growable: true);
  List<Cita> citasHijoProximas = List.empty(growable: true);
  List<Cita> citasHijoPasadas = List.empty(growable: true);
  List<Cita> citasHijoNoConfirmadas = List.empty(growable: true);
  bool loading = true;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      citasHijo = await AlumnosBBDD().getCitasAlumno(widget.alumno);
      citasHijoProximas = getCitasProximas(citasHijo);
      citasHijoPasadas = getCitasPasadas(citasHijo);
      citasHijoNoConfirmadas = getCitasNoConfirmadas(citasHijo);
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: esOscuro ? Colors.white : Colors.black12,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.all(10),
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
                      child: Image.network(
                        widget.alumno.url_foto_perfil.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        "Citas de ${widget.alumno.nombre} ${widget.alumno.apellido}",
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "No confirmadas:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : citasHijoNoConfirmadas.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: citasHijoNoConfirmadas.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => CitaPanel(
                                                  citaSeleccionada:
                                                      citasHijoNoConfirmadas[
                                                          index])));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                              Icons.watch_later_outlined),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(citasHijoNoConfirmadas[index]
                                              .titulo),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text(
                              "${widget.alumno.nombre} no tiene citas por confirmar.",
                            ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Proximas:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  loading
                      ? Center(child: CircularProgressIndicator())
                      : citasHijoProximas.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: citasHijoProximas.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => CitaPanel(
                                                  citaSeleccionada:
                                                      citasHijoProximas[
                                                          index])));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timelapse_outlined),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(citasHijoProximas[index].titulo),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text(
                              "${widget.alumno.nombre} no tiene citas próximas.",
                            ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Pasadas:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  loading
                      ? Center(child: CircularProgressIndicator())
                      : citasHijoPasadas.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: citasHijoPasadas.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => CitaPanel(
                                                  citaSeleccionada:
                                                      citasHijoPasadas[
                                                          index])));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.history_toggle_off_sharp),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(citasHijoPasadas[index].titulo),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text(
                              "${widget.alumno.nombre} no tiene citas pasadas.",
                            ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CrearCita(
                    alumno: widget.alumno,
                  )));
        },
      ),
    );
  }
}
