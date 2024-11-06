<?php

namespace App\Services;

use App\Models\Transaction;
use Illuminate\Support\Facades\Auth;

class TransactionService
{
    // Get all transactions for the authenticated user
    public function getAllTransactions($userId)
    {
        return Transaction::where('user_id', $userId)->get();
    }

    // Get a specific transaction by ID
    public function getTransactionById($id)
    {
        return Transaction::find($id);
    }

    // Create a new transaction
    public function createTransaction($data)
    {
        $data['user_id'] = Auth::id(); // Add authenticated user ID to the data
        return Transaction::create($data);
    }
}
