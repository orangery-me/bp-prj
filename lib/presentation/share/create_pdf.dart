import 'dart:io';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../common/extensions/data_analyze_extension.dart';

class CreatePDF {
    static String formatDate(DateTime? date) {
        if (date == null) return '-';
        String day = date.day.toString().padLeft(2, '0');
        String month = date.month.toString().padLeft(2, '0');
        String year = date.year.toString();
        return '$year-$month-$day';
    }

    static String formatTime(DateTime? date) {
        if (date == null) return '-';
        String hour = date.hour.toString().padLeft(2, '0');
        String minute = date.minute.toString().padLeft(2, '0');
        String second = date.second.toString().padLeft(2, '0');
        return '$hour:$minute:$second';
    }

    static Future<File> generatePDF(List<Measurement> measurements, Profile profile, DateTime start, DateTime end) async {
        final pdf = Document();

        if (measurements.isEmpty) {
            pdf.addPage(
                MultiPage(
                    build: (Context context) => [
                        Header(level: 0, child: Text('Health Data Measurements')),
                        Paragraph(text: 'No measurements available.'),
                    ],
                ),
            );
        } else {
            pdf.addPage(
                MultiPage(
                    build: (Context context) => [
                        Table(
                            columnWidths: {
                                0: const FlexColumnWidth(3), // Cột đầu tiên chiếm 3 phần
                                1: const FlexColumnWidth(1), // Cột thứ hai chiếm 1 phần
                            },
                            border: null, // Bỏ viền của bảng
                            children: [
                                TableRow(
                                    children: [
                                        Text(
                                            'BP Measurements Report',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                profile.fullName,
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                                            ),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                        Table(
                            columnWidths: {
                                0: const FlexColumnWidth(3),
                                1: const FlexColumnWidth(1),
                            },
                            border: null,
                            children: [
                                TableRow(
                                    children: [
                                        Text(
                                            '${formatDate(start)} - ${formatDate(end)}',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                '${profile.getAge()} years old',
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                                            ),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                        SizedBox(height: 20),
                        TableHelper.fromTextArray(
                            headers: [
                                'Date',
                                'Time',
                                'Sys - Dia',
                                'Pulse',
                                'Weight',
                                'MAP',
                                'BMI',
                                'Note',
                            ],
                            data: measurements.map((measurement) {
                                return [
                                    formatDate(measurement.date),
                                    formatTime(measurement.date),
                                    '${measurement.systolis} - ${measurement.diastolis}',
                                    measurement.pulse.toString(),
                                    measurement.weight.toStringAsFixed(1),
                                    DataAnalyzeExtension.getMAP(measurement.systolis, measurement.diastolis).toStringAsFixed(2),
                                    DataAnalyzeExtension.getBMI(double.parse(profile.weight), double.parse(profile.height).round()).toStringAsFixed(2),
                                    measurement.note ?? '-',
                                ];
                            }).toList(),
                            border: TableBorder.all(color: PdfColors.grey),
                            headerStyle: TextStyle(fontWeight: FontWeight.bold, color: PdfColors.black),
                            headerDecoration: const BoxDecoration(color: PdfColors.grey300),
                            cellStyle: const TextStyle(fontSize: 10),
                            cellAlignment: Alignment.center,
                            headerAlignment: Alignment.center,
                        ),
                        SizedBox(height: 20),
                        Paragraph(
                            text: 'The Report is generated by Blood Pressure App for iOS',
                            style: const TextStyle(fontSize: 10, color: PdfColors.grey),
                            textAlign: TextAlign.center,
                        ),
                    ],
                ),
            );
        }
        Directory? directory = await getExternalStorageDirectory();
        if (directory == null) {
            throw Exception("Không thể truy cập thư mục lưu trữ.");
        }

        final newFile = File('${directory.path}/pdf_HealthData.pdf');
        await newFile.writeAsBytes(await pdf.save());
        return newFile;
    }

    static Future<void> openPDF(File file) async {
        await OpenFile.open(file.path);
    }
}
