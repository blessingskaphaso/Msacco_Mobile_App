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
        Schema::create('personal_information', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Reference to the user
            $table->string('home_address'); // Residential address of the user
            $table->string('next_of_kin_name'); // Name of the next of kin
            $table->string('next_of_kin_contact'); // Contact number of the next of kin
            $table->string('relationship'); // Relationship of the next of kin to the user
            $table->string('employment_status'); // Employment status (e.g., Employed, Unemployed)
            $table->string('employer_name')->nullable(); // Employer's name (nullable)
            $table->string('position')->nullable(); // Position held at the employer's company (nullable)
            $table->date('date_of_birth'); // Date of birth of the user
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('personal_information');
    }
};
