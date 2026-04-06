import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../login_screen.dart';
import '../portfolio_screen.dart';
import 'profile_form_screen.dart';
import 'skills_list_screen.dart';
import 'experiences_list_screen.dart';
import 'education_list_screen.dart';
import 'projects_list_screen.dart';
import 'languages_list_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _profile;
  int _skillCount = 0;
  int _experienceCount = 0;
  int _educationCount = 0;
  int _projectCount = 0;
  int _languageCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        ApiService.getUser(),
        ApiService.getOne('profile'),
        ApiService.getList('skill-categories'),
        ApiService.getList('experiences'),
        ApiService.getList('education'),
        ApiService.getList('projects'),
        ApiService.getList('languages'),
      ]);
      if (!mounted) return;
      setState(() {
        _user = results[0] as Map<String, dynamic>?;
        _profile = results[1] as Map<String, dynamic>?;
        _skillCount = (results[2] as List).length;
        _experienceCount = (results[3] as List).length;
        _educationCount = (results[4] as List).length;
        _projectCount = (results[5] as List).length;
        _languageCount = (results[6] as List).length;
      });
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _navigateTo(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Admin Dashboard', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(child: Text(_user!['name'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13))),
            ),
          IconButton(
            icon: const Icon(Icons.language, color: Color(0xFF03DAC6)),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const PortfolioScreen()),
              (route) => false,
            ),
            tooltip: 'View Site',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Stats
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  // Profile summary
                  _buildProfileCard(),
                  const SizedBox(height: 24),
                  // Quick actions
                  _buildQuickActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      _StatItem('Skills', '$_skillCount', Icons.code, const Color(0xFF6C63FF)),
      _StatItem('Experiences', '$_experienceCount', Icons.work, const Color(0xFF03DAC6)),
      _StatItem('Education', '$_educationCount', Icons.school, const Color(0xFFFF9800)),
      _StatItem('Projects', '$_projectCount', Icons.rocket_launch, const Color(0xFFE91E63)),
      _StatItem('Languages', '$_languageCount', Icons.translate, const Color(0xFF2196F3)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.2,
      ),
      itemCount: stats.length,
      itemBuilder: (ctx, i) {
        final s = stats[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: s.color, width: 4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(s.label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(s.value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                ],
              ),
              Icon(s.icon, color: Colors.white24, size: 28),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF6C63FF), size: 20),
                onPressed: () => _navigateTo(const ProfileFormScreen()),
              ),
            ],
          ),
          const Divider(color: Colors.white12),
          if (_profile != null) ...[
            _profileRow('Name', _profile!['name']),
            _profileRow('Title', _profile!['title']),
            _profileRow('Email', _profile!['email']),
            _profileRow('Phone', _profile!['phone']),
            _profileRow('Location', _profile!['location']),
            _profileRow('GitHub', _profile!['github']),
          ] else
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No profile yet. Tap edit to create one.', style: TextStyle(color: Colors.white38)),
            ),
        ],
      ),
    );
  }

  Widget _profileRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13))),
          Expanded(child: Text(value ?? '–', style: const TextStyle(color: Colors.white, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _ActionItem('Edit Profile', Icons.person, () => _navigateTo(const ProfileFormScreen())),
      _ActionItem('Skills', Icons.code, () => _navigateTo(const SkillsListScreen())),
      _ActionItem('Experiences', Icons.work, () => _navigateTo(const ExperiencesListScreen())),
      _ActionItem('Education', Icons.school, () => _navigateTo(const EducationListScreen())),
      _ActionItem('Projects', Icons.rocket_launch, () => _navigateTo(const ProjectsListScreen())),
      _ActionItem('Languages', Icons.translate, () => _navigateTo(const LanguagesListScreen())),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manage Content', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...actions.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: a.onTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(a.icon, color: const Color(0xFF6C63FF), size: 20),
                    const SizedBox(width: 12),
                    Text(a.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.white24),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatItem(this.label, this.value, this.icon, this.color);
}

class _ActionItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionItem(this.label, this.icon, this.onTap);
}
