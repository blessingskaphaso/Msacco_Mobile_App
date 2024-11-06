<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cache extends Model
{
    use HasFactory;

    protected $fillable = [
        'key',
        'value',
        'expiration',
    ];

    protected $primaryKey = 'key';
    protected $keyType = 'string';
    public $incrementing = false;

    public $timestamps = false;

    /**
     * This table will not have relationships with other models since it is meant for caching purposes.
     */
}
