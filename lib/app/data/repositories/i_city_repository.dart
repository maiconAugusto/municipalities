import 'package:municipalities/app/data/models/city_model.dart';

abstract class ICityRepository {
  Future<List<CityModel>> loadCities({
    required int start,
    required int limit,
  });
}
