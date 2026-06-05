import 'package:flutter/material.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DatabaseService>(context).user;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FutureBuilder(
              future: Future.wait([
                firestore.getLunes(user!.uid),
                SharedPreferences.getInstance()
              ]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const Text('no data');
                  } else {
                    switch (snapshot.data[1].getString('Label')) {
                      case 'desayuno':
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 218, 215),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            snapshot.data[0].desayuno[snapshot
                                                .data[1]
                                                .getInt('Index')]['titulo'],
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(3, 3),
                                                    blurRadius: 5)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    'Composicion Nutricional',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Humedad (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].desayuno[snapshot.data[1].getInt('Index')]['humedad']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kcal) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].desayuno[snapshot.data[1].getInt('Index')]['energiac']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kj) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].desayuno[snapshot.data[1].getInt('Index')]['energiaj']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Proteina (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].desayuno[snapshot.data[1].getInt('Index')]['proteina']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Lipidos (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].desayuno[snapshot.data[1].getInt('Index')]['lipidos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Carbohidratos Totales (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].desayuno[snapshot.data[1].getInt('Index')]['carbohidratos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      case 'media':
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 218, 215),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            snapshot.data[0].media[snapshot
                                                .data[1]
                                                .getInt('Index')]['titulo'],
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(3, 3),
                                                    blurRadius: 5)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    'Composicion Nutricional',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                               RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Humedad (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].media[snapshot.data[1].getInt('Index')]['humedad']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kcal) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].media[snapshot.data[1].getInt('Index')]['energiac']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kj) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].media[snapshot.data[1].getInt('Index')]['energiaj']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Proteina (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].media[snapshot.data[1].getInt('Index')]['proteina']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Lipidos (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].media[snapshot.data[1].getInt('Index')]['lipidos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Carbohidratos Totales (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].media[snapshot.data[1].getInt('Index')]['carbohidratos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      case 'almuerzo':
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 218, 215),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            snapshot.data[0].almuerzo[snapshot
                                                .data[1]
                                                .getInt('Index')]['titulo'],
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(3, 3),
                                                    blurRadius: 5)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    'Composicion Nutricional',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Humedad (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].almuerzo[snapshot.data[1].getInt('Index')]['humedad']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kcal) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].almuerzo[snapshot.data[1].getInt('Index')]['energiac']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kj) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].almuerzo[snapshot.data[1].getInt('Index')]['energiaj']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Proteina (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].almuerzo[snapshot.data[1].getInt('Index')]['proteina']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Lipidos (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].almuerzo[snapshot.data[1].getInt('Index')]['lipidos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Carbohidratos Totales (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].almuerzo[snapshot.data[1].getInt('Index')]['carbohidratos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      case 'merienda':
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 218, 215),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            snapshot.data[0].merienda[snapshot
                                                .data[1]
                                                .getInt('Index')]['titulo'],
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(3, 3),
                                                    blurRadius: 5)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    'Composicion Nutricional',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Humedad (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].merienda[snapshot.data[1].getInt('Index')]['humedad']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kcal) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].merienda[snapshot.data[1].getInt('Index')]['energiac']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kj) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].merienda[snapshot.data[1].getInt('Index')]['energiaj']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Proteina (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].merienda[snapshot.data[1].getInt('Index')]['proteina']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Lipidos (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].merienda[snapshot.data[1].getInt('Index')]['lipidos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Carbohidratos Totales (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].merienda[snapshot.data[1].getInt('Index')]['carbohidratos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      case 'cena':
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 218, 215),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            snapshot.data[0].cena[snapshot
                                                .data[1]
                                                .getInt('Index')]['titulo'],
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(3, 3),
                                                    blurRadius: 5)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    'Composicion Nutricional',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Humedad (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].cena[snapshot.data[1].getInt('Index')]['humedad']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kcal) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].cena[snapshot.data[1].getInt('Index')]['energiac']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Energia (Kj) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].cena[snapshot.data[1].getInt('Index')]['energiaj']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Proteina (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].cena[snapshot.data[1].getInt('Index')]['proteina']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Lipidos (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].cena[snapshot.data[1].getInt('Index')]['lipidos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Carbohidratos Totales (g) : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${snapshot.data[0].cena[snapshot.data[1].getInt('Index')]['carbohidratos']}',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      default:
                        return const Text('Error');
                    }
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text('Loading');
                } else {
                  return const Text('Error');
                }
              })),
    );
  }
}
