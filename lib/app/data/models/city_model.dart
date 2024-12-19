class City {
  final String name;
  final String state;
  final String stateAcronym;

  City({
    required this.name,
    required this.state,
    required this.stateAcronym,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['nome'] ?? '',
      state: json['microrregiao']['mesorregiao']['UF']['nome'] ?? '',
      stateAcronym: json['microrregiao']['mesorregiao']['UF']['sigla'] ?? '',
    );
  }
}
