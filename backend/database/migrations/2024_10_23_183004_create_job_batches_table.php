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
        Schema::create('job_batches', function (Blueprint $table) {
            $table->string('id')->primary(); // Batch ID
            $table->string('name'); // Name of the batch
            $table->integer('total_jobs'); // Total number of jobs in the batch
            $table->integer('pending_jobs'); // Number of jobs still pending
            $table->integer('failed_jobs'); // Number of failed jobs
            $table->longText('failed_job_ids'); // List of IDs of the failed jobs
            $table->mediumText('options')->nullable(); // Additional options for the job batch
            $table->integer('cancelled_at')->nullable(); // Timestamp when the batch was cancelled
            $table->integer('created_at'); // Timestamp when the batch was created
            $table->integer('finished_at')->nullable(); // Timestamp when the batch was finished
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('job_batches');
    }
};
