import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateToTab;

  const HomePage({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            const Row(
              children: [
                Text(
                  'Hi, Alex ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '👋',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Let's boost your career readiness",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),

            // --- Job Readiness Card ---
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
                        'Job Readiness',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: Color(0xFF13B5EA), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '72%',
                            style: TextStyle(
                              color: const Color(0xFF13B5EA).withValues(alpha: 0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: 0.72,
                          strokeWidth: 10,
                          backgroundColor: const Color(0xFF222B40),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF13B5EA)),
                        ),
                        const Center(
                          child: Icon(Icons.bolt, color: Color(0xFF13B5EA), size: 48),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1120).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Skills Gap', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            SizedBox(height: 4),
                            Text('5 skills to master for your target role', style: TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                        const Text('28%', style: TextStyle(color: Color(0xFF13B5EA), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Top Skills ---
            const Text(
              'Top Skills',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151C2C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSkillBar('Frontend Development', '85%', 0.85, [const Color(0xFF13B5EA), const Color(0xFF2C6CFF)]),
                  const SizedBox(height: 20),
                  _buildSkillBar('UI/UX Design', '70%', 0.70, [const Color(0xFFFF2E93), const Color(0xFFFF8E53)]),
                  const SizedBox(height: 20),
                  _buildSkillBar('Backend Development', '60%', 0.60, [const Color(0xFF8A2BE2), const Color(0xFFB066FF)]),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Quick Actions ---
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickAction('Check CV', Icons.description_outlined, [const Color(0xFF13B5EA), const Color(0xFF2C6CFF)], () => onNavigateToTab?.call(3)),
            _buildQuickAction('Analyze Portfolio', Icons.work_outline, [const Color(0xFFFF2E93), const Color(0xFFFF8E53)], () => onNavigateToTab?.call(2)),
            _buildQuickAction('Skill Match', Icons.track_changes, [const Color(0xFF8A2BE2), const Color(0xFFB066FF)], () => onNavigateToTab?.call(4)),
            
            const SizedBox(height: 32),

            // --- Daily Goal ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1433), // Deep purple accent
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF5A2A9B).withValues(alpha: 0.5), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.star_outline, color: Color(0xFFB066FF), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Daily Goal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete 2 TypeScript challenges today\nto improve your skills',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D1B4E),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF8A2BE2), Color(0xFFB066FF)],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '1/2',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillBar(String label, String percent, double value, List<Color> gradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            Text(percent, style: TextStyle(color: gradient.first, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF222B40),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon, List<Color> gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151C2C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
