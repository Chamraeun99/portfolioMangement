<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Education extends Model
{
    protected $table = 'education';

    protected $fillable = [
        'user_id', 'degree', 'institution', 'period', 'detail',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
