import 'package:flutter/material.dart';

ThemeData getTheme() {
  ColorScheme scheme = ColorScheme.fromSeed(seedColor: Colors.redAccent);
  return ThemeData(
    colorScheme: scheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    searchBarTheme: const SearchBarThemeData(
      elevation: MaterialStatePropertyAll(1),
    ),
    searchViewTheme: const SearchViewThemeData(elevation: 1.5),
  );
}
