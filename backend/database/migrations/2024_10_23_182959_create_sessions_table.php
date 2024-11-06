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
        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary(); // Session ID
            $table->foreignId('user_id')->nullable()->constrained('users')->onDelete('cascade'); // User ID reference, nullable if not logged in
            $table->string('ip_address', 45)->nullable(); // IP Address of the session
            $table->text('user_agent')->nullable(); // User Agent information
            $table->longText('payload'); // Session payload data
            $table->integer('last_activity')->index(); // Last activity timestamp
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sessions');
    }
};
