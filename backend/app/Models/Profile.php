<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Profile extends Model
{
    protected $fillable = [
        'user_id', 'name', 'title', 'phone', 'email', 'location', 'github', 'about',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
