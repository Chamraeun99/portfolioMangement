import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  List<dynamic> _projects = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _projects = await ApiService.getList('projects');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this project?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.delete('projects', id);
      _load();
    }
  }

  void _openForm([Map<String, dynamic>? project]) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => _ProjectFormScreen(project: project)));
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Projects', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.add, color: Color(0xFF6C63FF)), onPressed: () => _openForm())],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _projects.isEmpty
              ? const Center(child: Text('No projects yet', style: TextStyle(color: Colors.white38)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _projects.length,
                    itemBuilder: (ctx, i) {
                      final p = _projects[i];
                      final techStack = (p['tech_stack'] as List?)?.cast<String>() ?? [];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${p['icon'] ?? ''} ', style: const TextStyle(fontSize: 20)),
                                Expanded(child: Text(p['title'] ?? '', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15))),
                                if (p['type'] != null) Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFF6C63FF).withAlpha(30), borderRadius: BorderRadius.circular(6)),
                                  child: Text(p['type'], style: const TextStyle(color: Color(0xFF6C63FF), fontSize: 11)),
                                ),
                                IconButton(icon: const Icon(Icons.edit, color: Color(0xFF6C63FF), size: 18), onPressed: () => _openForm(p)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18), onPressed: () => _delete(p['id'])),
                              ],
                            ),
                            if (p['description'] != null) ...[
                              const SizedBox(height: 8),
                              Text(p['description'], style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                            ],
                            if (techStack.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(spacing: 6, runSpacing: 4, children: techStack.map((t) => Chip(label: Text(t, style: const TextStyle(color: Colors.white, fontSize: 11)), backgroundColor: const Color(0xFF16213E), side: BorderSide.none, visualDensity: VisualDensity.compact)).toList()),
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

class _ProjectFormScreen extends StatefulWidget {
  final Map<String, dynamic>? project;
  const _ProjectFormScreen({this.project});

  @override
  State<_ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<_ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _iconCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _techCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      final p = widget.project!;
      _titleCtrl.text = p['title'] ?? '';
      _iconCtrl.text = p['icon'] ?? '';
      _typeCtrl.text = p['type'] ?? '';
      _descCtrl.text = p['description'] ?? '';
      _techCtrl.text = (p['tech_stack'] as List?)?.join(', ') ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'title': _titleCtrl.text,
      'icon': _iconCtrl.text,
      'type': _typeCtrl.text,
      'description': _descCtrl.text,
      'tech_stack': _techCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    };
    if (widget.project != null) {
      await ApiService.update('projects', widget.project!['id'], data);
    } else {
      await ApiService.create('projects', data);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(widget.project != null ? 'Edit Project' : 'Add Project', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
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
                _field('Title', _titleCtrl, required: true),
                _field('Icon (emoji)', _iconCtrl, hint: 'e.g. 🛒'),
                _field('Type', _typeCtrl, hint: 'e.g. Web App'),
                _field('Description', _descCtrl, maxLines: 3),
                _field('Tech Stack (comma-separated)', _techCtrl, hint: 'e.g. Laravel, MySQL'),
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
