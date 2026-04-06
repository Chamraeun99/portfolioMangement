import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class SkillsListScreen extends StatefulWidget {
  const SkillsListScreen({super.key});

  @override
  State<SkillsListScreen> createState() => _SkillsListScreenState();
}

class _SkillsListScreenState extends State<SkillsListScreen> {
  List<dynamic> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _categories = await ApiService.getList('skill-categories');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this skill category?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.delete('skill-categories', id);
      _load();
    }
  }

  void _openForm([Map<String, dynamic>? category]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _SkillCategoryFormDialog(category: category),
    );
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Skills', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.add, color: Color(0xFF6C63FF)), onPressed: () => _openForm()),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _categories.isEmpty
              ? Center(child: Text('No skill categories yet', style: TextStyle(color: Colors.white38)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _categories.length,
                    itemBuilder: (ctx, i) {
                      final cat = _categories[i];
                      final skills = (cat['skills'] as List?)?.map((s) => s['name'].toString()).toList() ?? [];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${cat['icon'] ?? ''} ${cat['title']}', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                                const Spacer(),
                                IconButton(icon: const Icon(Icons.edit, color: Color(0xFF6C63FF), size: 18), onPressed: () => _openForm(cat)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18), onPressed: () => _delete(cat['id'])),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: skills.map((s) => Chip(
                                label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                backgroundColor: const Color(0xFF16213E),
                                side: BorderSide.none,
                              )).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _SkillCategoryFormDialog extends StatefulWidget {
  final Map<String, dynamic>? category;
  const _SkillCategoryFormDialog({this.category});

  @override
  State<_SkillCategoryFormDialog> createState() => _SkillCategoryFormDialogState();
}

class _SkillCategoryFormDialogState extends State<_SkillCategoryFormDialog> {
  final _titleCtrl = TextEditingController();
  final _iconCtrl = TextEditingController();
  final _itemsCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _titleCtrl.text = widget.category!['title'] ?? '';
      _iconCtrl.text = widget.category!['icon'] ?? '';
      final skills = (widget.category!['skills'] as List?)?.map((s) => s['name'].toString()).join(', ') ?? '';
      _itemsCtrl.text = skills;
    }
  }

  Future<void> _save() async {
    if (_titleCtrl.text.isEmpty) return;
    setState(() => _saving = true);
    final data = {
      'title': _titleCtrl.text,
      'icon': _iconCtrl.text,
      'items': _itemsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    };
    if (widget.category != null) {
      await ApiService.update('skill-categories', widget.category!['id'], data);
    } else {
      await ApiService.create('skill-categories', data);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: Text(widget.category != null ? 'Edit Category' : 'Add Category', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField('Title', _titleCtrl),
            _dialogField('Icon (emoji)', _iconCtrl),
            _dialogField('Skills (comma-separated)', _itemsCtrl),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _dialogField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF16213E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
