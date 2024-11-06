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
        Schema::create('loans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Reference to the user requesting the loan
            $table->foreignId('loan_type_id')->constrained('loan_types'); // Reference to the type of loan being requested
            $table->decimal('loan_amount', 15, 2); // Requested loan amount
            $table->integer('repayment_period'); // Repayment period in months
            $table->decimal('interest_rate', 5, 2); // Interest rate for the loan
            $table->enum('status', ['Approved', 'Rejected', 'Pending','Settled'])->default('Pending'); // Loan status
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('loans');
    }
};
