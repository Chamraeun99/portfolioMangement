import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  List<dynamic> _education = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _education = await ApiService.getList('education');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this education record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.delete('education', id);
      _load();
    }
  }

  void _openForm([Map<String, dynamic>? edu]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _EducationFormDialog(education: edu),
    );
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Education', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.add, color: Color(0xFF6C63FF)), onPressed: () => _openForm())],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _education.isEmpty
              ? const Center(child: Text('No education records yet', style: TextStyle(color: Colors.white38)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _education.length,
                    itemBuilder: (ctx, i) {
                      final edu = _education[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: const Color(0xFF6C63FF).withAlpha(30), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.school, color: Color(0xFF6C63FF), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(edu['degree'] ?? '', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text('${edu['institution'] ?? ''} • ${edu['period'] ?? ''}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                  if (edu['detail'] != null) Text(edu['detail'], style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                ],
                              ),
                            ),
                            IconButton(icon: const Icon(Icons.edit, color: Color(0xFF6C63FF), size: 18), onPressed: () => _openForm(edu)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18), onPressed: () => _delete(edu['id'])),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _EducationFormDialog extends StatefulWidget {
  final Map<String, dynamic>? education;
  const _EducationFormDialog({this.education});

  @override
  State<_EducationFormDialog> createState() => _EducationFormDialogState();
}

class _EducationFormDialogState extends State<_EducationFormDialog> {
  final _degreeCtrl = TextEditingController();
  final _instCtrl = TextEditingController();
  final _periodCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.education != null) {
      _degreeCtrl.text = widget.education!['degree'] ?? '';
      _instCtrl.text = widget.education!['institution'] ?? '';
      _periodCtrl.text = widget.education!['period'] ?? '';
      _detailCtrl.text = widget.education!['detail'] ?? '';
    }
  }

  Future<void> _save() async {
    if (_degreeCtrl.text.isEmpty || _instCtrl.text.isEmpty || _periodCtrl.text.isEmpty) return;
    setState(() => _saving = true);
    final data = {
      'degree': _degreeCtrl.text,
      'institution': _instCtrl.text,
      'period': _periodCtrl.text,
      'detail': _detailCtrl.text,
    };
    if (widget.education != null) {
      await ApiService.update('education', widget.education!['id'], data);
    } else {
      await ApiService.create('education', data);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: Text(widget.education != null ? 'Edit Education' : 'Add Education', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField('Degree', _degreeCtrl),
            _dialogField('Institution', _instCtrl),
            _dialogField('Period', _periodCtrl),
            _dialogField('Detail', _detailCtrl),
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
