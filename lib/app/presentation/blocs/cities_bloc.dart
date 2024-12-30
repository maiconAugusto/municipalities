import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:municipalities/app/data/models/city_model.dart';
import 'package:municipalities/app/domain/use_cases/cities_use_case.dart';

enum CityStatus { initial, loading, success, failure }

class CityState {
  final CityStatus status;
  final List<CityModel> cities;
  final bool hasReachedMax;
  final String? errorMessage;

  CityState({
    required this.status,
    this.cities = const [],
    this.hasReachedMax = false,
    this.errorMessage,
  });

  CityState copyWith({
    CityStatus? status,
    List<CityModel>? cities,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return CityState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CitiesBloc extends Cubit<CityState> {
  final CitiesUseCase _citiesUseCase;

  int _currentBatch = 0;
  final int _batchSize = 50;

  CitiesBloc(this._citiesUseCase)
      : super(CityState(status: CityStatus.initial)) {
    fetchCities();
  }

  Future<void> fetchCities({bool forceRefresh = false}) async {
    emit(state.copyWith(status: CityStatus.loading));

    try {
      if (forceRefresh) {
        await _citiesUseCase.refreshCache();
      }
      final cities = await _citiesUseCase.loadCities(
        start: _currentBatch * _batchSize,
        limit: _batchSize,
      );

      final hasReachedMax = cities.length < _batchSize;

      emit(state.copyWith(
        status: CityStatus.success,
        cities: List.of(state.cities)..addAll(cities),
        hasReachedMax: hasReachedMax,
      ));

      _currentBatch++;
    } catch (e) {
      String? errorMessage;
      if (e is DioException) {
        errorMessage = e.message;
      } else if (e is Exception) {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      }
      emit(
        state.copyWith(
          status: CityStatus.failure,
          errorMessage: errorMessage,
        ),
      );
    }
  }
}
