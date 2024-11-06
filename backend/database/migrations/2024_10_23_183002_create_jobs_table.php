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
        Schema::create('jobs', function (Blueprint $table) {
            $table->id(); // Job ID
            $table->string('queue')->index(); // Queue name for the job
            $table->longText('payload'); // Job payload data
            $table->unsignedTinyInteger('attempts'); // Number of attempts to execute the job
            $table->unsignedInteger('reserved_at')->nullable(); // Timestamp of reservation
            $table->unsignedInteger('available_at'); // Timestamp when job becomes available for processing
            $table->unsignedInteger('created_at'); // Timestamp when job was created
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jobs');
    }
};
