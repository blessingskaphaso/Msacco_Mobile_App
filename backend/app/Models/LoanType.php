<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LoanType extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'interest_rate',
        'duration',
    ];

    /**
     * Relationships
     */
    public function loans()
    {
        return $this->hasMany(Loan::class);
    }
}
