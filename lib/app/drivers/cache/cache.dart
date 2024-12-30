import 'package:hive_flutter/hive_flutter.dart';
import 'package:municipalities/app/data/models/city_model.dart';

Future<void> initHive() async {
  Hive.registerAdapter(
    CityModelAdapter(),
  );
  await Hive.initFlutter();
  await Hive.openBox('citiesCache');
}
