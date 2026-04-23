import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';

class ProgressPage extends StatelessWidget {
  ProgressPage({super.key});
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DatabaseService>(context).user;
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder(
                future: firestore.getPaciente(user!.uid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: const Center(
                          child: Text("Sin datos de usuario"),
                        ),
                      );
                    } else {
                      return Text(snapshot.data.nombre);
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })));
  }
}
