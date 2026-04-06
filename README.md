<p align="center">
  <h1 align="center">Portfolio</h1>
  <p align="center">
    A full-stack professional portfolio platform built with <strong>Flutter</strong> and <strong>Laravel</strong>
    <br />
    Showcase your skills, experience, education, projects, and more — with an admin dashboard to manage it all.
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11.4-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Laravel-13.0-FF2D20?logo=laravel&logoColor=white" alt="Laravel" />
  <img src="https://img.shields.io/badge/PHP-8.3+-777BB4?logo=php&logoColor=white" alt="PHP" />
  <img src="https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL" />
</p>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [API Reference](#api-reference)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Default Credentials](#default-credentials)
- [License](#license)

---

## Overview

**Portfolio** is a modern, full-stack web and mobile application designed to serve as a dynamic personal portfolio. Unlike static portfolio sites, this platform provides a complete **admin dashboard** to manage all content through a clean interface — no code changes required.

The project consists of two parts:

| Component | Technology | Description |
|-----------|------------|-------------|
| **Backend** | Laravel 13 (PHP 8.3+) | RESTful API with Sanctum token authentication |
| **Frontend** | Flutter 3.11.4 (Dart) | Cross-platform app (Web, Android, iOS, Desktop) |

---

## Features

### Public Portfolio
- Dynamic hero section with profile info and social links
- Skills organized by category with visual tags
- Work experience timeline with tech stack badges
- Education history
- Project showcase with descriptions and technologies
- Language proficiency with progress bars
- Contact section with clickable email, phone, and location
- Smooth entrance animations and transitions
- Graceful fallback to static data when API is unavailable

### Admin Dashboard
- Secure JWT/token-based authentication
- Dashboard overview with content statistics
- Full CRUD management for:
  - **Profile** — name, title, bio, contact info, GitHub link
  - **Skills** — categories with emoji icons and skill items
  - **Experience** — roles, companies, periods, descriptions, tech stacks
  - **Education** — degrees, institutions, periods, details
  - **Projects** — titles, descriptions, tech stacks, types, icons
  - **Languages** — names, proficiency levels, percentage bars
- Real-time data updates
- Logout and "View Site" quick actions

### Technical
- RESTful API design with proper HTTP methods and status codes
- Token-based authentication via Laravel Sanctum
- Input validation and authorization on all endpoints
- CORS configured for cross-origin requests
- Multi-database support (PostgreSQL, MySQL, SQLite)
- Cross-platform Flutter frontend (Web, Android, iOS, Linux, macOS, Windows)

---

## Tech Stack

### Backend

| Technology | Purpose |
|------------|---------|
| **PHP 8.3+** | Server-side language |
| **Laravel 13** | Web application framework |
| **Laravel Sanctum** | API token authentication |
| **PostgreSQL** | Primary database (default) |
| **Vite** | Frontend asset bundling |
| **PHPUnit** | Testing framework |

### Frontend

| Technology | Purpose |
|------------|---------|
| **Flutter 3.11.4** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Material Design 3** | UI design system |
| **Google Fonts (Poppins)** | Typography |
| **SharedPreferences** | Local token storage |
| **http** | HTTP client for API communication |
| **url_launcher** | External link handling |

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Flutter Frontend                     │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────────┐  │
│  │ Portfolio │  │ Login Screen │  │  Admin Dashboard  │  │
│  │  Screen   │  │              │  │  (CRUD Screens)   │  │
│  └─────┬─────┘  └──────┬───────┘  └────────┬──────────┘  │
│        │               │                   │             │
│        └───────────────┼───────────────────┘             │
│                        │                                 │
│              ┌─────────▼─────────┐                       │
│              │    API Service    │                       │
│              │  (JWT Token Mgmt) │                       │
│              └─────────┬─────────┘                       │
└────────────────────────┼─────────────────────────────────┘
                         │  HTTP / REST
┌────────────────────────┼─────────────────────────────────┐
│                        ▼          Laravel Backend        │
│              ┌──────────────────┐                        │
│              │   API Routes     │                        │
│              │  (Sanctum Auth)  │                        │
│              └────────┬─────────┘                        │
│                       │                                  │
│  ┌────────────────────▼─────────────────────────────┐    │
│  │               Controllers                         │    │
│  │  Auth · Profile · Skills · Experience · Education │    │
│  │  Projects · Languages · Portfolio                 │    │
│  └────────────────────┬─────────────────────────────┘    │
│                       │                                  │
│  ┌────────────────────▼─────────────────────────────┐    │
│  │            Eloquent Models & Relations            │    │
│  └────────────────────┬─────────────────────────────┘    │
│                       │                                  │
│              ┌────────▼─────────┐                        │
│              │   PostgreSQL     │                        │
│              └──────────────────┘                        │
└──────────────────────────────────────────────────────────┘
```

---

## Screenshots

> Add your screenshots here:
>
> ```
> ![Portfolio Home](screenshots/portfolio-home.png)
> ![Admin Dashboard](screenshots/admin-dashboard.png)
> ![Skills Management](screenshots/skills-management.png)
> ```

---

## Getting Started

### Prerequisites

| Tool | Version | Link |
|------|---------|------|
| PHP | 8.3+ | [php.net](https://www.php.net/downloads) |
| Composer | 2.x | [getcomposer.org](https://getcomposer.org/) |
| Node.js | 18+ | [nodejs.org](https://nodejs.org/) |
| PostgreSQL | 14+ | [postgresql.org](https://www.postgresql.org/download/) |
| Flutter | 3.11.4+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |

---

### Backend Setup

1. **Navigate to the backend directory:**

   ```bash
   cd backend
   ```

2. **Install dependencies:**

   ```bash
   composer install
   npm install
   ```

3. **Configure environment:**

   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Update `.env` with your database credentials:**

   ```env
   DB_CONNECTION=pgsql
   DB_HOST=127.0.0.1
   DB_PORT=5432
   DB_DATABASE=portfolio
   DB_USERNAME=your_username
   DB_PASSWORD=your_password
   ```

5. **Run migrations and seed the database:**

   ```bash
   php artisan migrate --seed
   ```

6. **Start the development server:**

   ```bash
   php artisan serve
   ```

   The API will be available at `http://127.0.0.1:8000`

> **Quick Setup:** You can also run `composer run setup` to install dependencies, run migrations, and seed in one command. Use `composer run dev` to start all development services simultaneously.

---

### Frontend Setup

1. **Navigate to the frontend directory:**

   ```bash
   cd frontend
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure the API base URL:**

   Open `lib/services/api_service.dart` and update the base URL if needed:

   ```dart
   static const String baseUrl = 'http://127.0.0.1:8000/api';
   ```

4. **Run the application:**

   ```bash
   # Web
   flutter run -d chrome

   # Android
   flutter run -d android

   # iOS
   flutter run -d ios

   # Desktop
   flutter run -d windows
   flutter run -d macos
   flutter run -d linux
   ```

---

## API Reference

### Authentication

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `POST` | `/api/register` | Register a new user | No |
| `POST` | `/api/login` | Login and receive token | No |
| `POST` | `/api/logout` | Logout and revoke token | Yes |
| `GET` | `/api/user` | Get authenticated user | Yes |

### Public

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/portfolio/{userId}` | Get full public portfolio | No |

### Profile

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/profile` | Get user profile | Yes |
| `PUT` | `/api/profile` | Update user profile | Yes |

### Skills

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/skill-categories` | List all skill categories | Yes |
| `POST` | `/api/skill-categories` | Create skill category | Yes |
| `PUT` | `/api/skill-categories/{id}` | Update skill category | Yes |
| `DELETE` | `/api/skill-categories/{id}` | Delete skill category | Yes |

### Experience

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/experiences` | List all experiences | Yes |
| `POST` | `/api/experiences` | Create experience | Yes |
| `PUT` | `/api/experiences/{id}` | Update experience | Yes |
| `DELETE` | `/api/experiences/{id}` | Delete experience | Yes |

### Education

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/education` | List all education entries | Yes |
| `POST` | `/api/education` | Create education entry | Yes |
| `PUT` | `/api/education/{id}` | Update education entry | Yes |
| `DELETE` | `/api/education/{id}` | Delete education entry | Yes |

### Projects

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/projects` | List all projects | Yes |
| `POST` | `/api/projects` | Create project | Yes |
| `PUT` | `/api/projects/{id}` | Update project | Yes |
| `DELETE` | `/api/projects/{id}` | Delete project | Yes |

### Languages

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/languages` | List all languages | Yes |
| `POST` | `/api/languages` | Create language | Yes |
| `PUT` | `/api/languages/{id}` | Update language | Yes |
| `DELETE` | `/api/languages/{id}` | Delete language | Yes |

### Example Requests

<details>
<summary><strong>Register</strong></summary>

```bash
curl -X POST http://127.0.0.1:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Response:**
```json
{
  "user": { "id": 1, "name": "John Doe", "email": "john@example.com" },
  "token": "1|abc123..."
}
```

</details>

<details>
<summary><strong>Login</strong></summary>

```bash
curl -X POST http://127.0.0.1:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@portfolio.com",
    "password": "password"
  }'
```

</details>

<details>
<summary><strong>Create Skill Category</strong></summary>

```bash
curl -X POST http://127.0.0.1:8000/api/skill-categories \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Frontend",
    "icon": "🎨",
    "items": ["React", "Vue", "TypeScript"]
  }'
