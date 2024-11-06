<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TransactionSource extends Model
{
    use HasFactory;

    // Define the table associated with the model
    protected $table = 'transaction_sources';

    // Define the fillable attributes
    protected $fillable = [
        'name',
    ];

    /**
     * Relationships
     */

    // Define any relationships, e.g., transactions associated with this source
    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'source_id');
    }
}
