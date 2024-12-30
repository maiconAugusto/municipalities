import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
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
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo de conexão excedido');
      } else if (dioError.response != null &&
          dioError.response?.statusCode == 500) {
        throw Exception('Erro no servidor');
      } else {
        throw Exception('Erro ao se comunicar com o serviço');
      }
    } catch (e) {
      throw Exception('Erro ao buscar municípios');
    }
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
