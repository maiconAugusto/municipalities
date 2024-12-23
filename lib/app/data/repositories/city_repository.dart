import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../models/city_model.dart';

class CityRepositories {
  final _injector = GetIt.instance;
  final _box = Hive.box('citiesCache');

  Future<List<CityModel>> loadCities({
    required int start,
    required int limit,
  }) async {
    if (_box.isNotEmpty) {
      final cachedCities =
          _box.get('cities', defaultValue: []).cast<CityModel>();
      return cachedCities.sublist(
        start,
        (start + limit > cachedCities.length)
            ? cachedCities.length
            : start + limit,
      );
    }

    final List<CityModel> cities = await _fetchFromApi();

    await _box.put('cities', cities);

    return cities.sublist(
      start,
      (start + limit > cities.length) ? cities.length : start + limit,
    );
  }

  Future<List<CityModel>> _fetchFromApi() async {
    final dio = _injector<Dio>();
    final response = await dio.get("municipios");
    return (response.data as List)
        .map((json) => CityModel.fromJson(json))
        .toList();
  }

  Future<void> refreshCache() async {
    final List<CityModel> cities = await _fetchFromApi();
    await _box.put('cities', cities);
  }
}
