<?php

namespace App\Services;

use App\Models\Share;

class ShareService
{
    // Retrieve all shares for a specific user
    public function getUserShares($userId)
    {
        return Share::where('user_id', $userId)->get();
    }

    // Retrieve a specific share record by ID and user ID
    public function getShareById($userId, $shareId)
    {
        return Share::where('user_id', $userId)->where('id', $shareId)->first();
    }

    // Create a new share record for a user
    public function createShare($userId, array $data)
    {
        return Share::create([
            'user_id' => $userId,
            'amount' => $data['amount'],
        ]);
    }

    // Update an existing share record for a user
    public function updateShare($userId, $shareId, array $data)
    {
        $share = Share::where('user_id', $userId)->where('id', $shareId)->first();

        if ($share) {
            $share->update($data);
        }

        return $share;
    }

    // Users with shares already
    public function userHasShares($userId)
    {
        return Share::where('user_id', $userId)->exists();
    }

}
