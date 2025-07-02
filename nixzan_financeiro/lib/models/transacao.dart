import 'package:hive/hive.dart';

part 'transacao.g.dart';

@HiveType(typeId: 0)
class Transacao extends HiveObject {
  @HiveField(0)
  String titulo;

  @HiveField(1)
  double valor;

  @HiveField(2)
  DateTime data;

  @HiveField(3)
  bool isGanho; // true = ganho, false = gasto

  Transacao({
    required this.titulo,
    required this.valor,
    required this.data,
    required this.isGanho,
  });
}
