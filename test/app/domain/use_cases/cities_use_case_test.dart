import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:municipalities/app/data/repositories/city_repository.dart';
import 'package:municipalities/app/domain/entities/city_entity.dart';
import 'package:municipalities/app/domain/use_cases/cities_use_case.dart';

class MockCityRepositories extends Mock implements CityRepositories {}

void main() {
  late MockCityRepositories mockRepository;
  late CitiesUseCase citiesUseCase;

  final testCities = [
    CityEntity(
        id: 1,
        name: 'Ponta Porã',
        mesoregion: 'P',
        microregion: 'PP',
        state: 'MS',
        stateAcronym: 'MS'),
    CityEntity(
        id: 1,
        name: 'Dourados',
        mesoregion: 'D',
        microregion: 'DD',
        state: 'MS',
        stateAcronym: 'MS'),
  ];

  setUp(() {
    mockRepository = MockCityRepositories();
    citiesUseCase = CitiesUseCase(mockRepository);
  });

  group('CitiesUseCase', () {
    test('should deal with listing of cities', () async {
      when(() => mockRepository.loadCities(start: 0, limit: 2))
          .thenAnswer((_) async => testCities);

      final result = await citiesUseCase.loadCities(start: 0, limit: 2);

      expect(result, testCities);
      verify(() => mockRepository.loadCities(start: 0, limit: 2)).called(1);
    });

    test('should handle cache refresh', () async {
      when(() => mockRepository.refreshCache()).thenAnswer((_) async => {});

      await citiesUseCase.refreshCache();

      verify(() => mockRepository.refreshCache()).called(1);
    });

    test('should handle error when listing cities', () async {
      when(() => mockRepository.loadCities(start: 0, limit: 2))
          .thenThrow(Exception('Erro ao carregar cidades'));

      expect(
        () async => await citiesUseCase.loadCities(start: 0, limit: 2),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem',
            contains('Erro ao carregar cidades'))),
      );
      verify(() => mockRepository.loadCities(start: 0, limit: 2)).called(1);
    });
  });
}
