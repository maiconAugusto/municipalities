class CityModel {
  final String name;
  final String state;
  final String stateAcronym;

  CityModel({
    required this.name,
    required this.state,
    required this.stateAcronym,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['nome'] ?? '',
      state: json['microrregiao']['mesorregiao']['UF']['nome'] ?? '',
      stateAcronym: json['microrregiao']['mesorregiao']['UF']['sigla'] ?? '',
    );
  }
}
