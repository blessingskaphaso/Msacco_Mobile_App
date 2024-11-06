<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable // Extend Authenticatable instead of Model
{
    use HasApiTokens, HasFactory, SoftDeletes;

    protected $fillable = ['name', 'email', 'password', 'phone_number', 'status', 'role'];

    public function account()
    {
        return $this->hasOne(Account::class);
    }

    public function activityLogs()
    {
        return $this->hasMany(ActivityLog::class);
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }

    public function personalDetail()
    {
        return $this->hasOne(PersonalDetail::class);
    }

    public function documents()
    {
        return $this->hasMany(Document::class);
    }

    public function liveChatsSent()
    {
        return $this->hasMany(LiveChat::class, 'sender_id');
    }

    public function liveChatsReceived()
    {
        return $this->hasMany(LiveChat::class, 'receiver_id');
    }

    /**
     * Check if the user is an admin.
     *
     * @return bool
     */
    public function isAdmin()
    {
        return $this->role === 'admin';
    }
}
