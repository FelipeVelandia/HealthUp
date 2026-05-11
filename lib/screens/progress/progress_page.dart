import 'package:flutter/material.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'widgets/exam_card.dart';
import 'package:go_router/go_router.dart';

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
                      return Scaffold(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          appBar: AppBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface),
                          body: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("!Hola ${snapshot.data.nombre}!",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                const Text("Bienvenido de vuelta, revisa tu progreso",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                const SizedBox(height: 25),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: 0.45,
                                        strokeWidth: 8,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 25),
                                ExamCard(
                                  description: "Formulario de antecedentes",
                                  completed: false,
                                  onTap: () =>
                                      GoRouter.of(context).push("/initial"),
                                ),
                                const SizedBox(height: 25),
                                ExamCard(
                                  description: "Misiones Diarias",
                                  completed: false,
                                  onTap: () =>
                                      GoRouter.of(context).push("/daily"),
                                ),
                              ],
                            ),
                          ));
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
