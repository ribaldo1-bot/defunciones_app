// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defuncion_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DefuncionRecordAdapter extends TypeAdapter<DefuncionRecord> {
  @override
  final int typeId = 5;

  @override
  DefuncionRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DefuncionRecord(
      id: fields[0] as String,
      nombres: fields[1] as String,
      dni: fields[2] as String,
      edad: fields[3] as int,
      sexo: fields[4] as Sexo,
      ocupacion: fields[5] as String,
      fecha: fields[6] as DateTime,
      hora: fields[7] as TimeOfDay,
      direccionCalle: fields[8] as String,
      direccionBarrio: fields[9] as String,
      direccionDistrito: fields[10] as String,
      estadoCivil: fields[11] as EstadoCivil,
      nivelInstruccion: fields[12] as NivelInstruccion,
      tipoSeguro: fields[13] as TipoSeguro,
      tipoSeguroOtro: fields[14] as String?,
      causasDefuncion: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DefuncionRecord obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombres)
      ..writeByte(2)
      ..write(obj.dni)
      ..writeByte(3)
      ..write(obj.edad)
      ..writeByte(4)
      ..write(obj.sexo)
      ..writeByte(5)
      ..write(obj.ocupacion)
      ..writeByte(6)
      ..write(obj.fecha)
      ..writeByte(7)
      ..write(obj.hora)
      ..writeByte(8)
      ..write(obj.direccionCalle)
      ..writeByte(9)
      ..write(obj.direccionBarrio)
      ..writeByte(10)
      ..write(obj.direccionDistrito)
      ..writeByte(11)
      ..write(obj.estadoCivil)
      ..writeByte(12)
      ..write(obj.nivelInstruccion)
      ..writeByte(13)
      ..write(obj.tipoSeguro)
      ..writeByte(14)
      ..write(obj.tipoSeguroOtro)
      ..writeByte(15)
      ..write(obj.causasDefuncion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefuncionRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
