<?php

namespace App\Http\Controllers;

use App\Models\Loan;
use App\Models\Account;
use App\Models\LoanType;
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

        $loans = $user->isAdmin()
            ? Loan::all()
            : $user->account?->loans ?? [];

        return response()->json($loans, 200);
    }

            /**
     * Store a new loan request for the authenticated user.
     *
     * This endpoint allows an authenticated user to request a loan. The system validates
     * the loan type and amount, ensuring it falls within the user's eligibility limits based
     * on their account balances. If the request passes all checks, a loan with a "Pending" status
     * is created.
     *
     * Restrictions:
     * - The user must have an account.
     * - The loan amount cannot exceed three times the sum of the user's share and deposit balances.
     *
     * @param Request $request The HTTP request containing the loan details.
     *
     * @bodyParam loan_type_id int required The ID of the loan type. Example: 1
     * @bodyParam amount float required The requested loan amount. Must be greater than 0. Example: 5000.00
     *
     * @return \Illuminate\Http\JsonResponse
     *
     * @response 201 {
     *   "id": 1,
     *   "account_id": 2,
     *   "loan_type_id": 1,
     *   "amount": 5000.00,
     *   "balance": 5000.00,
     *   "status": "Pending",
     *   "created_at": "2024-12-16T12:34:56.000000Z",
     *   "updated_at": "2024-12-16T12:34:56.000000Z"
     * }
     *
     * @response 403 {
     *   "message": "User does not have an account."
     * }
     *
     * @response 403 {
     *   "message": "Requested loan amount exceeds the allowable limit."
     * }
     *
     * @response 422 {
     *   "errors": {
     *     "loan_type_id": [
     *       "The selected loan type is invalid."
     *     ],
     *     "amount": [
     *       "The amount must be greater than 0."
     *     ]
     *   }
     * }
     */
    public function store(Request $request)
    {
        // Debug user and request data
        // dd([
        //     'request_all' => $request->all(),
        //     'user' => Auth::user()->toArray()
        // ]);

        $user = Auth::user();
        $account = $user->account;
        $loanType = LoanType::find($request->input('loan_type_id'));

        // Debug account data
        // dd([
        //     'user_id' => $user->id,
        //     'account' => $account ? $account->toArray() : null,
        //     'loan_type' => $loanType ? $loanType->toArray() : null
        // ]);

        if (!$account) {
            return response()->json(['message' => 'User does not have an account.'], 403);
        }

        $validator = $this->validateLoanRequest($request);

        // Debug validation results
        // dd([
        //     'validation_passes' => !$validator->fails(),
        //     'validation_errors' => $validator->errors()->toArray()
        // ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $maxLoanAmount = ($account->share_balance + $account->deposit_balance) * 3;

        // Debug loan amount check
        // dd([
        //     'share_balance' => $account->share_balance,
        //     'deposit_balance' => $account->deposit_balance,
        //     'max_loan_amount' => $maxLoanAmount,
        //     'requested_amount' => $request->amount
        // ]);

        if ($request->amount > $maxLoanAmount) {
            return response()->json(['message' => 'Requested loan amount exceeds the allowable limit.'], 403);
        }

        // Enable query logging before creating the loan
        \DB::enableQueryLog();

        $loan = Loan::create([
            'user_id' => $user->id,  // Add user_id here
            'account_id' => $account->id,
            'loan_type_id' => $request->loan_type_id,
            'loan_amount' => $request->amount,
            'balance' => $request->amount,
            'repayment_period' => $loanType->duration,
            'interest_rate' => $loanType->interest_rate,
            'status' => 'Pending',
        ]);

        // Debug the created loan and the SQL query
        // dd([
        //     'created_loan' => $loan->toArray(),
        //     'sql_query' => \DB::getQueryLog()
        // ]);

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

        $validator = $this->validateLoanUpdateRequest($request);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

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

    /**
     * Validates the loan creation request.
     *
     * @param Request $request
     * @return \Illuminate\Contracts\Validation\Validator
     */
    private function validateLoanRequest(Request $request)
    {
        return validator($request->all(), [
            'loan_type_id' => 'required|exists:loan_types,id',
            'amount' => 'required|numeric|min:0.01',
        ]);
    }

    /**
     * Validates the loan update request.
     *
     * @param Request $request
     * @return \Illuminate\Contracts\Validation\Validator
     */
    private function validateLoanUpdateRequest(Request $request)
    {
        return validator($request->all(), [
            'status' => 'sometimes|in:Approved,Rejected,Pending,Settled',
            'balance' => 'sometimes|numeric|min:0',
        ]);
    }
}
