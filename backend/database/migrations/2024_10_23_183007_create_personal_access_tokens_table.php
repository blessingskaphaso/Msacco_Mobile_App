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
        Schema::create('personal_access_tokens', function (Blueprint $table) {
            $table->id();
            $table->morphs('tokenable'); // Refers to user or any other authenticatable model
            $table->string('name');
            $table->string('token', 64)->unique();
            $table->text('abilities')->nullable(); // Define abilities (scopes) of the token
            $table->timestamp('last_used_at')->nullable();
            $table->timestamp('expires_at')->nullable(); // Token expiration, useful for session control
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('personal_access_tokens');
    }
};
