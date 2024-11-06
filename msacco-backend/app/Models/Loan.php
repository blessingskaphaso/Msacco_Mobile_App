<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Loan extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['user_id', 'loan_type_id', 'loan_amount', 'repayment_period', 'interest_rate', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function loanType()
    {
        return $this->belongsTo(LoanType::class);
    }

    public function repayments()
    {
        return $this->hasMany(Repayment::class);
    }
}

