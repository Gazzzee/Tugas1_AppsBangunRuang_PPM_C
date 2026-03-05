import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VolumePage(),
    );
  }
}

// StatefulWidget karena data (hasil) bisa berubah
class VolumePage extends StatefulWidget {
  const VolumePage({super.key});

  @override
  _VolumePageState createState() => _VolumePageState();
}

// Class state yang berisi logika dan tampilan
class _VolumePageState extends State<VolumePage> {
  String selectedBangun = "Kubus"; 
  double hasil = 0; 

  // Controller untuk mengambil input dari TextField
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  // key form untuk mem-validasi input
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // bersihkan controller ketika State dihancurkan
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  // Fungsi untuk menghitung volume
  void hitungVolume() {
    if (!_formKey.currentState!.validate()) return;

    // Mengambil nilai dari input dan mengubah ke double
    double nilai1 = double.parse(controller1.text);
    double nilai2 =
        double.parse(controller2.text.isEmpty ? '0' : controller2.text);

    setState(() {
      if (selectedBangun == "Kubus") {
        hasil = pow(nilai1, 3).toDouble(); // Rumus: sisi³
      } else if (selectedBangun == "Tabung") {
        hasil = pi * pow(nilai1, 2) * nilai2; // Rumus: π × r² × t
      } else if (selectedBangun == "Bola") {
        hasil = (4 / 3) * pi * pow(nilai1, 3); // Rumus: 4/3 × π × r³
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kerangka utama halaman
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 196, 250),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bangun Ruang - L200230136",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Dwi Bagas Prasetya",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown untuk memilih bangun ruang
              DropdownButton<String>(
                value: selectedBangun,
                isExpanded: true,
                items: ["Kubus", "Tabung", "Bola"]
                    .map((bangun) => DropdownMenuItem(
                          value: bangun,
                          child: Text(bangun),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBangun = value!;
                    hasil = 0;
                    controller1.clear();
                    controller2.clear();
                  });
                },
              ),

              SizedBox(height: 16), // Jarak antar widget

              // Input sisi atau jari-jari
              TextFormField(
                controller: controller1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: selectedBangun == "Kubus"
                      ? "Sisi (cm)"
                      : "Jari-jari (cm)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Masukkan angka lebih besar dari nol';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Input tinggi hanya muncul jika memilih Tabung
              if (selectedBangun == "Tabung")
                TextFormField(
                  controller: controller2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Tinggi (cm)",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan tinggi';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Masukkan angka lebih besar dari nol';
                    }
                    return null;
                  },
                ),

              SizedBox(height: 16),

              // Tombol untuk menghitung volume
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background
                  foregroundColor: Colors.white, // text
                ),
                onPressed: hitungVolume,
                child: Text("Hitung"),
              ),

              SizedBox(height: 16),

              // Menampilkan hasil perhitungan
              Text(
                "Hasil: ${hasil.toStringAsFixed(2)} cm³",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
