import 'dart:convert';
import 'dart:typed_data'; // Use this instead of dart:io
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:skillup/loading_overlay.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
// DO NOT IMPORT DART:IO

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

  // The Vercel URL you verified earlier
  final String _apiUrl = 'https://skillup-api.vercel.app/api/match';

  /// Picks a PDF and extracts text using memory bytes (Web Compatible)
  Future<void> _pickAndExtractCV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // This is the most important line
      );

      if (result == null || result.files.isEmpty) return;

      setState(() => _isAnalyzing = true);

      // Web does not support .path, so we use .bytes directly
      final Uint8List? fileBytes = result.files.first.bytes;
      
      if (fileBytes != null) {
        // Initialize Syncfusion PDF document from memory bytes
        final PdfDocument document = PdfDocument(inputBytes: fileBytes);
        
        // Extract text content from the PDF
        String extractedText = PdfTextExtractor(document).extractText();
        document.dispose();

        setState(() {
          _cvText = extractedText;
          _fileName = result.files.first.name;
          _result = null; // Reset previous results
        });

        if (extractedText.trim().isEmpty) {
          throw Exception("Could not extract text from the selected PDF.");
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'), 
            backgroundColor: Colors.redAccent
          )
        );
      }
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  /// Sends the extracted CV text and Job Title to the Vercel Backend
  Future<void> _analyzeMatch() async {
    if (_jobController.text.trim().isEmpty) {
      _showError('Please enter a job position');
      return;
    }

    if (_cvText == null || _cvText!.isEmpty) {
      _showError('Please upload your CV first');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'jobTitle': _jobController.text.trim(),
          'cvContent': _cvText, 
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _result = jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Analysis failed: $e');
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent)
      );
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
                const Center(
                  child: Text(
                    'Skill Matching', 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                  )
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Find your skill gaps for any job', 
                    style: TextStyle(color: Colors.white54, fontSize: 14)
                  )
                ),
                const SizedBox(height: 32),
                
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151C2C), 
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Job Position', 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _jobController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g., Frontend Developer...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          prefixIcon: const Icon(Icons.search, color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1C2438),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12), 
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const Text(
                        'Your CV', 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _isAnalyzing ? null : _pickAndExtractCV,
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

                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity, 
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _isAnalyzing ? null : _analyzeMatch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3E6B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.track_changes, color: Colors.white70, size: 20),
                          label: const Text(
                            'Analyze Match', 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Popular positions:', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, 
                        runSpacing: 8,
                        children: [
                          _buildChip('Frontend Developer'),
                          _buildChip('Backend Developer'),
                          _buildChip('Full Stack Engineer'),
                          _buildChip('Data Scientist'),
                        ],
                      ),
                    ],
                  ),
                ),

                if (_result != null) ...[
                  const SizedBox(height: 32),
                  _buildDarkResultCard(
                    title: "Match Score", 
                    icon: Icons.analytics_outlined, 
                    color: Colors.blueAccent,
                    content: Text(
                      "${_result!['matchScore']}%", 
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDarkResultCard(
                    title: "Skill Gaps to Fill", 
                    icon: Icons.radar, 
                    color: Colors.orangeAccent,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (_result!['skillGaps'] as List).map((gap) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("• $gap", style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4)),
                        )
                      ).toList(),
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
          color: const Color(0xFF1C2438), 
          borderRadius: BorderRadius.circular(8), 
          border: Border.all(color: const Color(0xFF2A354E), width: 0.5),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ),
    );
  }

  Widget _buildDarkResultCard({required String title, required IconData icon, required Color color, required Widget content}) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C), 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: const Color(0xFF2A354E))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22), 
              const SizedBox(width: 12),
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