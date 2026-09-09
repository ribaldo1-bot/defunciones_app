import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/defuncion_record.dart';
import '../../models/enums.dart';
import '../../repositories/defuncion_repository.dart';
import '../widgets/custom_radio_group.dart';

class FormularioScreen extends StatefulWidget {
  final DefuncionRepository repository;
  final DefuncionRecord? existingRecord;

  const FormularioScreen({
    super.key,
    required this.repository,
    this.existingRecord,
  });

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores Tarjeta 1
  final _nombresController = TextEditingController();
  final _dniController = TextEditingController();
  final _edadController = TextEditingController();
  DateTime? _fechaNacimiento;

  // Variables Tarjeta 2
  DateTime? _fecha;
  TimeOfDay? _hora;
  final _calleController = TextEditingController();
  final _barrioController = TextEditingController();
  final _distritoController = TextEditingController();

  // Variables Tarjeta 3
  Sexo? _sexo;
  final _ocupacionController = TextEditingController();
  EstadoCivil? _estadoCivil;
  NivelInstruccion? _nivelInstruccion;
  TipoSeguro? _tipoSeguro;
  final _tipoSeguroOtroController = TextEditingController();

  // Controladores Tarjeta 4
  final _causasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingRecord != null) {
      final r = widget.existingRecord!;
      _nombresController.text = r.nombres;
      _dniController.text = r.dni;
      _edadController.text = r.edad.toString();
      _fecha = r.fecha;
      _hora = r.hora;
      _calleController.text = r.direccionCalle;
      _barrioController.text = r.direccionBarrio;
      _distritoController.text = r.direccionDistrito;
      _sexo = r.sexo;
      _ocupacionController.text = r.ocupacion;
      _estadoCivil = r.estadoCivil;
      _nivelInstruccion = r.nivelInstruccion;
      _tipoSeguro = r.tipoSeguro;
      if (r.tipoSeguroOtro != null) {
        _tipoSeguroOtroController.text = r.tipoSeguroOtro!;
      }
      _causasController.text = r.causasDefuncion;
    } else {
      _fecha = DateTime.now();
      _hora = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _dniController.dispose();
    _edadController.dispose();
    _calleController.dispose();
    _barrioController.dispose();
    _distritoController.dispose();
    _ocupacionController.dispose();
    _tipoSeguroOtroController.dispose();
    _causasController.dispose();
    super.dispose();
  }

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      if (_edadController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione la Fecha de Nacimiento.')),
        );
        return;
      }
      if (_fecha == null || _hora == null || _sexo == null || _estadoCivil == null || _nivelInstruccion == null || _tipoSeguro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos de selección obligatorios.')),
        );
        return;
      }

      final isEditing = widget.existingRecord != null;
      final record = DefuncionRecord(
        id: isEditing ? widget.existingRecord!.id : const Uuid().v4(),
        nombres: _nombresController.text,
        dni: _dniController.text,
        edad: int.parse(_edadController.text),
        sexo: _sexo!,
        ocupacion: _ocupacionController.text,
        fecha: _fecha!,
        hora: _hora!,
        direccionCalle: _calleController.text,
        direccionBarrio: _barrioController.text,
        direccionDistrito: _distritoController.text,
        estadoCivil: _estadoCivil!,
        nivelInstruccion: _nivelInstruccion!,
        tipoSeguro: _tipoSeguro!,
        tipoSeguroOtro: _tipoSeguro == TipoSeguro.otro ? _tipoSeguroOtroController.text : null,
        causasDefuncion: _causasController.text,
      );

      try {
        if (isEditing) {
          await widget.repository.editarRegistro(record);
        } else {
          await widget.repository.guardarRegistro(record);
        }
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e')),
          );
        }
      }
    }
  }

  Widget _buildCardTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRecord != null ? 'Editar Registro' : 'Nuevo Registro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            // Tarjeta 1: Identificación
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardTitle('1. Identificación'),
                    TextFormField(
                      controller: _nombresController,
                      decoration: const InputDecoration(labelText: 'Nombres y Apellidos'),
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dniController,
                      decoration: const InputDecoration(labelText: 'DNI'),
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        if (value.length != 8) return 'Debe tener exactamente 8 dígitos';
                        if (int.tryParse(value) == null) return 'Solo números';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.cake),
                            label: Text(_fechaNacimiento == null ? 'Fecha de Nacimiento' : '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}'),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _fechaNacimiento ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  _fechaNacimiento = picked;
                                  final today = DateTime.now();
                                  int age = today.year - picked.year;
                                  if (today.month < picked.month || (today.month == picked.month && today.day < picked.day)) {
                                    age--;
                                  }
                                  _edadController.text = age.toString();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text('Edad: ${_edadController.text.isEmpty ? '-' : _edadController.text} años', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Tarjeta 2: Cronología y Lugar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardTitle('2. Cronología y Lugar'),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(_fecha == null ? 'Fecha de Fallecimiento' : '${_fecha!.day}/${_fecha!.month}/${_fecha!.year}'),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _fecha ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setState(() => _fecha = picked);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: Text(_hora == null ? 'Hora' : _hora!.format(context)),
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _hora ?? TimeOfDay.now(),
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) setState(() => _hora = picked);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _calleController,
                      decoration: const InputDecoration(labelText: 'Dirección (Jr./Av./Calle)'),
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _barrioController,
                      decoration: const InputDecoration(labelText: 'Barrio / Comunidad'),
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _distritoController,
                      decoration: const InputDecoration(labelText: 'Distrito / Provincia / Región'),
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                  ],
                ),
              ),
            ),

            // Tarjeta 3: Datos Estadísticos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardTitle('3. Datos Estadísticos'),
                    const Text('Sexo:', style: TextStyle(fontWeight: FontWeight.bold)),
                    CustomRadioGroup<Sexo>(
                      values: Sexo.values,
                      labels: const ['Masculino', 'Femenino'],
                      groupValue: _sexo,
                      onChanged: (val) => setState(() => _sexo = val),
                    ),
                    const Divider(),
                    TextFormField(
                      controller: _ocupacionController,
                      decoration: const InputDecoration(labelText: 'Ocupación habitual'),
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                    const Divider(),
                    const Text('Estado Civil:', style: TextStyle(fontWeight: FontWeight.bold)),
                    CustomRadioGroup<EstadoCivil>(
                      values: EstadoCivil.values,
                      labels: const ['Soltero', 'Casado', 'Viudo', 'Conviviente'],
                      groupValue: _estadoCivil,
                      onChanged: (val) => setState(() => _estadoCivil = val),
                    ),
                    const Divider(),
                    const Text('Nivel de Instrucción:', style: TextStyle(fontWeight: FontWeight.bold)),
                    CustomRadioGroup<NivelInstruccion>(
                      values: NivelInstruccion.values,
                      labels: const ['Sin instrucción', 'Primaria', 'Secundaria', 'Superior'],
                      groupValue: _nivelInstruccion,
                      onChanged: (val) => setState(() => _nivelInstruccion = val),
                    ),
                    const Divider(),
                    const Text('Tipo de Seguro:', style: TextStyle(fontWeight: FontWeight.bold)),
                    CustomRadioGroup<TipoSeguro>(
                      values: TipoSeguro.values,
                      labels: const ['SIS', 'EsSalud', 'Privado', 'Otro'],
                      groupValue: _tipoSeguro,
                      onChanged: (val) => setState(() => _tipoSeguro = val),
                    ),
                    if (_tipoSeguro == TipoSeguro.otro) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tipoSeguroOtroController,
                        decoration: const InputDecoration(labelText: 'Especifique otro seguro'),
                        validator: (value) => value == null || value.isEmpty ? 'Especifique el seguro' : null,
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // Tarjeta 4: Final
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardTitle('4. Final'),
                    const Text('Causas de Defunción:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _causasController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describa detalladamente...',
                      ),
                      maxLines: 5,
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _guardarCambios,
              icon: const Icon(Icons.save),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Guardar Cambios', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
