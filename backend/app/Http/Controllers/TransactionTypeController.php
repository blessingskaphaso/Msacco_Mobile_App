<?php

namespace App\Http\Controllers;

use App\Services\TransactionTypeService;
use Illuminate\Http\Request;

class TransactionTypeController extends Controller
{
    protected $transactionTypeService;

    public function __construct(TransactionTypeService $transactionTypeService)
    {
        $this->transactionTypeService = $transactionTypeService;
    }

    // Get all transaction types
    public function index()
    {
        $types = $this->transactionTypeService->getAllTypes();
        return response()->json(['types' => $types], 200);
    }

    // Get a specific transaction type by ID
    public function show($id)
    {
        $type = $this->transactionTypeService->getTypeById($id);

        if (!$type) {
            return response()->json(['error' => 'Transaction type not found'], 404);
        }

        return response()->json(['type' => $type], 200);
    }

    // Create a new transaction type
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|unique:transaction_types',
        ]);

        $type = $this->transactionTypeService->createType($request->all());

        return response()->json(['message' => 'Transaction type created successfully', 'type' => $type], 201);
    }
}
