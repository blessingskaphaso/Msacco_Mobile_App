<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class LoanConfiguration extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['max_loan_multiplier', 'interest_rate'];
}
