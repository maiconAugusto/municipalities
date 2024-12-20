import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:municipalities/app/data/models/city_model.dart';
import 'package:municipalities/app/data/repositories/i_city_repository.dart';

class CityRepositories implements ICityRepository {
  final _injector = GetIt.instance;

  @override
  Future<List<CityModel>> loadCities() async {
    try {
      final dio = _injector<Dio>();
      final response = await dio.get("municipios");
      List<CityModel> cities = (response.data as List)
          .map((json) => CityModel.fromJson(json))
          .toList();
      return cities;
    } catch (e) {
      rethrow;
    }
  }
}
