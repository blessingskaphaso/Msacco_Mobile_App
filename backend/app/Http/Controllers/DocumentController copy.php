<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\DocumentService;
use Illuminate\Support\Facades\Auth;

class DocumentController extends Controller
{
    protected $documentService;

    public function __construct(DocumentService $documentService)
    {
        $this->documentService = $documentService;
    }

    // 1. Add documents for the authenticated user
    public function store(Request $request)
    {
        $request->validate([
            'documents.*.document_type' => 'required|string|in:passport,id',
            'documents.*.file' => 'required|file|mimes:jpeg,png,pdf|max:2048'
        ]);

        $user = Auth::user();
        $documents = $this->documentService->addDocuments($user->id, $request->input('documents'), $request->file('documents'));

        return response()->json(['message' => 'Documents added successfully', 'documents' => $documents], 201);
    }

    // 2. Retrieve all documents for the authenticated user
    public function index()
    {
        $user = Auth::user();
        $documents = $this->documentService->getDocuments($user->id);

        return response()->json(['documents' => $documents], 200);
    }

    // 3. Retrieve a specific document by document_id for the authenticated user
    public function show($document_id)
    {
        $user = Auth::user();

        $document = $this->documentService->getDocumentById($user->id, $document_id);

        if (!$document) {
            return response()->json(['error' => 'Document not found or unauthorized access'], 404);
        }

        return response()->json(['document' => $document], 200);
    }

    // 4. Admin-only: Retrieve all documents in the database
    public function adminIndex()
    {
        $documents = $this->documentService->getAllDocuments();

        return response()->json(['documents' => $documents], 200);
    }
}
