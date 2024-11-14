<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TransactionController extends Controller
{
    /**
     * Display a listing of all transactions (Admin only).
     *
     * Only admins can access this endpoint to view all transactions across all accounts.
     * Regular users are restricted to viewing transactions for their own accounts only.
     *
     * @return \Illuminate\Http\JsonResponse JSON response containing all transactions.
     */
    public function index()
    {
        $user = Auth::user();

        if (!$user->isAdmin()) {
            return response()->json(['message' => 'Only admins can view all transactions.'], 403);
        }

        $transactions = Transaction::all();
        return response()->json($transactions, 200);
    }

    /**
     * Store a new transaction for a specified account (Admin only).
     *
     * This method allows an admin to record a transaction for a user's account.
     * Transactions can be of type deposit, withdrawal, or loan repayment.
     * The account balance is adjusted based on the transaction type.
     * Withdrawals and loan repayments deduct from the deposit balance,
     * while deposits add to the deposit balance.
     *
     * @param Request $request HTTP request containing account_id, type, amount, source, and destination.
     * @return \Illuminate\Http\JsonResponse JSON response with the created transaction details or an error message.
     */
    public function store(Request $request)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can create transactions.'], 403);
        }

        $request->validate([
            'account_id' => 'required|exists:accounts,id',
            'type' => 'required|in:deposit,withdrawal,loan_repayment',
            'amount' => 'required|numeric|min:0.01',
            'source' => 'required|string|max:255',
            'destination' => 'required|string|max:255',
        ]);

        $account = Account::find($request->account_id);

        if ($request->type === 'withdrawal' && $account->deposit_balance < $request->amount) {
            return response()->json(['message' => 'Insufficient funds for withdrawal.'], 403);
        }

        // Adjust balance based on transaction type
        if ($request->type === 'deposit') {
            $account->increment('deposit_balance', $request->amount);
        } elseif ($request->type === 'withdrawal') {
            $account->decrement('deposit_balance', $request->amount);
        } elseif ($request->type === 'loan_repayment') {
            // Assuming loan repayments also decrease the deposit balance
            $account->decrement('deposit_balance', $request->amount);
        }

        // Record the transaction
        $transaction = Transaction::create([
            'account_id' => $request->account_id,
            'type' => $request->type,
            'amount' => $request->amount,
            'source' => $request->source,
            'destination' => $request->destination,
            'transaction_date' => now(),
        ]);

        return response()->json($transaction, 201);
    }

    /**
     * Display a specific transaction.
     *
     * This endpoint retrieves the details of a specific transaction by its ID.
     * Only authenticated users can access it, and they must have the proper authorization.
     *
     * @param Transaction $transaction The transaction instance retrieved by its ID.
     * @return \Illuminate\Http\JsonResponse JSON response containing the transaction details.
     */
    public function show(Transaction $transaction)
    {
        return response()->json($transaction, 200);
    }

    /**
     * Display a list of transactions for a specific account.
     *
     * Retrieves all transactions associated with a given account, sorted by the most recent first.
     * Admins can view transactions for any account, while regular users can only view
     * transactions for their own accounts.
     *
     * @param Account $account The account instance for which transactions are being retrieved.
     * @return \Illuminate\Http\JsonResponse JSON response containing the list of transactions or an error message.
     */
    public function accountTransactions(Account $account)
    {
        $user = Auth::user();

        // Only admins or the account owner can view transactions for an account
        if (!$user->isAdmin() && $user->id !== $account->user_id) {
            return response()->json(['message' => 'Unauthorized access to account transactions.'], 403);
        }

        $transactions = $account->transactions()->orderBy('created_at', 'desc')->get();

        return response()->json($transactions, 200);
    }
}
