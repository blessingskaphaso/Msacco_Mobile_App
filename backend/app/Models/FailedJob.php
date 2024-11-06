<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FailedJob extends Model
{
    use HasFactory;

    protected $fillable = [
        'uuid',
        'connection',
        'queue',
        'payload',
        'exception',
        'failed_at',
    ];

    public $timestamps = false;

    /**
     * The FailedJob table is used by Laravel to manage jobs that failed during execution.
     */
}
