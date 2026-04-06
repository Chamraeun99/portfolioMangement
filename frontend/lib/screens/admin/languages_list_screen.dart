import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class LanguagesListScreen extends StatefulWidget {
  const LanguagesListScreen({super.key});

  @override
  State<LanguagesListScreen> createState() => _LanguagesListScreenState();
}

class _LanguagesListScreenState extends State<LanguagesListScreen> {
  List<dynamic> _languages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _languages = await ApiService.getList('languages');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this language?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.delete('languages', id);
      _load();
    }
  }

  void _openForm([Map<String, dynamic>? language]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _LanguageFormDialog(language: language),
    );
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Languages', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.add, color: Color(0xFF6C63FF)), onPressed: () => _openForm())],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _languages.isEmpty
              ? const Center(child: Text('No languages yet', style: TextStyle(color: Colors.white38)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _languages.length,
                    itemBuilder: (ctx, i) {
                      final lang = _languages[i];
                      final percent = (lang['percent'] as num?)?.toDouble() ?? 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(lang['name'] ?? '', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                                      Text(lang['level'] ?? '', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Text('${(percent * 100).round()}%', style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
                                IconButton(icon: const Icon(Icons.edit, color: Color(0xFF6C63FF), size: 18), onPressed: () => _openForm(lang)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18), onPressed: () => _delete(lang['id'])),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: const Color(0xFF16213E),
                                color: const Color(0xFF6C63FF),
                                minHeight: 8,
                              ),
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

class _LanguageFormDialog extends StatefulWidget {
  final Map<String, dynamic>? language;
  const _LanguageFormDialog({this.language});

  @override
  State<_LanguageFormDialog> createState() => _LanguageFormDialogState();
}

class _LanguageFormDialogState extends State<_LanguageFormDialog> {
  final _nameCtrl = TextEditingController();
  final _levelCtrl = TextEditingController();
  double _percent = 0.5;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.language != null) {
      _nameCtrl.text = widget.language!['name'] ?? '';
      _levelCtrl.text = widget.language!['level'] ?? '';
      _percent = (widget.language!['percent'] as num?)?.toDouble() ?? 0.5;
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _levelCtrl.text.isEmpty) return;
    setState(() => _saving = true);
    final data = {
      'name': _nameCtrl.text,
      'level': _levelCtrl.text,
      'percent': _percent,
    };
    if (widget.language != null) {
      await ApiService.update('languages', widget.language!['id'], data);
    } else {
      await ApiService.create('languages', data);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: Text(widget.language != null ? 'Edit Language' : 'Add Language', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField('Language Name', _nameCtrl),
            _dialogField('Level', _levelCtrl),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Proficiency: ', style: TextStyle(color: Colors.white54)),
                Text('${(_percent * 100).round()}%', style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
              ],
            ),
            Slider(
              value: _percent,
              onChanged: (v) => setState(() => _percent = (v * 20).round() / 20), // steps of 5%
              activeColor: const Color(0xFF6C63FF),
              inactiveColor: const Color(0xFF16213E),
            ),
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
          labelText: label, labelStyle: const TextStyle(color: Colors.white54),
          filled: true, fillColor: const Color(0xFF16213E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
