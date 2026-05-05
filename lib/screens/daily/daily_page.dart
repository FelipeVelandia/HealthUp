import 'package:flutter/material.dart';
import 'package:nutrialg_life/services/database_service.dart';

class DailyPage extends StatelessWidget {
  DailyPage({super.key});
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: const Row(
          children: [
            Text(
              'Misiones Diarias',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 9/16
          ),
          itemCount: 3, 
          itemBuilder: (context, int i) {
          return Container (
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: Offset(3, 3)
                )
              ]
            ),
            child: Column(
              children: [
                Image.asset('assets/image5.jpg'),
                Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 52),
                          child: Text(
                            "EJERCICIO",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
