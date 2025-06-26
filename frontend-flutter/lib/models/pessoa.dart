class Pessoa {
  int id;
  String nome;
  int idade;
  String ramo;
  String? fotoUrl;

  Pessoa({
    required this.id,
    required this.nome,
    required this.idade,
    required this.ramo,
    this.fotoUrl,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) => Pessoa(
        id: json['id'],
        nome: json['nome'],
        idade: json['idade'],
        ramo: json['ramo'],
        fotoUrl: json['fotoUrl'],
      );

  // 🔽 Getter que monta a URL completa
  String? get fotoCompleta {
    if (fotoUrl == null || fotoUrl!.isEmpty) return null;
    return 'http://192.168.2.134:5000/$fotoUrl';
  }
}
