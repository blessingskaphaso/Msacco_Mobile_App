<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PersonalInformation extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'home_address',
        'next_of_kin_name',
        'next_of_kin_contact',
        'relationship',
        'employment_status',
        'employer_name',
        'position',
        'date_of_birth',
    ];

    /**
     * Relationships
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function documents()
    {
        return $this->hasMany(UserDocument::class, 'user_id');
    }

}
