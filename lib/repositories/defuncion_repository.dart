import 'package:hive_flutter/hive_flutter.dart';
import '../models/defuncion_record.dart';
import '../models/enums.dart';
import '../models/time_of_day_adapter.dart';

class DefuncionRepository {
  static const String _boxName = 'defuncionesBox';

  /// Inicializa Hive, registra adaptadores y abre la caja.
  Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adaptadores manuales
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TimeOfDayAdapter());
    }

    // Registrar adaptadores generados
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SexoAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(EstadoCivilAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(NivelInstruccionAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TipoSeguroAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(DefuncionRecordAdapter());
    }

    await Hive.openBox<DefuncionRecord>(_boxName);
  }

  /// Valida que el DNI tenga exactamente 8 dígitos numéricos
  void _validarDNI(String dni) {
    if (dni.length != 8) {
      throw FormatException('El DNI debe tener exactamente 8 caracteres.');
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(dni)) {
      throw FormatException('El DNI debe contener solo números.');
    }
  }

  /// Crea un nuevo registro
  Future<void> guardarRegistro(DefuncionRecord record) async {
    _validarDNI(record.dni);
    final box = Hive.box<DefuncionRecord>(_boxName);
    await box.put(record.id, record);
  }

  /// Obtiene todos los registros
  List<DefuncionRecord> obtenerRegistros() {
    final box = Hive.box<DefuncionRecord>(_boxName);
    return box.values.toList();
  }

  /// Obtiene un registro por su ID
  DefuncionRecord? obtenerRegistroPorId(String id) {
    final box = Hive.box<DefuncionRecord>(_boxName);
    return box.get(id);
  }

  /// Edita un registro existente
  Future<void> editarRegistro(DefuncionRecord record) async {
    _validarDNI(record.dni);
    final box = Hive.box<DefuncionRecord>(_boxName);
    if (!box.containsKey(record.id)) {
      throw Exception('El registro con ID ${record.id} no existe.');
    }
    await box.put(record.id, record);
  }

  /// Elimina un registro por su ID
  Future<void> eliminarRegistro(String id) async {
    final box = Hive.box<DefuncionRecord>(_boxName);
    await box.delete(id);
  }
}
