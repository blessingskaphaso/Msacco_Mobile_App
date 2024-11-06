<?php

namespace App\Http\Controllers;

use App\Services\TransactionSourceService;
use Illuminate\Http\Request;
use Illuminate\Database\QueryException;

class TransactionSourceController extends Controller
{
    protected $transactionSourceService;

    public function __construct(TransactionSourceService $transactionSourceService)
    {
        $this->transactionSourceService = $transactionSourceService;
    }

    // Get all transaction sources
    public function index()
    {
        $sources = $this->transactionSourceService->getAllSources();
        return response()->json(['sources' => $sources], 200);
    }

    // Get a specific transaction source by ID
    public function show($id)
    {
        $source = $this->transactionSourceService->getSourceById($id);

        if (!$source) {
            return response()->json(['error' => 'Transaction source not found'], 404);
        }

        return response()->json(['source' => $source], 200);
    }

    // Create a new transaction source
    public function store(Request $request)
    {
        $validator = \Validator::make($request->all(), [
            'name' => 'required|string|unique:transaction_sources,name',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 409);
        }

        try {
            $source = $this->transactionSourceService->createSource($request->all());
            return response()->json(['message' => 'Transaction source created successfully', 'source' => $source], 201);
        } catch (\Exception $e) {
            \Log::error('Transaction source creation error: ' . $e->getMessage());
            return response()->json(['error' => 'An unexpected error occurred'], 500);
        }
    }

}
