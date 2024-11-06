<?php

namespace App\Services;

use App\Models\Deposit;

class DepositService
{
    // Retrieve all deposits for a specific user
    public function getUserDeposits($userId)
    {
        return Deposit::where('user_id', $userId)->get();
    }

    // Retrieve a specific deposit record by ID and user ID
    public function getDepositById($userId, $depositId)
    {
        return Deposit::where('user_id', $userId)->where('id', $depositId)->first();
    }

    // Create a new deposit record for a user
    public function createDeposit($userId, array $data)
    {
        return Deposit::create([
            'user_id' => $userId,
            'amount' => $data['amount'],
        ]);
    }

    // Update an existing deposit record for a user
    public function updateDeposit($userId, $depositId, array $data)
    {
        $deposit = Deposit::where('user_id', $userId)->where('id', $depositId)->first();

        if ($deposit) {
            $deposit->update($data);
        }

        return $deposit;
    }

    // Get Total Deposits for an individual
    public function getTotalDeposits($userId)
    {
        return Deposit::where('user_id', $userId)->sum('amount');
    }

}
