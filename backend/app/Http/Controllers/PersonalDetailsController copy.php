<?php

namespace App\Http\Controllers;

use App\Services\PersonalDetailsService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PersonalDetailsController extends Controller
{
    protected $personalDetailsService;

    public function __construct(PersonalDetailsService $personalDetailsService)
    {
        $this->personalDetailsService = $personalDetailsService;
    }

    // Retrieve Personal Details with Documents
    public function show()
    {
        $user = Auth::user();
        $personalDetails = $this->personalDetailsService->getDetails($user->id);

        return response()->json(['personal_details' => $personalDetails], 200);
    }

    // Retrieve All Documents for the Authenticated User
    public function showDocuments()
    {
        $user = Auth::user();
        $documents = $this->personalDetailsService->getDocuments($user->id);

        return response()->json(['documents' => $documents], 200);
    }

    // Retrieve a Specific Document by ID
    public function showDocument($id)
    {
        $user = Auth::user();
        $document = $this->personalDetailsService->getDocumentById($user->id, $id);
    
        if (!$document) {
            return response()->json(['error' => 'Document not found or unauthorized access'], 404);
        }
    
        return response()->json(['document' => $document], 200);
    }
    

    // Add Multiple Documents for the Authenticated User
    public function addDocument(Request $request)
    {
        \Log::info('addDocument endpoint hit');
        \Log::info('Request Data:', $request->all());
    
        // Validate each document entry
        $request->validate([
            'documents.*.document_type' => 'required|string|in:passport,id',
            'documents.*.file' => 'required|file|mimes:jpeg,png,pdf|max:2048'
        ]);
    
        $user = Auth::user();
        $documents = [];
    
        // Loop through each document in the `documents` array
        foreach ($request->input('documents') as $index => $docData) {
            $file = $request->file("documents.$index.file"); // Access the file directly
    
            // Pass document type and file to the service
            $document = $this->personalDetailsService->addDocument($user->id, [
                'document_type' => $docData['document_type'],
                'file' => $file,
            ]);
    
            $documents[] = $document;
        }
    
        return response()->json(['message' => 'Documents added successfully', 'documents' => $documents], 201);
    }
        
    // Update Personal Details and Upload Multiple Documents
    public function update(Request $request)
    {
        $request->validate([
            'home_address' => 'string|max:255',
            'next_of_kin_name' => 'string|max:255',
            'next_of_kin_contact' => 'string|max:15',
            'relationship' => 'string|max:50',
            'employment_status' => 'string|max:50',
            'documents.*.document_type' => 'string|in:passport,id',
            'documents.*.file' => 'file|mimes:jpeg,png,pdf|max:2048'
        ]);

        $user = Auth::user();
        $data = $request->except('documents');
        $documents = $request->file('documents');

        $updatedDetails = $this->personalDetailsService->updateDetailsWithDocuments($user->id, $data, $documents);

        return response()->json(['message' => 'Personal details updated successfully', 'personal_details' => $updatedDetails], 200);
    }
}