```

</details>

<details>
<summary><strong>Create Experience</strong></summary>

```bash
curl -X POST http://127.0.0.1:8000/api/experiences \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "role": "Senior Developer",
    "company": "Tech Corp",
    "period": "2022-2025",
    "location": "San Francisco",
    "description": "Built scalable web applications",
    "skills": ["Laravel", "React", "PostgreSQL"]
  }'
```

</details>

---

## Database Schema

```
┌──────────────┐     ┌──────────────────┐     ┌────────────┐
│    users      │────│     profiles      │     │   skills    │
│──────────────│     │──────────────────│     │────────────│
│ id           │     │ id               │     │ id         │
│ name         │     │ user_id (FK)     │     │ category_id│
│ email        │     │ name             │     │ name       │
│ password     │     │ title            │     └──────┬─────┘
└──────┬───────┘     │ phone            │            │
       │             │ email            │     ┌──────┴──────────┐
       │             │ location         │     │skill_categories │
       │             │ github           │     │─────────────────│
       │             │ about            │     │ id              │
       │             └──────────────────┘     │ user_id (FK)    │
       │                                      │ title           │
       ├──────────────────────────────────────│ icon            │
       │                                      └─────────────────┘
       │
       ├─────┬─────────────┬──────────────┬──────────────┐
       │     │             │              │              │
  ┌────▼───┐ ┌────▼──────┐ ┌──────▼─────┐ ┌──────▼─────┐
  │experien│ │ education │ │  projects  │ │ languages  │
  │  ces   │ │           │ │            │ │            │
  │────────│ │───────────│ │────────────│ │────────────│
  │ id     │ │ id        │ │ id         │ │ id         │
  │user_id │ │ user_id   │ │ user_id    │ │ user_id    │
  │ role   │ │ degree    │ │ title      │ │ name       │
  │company │ │institution│ │ description│ │ level      │
  │ period │ │ period    │ │ tech_stack │ │ percent    │
  │location│ │ detail    │ │ type       │ │            │
  │descrip.│ │           │ │ icon       │ │            │
  │skills[]│ │           │ │            │ │            │
  └────────┘ └───────────┘ └────────────┘ └────────────┘
