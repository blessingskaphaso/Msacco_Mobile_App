<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Account extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['user_id', 'account_number', 'share_balance', 'deposit_balance'];

    /**
     * Boot method to automatically generate the account number.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($account) {
            // Generate a unique 6-digit account number starting with 3
            $lastAccount = self::latest('id')->first();
            $nextNumber = $lastAccount ? intval(substr($lastAccount->account_number, 1)) + 1 : 1;
            $account->account_number = '3' . str_pad($nextNumber, 5, '0', STR_PAD_LEFT);
        });
    }

    /**
     * Relationship with the User model.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Relationship with the Transaction model.
     */
    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    /**
     * Relationship with the Loan model.
     */
    public function loans()
    {
        return $this->hasMany(Loan::class);
    }
}
