<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Transaction extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'account_id',
        'type',
        'amount',
        'transaction_date',
        'source',
        'destination',
    ];

    public function account()
    {
        return $this->belongsTo(Account::class);
    }
}
