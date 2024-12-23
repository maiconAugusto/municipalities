import 'package:hive/hive.dart';

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

  CityModel({
    required this.name,
    required this.state,
    required this.stateAcronym,
    required this.id,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['nome'],
      state: json['microrregiao']['mesorregiao']['UF']['nome'],
      stateAcronym: json['microrregiao']['mesorregiao']['UF']['sigla'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'microrregiao': {
        'mesorregiao': {
          'UF': {
            'nome': state,
            'sigla': stateAcronym,
          },
        },
      },
    };
  }
}
