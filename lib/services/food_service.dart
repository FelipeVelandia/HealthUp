import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/food_item.dart';

class FoodService {
  static Future<List<FoodItem>> loadFoods() async {
    final rawData = await rootBundle.loadString('assets/alimentos.csv');
    
    final converter = const CsvToListConverter();
    List<List<dynamic>> rows = converter.convert(
      rawData,
      fieldDelimiter: ';',
      shouldParseNumbers: false,
    );

    // .skip(2) porque tu CSV tiene 2 filas de encabezado antes de los datos
    return rows.skip(2).map((row) {
      return FoodItem(
        code: row[0].toString(),
        name: row[1].toString(),
        calories: _parse(row[2]),
        protein: _parse(row[3]),
        lipids: _parse(row[4]),
        carbs: _parse(row[5]),
        fiber: _parse(row[6]),
      );
    }).toList();
  }

  static double _parse(dynamic value) {
    if (value == null) return 0.0;
    String strValue = value.toString().replaceAll(',', '.');
    return double.tryParse(strValue) ?? 0.0;
  }
}