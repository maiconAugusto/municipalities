import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:municipalities/app/data/models/city_model.dart';
import 'package:municipalities/app/data/repositories/i_city_repository.dart';

class CityRepositories implements ICityRepository {
  final _injector = GetIt.instance;
  List<CityModel> _allCities = [];

  @override
  Future<List<CityModel>> loadCities({
    required int start,
    required int limit,
  }) async {
    if (_allCities.isEmpty) {
      final dio = _injector<Dio>();
      final response = await dio.get("municipios");
      _allCities = (response.data as List)
          .map((json) => CityModel.fromJson(json))
          .toList();
    }

    return _allCities.sublist(
      start,
      (start + limit > _allCities.length) ? _allCities.length : start + limit,
    );
  }
}
