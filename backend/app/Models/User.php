<?php

namespace App\Models;

//soft delete
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

use Laravel\Passport\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes;

    protected $fillable = [
        'name',
        'email',
        'phone_number',
        'password',
        'role',
    ];

    protected $dates = ['deleted_at'];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * Relationship with the Shares model.
     */
    public function shares()
    {
        return $this->hasMany(Share::class);
    }

    /**
     * Relationship with the Loans model.
     */
    public function loans()
    {
        return $this->hasMany(Loan::class);
    }

    /**
     * Relationship with Deposits.
     */
    public function deposits()
    {
        return $this->hasMany(Deposit::class);
    }

    /**
     * Relationship with Transactions.
     */
    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    /**
     * Relationship with Documents.
     */
    public function documents()
    {
        return $this->hasMany(Document::class);
    }

    /**
     * Relationship with BiometricData.
     */
    public function biometricData()
    {
        return $this->hasOne(BiometricData::class);
    }

    /**
     * Relationship with PersonalInformation.
     */
    public function personalInformation()
    {
        return $this->hasOne(PersonalInformation::class);
    }

    /**
     * Relationship with Notifications.
     */
    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }
}
