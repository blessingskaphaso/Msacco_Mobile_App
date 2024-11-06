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
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Reference to the user making the transaction
            $table->foreignId('transaction_type_id')->constrained('transaction_types')->onDelete('restrict'); // Type of transaction
            $table->foreignId('source_id')->constrained('transaction_sources')->onDelete('restrict'); // Source of funds
            $table->foreignId('destination_id')->constrained('transaction_sources')->onDelete('restrict'); // Destination of funds
            $table->decimal('amount', 15, 2); // Amount involved in the transaction
            $table->date('transaction_date')->default(DB::raw('CURRENT_DATE')); // Date of the transaction
            $table->text('description')->nullable(); // Optional description for the transaction
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
