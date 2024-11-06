<?php

namespace App\Http\Controllers;

use App\Services\TransactionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TransactionController extends Controller
{
    protected $transactionService;

    public function __construct(TransactionService $transactionService)
    {
        $this->transactionService = $transactionService;
    }

    // Get all transactions for the authenticated user
    public function index()
    {
        $transactions = $this->transactionService->getAllTransactions(Auth::id());
        return response()->json(['transactions' => $transactions], 200);
    }

    // Get a specific transaction by ID
    public function show($id)
    {
        $transaction = $this->transactionService->getTransactionById($id);

        if (!$transaction) {
            return response()->json(['error' => 'Transaction not found'], 404);
        }

        return response()->json(['transaction' => $transaction], 200);
    }

    // Create a new transaction
    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric',
            'transaction_type_id' => 'required|exists:transaction_types,id',
            'source_id' => 'required|exists:transaction_sources,id',
            'destination_id' => 'required|exists:transaction_sources,id|different:source_id',
            'description' => 'nullable|string',
        ]);

        $transaction = $this->transactionService->createTransaction($request->all());

        return response()->json(['message' => 'Transaction created successfully', 'transaction' => $transaction], 201);
    }
}
