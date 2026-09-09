import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
import '../models/defuncion_record.dart';
import '../models/enums.dart';

class PdfService {
  static Future<void> exportAndShare(DefuncionRecord record) async {
    final pdf = pw.Document();

    final ByteData imageData = await rootBundle.load('assets/logo.jpeg');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(logoImage, width: 60, height: 60),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'FUNERARIA LOS ÁNGELES - AZÁNGARO',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'REGISTRO DE DATOS PARA CERTIFICADO DE DEFUNCIÓN',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // 1. Identificación
              _buildSectionTitle('1. IDENTIFICACIÓN'),
              _buildDottedRow('NOMBRES Y APELLIDOS', record.nombres),
              pw.Row(
                children: [
                  pw.Expanded(child: _buildDottedRow('DNI', record.dni)),
                  pw.SizedBox(width: 16),
                  pw.Expanded(child: _buildDottedRow('EDAD', '${record.edad} años')),
                ],
              ),
              pw.SizedBox(height: 16),

              // 2. Cronología y Lugar
              _buildSectionTitle('2. CRONOLOGÍA Y LUGAR'),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildDottedRow(
                      'FECHA DE FALLECIMIENTO',
                      '${record.fecha.day}/${record.fecha.month}/${record.fecha.year}',
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildDottedRow(
                      'HORA',
                      '${record.hora.hour.toString().padLeft(2, '0')}:${record.hora.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ],
              ),
              _buildDottedRow('DIRECCIÓN (JR./AV./CALLE)', record.direccionCalle),
              _buildDottedRow('BARRIO/COMUNIDAD', record.direccionBarrio),
              _buildDottedRow('DISTRITO/PROVINCIA/REGIÓN', record.direccionDistrito),
              pw.SizedBox(height: 16),

              // 3. Datos Estadísticos
              _buildSectionTitle('3. DATOS ESTADÍSTICOS'),
              _buildDottedRow('OCUPACIÓN HABITUAL', record.ocupacion),
              pw.SizedBox(height: 8),

              pw.Text('SEXO:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Row(
                children: [
                  _buildCheckboxRow('MASCULINO', record.sexo == Sexo.masculino),
                  pw.SizedBox(width: 16),
                  _buildCheckboxRow('FEMENINO', record.sexo == Sexo.femenino),
                ],
              ),
              pw.SizedBox(height: 8),

              pw.Text('ESTADO CIVIL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildCheckboxRow('SOLTERO', record.estadoCivil == EstadoCivil.soltero),
                  _buildCheckboxRow('CASADO', record.estadoCivil == EstadoCivil.casado),
                  _buildCheckboxRow('VIUDO', record.estadoCivil == EstadoCivil.viudo),
                  _buildCheckboxRow('CONVIVIENTE', record.estadoCivil == EstadoCivil.conviviente),
                ],
              ),
              pw.SizedBox(height: 8),

              pw.Text('NIVEL DE INSTRUCCIÓN:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildCheckboxRow('SIN INSTRUCCIÓN', record.nivelInstruccion == NivelInstruccion.sinInstruccion),
                  _buildCheckboxRow('PRIMARIA', record.nivelInstruccion == NivelInstruccion.primaria),
                  _buildCheckboxRow('SECUNDARIA', record.nivelInstruccion == NivelInstruccion.secundaria),
                  _buildCheckboxRow('SUPERIOR', record.nivelInstruccion == NivelInstruccion.superior),
                ],
              ),
              pw.SizedBox(height: 8),

              pw.Text('TIPO DE SEGURO:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildCheckboxRow('SIS', record.tipoSeguro == TipoSeguro.sis),
                  _buildCheckboxRow('ESSALUD', record.tipoSeguro == TipoSeguro.essalud),
                  _buildCheckboxRow('PRIVADO', record.tipoSeguro == TipoSeguro.privado),
                  _buildCheckboxRow('OTRO', record.tipoSeguro == TipoSeguro.otro),
                ],
              ),
              if (record.tipoSeguro == TipoSeguro.otro && record.tipoSeguroOtro != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 8),
                  child: _buildDottedRow('ESPECIFIQUE OTRO SEGURO', record.tipoSeguroOtro!),
                ),
              pw.SizedBox(height: 16),

              // 4. Final
              _buildSectionTitle('4. FINAL (CAUSAS DE DEFUNCIÓN)'),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, style: pw.BorderStyle.dashed),
                ),
                child: pw.Text(
                  record.causasDefuncion,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save and Share
    final bytes = await pdf.save();
    
    if (kIsWeb) {
      final base64Data = base64Encode(bytes);
      final anchor = html.AnchorElement(href: 'data:application/pdf;base64,$base64Data')
        ..setAttribute('download', 'certificado_defuncion_${record.dni}.pdf')
        ..click();
    } else {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/certificado_defuncion_${record.dni}.pdf');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Adjunto el registro de defunción de ${record.nombres}.',
      );
    }
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: PdfColors.grey300,
      width: double.infinity,
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildDottedRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('$label: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dashed, width: 0.5)),
              ),
              child: pw.Text(
                value.toUpperCase(),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCheckboxRow(String label, bool isChecked) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 12,
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
          ),
          child: pw.Center(
            child: isChecked
                ? pw.Text('X', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))
                : pw.SizedBox(),
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }
}
