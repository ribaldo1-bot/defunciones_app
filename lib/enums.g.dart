// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SexoAdapter extends TypeAdapter<Sexo> {
  @override
  final int typeId = 1;

  @override
  Sexo read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Sexo.masculino;
      case 1:
        return Sexo.femenino;
      default:
        return Sexo.masculino;
    }
  }

  @override
  void write(BinaryWriter writer, Sexo obj) {
    switch (obj) {
      case Sexo.masculino:
        writer.writeByte(0);
        break;
      case Sexo.femenino:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SexoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EstadoCivilAdapter extends TypeAdapter<EstadoCivil> {
  @override
  final int typeId = 2;

  @override
  EstadoCivil read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EstadoCivil.soltero;
      case 1:
        return EstadoCivil.casado;
      case 2:
        return EstadoCivil.viudo;
      case 3:
        return EstadoCivil.conviviente;
      default:
        return EstadoCivil.soltero;
    }
  }

  @override
  void write(BinaryWriter writer, EstadoCivil obj) {
    switch (obj) {
      case EstadoCivil.soltero:
        writer.writeByte(0);
        break;
      case EstadoCivil.casado:
        writer.writeByte(1);
        break;
      case EstadoCivil.viudo:
        writer.writeByte(2);
        break;
      case EstadoCivil.conviviente:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstadoCivilAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NivelInstruccionAdapter extends TypeAdapter<NivelInstruccion> {
  @override
  final int typeId = 3;

  @override
  NivelInstruccion read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NivelInstruccion.sinInstruccion;
      case 1:
        return NivelInstruccion.primaria;
      case 2:
        return NivelInstruccion.secundaria;
      case 3:
        return NivelInstruccion.superior;
      default:
        return NivelInstruccion.sinInstruccion;
    }
  }

  @override
  void write(BinaryWriter writer, NivelInstruccion obj) {
    switch (obj) {
      case NivelInstruccion.sinInstruccion:
        writer.writeByte(0);
        break;
      case NivelInstruccion.primaria:
        writer.writeByte(1);
        break;
      case NivelInstruccion.secundaria:
        writer.writeByte(2);
        break;
      case NivelInstruccion.superior:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NivelInstruccionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipoSeguroAdapter extends TypeAdapter<TipoSeguro> {
  @override
  final int typeId = 4;

  @override
  TipoSeguro read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoSeguro.sis;
      case 1:
        return TipoSeguro.essalud;
      case 2:
        return TipoSeguro.privado;
      case 3:
        return TipoSeguro.otro;
      default:
        return TipoSeguro.sis;
    }
  }

  @override
  void write(BinaryWriter writer, TipoSeguro obj) {
    switch (obj) {
      case TipoSeguro.sis:
        writer.writeByte(0);
        break;
      case TipoSeguro.essalud:
        writer.writeByte(1);
        break;
      case TipoSeguro.privado:
        writer.writeByte(2);
        break;
      case TipoSeguro.otro:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoSeguroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
