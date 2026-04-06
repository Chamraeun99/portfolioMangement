<?php

namespace App\Http\Controllers;

use App\Models\Education;
use App\Models\Experience;
use App\Models\Language;
use App\Models\Profile;
use App\Models\Project;
use App\Models\Skill;
use App\Models\SkillCategory;
use Illuminate\Http\Request;

class PortfolioController extends Controller
{
    // ─── Profile ──────────────────────────────────────────────────────

    public function getProfile(Request $request)
    {
        $profile = $request->user()->profile;
        return response()->json($profile);
    }

    public function updateProfile(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'title' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:50',
            'email' => 'nullable|string|email|max:255',
            'location' => 'nullable|string|max:255',
            'github' => 'nullable|string|max:255',
            'about' => 'nullable|string',
        ]);

        $profile = $request->user()->profile()->updateOrCreate(
            ['user_id' => $request->user()->id],
            $validated
        );

        return response()->json($profile);
    }

    // ─── Skill Categories ─────────────────────────────────────────────

    public function getSkillCategories(Request $request)
    {
        $categories = $request->user()->skillCategories()->with('skills')->get();
        return response()->json($categories);
    }

    public function storeSkillCategory(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'icon' => 'nullable|string|max:10',
            'items' => 'nullable|array',
            'items.*' => 'string|max:255',
        ]);

        $category = $request->user()->skillCategories()->create([
            'title' => $validated['title'],
            'icon' => $validated['icon'] ?? null,
        ]);

        if (!empty($validated['items'])) {
            foreach ($validated['items'] as $item) {
                $category->skills()->create(['name' => $item]);
            }
        }

        return response()->json($category->load('skills'), 201);
    }

    public function updateSkillCategory(Request $request, SkillCategory $skillCategory)
    {
        $this->authorizeResource($request, $skillCategory);

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'icon' => 'nullable|string|max:10',
            'items' => 'nullable|array',
            'items.*' => 'string|max:255',
        ]);

        $skillCategory->update([
            'title' => $validated['title'],
            'icon' => $validated['icon'] ?? null,
        ]);

        if (isset($validated['items'])) {
            $skillCategory->skills()->delete();
            foreach ($validated['items'] as $item) {
                $skillCategory->skills()->create(['name' => $item]);
            }
        }

        return response()->json($skillCategory->load('skills'));
    }

    public function deleteSkillCategory(Request $request, SkillCategory $skillCategory)
    {
        $this->authorizeResource($request, $skillCategory);
        $skillCategory->delete();
        return response()->json(['message' => 'Deleted successfully']);
    }

    // ─── Experiences ──────────────────────────────────────────────────

    public function getExperiences(Request $request)
    {
        return response()->json($request->user()->experiences);
    }

    public function storeExperience(Request $request)
    {
        $validated = $request->validate([
            'role' => 'required|string|max:255',
            'company' => 'required|string|max:255',
            'period' => 'required|string|max:255',
            'location' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'skills' => 'nullable|array',
            'skills.*' => 'string|max:255',
        ]);

        $experience = $request->user()->experiences()->create($validated);
        return response()->json($experience, 201);
    }

    public function updateExperience(Request $request, Experience $experience)
    {
        $this->authorizeResource($request, $experience);

        $validated = $request->validate([
            'role' => 'required|string|max:255',
            'company' => 'required|string|max:255',
            'period' => 'required|string|max:255',
            'location' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'skills' => 'nullable|array',
            'skills.*' => 'string|max:255',
        ]);

        $experience->update($validated);
        return response()->json($experience);
    }

    public function deleteExperience(Request $request, Experience $experience)
    {
        $this->authorizeResource($request, $experience);
        $experience->delete();
        return response()->json(['message' => 'Deleted successfully']);
    }

    // ─── Education ────────────────────────────────────────────────────

    public function getEducation(Request $request)
    {
        return response()->json($request->user()->education);
    }

    public function storeEducation(Request $request)
    {
        $validated = $request->validate([
            'degree' => 'required|string|max:255',
            'institution' => 'required|string|max:255',
            'period' => 'required|string|max:255',
            'detail' => 'nullable|string|max:255',
        ]);

        $education = $request->user()->education()->create($validated);
        return response()->json($education, 201);
    }

    public function updateEducation(Request $request, Education $education)
    {
        $this->authorizeResource($request, $education);

        $validated = $request->validate([
            'degree' => 'required|string|max:255',
            'institution' => 'required|string|max:255',
            'period' => 'required|string|max:255',
            'detail' => 'nullable|string|max:255',
        ]);

        $education->update($validated);
        return response()->json($education);
    }

    public function deleteEducation(Request $request, Education $education)
    {
        $this->authorizeResource($request, $education);
        $education->delete();
        return response()->json(['message' => 'Deleted successfully']);
    }

    // ─── Projects ─────────────────────────────────────────────────────

    public function getProjects(Request $request)
    {
        return response()->json($request->user()->projects);
    }

    public function storeProject(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'tech_stack' => 'nullable|array',
            'tech_stack.*' => 'string|max:255',
            'type' => 'nullable|string|max:255',
            'icon' => 'nullable|string|max:10',
        ]);

        $project = $request->user()->projects()->create($validated);
        return response()->json($project, 201);
    }

    public function updateProject(Request $request, Project $project)
    {
        $this->authorizeResource($request, $project);

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'tech_stack' => 'nullable|array',
            'tech_stack.*' => 'string|max:255',
            'type' => 'nullable|string|max:255',
            'icon' => 'nullable|string|max:10',
        ]);

        $project->update($validated);
        return response()->json($project);
    }

    public function deleteProject(Request $request, Project $project)
    {
        $this->authorizeResource($request, $project);
        $project->delete();
        return response()->json(['message' => 'Deleted successfully']);
    }

    // ─── Languages ────────────────────────────────────────────────────

    public function getLanguages(Request $request)
    {
        return response()->json($request->user()->languages);
    }

    public function storeLanguage(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'level' => 'required|string|max:255',
            'percent' => 'required|numeric|min:0|max:1',
        ]);

        $language = $request->user()->languages()->create($validated);
        return response()->json($language, 201);
    }

    public function updateLanguage(Request $request, Language $language)
    {
        $this->authorizeResource($request, $language);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'level' => 'required|string|max:255',
            'percent' => 'required|numeric|min:0|max:1',
        ]);

        $language->update($validated);
        return response()->json($language);
    }

    public function deleteLanguage(Request $request, Language $language)
    {
        $this->authorizeResource($request, $language);
        $language->delete();
        return response()->json(['message' => 'Deleted successfully']);
    }

    // ─── Public Portfolio (no auth needed) ────────────────────────────

    public function getPublicPortfolio($userId)
    {
        $user = \App\Models\User::findOrFail($userId);

        return response()->json([
            'profile' => $user->profile,
            'skills' => $user->skillCategories()->with('skills')->get(),
            'experiences' => $user->experiences,
            'education' => $user->education,
            'projects' => $user->projects,
            'languages' => $user->languages,
        ]);
    }

    // ─── Authorization helper ─────────────────────────────────────────

    private function authorizeResource(Request $request, $resource)
    {
        if ($resource->user_id !== $request->user()->id) {
            abort(403, 'Unauthorized');
        }
    }
}
