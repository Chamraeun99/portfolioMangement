class PortfolioData {
  static const String name = 'Rom Chamraeun';
  static const String title = 'Computer Science Student & Web Developer';
  static const String phone = '071 468 9475';
  static const String email = 'romchamraeun@gmail.com';
  static const String location = 'Km6, Phnom Penh, Cambodia';
  static const String github = 'github.com/romchamraeun';
  static const String about =
      'An energetic and eager-to-learn person who is always seeking a dynamic environment with challenges to develop myself and achieve my future career goals. Passionate about building web applications and solving real-world problems through technology.';

  static const List<SkillCategory> skills = [
    SkillCategory(
      title: 'Programming & Web',
      icon: '💻',
      items: ['HTML', 'CSS', 'JavaScript', 'PHP', 'React', 'Laravel'],
    ),
    SkillCategory(
      title: 'Database Management',
      icon: '🗄️',
      items: ['MySQL', 'PostgreSQL', 'SQL Server'],
    ),
    SkillCategory(
      title: 'Cloud & Deployment',
      icon: '☁️',
      items: ['Vercel', 'Render', 'Railway', 'Hugging Face', 'Neon', 'Ubuntu'],
    ),
    SkillCategory(
      title: 'Office & Analytics',
      icon: '📊',
      items: ['Excel', 'PowerPoint', 'PowerBI', 'Access'],
    ),
  ];

  static const List<String> softSkills = [
    'Fast Learner',
    'Critical Thinking',
    'Teamwork',
    'Working Comprehension',
    'Kind & Collaborative',
    'Energetic',
  ];

  static const List<ExperienceData> experiences = [
    ExperienceData(
      role: 'Web Developer Intern',
      company: 'Enterprise Co., Ltd.',
      period: '2024 – Present',
      location: 'Phnom Penh, Cambodia',
      description:
          'Developed and maintained web applications for the company. Collaborated with the team on full-stack web projects using PHP, JavaScript, and MySQL. Contributed to the Juice project website and internal enterprise tools.',
      skills: ['PHP', 'JavaScript', 'MySQL', 'HTML/CSS'],
    ),
  ];

  static const List<EducationData> education = [
    EducationData(
      degree: 'Bachelor of Computer Science',
      institution: 'Norton University',
      period: '2021 – Present',
      detail: 'Year 4 | Phnom Penh, Cambodia',
    ),
    EducationData(
      degree: 'High School Certificate',
      institution: 'Srayang High School',
      period: '2018 – 2021',
      detail: 'Grade: Very Good',
    ),
  ];

  static const List<ProjectData> projects = [
    ProjectData(
      title: 'Online Store',
      description:
          'A full-stack e-commerce web application with product listing, shopping cart, and checkout features. Built with Laravel and MySQL backend.',
      techStack: ['Laravel', 'MySQL', 'HTML', 'CSS', 'JavaScript'],
      type: 'Web App',
      icon: '🛒',
    ),
    ProjectData(
      title: 'Browser Game',
      description:
          'An interactive browser-based game developed using HTML5 Canvas and JavaScript. Features multiple levels and score tracking.',
      techStack: ['HTML5', 'CSS3', 'JavaScript'],
      type: 'Web Game',
      icon: '🎮',
    ),
  ];

  static const List<LanguageData> languages = [
    LanguageData(name: 'Khmer', level: 'Native', percent: 1.0),
    LanguageData(name: 'English', level: 'Working Proficiency', percent: 0.7),
  ];
}

class SkillCategory {
  final String title;
  final String icon;
  final List<String> items;
  const SkillCategory({
    required this.title,
    required this.icon,
    required this.items,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      items: (json['skills'] as List?)
              ?.map((s) => s is Map ? s['name'].toString() : s.toString())
              .toList() ??
          [],
    );
  }
}

class ExperienceData {
  final String role;
  final String company;
  final String period;
  final String location;
  final String description;
  final List<String> skills;
  const ExperienceData({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.description,
    required this.skills,
  });

  factory ExperienceData.fromJson(Map<String, dynamic> json) {
    return ExperienceData(
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      period: json['period'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      skills: (json['skills'] as List?)?.map((s) => s.toString()).toList() ?? [],
    );
  }
}

class EducationData {
  final String degree;
  final String institution;
  final String period;
  final String detail;
  const EducationData({
    required this.degree,
    required this.institution,
    required this.period,
    required this.detail,
  });

  factory EducationData.fromJson(Map<String, dynamic> json) {
    return EducationData(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      period: json['period'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}

class ProjectData {
  final String title;
  final String description;
  final List<String> techStack;
  final String type;
  final String icon;
  const ProjectData({
    required this.title,
    required this.description,
    required this.techStack,
    required this.type,
    required this.icon,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      techStack: (json['tech_stack'] as List?)?.map((s) => s.toString()).toList() ?? [],
      type: json['type'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class LanguageData {
  final String name;
  final String level;
  final double percent;
  const LanguageData({
    required this.name,
    required this.level,
    required this.percent,
  });

  factory LanguageData.fromJson(Map<String, dynamic> json) {
    return LanguageData(
      name: json['name'] ?? '',
      level: json['level'] ?? '',
      percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
