import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DoctorTrialsScreen extends StatelessWidget {
  const DoctorTrialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Trials'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade600,
      ),
      body: Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('Doctor name'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Trial name'),
                    subtitle: const Text('Trial description'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _createPDF();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade200,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text('Generate PDF'),
                    ),
                    onTap: () {
                      // Navigate to the trial details screen
                    },
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the create trial screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan.shade200, 
              textStyle: const TextStyle(color: Colors.black),
            ),
            child: const Text('Create a new trial'),
          ),
        ],
      ),
    ),

    );
  }
}

Future<void> _createPDF() async {
    //Create a PDF document.
    PdfDocument document = PdfDocument();
    //Add a page and draw text
    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(20, 60, 150, 30));    
    //Save the document
    List<int> bytes = await document.save();
    //Dispose the document
    document.dispose();

    //Download the output file
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();
 }