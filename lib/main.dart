import 'package:flutter/material.dart';
import 'dart:math'; 
import 'admin_dashboard.dart';

// GLOBAL DATA PIPELINE
List<Map<String, String>> globalEnrollments = [];

void main() {
  runApp(const NexusClubHub());
}

class NexusClubHub extends StatelessWidget {
  const NexusClubHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: Colors.cyanAccent,
      ),
      home: const ClubDirectoryScreen(),
    );
  }
}

class ClubDirectoryScreen extends StatelessWidget {
  const ClubDirectoryScreen({super.key});

  final List<Map<String, String>> clubs = const [
    {
      'name': 'Robotics Collective',
      'image': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=1000',
      'desc': 'Build the future with AI and hardware.'
    },
    {
      'name': 'Design Guild',
      'image': 'https://images.unsplash.com/photo-1561070791-2526d30994b5?q=80&w=1000',
      'desc': 'Visual storytelling and UI/UX design.'
    },
    {
      'name': 'Coding Titans',
      'image': 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=1000',
      'desc': 'Competitive programming and dev projects.'
    },
  ];

  void _showAdminLogin(BuildContext context) {
    final nameCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Admin Access", style: TextStyle(color: Colors.cyanAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Admin Name")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Passcode")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameCtrl.text == "MUTHU" && passCtrl.text == "MUTHU") {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Access Denied: Invalid Credentials"), backgroundColor: Colors.redAccent),
                );
              }
            },
            child: const Text("LOGIN", style: TextStyle(color: Colors.cyanAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NEXUS CLUB HUB"), centerTitle: true, backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: clubs.length,
        itemBuilder: (context, index) => _buildClubCard(context, clubs[index]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyanAccent,
        onPressed: () => _showAdminLogin(context),
        label: const Text("ADMIN PANEL", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.lock, color: Colors.black),
      ),
    );
  }

  Widget _buildClubCard(BuildContext context, Map<String, String> club) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(club['image']!), fit: BoxFit.cover, opacity: 0.4),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: ListTile(
          title: Text(club['name']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
          subtitle: Text(club['desc']!, style: const TextStyle(color: Colors.white)),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
            onPressed: () => _showEnrollmentForm(context, club['name']!),
            child: const Text("JOIN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void _showEnrollmentForm(BuildContext context, String clubName) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Register for $clubName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: idController, decoration: const InputDecoration(labelText: "Student ID")),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                onPressed: () {
                  String uniqueKey = "NX-${Random().nextInt(9999).toString().padLeft(4, '0')}";
                  globalEnrollments.add({
                    'name': nameController.text,
                    'id': idController.text,
                    'club': clubName,
                    'unique_key': uniqueKey,
                  });
                  Navigator.pop(context);
                  _showMemberCard(context, nameController.text, uniqueKey, clubName);
                },
                child: const Text("SUBMIT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showMemberCard(BuildContext context, String name, String key, String club) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
          side: const BorderSide(color: Colors.cyanAccent, width: 2)
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user, color: Colors.cyanAccent, size: 50),
              const SizedBox(height: 10),
              const Text("DIGITAL MEMBER CARD", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.cyanAccent)),
              const Divider(color: Colors.white24, height: 40),
              Text(name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              // Main focus is now the Unique ID
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.cyanAccent),
                ),
                child: Text(
                  "UNIQUE ID: $key", 
                  style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20)
                ),
              ),
              const SizedBox(height: 12),
              Text("OFFICIAL MEMBER OF $club", style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text("CLOSE", style: TextStyle(color: Colors.white38))
              ),
            ],
          ),
        ),
      ),
    );
  }
}