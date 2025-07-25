import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool _onBoard = true;

  //* Getter para el usuario actual
  User? get user => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;
  bool get onBoard => _onBoard;

  //* Sign in
  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners(); // Notifica cambios a los listeners
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? "Error de inicio de sesión."),
          showCloseIcon: true,
        ));
      }
    }
  }

  //* Register
  Future<void> signUp(
      BuildContext context, String password, Paciente paciente) async {
    try {
      // Crear el usuario con correo y contraseña
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: paciente.email!, password: password);

      // Obtener el ID del usuario recién creado
      String userId = userCredential.user?.uid ?? '';

      // Guardar ID Usuario
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("UserID", userId);

      // Verificar si el userId es válido antes de insertar los datos
      if (userId.isNotEmpty) {
        // Crear los datos del paciente que se insertarán en Firestore
        Map<String, dynamic> data = paciente.toJson();

        // Insertar los datos del usuario en Firestore
        await _firestore.collection('pacientes').doc(userId).set(data);

        // Comlpetar Initial Survey
        _onBoard = false;

        // Notificar que los datos han sido guardados
        notifyListeners();

        // Regresando a la página principal
        if (context.mounted) {
          context.go("/progress");
        }
      } else {
        throw Exception('Error al obtener el ID del usuario');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? "Error al registrarse."),
          showCloseIcon: true,
        ));
      }
    } catch (e) {
      // Capturar errores no relacionados con FirebaseAuth
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error inesperado: $e'),
          showCloseIcon: true,
        ));
      }
    }
  }

  //* Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  //* Register Antecedente

  Future<void> initial(
      BuildContext context, Antecedentes antecedentes, Habito habitos) async {

        Map<String, dynamic> dataAnt = antecedentes.toJson();
        Map<String, dynamic> dataHab = habitos.toJson();

        // Obtener ID Usuario
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String? userId = prefs.getString("UserID");

        // Insertar los datos del usuario en Firestore
        await _firestore.collection('antecedentes').doc(userId).set(dataAnt);
        await _firestore.collection('habitos').doc(userId).set(dataHab);

        // Comlpetar Initial Survey
        _onBoard = true;

        // Regresando a la página principal
        if (context.mounted) {
          context.go("/progress");
        }

        // Notificar que se ha completado la survey
        notifyListeners();
  }

  Future<Dieta> getDieta (String id) async{
    var snap = await _firestore.collection('dietas').doc(id).get();

    return Dieta.fromMap(snap.data());
  }

  Future<Plan> getLunes (String id) async{
    var snap = await _firestore.collection('dietas').doc(id).collection('plan').doc('lun').get();

    return Plan.fromMap(snap.data());
  }
}
