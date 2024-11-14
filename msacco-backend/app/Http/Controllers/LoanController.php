<?php

namespace App\Http\Controllers;

use App\Models\Loan;
use App\Models\Account;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoanController extends Controller
{
    /**
     * Display a listing of all loans.
     *
     * Admins can view all loans, while regular users can view only their own loans.
     *
     * @return \Illuminate\Http\JsonResponse JSON response containing loans.
     */
    public function index()
    {
        $user = Auth::user();

        if ($user->isAdmin()) {
            $loans = Loan::all();
        } else {
            $loans = $user->account->loans;
        }

        return response()->json($loans, 200);
    }

    /**
     * Store a new loan request for the authenticated user.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse JSON response with loan details or error message.
     */
    public function store(Request $request)
    {
        $user = Auth::user();
        $account = $user->account;

        if (!$account) {
            return response()->json(['message' => 'User does not have an account.'], 403);
        }

        $request->validate([
            'loan_type_id' => 'required|exists:loan_types,id',
            'amount' => 'required|numeric|min:0.01',
        ]);

        $maxLoanAmount = ($account->share_balance + $account->deposit_balance) * 3;

        if ($request->amount > $maxLoanAmount) {
            return response()->json(['message' => 'Requested loan amount exceeds the allowable limit.'], 403);
        }

        $loan = Loan::create([
            'account_id' => $account->id,
            'loan_type_id' => $request->loan_type_id,
            'amount' => $request->amount,
            'balance' => $request->amount,
            'status' => 'Pending',
        ]);

        return response()->json($loan, 201);
    }

    /**
     * Display details of a specific loan.
     *
     * @param Loan $loan
     * @return \Illuminate\Http\JsonResponse JSON response containing loan details.
     */
    public function show(Loan $loan)
    {
        $user = Auth::user();

        if (!$user->isAdmin() && $loan->account->user_id !== $user->id) {
            return response()->json(['message' => 'Unauthorized access to loan details.'], 403);
        }

        return response()->json($loan, 200);
    }

    /**
     * Update a specific loan's details (Admin only).
     *
     * Allows admins to update loan status or adjust loan terms.
     *
     * @param Request $request
     * @param Loan $loan
     * @return \Illuminate\Http\JsonResponse JSON response with updated loan details or error message.
     */
    public function update(Request $request, Loan $loan)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can update loans.'], 403);
        }

        $request->validate([
            'status' => 'sometimes|in:Approved,Rejected,Pending,Settled',
            'balance' => 'sometimes|numeric|min:0',
        ]);

        $loan->update($request->only(['status', 'balance']));

        return response()->json($loan, 200);
    }

    /**
     * Remove a specific loan (Admin only).
     *
     * @param Loan $loan
     * @return \Illuminate\Http\JsonResponse JSON response confirming deletion or error message.
     */
    public function destroy(Loan $loan)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can delete loans.'], 403);
        }

        $loan->delete();
        return response()->json(['message' => 'Loan deleted successfully'], 200);
    }
}
