import 'package:flutter/material.dart';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';
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

class ClubDirectoryScreen extends StatefulWidget {
  const ClubDirectoryScreen({super.key});

  @override
  State<ClubDirectoryScreen> createState() => _ClubDirectoryScreenState();
}

class _ClubDirectoryScreenState extends State<ClubDirectoryScreen> {
  final List<Map<String, String>> allClubs = const [
    {
      'name': 'Mozilla Firefox Club',
      'image': 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?q=80&w=1000',
      'desc': 'Open-source community fostering web innovation.',
      'category': 'Tech',
      'logo': '🦊'
    },
    {
      'name': 'Music Club',
      'image': 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?q=80&w=1000',
      'desc': 'Harmonize your passion for melodies and rhythms.',
      'category': 'Arts',
      'logo': '🎵'
    },
    {
      'name': 'Dance Club',
      'image': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=1000',
      'desc': 'Express yourself through movement and choreography.',
      'category': 'Arts',
      'logo': '💃'
    },
    {
      'name': 'Events Club',
      'image': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=1000',
      'desc': 'Orchestrate memorable campus experiences.',
      'category': 'Management',
      'logo': '🎉'
    },
    {
      'name': 'Students Welfare Club',
      'image': 'https://images.unsplash.com/photo-1559027615-cd4628902d4a?q=80&w=1000',
      'desc': 'Championing student rights and well-being.',
      'category': 'Social',
      'logo': '🤝'
    },
    {
      'name': 'Cycling Club',
      'image': 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?q=80&w=1000',
      'desc': 'Pedal towards fitness and adventure together.',
      'category': 'Sports',
      'logo': '🚴'
    },
  ];

  List<Map<String, String>> filteredClubs = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Tech', 'Arts', 'Sports', 'Social', 'Management'];

  @override
  void initState() {
    super.initState();
    filteredClubs = allClubs;
  }

  void _filterClubs() {
    setState(() {
      filteredClubs = allClubs.where((club) {
        final matchesSearch = club['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            club['desc']!.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory = selectedCategory == 'All' || club['category'] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

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
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Admin Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.cyanAccent),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Passcode",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Colors.cyanAccent),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              if (nameCtrl.text == "ADMIN" && passCtrl.text == "ADMIN") {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboard()),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Access Denied"), backgroundColor: Colors.redAccent),
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
      appBar: AppBar(
        title: const Text("NEXUS CLUB HUB"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                _filterClubs();
              },
              decoration: InputDecoration(
                hintText: "Search clubs...",
                prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                        _filterClubs();
                      });
                    },
                    backgroundColor: const Color(0xFF1E293B),
                    selectedColor: Colors.cyanAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredClubs.isEmpty
                ? const Center(child: Text("No clubs found"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredClubs.length,
                    itemBuilder: (context, index) => _buildClubCard(context, filteredClubs[index]),
                  ),
          ),
        ],
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
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(club['image']!),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: Colors.cyanAccent, borderRadius: BorderRadius.circular(15)),
                  child: Center(child: Text(club['logo']!, style: const TextStyle(fontSize: 30))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(club['name']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                      Text(club['category']!, style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Text(club['desc']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black),
                onPressed: () => _showEnrollmentForm(context, club['name']!),
                child: const Text("JOIN NOW", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnrollmentForm(BuildContext context, String clubName) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final emailController = TextEditingController();
    final interestController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Register for $clubName", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                const SizedBox(height: 20),
                TextFormField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name *", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: idController, decoration: const InputDecoration(labelText: "Student ID *", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: emailController, decoration: const InputDecoration(labelText: "Email *", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: interestController, maxLines: 3, decoration: const InputDecoration(labelText: "Interest Statement *", border: OutlineInputBorder())),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        String uniqueKey = "NX-${Random().nextInt(9999).toString().padLeft(4, '0')}";
                        globalEnrollments.add({
                          'name': nameController.text.trim(),
                          'id': idController.text.trim(),
                          'email': emailController.text.trim(),
                          'interest': interestController.text.trim(),
                          'club': clubName,
                          'unique_key': uniqueKey,
                        });
                        Navigator.pop(context);
                        _showMemberCard(context, nameController.text, uniqueKey, clubName, idController.text);
                      }
                    },
                    child: const Text("SUBMIT APPLICATION", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- FIXED MEMBER CARD FUNCTION ---
  void _showMemberCard(BuildContext context, String name, String key, String club, String studentId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.cyanAccent, width: 2),
        ),
        child: SingleChildScrollView( // FIXED OVERFLOW HERE
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, color: Colors.cyanAccent, size: 50),
                const SizedBox(height: 10),
                const Text("DIGITAL MEMBER CARD", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.cyanAccent)),
                const Divider(color: Colors.white24, height: 40),
                Text(name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text("Student ID: $studentId", style: const TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: QrImageView( // FIXED QR VISIBILITY HERE
                    data: 'NEXUS-CLUB:$key:$name:$club:$studentId',
                    version: QrVersions.auto,
                    size: 150,
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.cyanAccent)),
                  child: Text("UNIQUE ID: $key", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 12),
                Text(club.toUpperCase(), style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE", style: TextStyle(color: Colors.white38))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
