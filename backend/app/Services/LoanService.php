<?php

namespace App\Services;

use App\Models\Loan;
use App\Models\User;
use App\Models\LoanType;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class LoanService
{
    // Get loans by user ID
    public function getLoansByUserId($userId)
    {
        return Loan::where('user_id', $userId)->get();
    }

    // Get a specific loan by ID
    public function getLoanById($id)
    {
        return Loan::find($id);
    }

    // Calculate eligibility for a new loan
    public function calculateLoanEligibility($userId)
    {
        $user = User::find($userId);

        // Get shares and deposits
        $shares = $user->shares->sum('amount') ?? 0;
        $deposits = $user->deposits->sum('amount') ?? 0;

        // Calculate loan cap as (Shares + Deposits) * 3
        $loanCap = ($shares + $deposits) * 3;

        // Calculate outstanding loans with status 'Approved'
        $currentLoans = Loan::where('user_id', $userId)
                            ->where('status', 'Approved')
                            ->sum('loan_amount');

        // Eligible loan amount after subtracting current loans
        $eligibleAmount = max(0, $loanCap - $currentLoans);

        return [
            'eligible_amount' => $eligibleAmount,
            'current_loans' => $currentLoans,
            'current_deposits' => $deposits,
        ];
    }

    // Request a new loan
    public function createLoan($data)
    {
        $loanType = LoanType::find($data['loan_type_id']);

        if (!$loanType) {
            throw new \Exception("Invalid loan type");
        }

        $user = Auth::user();
        $eligibility = $this->calculateLoanEligibility($user->id);

        if ($data['amount'] > $eligibility['eligible_amount']) {
            throw new \Exception("Requested loan amount exceeds eligible amount.");
        }

        if ($data['amount'] <= $eligibility['current_deposits']) {
            throw new \Exception("Requested loan amount must be greater than current deposits.");
        }

        // Create loan with validated conditions
        return Loan::create([
            'user_id' => $user->id,
            'loan_type_id' => $loanType->id,
            'loan_amount' => $data['amount'],
            'interest_rate' => $loanType->interest_rate,
            'duration' => $loanType->duration,
            'repayment_period' => $loanType->duration,
            'status' => 'Pending'
        ]);
    }

    // Approve loan
    public function approveLoan($id)
    {
        \Log::info("Attempting to approve loan with ID: $id");

        // Retrieve the loan
        $loan = Loan::find($id);

        if (!$loan) {
            \Log::error("Loan with ID: $id not found");
            return null;
        }

        // Log current status of the loan
        \Log::info("Loan with ID: $id found with status: " . $loan->status);

        // Check if the loan is in pending status
        if ($loan->status !== 'Pending') {
            \Log::warning("Loan with ID: $id cannot be approved because its status is '{$loan->status}' (must be 'Pending')");
            return null;
        }

        // Start the transaction
        DB::transaction(function () use ($loan) {
            // Approve the loan and log the change
            $loan->update(['status' => 'Approved']);
            \Log::info("Loan with ID: {$loan->id} approved successfully");

            // Retrieve total deposits directly if it's a relationship
            $user = User::find($loan->user_id);
            $totalDeposits = $user->deposits->sum('amount'); // Summing deposits if it’s a collection

            // Update deposits by adding loan amount
            $updatedDeposits = $totalDeposits + $loan->loan_amount;
            $user->update(['deposits' => $updatedDeposits]);
            
            \Log::info("User ID {$loan->user_id}'s deposits updated by {$loan->loan_amount}, new total deposits: {$updatedDeposits}");

            // Log audit entry for approval
            \Log::info("Audit Log: Loan ID {$loan->id} approved for user {$loan->user_id} with amount {$loan->loan_amount}");
        });

        return $loan;
    }


    // Reject loan
    public function rejectLoan($id)
    {
        $loan = Loan::find($id);

        if (!$loan || $loan->status !== 'Pending') {
            return null;
        }

        $loan->update(['status' => 'Rejected']);
        return $loan;
    }

    // Settle loan
    public function settleLoan($id)
    {
        \Log::info("Attempting to settle loan with ID: $id");

        // Retrieve the loan
        $loan = Loan::find($id);

        if (!$loan) {
            \Log::error("Loan with ID: $id not found");
            return null;
        }

        // Log current status of the loan
        \Log::info("Loan with ID: $id found with status: " . $loan->status);

        // Check if the loan is approved and can be settled
        if ($loan->status !== 'Approved') {
            \Log::warning("Loan with ID: $id cannot be settled because its status is '{$loan->status}' (must be 'Approved')");
            return null;
        }

        // Settle the loan and log the status update
        $loan->update(['status' => 'Settled']);
        \Log::info("Loan with ID: {$loan->id} marked as settled");

        // Record audit log for loan settlement
        \Log::info("Audit Log: Loan ID {$loan->id} settled for user {$loan->user_id}");

        return $loan;
    }

}
