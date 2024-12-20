import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:municipalities/app/data/models/city_model.dart';
import 'package:municipalities/app/domain/use_cases/cities_use_case.dart';

enum CityStatus { initial, loading, success, failure }

class CityState {
  final CityStatus status;
  final List<CityModel> cities;
  final String? errorMessage;

  CityState({required this.status, this.cities = const [], this.errorMessage});

  CityState copyWith({
    CityStatus? status,
    List<CityModel>? cities,
    String? errorMessage,
  }) {
    return CityState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MunicipioBloc extends Cubit<CityState> {
  final CitiesUseCase _citiesUseCase;

  MunicipioBloc(
    this._citiesUseCase,
  ) : super(
          CityState(status: CityStatus.initial),
        );

  Future<void> fetchCities() async {
    emit(state.copyWith(status: CityStatus.loading));
    try {
      final cities = await _citiesUseCase.loadCities();

      emit(
        state.copyWith(
          status: CityStatus.success,
          cities: cities,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CityStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
