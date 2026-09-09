import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 1)
enum Sexo {
  @HiveField(0)
  masculino,
  @HiveField(1)
  femenino,
}

@HiveType(typeId: 2)
enum EstadoCivil {
  @HiveField(0)
  soltero,
  @HiveField(1)
  casado,
  @HiveField(2)
  viudo,
  @HiveField(3)
  conviviente,
}

@HiveType(typeId: 3)
enum NivelInstruccion {
  @HiveField(0)
  sinInstruccion,
  @HiveField(1)
  primaria,
  @HiveField(2)
  secundaria,
  @HiveField(3)
  superior,
}

@HiveType(typeId: 4)
enum TipoSeguro {
  @HiveField(0)
  sis,
  @HiveField(1)
  essalud,
  @HiveField(2)
  privado,
  @HiveField(3)
  otro,
}
