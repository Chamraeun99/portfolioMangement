import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/portfolio_data.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';

// ─── Colors ───────────────────────────────────────────────────────────────
const Color _primary = Color(0xFF6C63FF);
const Color _secondary = Color(0xFF03DAC6);
const Color _darkBg = Color(0xFF0F0E17);
const Color _cardBg = Color(0xFF1A1A2E);
const Color _surface = Color(0xFF16213E);
const Color _textPrimary = Color(0xFFEEEEEE);
const Color _textSecondary = Color(0xFF9E9E9E);

// ─── Main Screen ──────────────────────────────────────────────────────────
class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heroCtrl;
  late final AnimationController _contentCtrl;
  late final Animation<double> _heroFade;
  late final Animation<double> _heroScale;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // ─── Dynamic data from API ──────────────────────────────────────────
  bool _isLoading = true;
  String _name = '';
  String _title = '';
  String _phone = '';
  String _email = '';
  String _location = '';
  String _github = '';
  String _about = '';
  List<SkillCategory> _skills = [];
  List<String> _softSkills = [];
  List<ExperienceData> _experiences = [];
  List<EducationData> _education = [];
  List<ProjectData> _projects = [];
  List<LanguageData> _languages = [];

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _heroCtrl,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _heroScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
          parent: _heroCtrl,
          curve: const Interval(0.0, 0.8, curve: Curves.elasticOut)),
    );
    _heroSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _heroCtrl,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut),
    );

    _heroCtrl.forward();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _contentCtrl.forward();
    });

    _loadPortfolioData();
  }

  Future<void> _loadPortfolioData() async {
    try {
      final data = await ApiService.getPublicPortfolio(1);
      if (data != null && mounted) {
        final profile = data['profile'] as Map<String, dynamic>? ?? {};
        setState(() {
          _name = profile['name'] ?? PortfolioData.name;
          _title = profile['title'] ?? PortfolioData.title;
          _phone = profile['phone'] ?? PortfolioData.phone;
          _email = profile['email'] ?? PortfolioData.email;
          _location = profile['location'] ?? PortfolioData.location;
          _github = profile['github'] ?? PortfolioData.github;
          _about = profile['about'] ?? PortfolioData.about;
          _skills = (data['skills'] as List?)
                  ?.map((s) => SkillCategory.fromJson(s))
                  .toList() ??
              PortfolioData.skills;
          _softSkills = PortfolioData.softSkills;
          _experiences = (data['experiences'] as List?)
                  ?.map((e) => ExperienceData.fromJson(e))
                  .toList() ??
              PortfolioData.experiences;
          _education = (data['education'] as List?)
                  ?.map((e) => EducationData.fromJson(e))
                  .toList() ??
              PortfolioData.education;
          _projects = (data['projects'] as List?)
                  ?.map((p) => ProjectData.fromJson(p))
                  .toList() ??
              PortfolioData.projects;
          _languages = (data['languages'] as List?)
                  ?.map((l) => LanguageData.fromJson(l))
                  .toList() ??
              PortfolioData.languages;
          _isLoading = false;
        });
      } else {
        _useFallbackData();
      }
    } catch (_) {
      _useFallbackData();
    }
  }

  void _useFallbackData() {
    if (!mounted) return;
    setState(() {
      _name = PortfolioData.name;
      _title = PortfolioData.title;
      _phone = PortfolioData.phone;
      _email = PortfolioData.email;
      _location = PortfolioData.location;
      _github = PortfolioData.github;
      _about = PortfolioData.about;
      _skills = PortfolioData.skills;
      _softSkills = PortfolioData.softSkills;
      _experiences = PortfolioData.experiences;
      _education = PortfolioData.education;
      _projects = PortfolioData.projects;
      _languages = PortfolioData.languages;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _contentCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
    if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _textPrimary,
        title: Text(
          _isLoading ? '' : _name,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 18, color: _textPrimary),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF6C63FF)),
            tooltip: 'Admin Login',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())).then((_) => _loadPortfolioData());
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroSection(),
            FadeTransition(
              opacity: _contentFade,
              child: SlideTransition(
                position: _contentSlide,
                child: Column(
                  children: [
                    _buildAboutSection(),
                    _buildSkillsSection(),
                    _buildExperienceSection(),
                    _buildEducationSection(),
                    _buildProjectsSection(),
                    _buildLanguagesSection(),
                    _buildContactSection(),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Drawer ─────────────────────────────────────────────────────────────
  Widget _buildDrawer() {
    final navItems = [
      ('About', _aboutKey, Icons.person_outline),
      ('Skills', _skillsKey, Icons.code_rounded),
      ('Experience', _experienceKey, Icons.work_outline_rounded),
      ('Education', _educationKey, Icons.school_outlined),
      ('Projects', _projectsKey, Icons.rocket_launch_outlined),
      ('Contact', _contactKey, Icons.contact_mail_outlined),
    ];

    return Drawer(
      backgroundColor: _surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF4A44CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.white24,
                      child:
                          const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _name,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  'CS Student & Web Developer',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          ...navItems.map(
            (item) => ListTile(
              leading: Icon(item.$3, color: _primary),
              title: Text(item.$1,
                  style: GoogleFonts.poppins(fontSize: 14, color: _textPrimary)),
              onTap: () => _scrollToKey(item.$2),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero ────────────────────────────────────────────────────────────────
  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _heroFade,
      child: SlideTransition(
        position: _heroSlide,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF6C63FF), Color(0xFF1A1A2E)],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
          child: Column(
            children: [
              ScaleTransition(
                scale: _heroScale,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF03DAC6), Color(0xFF6C63FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        width: 120,
                        height: 120,
                        color: const Color(0xFF6C63FF),
                        child:
                            const Icon(Icons.person, color: Colors.white, size: 60),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF03DAC6)],
                ).createShader(bounds),
                child: Text(
                  _name,
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.white.withOpacity(0.85)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Color(0xFF03DAC6), size: 15),
                  const SizedBox(width: 4),
                  Text(
                    _location,
                    style:
                        GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _heroButton(Icons.phone_rounded, 'Call',
                      () => _launchUrl('tel:${_phone.replaceAll(' ', '')}')),
                  const SizedBox(width: 12),
                  _heroButton(Icons.email_rounded, 'Email',
                      () => _launchUrl('mailto:$_email')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15),
      label: Text(label,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.15),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        elevation: 0,
      ),
    );
  }

  // ─── Shared helpers ──────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon, GlobalKey key) {
    return Container(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [_primary.withOpacity(0.6), Colors.transparent]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
                color: _primary.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 4)),
          ],
        ),
        child: child,
      );

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      );

  // ─── About ───────────────────────────────────────────────────────────────
  Widget _buildAboutSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('About Me', Icons.person_outline, _aboutKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _glassCard(
              child: Text(_about,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: _textSecondary, height: 1.8)),
            ),
          ),
        ],
      );

  // ─── Skills ──────────────────────────────────────────────────────────────
  Widget _buildSkillsSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Skills', Icons.code_rounded, _skillsKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ..._skills.asMap().entries.map((e) =>
                    _AnimatedSkillCard(
                        category: e.value,
                        delay: Duration(milliseconds: 300 + e.key * 100))),
                const SizedBox(height: 4),
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.handshake_rounded,
                                color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Text('Soft Skills',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: _textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _softSkills
                            .map((s) => _chip(s, _secondary))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  // ─── Experience ──────────────────────────────────────────────────────────
  Widget _buildExperienceSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Experience', Icons.work_outline_rounded, _experienceKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children:
                  _experiences.map(_buildExpCard).toList(),
            ),
          ),
        ],
      );

  Widget _buildExpCard(ExperienceData exp) => _glassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exp.role,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _textPrimary)),
                      Text(exp.company,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: _primary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 13, color: _textSecondary),
                const SizedBox(width: 4),
                Text(exp.period,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: _textSecondary)),
                const SizedBox(width: 12),
                Icon(Icons.location_on_rounded, size: 13, color: _textSecondary),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(exp.location,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: _textSecondary))),
              ],
            ),
            const SizedBox(height: 10),
            Text(exp.description,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: _textSecondary, height: 1.6)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: exp.skills.map((s) => _chip(s, _primary)).toList(),
            ),
          ],
        ),
      );

  // ─── Education ───────────────────────────────────────────────────────────
  Widget _buildEducationSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Education', Icons.school_outlined, _educationKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: _education.asMap().entries.map((entry) {
                final isLast = entry.key == _education.length - 1;
                return _buildEduCard(entry.value, isLast);
              }).toList(),
            ),
          ),
        ],
      );

  Widget _buildEduCard(EducationData edu, bool isLast) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_primary.withOpacity(0.5), Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(edu.degree,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _textPrimary)),
                      const SizedBox(height: 4),
                      Text(edu.institution,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: _primary,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 12, color: _textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('${edu.period}  •  ${edu.detail}',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: _textSecondary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  // ─── Projects ────────────────────────────────────────────────────────────
  Widget _buildProjectsSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Projects', Icons.rocket_launch_outlined, _projectsKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: _projects.asMap().entries.map((e) =>
                  _AnimatedProjectCard(
                      project: e.value,
                      delay: Duration(milliseconds: 400 + e.key * 150))).toList(),
            ),
          ),
        ],
      );

  // ─── Languages ───────────────────────────────────────────────────────────
  Widget _buildLanguagesSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Languages', Icons.language_rounded, GlobalKey()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _glassCard(
              child: Column(
                children: _languages.map(_buildLangItem).toList(),
              ),
            ),
          ),
        ],
      );

  Widget _buildLangItem(LanguageData lang) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _textPrimary)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(lang.level,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _primary,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _AnimatedProgressBar(value: lang.percent),
          ],
        ),
      );

  // ─── Contact ─────────────────────────────────────────────────────────────
  Widget _buildContactSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Contact', Icons.contact_mail_outlined, _contactKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _glassCard(
              child: Column(
                children: [
                  _contactItem(Icons.phone_rounded, 'Phone', _phone,
                      () => _launchUrl(
                          'tel:${_phone.replaceAll(' ', '')}')),
                  Divider(height: 16, color: Colors.white.withOpacity(0.07)),
                  _contactItem(Icons.email_rounded, 'Email',
                      _email,
                      () => _launchUrl('mailto:$_email')),
                  Divider(height: 16, color: Colors.white.withOpacity(0.07)),
                  _contactItem(Icons.location_on_rounded, 'Location',
                      _location, null),
                  Divider(height: 16, color: Colors.white.withOpacity(0.07)),
                  _contactItem(Icons.code_rounded, 'GitHub',
                      _github,
                      () => _launchUrl('https://$_github')),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _contactItem(
      IconData icon, String label, String value, VoidCallback? onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    _primary.withOpacity(0.7),
                    _secondary.withOpacity(0.7)
                  ]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 17),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: _textSecondary)),
                    Text(value,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: onTap != null ? _secondary : _textPrimary,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right_rounded,
                    color: _textSecondary, size: 18),
            ],
          ),
        ),
      );

  // ─── Footer ──────────────────────────────────────────────────────────────
  Widget _buildFooter() => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: _surface,
          border: Border(top: BorderSide(color: _primary.withOpacity(0.3))),
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]).createShader(b),
              child: Text(_name,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            const SizedBox(height: 4),
            Text(_title,
                style: GoogleFonts.poppins(color: _textSecondary, fontSize: 12)),
            const SizedBox(height: 12),
            Text('© ${DateTime.now().year} • Built with Flutter',
                style: GoogleFonts.poppins(
                    color: _textSecondary.withOpacity(0.6), fontSize: 11)),
          ],
        ),
      );
}

