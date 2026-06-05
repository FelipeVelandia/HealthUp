import 'package:flutter/material.dart';

// Notificador para los puntos del nivel actual
final ValueNotifier<int> globalPointsNotifier = ValueNotifier<int>(0);

// Nuevo notificador para las recompensas acumuladas totales
final ValueNotifier<int> globalRewardsNotifier = ValueNotifier<int>(0);
