// import 'package:educenter/main_menu.dart';
// import 'package:flutter/material.dart';

// class DrawerMio extends StatefulWidget {
//   const DrawerMio({super.key});

//   @override
//   State<DrawerMio> createState() => _DrawerMioState();
// }

// class _DrawerMioState extends State<DrawerMio> {
//   @override
//   Widget build(BuildContext context) {
//     return 
//     Drawer(
//       child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text('Bienvenido'),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home_outlined),
//               title: const Text("Casa"),
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const main_menu(
//                     body: Center(
//                       child: Text("No tienes hijos"),
//                     ),
//                   ),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.add_reaction_outlined),
//               title: const Text("Hijos"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.calendar_month_outlined),
//               title: const Text("Calendario"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.home_work_outlined),
//               title: const Text("Centro educativo"),
//               onTap: () {},
//             ),
//           ]),
//     );
//   }
// }
