import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/models/models.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //* Getter para el usuario actual
  User? get user => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

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

      // Verificar si el userId es válido antes de insertar los datos
      if (userId.isNotEmpty) {
        // Crear los datos del paciente que se insertarán en Firestore
        Map<String, dynamic> data = paciente.toJson();

        // Insertar los datos del usuario en Firestore
        await _firestore.collection('paciente').doc(userId).set(data);

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
}
