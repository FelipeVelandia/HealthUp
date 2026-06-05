import 'package:flutter/material.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DatabaseService>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 32),
                      _buildProfileInfoCard(context, snapshot),
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              } else {
                return const Text('Error');
              }
            }),
      ),
    );
  }

  Widget _buildProfileInfoCard(BuildContext context, AsyncSnapshot snapshot) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.badge, 'Documento', snapshot.data.documento),
            const Divider(),
            _buildInfoRow(
                Icons.person_outline, 'Nombre Completo', snapshot.data.nombre),
            const Divider(),
            _buildInfoRow(
                Icons.cake, 'Fecha de Nacimiento', snapshot.data.fecha),
            const Divider(),
            _buildInfoRow(Icons.phone, 'Teléfono', snapshot.data.telefono),
            const Divider(),
            _buildInfoRow(Icons.wc, 'Género', snapshot.data.genero),
            const Divider(),
            _buildInfoRow(
                Icons.email, 'Correo Electrónico', snapshot.data.email),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      // Column para mejor legibilidad en pantallas pequeñas
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
