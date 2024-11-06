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
        Schema::create('withdrawal_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Reference to the user requesting the withdrawal
            $table->decimal('amount', 15, 2); // Amount requested for withdrawal
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending'); // Status of the withdrawal request
            $table->timestamp('requested_at'); // Timestamp when the withdrawal was requested
            $table->timestamp('processed_at')->nullable(); // Timestamp when the withdrawal was processed
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('withdrawal_requests');
    }
};
