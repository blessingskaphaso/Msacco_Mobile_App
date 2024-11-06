<?php

namespace App\Http\Controllers;

use App\Services\LoanService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoanController extends Controller
{
    protected $loanService;

    public function __construct(LoanService $loanService)
    {
        $this->loanService = $loanService;
    }

    // Get all loans for the authenticated user
    public function index()
    {
        $loans = $this->loanService->getLoansByUserId(Auth::id());
        return response()->json(['loans' => $loans], 200);
    }

    // Get a specific loan by ID
    public function show($id)
    {
        $loan = $this->loanService->getLoanById($id);

        if (!$loan) {
            return response()->json(['error' => 'Loan not found'], 404);
        }

        return response()->json(['loan' => $loan], 200);
    }

    // Check loan eligibility before requesting a new loan
    public function checkEligibility()
    {
        $eligibility = $this->loanService->calculateLoanEligibility(Auth::id());

        return response()->json([
            'eligible_amount' => $eligibility['eligible_amount'],
            'current_loans' => $eligibility['current_loans'],
        ], 200);
    }

    // Request a new loan with eligibility check
    public function store(Request $request)
    {
        $request->validate([
            'loan_type_id' => 'required|exists:loan_types,id',
            'amount' => 'required|numeric|min:1'
        ]);

        // Check eligibility for requested amount
        $eligibility = $this->loanService->calculateLoanEligibility(Auth::id());

        if ($request->amount > $eligibility['eligible_amount']) {
            return response()->json([
                'error' => 'Requested loan amount exceeds your eligibility.',
                'eligible_amount' => $eligibility['eligible_amount'],
                'current_loans' => $eligibility['current_loans'],
            ], 403);
        }

        if ($request->amount <= $eligibility['current_deposits']) {
            return response()->json([
                'error' => 'Requested loan amount must be greater than current deposits.',
                'current_deposits' => $eligibility['current_deposits'],
            ], 403);
        }

        $loan = $this->loanService->createLoan($request->only('loan_type_id', 'amount'));

        return response()->json(['message' => 'Loan requested successfully', 'loan' => $loan], 201);
    }

    // Approve a loan
    public function approve($id)
    {
        $approvedLoan = $this->loanService->approveLoan($id);

        if (!$approvedLoan) {
            return response()->json(['error' => 'Loan not found or cannot be approved'], 404);
        }

        return response()->json(['message' => 'Loan approved successfully', 'loan' => $approvedLoan], 200);
    }

    // Reject a loan
    public function reject($id)
    {
        $rejectedLoan = $this->loanService->rejectLoan($id);

        if (!$rejectedLoan) {
            return response()->json(['error' => 'Loan not found or cannot be rejected'], 404);
        }

        return response()->json(['message' => 'Loan rejected successfully', 'loan' => $rejectedLoan], 200);
    }

    // Settle a loan
    public function settle($id)
    {
        $loan = $this->loanService->settleLoan($id);

        if (!$loan) {
            return response()->json(['error' => 'Loan not found or cannot be settled'], 404);
        }

        return response()->json(['message' => 'Loan marked as settled successfully', 'loan' => $loan], 200);
    }

}
