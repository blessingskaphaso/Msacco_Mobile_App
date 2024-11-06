<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LiveChatMessage extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'sender',
        'message',
        'chat_session_id',
        'timestamp',
    ];

    /**
     * Relationships
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function chatSession()
    {
        return $this->belongsTo(ChatSession::class);
    }
}
