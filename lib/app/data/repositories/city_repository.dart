import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:municipalities/app/data/errors/error_mapper.dart';
import 'package:municipalities/app/domain/entities/city_entity.dart';
import '../models/city_model.dart';

class CityRepositories {
  final _injector = GetIt.instance;
  final _box = Hive.box('citiesCache');

  Future<List<CityEntity>> loadCities({
    required int start,
    required int limit,
  }) async {
    try {
      if (_box.isNotEmpty) {
        final cachedCities = _box.get('cities', defaultValue: []) as List;
        final cachedCitiesEntities = cachedCities
            .whereType<CityModel>()
            .map((model) => model.toEntity())
            .toList();

        return _safeSublist(cachedCitiesEntities, start, limit);
      }

      final List<CityModel> cities = await _fetchFromApi();

      await _box.put('cities', cities);

      final citiesEntity = cities.map((model) => model.toEntity()).toList();

      return _safeSublist(citiesEntity, start, limit);
    } catch (e) {
      throw ErrorMapper.mapError(e);
    }
  }

  Future<List<CityModel>> _fetchFromApi() async {
    try {
      final dio = _injector<Dio>();
      final response = await dio.get("municipios");
      return (response.data as List)
          .map((json) => CityModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ErrorMapper.mapError(e);
    }
  }

  Future<void> refreshCache() async {
    try {
      final List<CityModel> cities = await _fetchFromApi();
      await _box.put('cities', cities);
    } catch (e) {
      throw ErrorMapper.mapError(e);
    }
  }

  List<T> _safeSublist<T>(List<T> list, int start, int limit) {
    final end = (start + limit > list.length) ? list.length : start + limit;
    if (start < 0 || start >= list.length) return [];
    return list.sublist(start, end);
  }
}
