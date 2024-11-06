<?php

namespace App\Services;

use App\Models\PersonalInformation;
use Illuminate\Support\Facades\Auth;

class PersonalDetailsService
{
    /**
     * Retrieve all personal details with attached documents for all users.
     *
     * @return \Illuminate\Database\Eloquent\Collection
     */
    public function getAllDetails()
    {
        // Retrieve all personal details with their associated documents
        return PersonalInformation::with('documents')->get();
    }

    /**
     * Retrieve personal details with attached documents for a specific user.
     *
     * @param int $userId
     * @return PersonalInformation|null
     */
    public function getDetails($userId)
    {
        // Retrieve personal details for a specific user along with their documents
        return PersonalInformation::where('user_id', $userId)->with('documents')->first();
    }

    /**
     * Add or update personal details for a specific user.
     *
     * @param int $userId
     * @param array $data
     * @return PersonalInformation
     */
    public function addOrUpdateDetails($userId, array $data)
    {
        // Check if personal details for this user already exist
        $personalDetails = PersonalInformation::where('user_id', $userId)->first();

        if ($personalDetails) {
            // Update existing personal details if they exist
            $personalDetails->update($data);
        } else {
            // Create new personal details if none exist
            $data['user_id'] = $userId;
            $personalDetails = PersonalInformation::create($data);
        }

        // Return the updated or newly created personal details with documents
        return $personalDetails->load('documents');
    }
}
