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
                                const SizedBox(height: 25),
                                const LinearProgressIndicator(value: 0.7),
                                const SizedBox(height: 25),
                                ExamCard(
                                  description: "Recomendaciones Universales",
                                  completed: false,
                                  onTap: () =>
                                      GoRouter.of(context).push("/initial"),
                                ),
                                const SizedBox(height: 25),
                                ExamCard(
                                  description: "Misiones Diarias",
                                  completed: false,
                                  onTap: () =>
                                      GoRouter.of(context).push("/initial"),
                                ),
                                const SizedBox(height: 35),
                                const Text(
                                    "El ejercicio es muy importante, acá te recomiendo algunos ejercicios que puedes realizar:",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Image.network('https://a.storyblok.com/f/97382/2000x1500/4c15e1224b/cover-benefits-of-yoga-and-meditation.png', width: 100),
                                    Image.network('https://a.storyblok.com/f/97382/2000x1500/4c15e1224b/cover-benefits-of-yoga-and-meditation.png', width: 100),
                                    Image.network('https://a.storyblok.com/f/97382/2000x1500/4c15e1224b/cover-benefits-of-yoga-and-meditation.png', width: 100),
                                  ],
                                )
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
