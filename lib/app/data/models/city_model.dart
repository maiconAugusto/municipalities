import 'package:hive/hive.dart';
import 'package:municipalities/app/domain/entities/city_entity.dart';

part 'city_model.g.dart';

@HiveType(typeId: 0)
class CityModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String state;

  @HiveField(2)
  final String stateAcronym;

  @HiveField(3)
  final int id;

  @HiveField(4)
  final String microregion;

  @HiveField(5)
  final String mesoregion;

  CityModel({
    required this.name,
    required this.state,
    required this.stateAcronym,
    required this.id,
    required this.microregion,
    required this.mesoregion,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['nome'],
      state: json['microrregiao']['mesorregiao']['UF']['nome'],
      stateAcronym: json['microrregiao']['mesorregiao']['UF']['sigla'],
      microregion: json['microrregiao']['nome'],
      mesoregion: json['microrregiao']['mesorregiao']['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'microrregiao': {
        'nome': microregion,
        'mesorregiao': {
          'nome': mesoregion,
          'UF': {
            'nome': state,
            'sigla': stateAcronym,
          },
        },
      },
    };
  }

  CityEntity toEntity() {
    return CityEntity(
      name: name,
      state: state,
      stateAcronym: stateAcronym,
      id: id,
      microregion: microregion,
      mesoregion: mesoregion,
    );
  }

  factory CityModel.fromEntity(CityEntity entity) {
    return CityModel(
      name: entity.name,
      state: entity.state,
      stateAcronym: entity.stateAcronym,
      id: entity.id,
      microregion: entity.microregion,
      mesoregion: entity.mesoregion,
    );
  }
}
