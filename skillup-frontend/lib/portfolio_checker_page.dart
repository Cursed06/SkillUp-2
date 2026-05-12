import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'loading_overlay.dart';

class PortfolioCheckerPage extends StatefulWidget {
  const PortfolioCheckerPage({super.key});

  @override
  State<PortfolioCheckerPage> createState() => _PortfolioCheckerPageState();
}

class _PortfolioCheckerPageState extends State<PortfolioCheckerPage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result;

  final String _apiUrl = 'https://skillup-api.vercel.app/api/match';

  Future<void> _uploadAndAnalyzeFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['pdf'],
    );
    if (fileResult == null || fileResult.files.single.path == null) return;

    setState(() { _isAnalyzing = true; _result = null; });

    try {
      File file = File(fileResult.files.single.path!);
      final List<int> bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      String extractedText = PdfTextExtractor(document).extractText();
      document.dispose();

      _sendToBackend("Portfolio File Analysis", extractedText);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _analyzeUrl() async {
    if (_urlController.text.trim().isEmpty) {
      _showError("Please enter a valid URL first.");
      return;
    }
    setState(() { _isAnalyzing = true; _result = null; });
    // In a real app, backend would scrape the URL. For MVP, we pass the URL as content.
    _sendToBackend("Portfolio Website Analysis", "Analyze portfolio at: ${_urlController.text}");
  }

  Future<void> _sendToBackend(String jobTitle, String content) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'jobTitle': jobTitle, 'cvContent': content}),
      );

      if (response.statusCode == 200) {
        setState(() => _result = jsonDecode(response.body));
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  void _showError(String message) {
    setState(() => _isAnalyzing = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
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
                const Center(child: Text('Portfolio Checker', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                const Center(child: Text('AI-powered portfolio analysis', style: TextStyle(color: Colors.white54, fontSize: 14))),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFF151C2C), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Upload Portfolio', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      
                      InkWell(
                        onTap: _isAnalyzing ? null : _uploadAndAnalyzeFile,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            color: Colors.transparent, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2A354E), width: 1.5),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.upload_file, color: Colors.white54, size: 32),
                              SizedBox(height: 12),
                              Text('Tap to Upload Portfolio Files', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              SizedBox(height: 4),
                              Text('PDF, ZIP, or multiple files', style: TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Color(0xFF2A354E))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: TextStyle(color: Colors.white54, fontSize: 12))),
                          Expanded(child: Divider(color: Color(0xFF2A354E))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _urlController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Paste portfolio URL',
                                hintStyle: const TextStyle(color: Colors.white38),
                                filled: true,
                                fillColor: const Color(0xFF1C2438),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(colors: [Color(0xFF13B5EA), Color(0xFF2C6CFF)]),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _isAnalyzing ? null : _analyzeUrl,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                              label: const Text('Analyze', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Results UI
                if (_result != null) ...[
                  const SizedBox(height: 32),
                  _buildDarkResultCard(
                    title: "Portfolio Score", icon: Icons.analytics_outlined, color: Colors.blueAccent,
                    content: Text("${_result!['matchScore']}/100", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  _buildDarkResultCard(
                    title: "Actionable Feedback", icon: Icons.edit_document, color: Colors.greenAccent,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (_result!['cvFeedback'] as List).map((fb) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• ", style: TextStyle(fontSize: 16, color: Colors.white70)),
                            Expanded(child: Text(fb.toString(), style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5))),
                          ],
                        ),
                      )).toList(),
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
