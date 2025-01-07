import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:municipalities/app/data/repositories/city_repository.dart';
import 'package:municipalities/app/domain/entities/city_entity.dart';
import 'package:municipalities/app/data/models/city_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CityRepositories repository;
  late MockDio mockDio;
  final injector = GetIt.instance;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CityModelAdapter());
    }

    mockDio = MockDio();
    injector.registerSingleton<Dio>(mockDio);
    final _box = await Hive.openBox('citiesCache');
    repository = CityRepositories();
  });

  tearDown(() async {
    await tearDownTestHive();
    injector.reset();
  });

  group('CityRepositories Tests', () {
    test('loadCities should return cached data if available', () async {
      final box = Hive.box('citiesCache');
      final List<CityModel> cachedCities = [
        CityModel(
          id: 1,
          name: 'Ponta Porã',
          mesoregion: 'P',
          microregion: 'PP',
          state: 'MS',
          stateAcronym: 'MS',
        ),
        CityModel(
          id: 2,
          name: 'Dourados',
          mesoregion: 'D',
          microregion: 'DD',
          state: 'MS',
          stateAcronym: 'MS',
        ),
      ];

      await box.put('cities', cachedCities);

      final result = await repository.loadCities(start: 0, limit: 2);

      expect(result, isA<List<CityEntity>>());
      expect(result.length, 2);
      expect(result[0].name, 'Ponta Porã');
      expect(result[1].name, 'Dourados');
    });

    test(
      'loadCities should fetch data from API and cache it when no cache exists',
      () async {
        final apiResponse = [
          {
            "id": 1,
            "nome": "City 1",
            "microrregiao": {
              "nome": "mR1",
              "mesorregiao": {
                "nome": "M1",
                "UF": {"nome": "S1", "sigla": "SA1"}
              }
            }
          },
          {
            "id": 2,
            "nome": "City 2",
            "microrregiao": {
              "nome": "mR2",
              "mesorregiao": {
                "nome": "M2",
                "UF": {"nome": "S2", "sigla": "SA2"}
              }
            }
          }
        ];

        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: apiResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await repository.loadCities(start: 0, limit: 2);

        expect(result, isA<List<CityEntity>>());
        expect(result.length, 2);
        expect(result[0].name, "City 1");
        expect(result[1].name, "City 2");

        final box = Hive.box('citiesCache');
        final cachedData = box.get('cities') as List<CityModel>;
        expect(cachedData.length, 2);
        expect(cachedData[0].name, "City 1");
        expect(cachedData[1].name, "City 2");
      },
    );

    test('loadCities should handle sublist safely', () async {
      final apiResponse = [
        {
          "id": 1,
          "nome": "City 1",
          "microrregiao": {
            "nome": "mR1",
            "mesorregiao": {
              "nome": "M1",
              "UF": {"nome": "S1", "sigla": "SA1"}
            }
          }
        },
      ];

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: apiResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.loadCities(start: 1, limit: 5);

      expect(result, isEmpty);
    });

    test('refreshCache should update cache with new data', () async {
      final apiResponse = [
        {
          "id": 1,
          "nome": "City 1",
          "microrregiao": {
            "nome": "mR1",
            "mesorregiao": {
              "nome": "M1",
              "UF": {"nome": "S1", "sigla": "SA1"}
            }
          }
        },
        {
          "id": 2,
          "nome": "City 2",
          "microrregiao": {
            "nome": "mR2",
            "mesorregiao": {
              "nome": "M2",
              "UF": {"nome": "S2", "sigla": "SA2"}
            }
          }
        }
      ];

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: apiResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await repository.refreshCache();

      final box = Hive.box('citiesCache');
      final cachedData = box.get('cities') as List<CityModel>;
      expect(cachedData.length, 2);
    });
  });
}
