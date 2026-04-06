import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class ExperiencesListScreen extends StatefulWidget {
  const ExperiencesListScreen({super.key});

  @override
  State<ExperiencesListScreen> createState() => _ExperiencesListScreenState();
}

class _ExperiencesListScreenState extends State<ExperiencesListScreen> {
  List<dynamic> _experiences = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _experiences = await ApiService.getList('experiences');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this experience?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.delete('experiences', id);
      _load();
    }
  }

  void _openForm([Map<String, dynamic>? experience]) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => _ExperienceFormScreen(experience: experience)));
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Experiences', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.add, color: Color(0xFF6C63FF)), onPressed: () => _openForm())],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _experiences.isEmpty
              ? const Center(child: Text('No experiences yet', style: TextStyle(color: Colors.white38)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _experiences.length,
                    itemBuilder: (ctx, i) {
                      final exp = _experiences[i];
                      final skills = (exp['skills'] as List?)?.cast<String>() ?? [];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(exp['role'] ?? '', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15))),
                                IconButton(icon: const Icon(Icons.edit, color: Color(0xFF6C63FF), size: 18), onPressed: () => _openForm(exp)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18), onPressed: () => _delete(exp['id'])),
                              ],
                            ),
                            Text('${exp['company'] ?? ''} • ${exp['period'] ?? ''}', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                            if (exp['location'] != null) Text(exp['location'], style: const TextStyle(color: Colors.white38, fontSize: 12)),
                            if (exp['description'] != null) ...[
                              const SizedBox(height: 8),
                              Text(exp['description'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                            if (skills.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(spacing: 6, runSpacing: 4, children: skills.map((s) => Chip(label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 11)), backgroundColor: const Color(0xFF16213E), side: BorderSide.none, visualDensity: VisualDensity.compact)).toList()),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _ExperienceFormScreen extends StatefulWidget {
  final Map<String, dynamic>? experience;
  const _ExperienceFormScreen({this.experience});

  @override
  State<_ExperienceFormScreen> createState() => _ExperienceFormScreenState();
}

class _ExperienceFormScreenState extends State<_ExperienceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _periodCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.experience != null) {
      final e = widget.experience!;
      _roleCtrl.text = e['role'] ?? '';
      _companyCtrl.text = e['company'] ?? '';
      _periodCtrl.text = e['period'] ?? '';
      _locationCtrl.text = e['location'] ?? '';
      _descCtrl.text = e['description'] ?? '';
      _skillsCtrl.text = (e['skills'] as List?)?.join(', ') ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'role': _roleCtrl.text,
      'company': _companyCtrl.text,
      'period': _periodCtrl.text,
      'location': _locationCtrl.text,
      'description': _descCtrl.text,
      'skills': _skillsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    };
    if (widget.experience != null) {
      await ApiService.update('experiences', widget.experience!['id'], data);
    } else {
      await ApiService.create('experiences', data);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(widget.experience != null ? 'Edit Experience' : 'Add Experience', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _field('Role', _roleCtrl, required: true),
                _field('Company', _companyCtrl, required: true),
                _field('Period', _periodCtrl, required: true, hint: 'e.g. 2024 – Present'),
                _field('Location', _locationCtrl),
                _field('Description', _descCtrl, maxLines: 3),
                _field('Skills (comma-separated)', _skillsCtrl),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: _saving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Save', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {bool required = false, String? hint, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        validator: required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
        decoration: InputDecoration(
          labelText: label, labelStyle: const TextStyle(color: Colors.white54),
          hintText: hint, hintStyle: const TextStyle(color: Colors.white24),
          filled: true, fillColor: const Color(0xFF16213E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
