<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BiometricData extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'biometric_type',
        'data_hash',
    ];

    /**
     * Relationships
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
