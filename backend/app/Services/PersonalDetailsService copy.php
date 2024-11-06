<?php

namespace App\Services;

use App\Models\PersonalInformation;
use App\Models\UserDocument;
use Illuminate\Support\Facades\Storage;

class PersonalDetailsService
{
    /**
     * Retrieve personal details for a user, including documents.
     *
     * @param int $userId
     * @return PersonalInformation|null
     */
    public function getDetails($userId)
    {
        return PersonalInformation::where('user_id', $userId)->with('documents')->first();
    }

    /**
     * Update personal details and store multiple documents.
     *
     * @param int $userId
     * @param array $data
     * @param array|null $documents
     * @return PersonalInformation
     */
    public function updateDetailsWithDocuments($userId, array $data, $documents = null)
    {
        $personalDetails = PersonalInformation::updateOrCreate(['user_id' => $userId], $data);

        if ($documents) {
            foreach ($documents as $document) {
                $documentType = $document['document_type'];
                $file = $document['file'];

                // Save document file
                $path = $file->store('documents', 'public');

                // Create a new document record
                UserDocument::create([
                    'user_id' => $userId,
                    'document_type' => $documentType,
                    'document_path' => $path,
                ]);
            }
        }

        return $personalDetails->load('documents');
    }

    /**
     * Retrieve all documents for a user.
     *
     * @param int $userId
     * @return \Illuminate\Database\Eloquent\Collection
     */
    public function getDocuments($userId)
    {
        // Fetch all documents related to the user
        return UserDocument::where('user_id', $userId)->get(['id', 'document_type', 'document_path']);
    }

    /**
     * Retrieve a specific document by ID and user ID.
     *
     * @param int $userId
     * @param int $documentId
     * @return UserDocument|null
     */
    public function getDocumentById($userId, $documentId)
    {
        // Ensure the document belongs to the specified user
        return UserDocument::where('user_id', $userId)->where('user_id', $documentId)->first();
    }

    /**
     * Add a single document for a user.
     *
     * @param int $userId
     * @param array $data
     * @return UserDocument
     */
    public function addDocument($userId, array $data)
    {
        $file = $data['file'];
        $documentType = $data['document_type'];

        // Store the file in the 'public/documents' directory
        $path = $file->store('documents', 'public');

        // Save document details in the database
        return UserDocument::create([
            'user_id' => $userId,
            'document_type' => $documentType,
            'document_path' => $path,
        ]);
    }
}
