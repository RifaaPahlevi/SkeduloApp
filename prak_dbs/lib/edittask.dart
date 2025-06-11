import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTaskScreen extends StatefulWidget {
  final String docId;
  final String existingText;
  final DateTime existingDateTime;

  const EditTaskScreen({
    Key? key,
    required this.docId,
    required this.existingText,
    required this.existingDateTime,
  }) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingText;
    _selectedDateTime = widget.existingDateTime;
  }


  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF48C2C6),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF48C2C6),
              onPrimary: Colors.white, 
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _pickTime(picked);
    }
  }

  void _pickTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF48C2C6),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF48C2C6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        _selectedDateTime = selectedDateTime;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _selectedDateTime == null) return;

    await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('tasks').doc(widget.docId).update({
      'text': _titleController.text,
      'timestamp': Timestamp.fromDate(_selectedDateTime!),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF48C2C6),
        title: Text('Edit Task', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Task',
                  labelStyle: TextStyle(
                  color: Color.fromARGB(255, 70, 70, 70),
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDateTime == null
                        ? 'Pilih Tanggal dan Waktu'
                        : 'Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text('Pilih Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF48C2C6),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Simpan Task'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Color(0xFF48C2C6),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}