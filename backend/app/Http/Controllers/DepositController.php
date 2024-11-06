<?php

namespace App\Http\Controllers;

use App\Services\DepositService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DepositController extends Controller
{
    protected $depositService;

    public function __construct(DepositService $depositService)
    {
        $this->depositService = $depositService;
    }

    // Retrieve all deposits for the authenticated user
    public function index()
    {
        $user = Auth::user();
    
        // Retrieve all deposits for the user
        $deposits = $this->depositService->getUserDeposits($user->id);
    
        // Calculate the sum of all deposits for the user
        $totalAmount = $this->depositService->getTotalDeposits($user->id);
    
        return response()->json([
            'deposits' => $deposits,
            'total_amount' => $totalAmount,
        ], 200);
    }
    

    // Retrieve a specific deposit by ID for the authenticated user
    public function show($deposit_id)
    {
        $user = Auth::user();
        $deposit = $this->depositService->getDepositById($user->id, $deposit_id);

        if (!$deposit) {
            return response()->json(['error' => 'Deposit not found or unauthorized access'], 404);
        }

        return response()->json(['deposit' => $deposit], 200);
    }

    // Add a new deposit for the authenticated user
    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0',
        ]);

        $user = Auth::user();
        $deposit = $this->depositService->createDeposit($user->id, $request->all());

        return response()->json(['message' => 'Deposit added successfully', 'deposit' => $deposit], 201);
    }

    // Update an existing deposit for the authenticated user
    public function update(Request $request, $deposit_id)
    {
        $request->validate([
            'amount' => 'numeric|min:0',
        ]);

        $user = Auth::user();
        $updatedDeposit = $this->depositService->updateDeposit($user->id, $deposit_id, $request->all());

        if (!$updatedDeposit) {
            return response()->json(['error' => 'Deposit not found or unauthorized access'], 404);
        }

        return response()->json(['message' => 'Deposit updated successfully', 'deposit' => $updatedDeposit], 200);
    }
}
