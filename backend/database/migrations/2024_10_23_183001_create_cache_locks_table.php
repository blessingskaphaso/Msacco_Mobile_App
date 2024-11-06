<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cache_locks', function (Blueprint $table) {
            $table->string('key')->primary(); // Primary key is the lock key itself
            $table->string('owner'); // Owner of the lock
            $table->integer('expiration'); // Expiration timestamp for the lock
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cache_locks');
    }
};
