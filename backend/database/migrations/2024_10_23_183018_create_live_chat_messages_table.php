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
        Schema::create('live_chat_messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Reference to the user participating in the chat
            $table->string('sender'); // The sender (either 'user' or 'support')
            $table->text('message'); // The chat message content
            $table->timestamp('created_at')->useCurrent(); // Timestamp of when the message was created
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('live_chat_messages');
    }
};
