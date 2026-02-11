import 'package:flutter/material.dart';
import 'main.dart'; // Accesses your globalEnrollments

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Hardcoded list of clubs to ensure order
  final List<String> clubNames = [
    'Mozilla Firefox Club',
    'Music Club',
    'Dance Club',
    'Events Club',
    'Students Welfare Club',
    'Cycling Club',
  ];

  // Helper to get students for a specific club
  List<Map<String, String>> getStudentsForClub(String clubName) {
    return globalEnrollments.where((e) => e['club'] == clubName).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN DASHBOARD"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. STATS CARDS
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Total Students",
                    globalEnrollments.length.toString(),
                    Icons.people,
                    Colors.cyanAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Active Clubs",
                    clubNames.where((c) => getStudentsForClub(c).isNotEmpty).length.toString(),
                    Icons.category,
                    Colors.purpleAccent,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // 2. COLLAPSIBLE CLUB LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clubNames.length,
              itemBuilder: (context, index) {
                final clubName = clubNames[index];
                final students = getStudentsForClub(clubName);
                final studentCount = students.length;

                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: studentCount > 0 
                          ? Colors.cyanAccent.withOpacity(0.3) 
                          : Colors.white10,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: studentCount > 0 ? Colors.cyanAccent.withOpacity(0.2) : Colors.white10,
                        child: Icon(
                          Icons.groups, 
                          color: studentCount > 0 ? Colors.cyanAccent : Colors.white24
                        ),
                      ),
                      title: Text(
                        clubName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "$studentCount Students Enrolled",
                        style: TextStyle(
                          color: studentCount > 0 ? Colors.greenAccent : Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.all(16),
                      children: students.isEmpty 
                        ? [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "No enrollments yet.",
                                style: TextStyle(color: Colors.white24, fontStyle: FontStyle.italic),
                              ),
                            )
                          ]
                        : students.map((student) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.white54, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student['name']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${student['id']} • ${student['email']}",
                                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
