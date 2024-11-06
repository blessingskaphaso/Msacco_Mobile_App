<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PersonalDetail extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['user_id', 'home_address', 'next_of_kin_name', 'next_of_kin_contact', 'relationship', 'employment_status', 'employer_name'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

