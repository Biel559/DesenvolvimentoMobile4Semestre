class Disciplina {
  final int? id;
  final String nome;
  final double nota1;
  final double nota2;
  final double nota3;

  Disciplina({
    this.id,
    required this.nome,
    required this.nota1,
    required this.nota2,
    required this.nota3,
  });

  double get media => (nota1 + nota2 + nota3) / 3;

  Disciplina copyWith({
    int? id,
    String? nome,
    double? nota1,
    double? nota2,
    double? nota3,
  }) {
    return Disciplina(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      nota1: nota1 ?? this.nota1,
      nota2: nota2 ?? this.nota2,
      nota3: nota3 ?? this.nota3,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'nota1': nota1,
        'nota2': nota2,
        'nota3': nota3,
      };

  factory Disciplina.fromMap(Map<String, dynamic> map) => Disciplina(
        id: map['id'] as int?,
        nome: map['nome'] as String,
        nota1: map['nota1'] as double,
        nota2: map['nota2'] as double,
        nota3: map['nota3'] as double,
      );
}