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
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('account_id')->constrained('accounts')->onDelete('cascade'); // Added account_id column
            $table->foreignId('loan_type_id')->constrained('loan_types');
            $table->decimal('loan_amount', 15, 2);
            $table->integer('repayment_period');
            $table->decimal('interest_rate', 5, 2);
            $table->enum('status', ['Approved', 'Rejected', 'Pending', 'Settled'])->default('Pending');
            $table->timestamps();
            $table->softDeletes();
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