// ─── Animated Skill Card ──────────────────────────────────────────────────
class _AnimatedSkillCard extends StatefulWidget {
  final SkillCategory category;
  final Duration delay;
  const _AnimatedSkillCard({required this.category, required this.delay});

  @override
  State<_AnimatedSkillCard> createState() => _AnimatedSkillCardState();
}

class _AnimatedSkillCardState extends State<_AnimatedSkillCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  IconData _iconFor(String title) {
    switch (title) {
      case 'Programming & Web':
        return Icons.web_rounded;
      case 'Database Management':
        return Icons.storage_rounded;
      case 'Cloud & Deployment':
        return Icons.cloud_rounded;
      case 'Office & Analytics':
        return Icons.bar_chart_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
            boxShadow: [
              BoxShadow(
                  color: _primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_iconFor(widget.category.title),
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.category.title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: _textPrimary)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.category.items
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: _primary.withOpacity(0.3)),
                          ),
                          child: Text(s,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: _primary,
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Animated Project Card ────────────────────────────────────────────────
class _AnimatedProjectCard extends StatefulWidget {
  final ProjectData project;
  final Duration delay;
  const _AnimatedProjectCard({required this.project, required this.delay});

  @override
  State<_AnimatedProjectCard> createState() => _AnimatedProjectCardState();
}

class _AnimatedProjectCardState extends State<_AnimatedProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.9, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  IconData _iconFor(String title) {
    if (title.toLowerCase().contains('store')) return Icons.shopping_cart_rounded;
    if (title.toLowerCase().contains('game')) return Icons.sports_esports_rounded;
    return Icons.rocket_launch_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
            boxShadow: [
              BoxShadow(
                  color: _primary.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)]),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              _primary.withOpacity(0.7),
                              _secondary.withOpacity(0.7)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_iconFor(widget.project.title),
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.project.title,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: _textPrimary)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _secondary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(widget.project.type,
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: _secondary,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(widget.project.description,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: _textSecondary,
                            height: 1.6)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.project.techStack
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: _primary.withOpacity(0.3)),
                                ),
                                child: Text(t,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: _primary,
                                        fontWeight: FontWeight.w500)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Animated Progress Bar ────────────────────────────────────────────────
class _AnimatedProgressBar extends StatefulWidget {
  final double value;
  const _AnimatedProgressBar({required this.value});

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (ctx, _) => ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _anim.value,
            backgroundColor: Colors.white.withOpacity(0.07),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
            minHeight: 8,
          ),
        ),
      );
}
