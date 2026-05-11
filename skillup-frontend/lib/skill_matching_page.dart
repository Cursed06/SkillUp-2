import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'loading_overlay.dart';

class SkillMatchingPage extends StatefulWidget {
  const SkillMatchingPage({super.key});

  @override
  State<SkillMatchingPage> createState() => _SkillMatchingPageState();
}

class _SkillMatchingPageState extends State<SkillMatchingPage> {
  final TextEditingController _jobController = TextEditingController();
  
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result;
  
  // Variables to hold the uploaded CV data
  String? _cvText;
  String? _fileName;

  final String _apiUrl = 'https://skill-up-2.vercel.app/api/match';

  Future<void> _pickAndExtractCV() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (fileResult == null || fileResult.files.single.path == null) return;

    // Show loading overlay while parsing the PDF
    setState(() => _isAnalyzing = true);

    try {
      File file = File(fileResult.files.single.path!);
      final List<int> bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      String extractedText = PdfTextExtractor(document).extractText();
      document.dispose();

      setState(() {
        _cvText = extractedText;
        _fileName = fileResult.files.single.name;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reading PDF: $e'), backgroundColor: Colors.redAccent)
        );
      }
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  Future<void> _analyzeMatch() async {
    if (_jobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a job position'), backgroundColor: Colors.redAccent)
      );
      return;
    }

    if (_cvText == null || _cvText!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your CV first'), backgroundColor: Colors.redAccent)
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jobTitle': _jobController.text,
          'cvContent': _cvText, // Now using the actual uploaded CV text!
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _result = jsonDecode(response.body));
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent)
        );
      }
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(child: Text('Skill Matching', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                const Center(child: Text('Find your skill gaps for any job', style: TextStyle(color: Colors.white54, fontSize: 14))),
                const SizedBox(height: 32),
                
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFF151C2C), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Job Position', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _jobController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g., Frontend Developer, Full Stack Engin...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          prefixIcon: const Icon(Icons.search, color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1C2438),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // --- NEW: Upload CV Section ---
                      const Text('Your CV', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _pickAndExtractCV,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2438),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _cvText != null ? const Color(0xFF13B5EA) : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _cvText != null ? Icons.check_circle : Icons.upload_file,
                                color: _cvText != null ? const Color(0xFF13B5EA) : Colors.white54,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _fileName ?? 'Tap to select your CV (PDF)',
                                  style: TextStyle(
                                    color: _cvText != null ? Colors.white : Colors.white38,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ------------------------------

                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity, height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _isAnalyzing ? null : _analyzeMatch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3E6B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.track_changes, color: Colors.white54, size: 20),
                          label: const Text('Analyze Match', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Popular positions:', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: [
                          _buildChip('Frontend Developer'),
                          _buildChip('Backend Developer'),
                          _buildChip('Full Stack Engineer'),
                          _buildChip('UX Designer'),
                        ],
                      ),
                    ],
                  ),
                ),

                if (_result != null) ...[
                  const SizedBox(height: 32),
                  _buildDarkResultCard(
                    title: "Match Score", icon: Icons.analytics_outlined, color: Colors.blueAccent,
                    content: Text("${_result!['matchScore']}%", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  _buildDarkResultCard(
                    title: "Skill Gaps to Fill", icon: Icons.radar, color: Colors.orangeAccent,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (_result!['skillGaps'] as List).map((gap) => Text("• $gap", style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5))).toList(),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ),
        if (_isAnalyzing) const LoadingOverlay(),
      ],
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () => setState(() => _jobController.text = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2438), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF2A354E), width: 0.5),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ),
    );
  }

  Widget _buildDarkResultCard({required String title, required IconData icon, required Color color, required Widget content}) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF151C2C), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A354E))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22), const SizedBox(width: 12),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
