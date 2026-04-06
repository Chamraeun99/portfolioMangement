<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\PortfolioController;
use Illuminate\Support\Facades\Route;

// ─── Public routes ────────────────────────────────────────────────────────
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/portfolio/{userId}', [PortfolioController::class, 'getPublicPortfolio']);

// ─── Protected routes ─────────────────────────────────────────────────────
Route::middleware('auth:sanctum')->group(function () {
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);

    // Profile
    Route::get('/profile', [PortfolioController::class, 'getProfile']);
    Route::put('/profile', [PortfolioController::class, 'updateProfile']);

    // Skill Categories
    Route::get('/skill-categories', [PortfolioController::class, 'getSkillCategories']);
    Route::post('/skill-categories', [PortfolioController::class, 'storeSkillCategory']);
    Route::put('/skill-categories/{skillCategory}', [PortfolioController::class, 'updateSkillCategory']);
    Route::delete('/skill-categories/{skillCategory}', [PortfolioController::class, 'deleteSkillCategory']);

    // Experiences
    Route::get('/experiences', [PortfolioController::class, 'getExperiences']);
    Route::post('/experiences', [PortfolioController::class, 'storeExperience']);
    Route::put('/experiences/{experience}', [PortfolioController::class, 'updateExperience']);
    Route::delete('/experiences/{experience}', [PortfolioController::class, 'deleteExperience']);

    // Education
    Route::get('/education', [PortfolioController::class, 'getEducation']);
    Route::post('/education', [PortfolioController::class, 'storeEducation']);
    Route::put('/education/{education}', [PortfolioController::class, 'updateEducation']);
    Route::delete('/education/{education}', [PortfolioController::class, 'deleteEducation']);

    // Projects
    Route::get('/projects', [PortfolioController::class, 'getProjects']);
    Route::post('/projects', [PortfolioController::class, 'storeProject']);
    Route::put('/projects/{project}', [PortfolioController::class, 'updateProject']);
    Route::delete('/projects/{project}', [PortfolioController::class, 'deleteProject']);

    // Languages
    Route::get('/languages', [PortfolioController::class, 'getLanguages']);
    Route::post('/languages', [PortfolioController::class, 'storeLanguage']);
    Route::put('/languages/{language}', [PortfolioController::class, 'updateLanguage']);
    Route::delete('/languages/{language}', [PortfolioController::class, 'deleteLanguage']);
});
