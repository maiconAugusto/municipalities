import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:municipalities/app/domain/entities/city_entity.dart';
import 'package:municipalities/app/domain/use_cases/cities_use_case.dart';
import 'package:municipalities/app/presentation/blocs/cities_bloc.dart';

class MockCitiesUseCase extends Mock implements CitiesUseCase {}

void main() {
  late MockCitiesUseCase mockCitiesUseCase;
  late CitiesBloc citiesBloc;

  setUp(() {
    mockCitiesUseCase = MockCitiesUseCase();
    citiesBloc = CitiesBloc(mockCitiesUseCase);
  });

  tearDown(() {
    citiesBloc.close();
  });

  group('CitiesBloc', () {
    final testCities = List.generate(
      10,
      (index) => CityEntity(
        id: index,
        name: 'City $index',
        mesoregion: '',
        microregion: '',
        state: 'MS',
        stateAcronym: 'Ms',
      ),
    );

    blocTest<CitiesBloc, CityState>(
      'emite [loading, success] com cidades carregadas com sucesso',
      build: () {
        when(() => mockCitiesUseCase.loadCities(
            start: any(named: 'start'),
            limit: any(named: 'limit'))).thenAnswer((_) async => testCities);
        return citiesBloc;
      },
      act: (bloc) => bloc.fetchCities(),
      expect: () => [
        isA<CityState>()
            .having((state) => state.status, 'status', CityStatus.loading),
        isA<CityState>()
            .having((state) => state.status, 'status', CityStatus.success)
            .having((state) => state.cities, 'cities', testCities)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
      verify: (_) {
        verify(() => mockCitiesUseCase.loadCities(start: 0, limit: 50))
            .called(2);
      },
    );

    blocTest<CitiesBloc, CityState>(
      'emite [loading, failure] ao falhar ao carregar cidades',
      build: () {
        when(() => mockCitiesUseCase.loadCities(
                start: any(named: 'start'), limit: any(named: 'limit')))
            .thenThrow(Exception('Erro ao carregar cidades'));
        return citiesBloc;
      },
      act: (bloc) => bloc.fetchCities(),
      expect: () => [
        isA<CityState>()
            .having((state) => state.status, 'status', CityStatus.loading),
        isA<CityState>()
            .having((state) => state.status, 'status', CityStatus.failure)
            .having((state) => state.errorMessage, 'errorMessage',
                'Erro ao carregar cidades'),
      ],
    );

    blocTest<CitiesBloc, CityState>(
      'emite [loading, success] com cache atualizado quando forceRefresh é true',
      build: () {
        when(() => mockCitiesUseCase.refreshCache())
            .thenAnswer((_) async => {});
        when(() => mockCitiesUseCase.loadCities(
            start: any(named: 'start'),
            limit: any(named: 'limit'))).thenAnswer((_) async => testCities);
        return citiesBloc;
      },
      act: (bloc) => bloc.fetchCities(forceRefresh: true),
      expect: () => [
        isA<CityState>()
            .having((state) => state.status, 'status', CityStatus.loading),
        isA<CityState>()
            .having((state) => state.status, 'status', CityStatus.success)
            .having((state) => state.cities, 'cities', testCities)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
      verify: (_) {
        verify(() => mockCitiesUseCase.refreshCache()).called(1);
        verify(() => mockCitiesUseCase.loadCities(start: 0, limit: 50))
            .called(2);
      },
    );
  });
}
