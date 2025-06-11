import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'addtask.dart';
import 'auth_service.dart';
import 'edittask.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? _editingDocId;

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime); 
  }

  Future<void> addTask(String text) async {
    if (text.isEmpty) return;
    await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('tasks').add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _controller.clear();
  }

  Future<void> updateTask(String docId, String text) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .doc(docId)
        .update({'text': text});
    _controller.clear();
    _editingDocId = null;
  }

  Future<void> deleteTask(String docId) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .doc(docId)
        .delete();
  }

  void _signOut() async {
    await AuthService().signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final tasksRef = _firestore.collection('users').doc(_auth.currentUser!.uid).collection('tasks').orderBy('timestamp');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF48C2C6),
        centerTitle: true,
          automaticallyImplyLeading: false,
        title: Text(
          "Skedulo",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasksRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final tasks = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final doc = tasks[index];
                    final text = doc['text'];
                    final timestamp = doc['timestamp'];

                    String timestampStr = '';
                    if (timestamp != null) {
                      timestampStr = formatTimestamp(timestamp);
                    }

                    return Card(
                      color: Color.fromARGB(255, 136, 214, 217),
                      child: ListTile(
                        title: Text(
                          text,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: timestampStr.isNotEmpty
                            ? Text(
                                'Di jadwalkan pada: $timestampStr',
                                style: TextStyle(color: Colors.white70),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskScreen(
                                      docId: doc.id,
                                      existingText: text,
                                      existingDateTime: timestamp.toDate(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () => deleteTask(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF48C2C6),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
