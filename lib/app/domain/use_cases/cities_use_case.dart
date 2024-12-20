import 'package:municipalities/app/data/models/city_model.dart';
import 'package:municipalities/app/data/repositories/city_repository.dart';

class CitiesUseCase {
  final CityRepositories _repository;

  CitiesUseCase(this._repository);

  Future<List<CityModel>> loadCities() async {
    return await _repository.loadCities();
  }
}
