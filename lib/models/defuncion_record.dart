import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'enums.dart';

part 'defuncion_record.g.dart';

@HiveType(typeId: 5)
class DefuncionRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nombres;

  @HiveField(2)
  String dni;

  @HiveField(3)
  int edad;

  @HiveField(4)
  Sexo sexo;

  @HiveField(5)
  String ocupacion;

  @HiveField(6)
  DateTime fecha;

  @HiveField(7)
  TimeOfDay hora;

  @HiveField(8)
  String direccionCalle;

  @HiveField(9)
  String direccionBarrio;

  @HiveField(10)
  String direccionDistrito;

  @HiveField(11)
  EstadoCivil estadoCivil;

  @HiveField(12)
  NivelInstruccion nivelInstruccion;

  @HiveField(13)
  TipoSeguro tipoSeguro;

  @HiveField(14)
  String? tipoSeguroOtro;

  @HiveField(15)
  String causasDefuncion;

  DefuncionRecord({
    required this.id,
    required this.nombres,
    required this.dni,
    required this.edad,
    required this.sexo,
    required this.ocupacion,
    required this.fecha,
    required this.hora,
    required this.direccionCalle,
    required this.direccionBarrio,
    required this.direccionDistrito,
    required this.estadoCivil,
    required this.nivelInstruccion,
    required this.tipoSeguro,
    this.tipoSeguroOtro,
    required this.causasDefuncion,
  });
}
