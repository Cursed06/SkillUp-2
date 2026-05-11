import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('My Projects', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('4 projects showcased', style: TextStyle(color: Colors.white54, fontSize: 15)),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: const Color(0xFF13B5EA), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 32),

            _buildProjectCard(
              title: 'E-Commerce Platform',
              description: 'Full-stack e-commerce solution with React, Node.js, and PostgreSQL. Features include user authentication, shopping cart, and payment integration.',
              tags: ['React', 'Node.js', 'PostgreSQL', 'Stripe'],
              hasCode: true, hasDemo: true,
            ),
            _buildProjectCard(
              title: 'Task Management App',
              description: 'Real-time collaborative task manager built with React and Firebase. Supports team workspaces and notifications.',
              tags: ['React', 'Firebase', 'Tailwind CSS'],
              hasCode: true, hasDemo: true,
            ),
            _buildProjectCard(
              title: 'Weather Dashboard',
              description: 'Weather forecasting dashboard using OpenWeather API with interactive charts and location-based predictions.',
              tags: ['TypeScript', 'Next.js', 'Chart.js', 'API'],
              hasCode: true, hasDemo: false,
            ),
            _buildProjectCard(
              title: 'Portfolio Website',
              description: 'Personal portfolio showcasing projects and skills with smooth animations and responsive design.',
              tags: ['React', 'Motion', 'Tailwind CSS'],
              hasCode: false, hasDemo: true,
            ),

            _buildAddProjectCard(),

            Row(
              children: [
                _buildStatCard('4', 'Projects', const Color(0xFF13B5EA)),
                _buildStatCard('14', 'Tech Stack', const Color(0xFFFF2E93)),
                _buildStatCard('3', 'Live Demos', const Color(0xFFB066FF)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String description,
    required List<String> tags,
    bool hasCode = true,
    bool hasDemo = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF151C2C), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          Wrap(children: tags.map((t) => _buildChip(t)).toList()),
          const SizedBox(height: 16),
          Row(
            children: [
              if (hasCode) ...[
                _buildButton('Code', Icons.code, false),
                if (hasDemo) const SizedBox(width: 12),
              ],
              if (hasDemo) _buildButton('Demo', Icons.open_in_new, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF1C2438), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    );
  }

  Widget _buildButton(String label, IconData icon, bool isPrimary) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF162544) : const Color(0xFF1C2438),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isPrimary ? const Color(0xFF13B5EA) : Colors.white),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isPrimary ? const Color(0xFF13B5EA) : Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProjectCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A354E), width: 2),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: const Color(0xFF1C2438), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add, color: Colors.white54),
            ),
            const SizedBox(height: 16),
            const Text('Add New Project', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Showcase your latest work', style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFF151C2C), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
