import 'package:flutter/material.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            const Text(
              'Skill Checklist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Track your mastered skills',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),

            // --- Overall Progress Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151C2C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overall Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: Color(0xFF13B5EA), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '58%',
                            style: TextStyle(
                              color: const Color(0xFF13B5EA).withValues(alpha: 0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF222B40),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.58,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF13B5EA), Color(0xFF2C6CFF)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('7 of 12 skills mastered', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      Text('5 to go', style: TextStyle(color: Color(0xFF13B5EA), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Hard Skills Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151C2C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF13B5EA),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Hard Skills',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSkillItem('React.js', true, const Color(0xFF13B5EA)),
                  _buildSkillItem('TypeScript', true, const Color(0xFF13B5EA)),
                  _buildSkillItem('Node.js', false, const Color(0xFF13B5EA)),
                  _buildSkillItem('Python', true, const Color(0xFF13B5EA)),
                  _buildSkillItem('SQL/Database', false, const Color(0xFF13B5EA)),
                  _buildSkillItem('Git & GitHub', true, const Color(0xFF13B5EA)),
                  _buildSkillItem('REST APIs', false, const Color(0xFF13B5EA)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Soft Skills Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151C2C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF2E93),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Soft Skills',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSkillItem('Communication', true, const Color(0xFFB066FF)),
                  _buildSkillItem('Teamwork', true, const Color(0xFFB066FF)),
                  _buildSkillItem('Problem Solving', true, const Color(0xFFB066FF)),
                  _buildSkillItem('Time Management', false, const Color(0xFFB066FF)),
                  _buildSkillItem('Leadership', false, const Color(0xFFB066FF)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Skills to Improve Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1616), // Dark reddish brown
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE65C00).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.error_outline, color: Color(0xFFFF9800), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Skills to Improve',
                        style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildImprovementItem('Node.js'),
                  _buildImprovementItem('SQL/Database'),
                  _buildImprovementItem('REST APIs'),
                  _buildImprovementItem('Time Management'),
                  _buildImprovementItem('Leadership'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(String name, bool isChecked, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2438),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A354E).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            color: isChecked ? accentColor : Colors.white24,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
