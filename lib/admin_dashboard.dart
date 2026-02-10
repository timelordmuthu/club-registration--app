import 'package:flutter/material.dart';
import 'main.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN PANEL - MUTHU"), 
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: globalEnrollments.isEmpty
          ? const Center(child: Text("No records found.", style: TextStyle(color: Colors.white38)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: globalEnrollments.length,
              itemBuilder: (context, index) {
                final student = globalEnrollments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                      ),
                      child: Text(
                        student['unique_key']!, 
                        style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)
                      ),
                    ),
                    title: Text(student['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text("ID: ${student['id']} | Club: ${student['club']}", style: const TextStyle(color: Colors.white70)),
                    trailing: const Icon(Icons.verified, color: Colors.greenAccent, size: 20),
                  ),
                );
              },
            ),
    );
  }
}