<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\Document;
use Illuminate\Validation\ValidationException;

class DocumentController extends Controller
{
    /**
     * Get all documents.
     * 
     * @return \Illuminate\Http\JsonResponse
     * 
     * @response 200 scenario="Success" {
     *   "documents": [
     *      {
     *         "id": 1,
     *         "user_id": 1,
     *         "title": "Passport",
     *         "file_path": "documents/passport.pdf",
     *         "created_at": "2024-01-01T00:00:00.000000Z",
     *         "updated_at": "2024-01-01T00:00:00.000000Z"
     *      }
     *   ]
     * }
     * @response 500 scenario="Server error" {
     *   "message": "An error occurred while fetching documents."
     * }
     */
    public function index()
    {
        try {
            $documents = Document::all();
            return response()->json(['documents' => $documents], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'An error occurred while fetching documents.'], 500);
        }
    }

       /**
     * Store documents for a user.
     * 
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|integer',
            'documents.*.document_type' => 'required|string|in:passport,id',
            'documents.*.file' => 'required|array',
            'documents.*.file.*' => 'file|mimes:jpeg,png,pdf|max:2048'
        ]);

        $userId = $request->input('user_id');
        $documentsData = [];

        try {
            foreach ($request->input('documents') as $index => $document) {
                if (!array_key_exists('document_type', $document) || null === $request->file("documents.{$index}.file")) {
                    return response()->json([
                        'message' => 'Validation error',
                        'errors' => ["documents.{$index}.file" => ['The document type or file is missing.']]
                    ], 422);
                }

                $documentType = $document['document_type'];
                $files = $request->file("documents.{$index}.file");

                // Handle each file upload in documents
                $filePaths = [];
                foreach ($files as $file) {
                    $filePath = $file->store("documents/{$userId}");
                    $filePaths[] = $filePath;
                }

                $documentsData[] = [
                    'user_id' => $userId,
                    'document_type' => $documentType,
                    'file_paths' => $filePaths
                ];
            }

            return response()->json(['message' => 'Documents added successfully', 'documents' => $documentsData], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An error occurred during document upload.',
                'error' => $e->getMessage()
            ], 500);
        }
    }



    /**
     * Show a specific document.
     * 
     * @param int $id The ID of the document
     * @return \Illuminate\Http\JsonResponse
     * 
     * @response 200 scenario="Success" {
     *   "document": {
     *      "id": 1,
     *      "user_id": 1,
     *      "title": "Passport",
     *      "file_path": "documents/passport.pdf",
     *      "created_at": "2024-01-01T00:00:00.000000Z",
     *      "updated_at": "2024-01-01T00:00:00.000000Z"
     *   }
     * }
     * @response 404 scenario="Document not found" {
     *   "message": "Document not found."
     * }
     * @response 500 scenario="Server error" {
     *   "message": "An error occurred while fetching the document."
     * }
     */
    public function show($id)
    {
        try {
            $document = Document::findOrFail($id);
            return response()->json(['document' => $document], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['message' => 'Document not found.'], 404);
        } catch (\Exception $e) {
            return response()->json(['message' => 'An error occurred while fetching the document.'], 500);
        }
    }

    /**
     * Delete a document.
     * 
     * @param int $id The ID of the document to delete
     * @return \Illuminate\Http\JsonResponse
     * 
     * @response 200 scenario="Success" {
     *   "message": "Document deleted successfully."
     * }
     * @response 404 scenario="Document not found" {
     *   "message": "Document not found."
     * }
     * @response 500 scenario="Server error" {
     *   "message": "An error occurred while deleting the document."
     * }
     */
    public function destroy($id)
    {
        try {
            $document = Document::findOrFail($id);

            // Delete the file from storage
            Storage::disk('public')->delete($document->file_path);

            // Delete the document record
            $document->delete();

            return response()->json(['message' => 'Document deleted successfully.'], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['message' => 'Document not found.'], 404);
        } catch (\Exception $e) {
            return response()->json(['message' => 'An error occurred while deleting the document.'], 500);
        }
    }
}
