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
        Schema::create('failed_jobs', function (Blueprint $table) {
            $table->id(); // Failed job ID
            $table->string('uuid')->unique(); // Unique identifier for the job
            $table->text('connection'); // The connection the job was running on
            $table->text('queue'); // The queue the job was pulled from
            $table->longText('payload'); // The payload of the job
            $table->longText('exception'); // Exception details for the failure
            $table->timestamp('failed_at')->useCurrent(); // Timestamp when the job failed
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('failed_jobs');
    }
};
