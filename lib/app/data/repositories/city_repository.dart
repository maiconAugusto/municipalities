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
      if (!_box.isNotEmpty) {
        final List<CityModel> cachedCities =
            _box.get('cities', defaultValue: []).cast<CityModel>();

        final List<CityEntity> cachedCitiesEntities =
            cachedCities.map((model) => model.toEntity()).toList();

        return cachedCitiesEntities.sublist(
          start,
          (start + limit > cachedCitiesEntities.length)
              ? cachedCitiesEntities.length
              : start + limit,
        );
      }

      final List<CityModel> cities = await _fetchFromApi();

      await _box.put('cities', cities);

      List<CityEntity> citiesEntity =
          cities.map((model) => model.toEntity()).toList();

      return citiesEntity.sublist(
        start,
        (start + limit > citiesEntity.length)
            ? citiesEntity.length
            : start + limit,
      );
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
      rethrow;
    }
  }

  Future<void> refreshCache() async {
    try {
      final List<CityModel> cities = await _fetchFromApi();
      await _box.put('cities', cities);
    } catch (e) {
      rethrow;
    }
  }
}
