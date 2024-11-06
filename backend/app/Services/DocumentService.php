<?php

namespace App\Services;

use App\Models\UserDocument;
use Illuminate\Support\Facades\Storage;

class DocumentService
{
    // 1. Add multiple documents for a user
    public function addDocuments($userId, $documentData, $files)
    {
        $documents = [];

        foreach ($documentData as $index => $data) {
            $file = $files[$index]['file'];
            $path = $file->store('documents', 'public');

            $document = UserDocument::create([
                'user_id' => $userId,
                'document_type' => $data['document_type'],
                'document_path' => $path,
            ]);

            $documents[] = $document;
        }

        return $documents;
    }

    // 2. Retrieve all documents for a user
    public function getDocuments($userId)
    {
        return UserDocument::where('user_id', $userId)->get(['id', 'user_id', 'document_type', 'document_path']);
    }

    // 3. Retrieve a specific document by document_id for a user
    public function getDocumentById($userId, $documentId)
    {
        return UserDocument::where('user_id', $userId)
                           ->where('id', $documentId)
                           ->first();
    }

    // 4. Admin: Retrieve all documents in the database
    public function getAllDocuments()
    {
        return UserDocument::with('user:id,name,email')->get(['id', 'user_id', 'document_type', 'document_path']);
    }
}
