<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'source_id', 
        'destination_id', 
        'amount', 
        'transaction_type', 
        'description'
    ];

    public function source()
    {
        return $this->belongsTo(TransactionType::class, 'source_id');
    }

    public function destination()
    {
        return $this->belongsTo(TransactionType::class, 'destination_id');
    }
}