```

---

## Project Structure

```
portfolio/
├── backend/                    # Laravel REST API
│   ├── app/
│   │   ├── Http/Controllers/   # API controllers
│   │   ├── Models/             # Eloquent models
│   │   └── Providers/          # Service providers
│   ├── config/                 # App configuration
│   ├── database/
│   │   ├── migrations/         # Database schema
│   │   └── seeders/            # Seed data
│   ├── routes/
│   │   └── api.php             # API route definitions
│   ├── .env.example            # Environment template
│   ├── composer.json           # PHP dependencies
│   └── package.json            # Node dependencies
│
├── frontend/                   # Flutter cross-platform app
│   ├── lib/
│   │   ├── main.dart           # App entry point & theme
│   │   ├── models/
│   │   │   └── portfolio_data.dart  # Data models
│   │   ├── screens/
│   │   │   ├── portfolio_screen.dart  # Public portfolio
│   │   │   ├── login_screen.dart      # Admin login
│   │   │   └── admin/                 # Admin CRUD screens
│   │   │       ├── admin_dashboard_screen.dart
│   │   │       ├── profile_form_screen.dart
│   │   │       ├── skills_list_screen.dart
│   │   │       ├── experiences_list_screen.dart
│   │   │       ├── education_list_screen.dart
│   │   │       ├── projects_list_screen.dart
│   │   │       └── languages_list_screen.dart
│   │   └── services/
│   │       └── api_service.dart  # HTTP client & auth
│   ├── assets/images/           # Static assets
│   ├── pubspec.yaml             # Flutter dependencies
│   └── web/                     # Web-specific config
│
└── README.md                    # This file
```

---

## Configuration

### Environment Variables (Backend)

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_NAME` | Application name | `Laravel` |
| `APP_ENV` | Environment | `local` |
| `APP_KEY` | Encryption key | Generated via `artisan` |
| `APP_URL` | Application URL | `http://localhost` |
| `DB_CONNECTION` | Database driver | `pgsql` |
| `DB_HOST` | Database host | `127.0.0.1` |
| `DB_PORT` | Database port | `5432` |
| `DB_DATABASE` | Database name | `portfolio` |
| `DB_USERNAME` | Database user | — |
| `DB_PASSWORD` | Database password | — |

### Frontend Configuration

| Setting | File | Description |
|---------|------|-------------|
| API Base URL | `lib/services/api_service.dart` | Backend API endpoint |
| Theme Colors | `lib/main.dart` | App color scheme |
| Assets | `pubspec.yaml` | Image and font assets |

### Theme Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#6C63FF` | Buttons, links, accents |
| Secondary | `#03DAC6` | Highlights, badges |
| Background | `#0F0E17` | Main background |
| Card | `#1A1A2E` | Card surfaces |
| Surface | `#16213E` | Elevated surfaces |

---

## Default Credentials

After running the database seeder:

| Field | Value |
|-------|-------|
| Email | `admin@portfolio.com` |
| Password | `password` |

> ⚠️ **Change these credentials immediately in production.**

---

## License

This project is private and not published under an open-source license.
